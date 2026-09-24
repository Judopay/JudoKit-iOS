//
//  JPDsCertificateRepository.m
//  JudoKit_iOS
//
//  Copyright (c) 2026 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "JPDsCertificateRepository.h"
#import "JPDsCdnApiService.h"
#import "JPDsCertificatesCacheStore.h"
#import "JPDsCertificatesResponse.h"
#import "NSString+Additions.h"

static NSString *const kLogTag = @"JPDsCertificateRepository";

static const NSTimeInterval kDefaultMaxAge = 24 * 60 * 60;          // 24 hours
static const NSTimeInterval kPreExpiryThreshold = 7 * 24 * 60 * 60; // 7 days

static const NSInteger kHTTPNotModified = 304;

@interface JPDsCertificateRepository ()

@property (nonatomic, strong) JPDsCdnApiService *apiService;
@property (nonatomic, strong) JPDsCertificatesCacheStore *cacheStore;
@property (nonatomic, strong) JPDsCertificatesCache *memoryCache;

// Serial queue serialises cache reads/writes and prevents concurrent refreshes.
@property (nonatomic, strong) dispatch_queue_t cacheQueue;
@property (nonatomic, assign) BOOL isRefreshing;

@end

@implementation JPDsCertificateRepository

- (instancetype)initWithApiService:(JPDsCdnApiService *)apiService
                        cacheStore:(JPDsCertificatesCacheStore *)cacheStore {
    if (self = [super init]) {
        _apiService = apiService;
        _cacheStore = cacheStore;
        _cacheQueue = dispatch_queue_create("com.judopay.dsCertificates", DISPATCH_QUEUE_SERIAL);

        // Load persisted cache into memory on init
        __weak typeof(self) weakSelf = self;
        dispatch_async(_cacheQueue, ^{
            weakSelf.memoryCache = [weakSelf.cacheStore load];
        });
    }
    return self;
}

#pragma mark - Public API

- (void)prefetch {
    // Utility rather than background QoS: the certificates are needed for an upcoming 3DS
    // transaction, and background-QoS work can be deferred for a long time when the device
    // is busy or in Low Power Mode (it only runs on efficiency cores on Apple Silicon).
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        [self refresh];
    });
}

- (JPDsCertificateEntry *)cachedEntryForDsId:(NSString *)dsId {
    __block JPDsCertificateEntry *result = nil;
    dispatch_sync(self.cacheQueue, ^{
        NSDate *now = [NSDate date];
        for (JPDsCertificateEntry *entry in self.memoryCache.entries) {
            if ([entry.dsId isEqualToString:dsId] && [entry isNotExpiredForDate:now]) {
                result = entry;
                break;
            }
        }
    });
    return result;
}

#pragma mark - Refresh

- (void)refresh {
    __block BOOL shouldSkip = NO;
    dispatch_sync(self.cacheQueue, ^{
        if (self.isRefreshing) {
            shouldSkip = YES;
            return;
        }

        NSDate *now = [NSDate date];
        BOOL cacheIsFresh = [self.memoryCache isFreshForDate:now];
        BOOL hasNearExpiry = [self.memoryCache hasNearExpiryEntryForDate:now threshold:kPreExpiryThreshold];

        if (cacheIsFresh && !hasNearExpiry) {
            shouldSkip = YES;
            return;
        }

        self.isRefreshing = YES;
    });

    if (shouldSkip) {
        return;
    }

    __block NSString *cachedEtag = nil;
    __block NSString *cachedLastModified = nil;

    dispatch_sync(self.cacheQueue, ^{
        cachedEtag = self.memoryCache.etag;
        cachedLastModified = self.memoryCache.lastModified;
    });

    // Don't block a thread waiting for the response: the request's own timeout bounds the
    // refresh, and isRefreshing is cleared once the completion has run.
    [self.apiService fetchCertsWithEtag:cachedEtag
                           lastModified:cachedLastModified
                             completion:^(JPDsCertificatesResponse *certsResponse, NSError *error, NSInteger httpStatusCode) {
                                 @try {
                                     [self handleCDNResponse:certsResponse httpStatusCode:httpStatusCode error:error];
                                 } @catch (NSException *exception) {
                                     NSLog(@"[%@] WARNING: unexpected exception during refresh: %@", kLogTag, exception.reason);
                                 }
                                 dispatch_async(self.cacheQueue, ^{
                                     self.isRefreshing = NO;
                                 });
                             }];
}

- (void)handleCDNResponse:(JPDsCertificatesResponse *)certsResponse
           httpStatusCode:(NSInteger)statusCode
                    error:(NSError *)error {
    if (error) {
        NSLog(@"[%@] WARNING: CDN fetch failed: %@", kLogTag, error.localizedDescription);
        return;
    }

    if (statusCode == kHTTPNotModified) {
        // Server confirms our cached copy is still current; just bump the fetchedAt timestamp
        dispatch_sync(self.cacheQueue, ^{
            if (!self.memoryCache) {
                NSLog(@"[%@] WARNING: 304 received but no memory cache; attempting disk load", kLogTag);
                self.memoryCache = [self.cacheStore load];
            }
            if (self.memoryCache) {
                self.memoryCache.fetchedAt = [NSDate date].timeIntervalSince1970;
                [self.cacheStore save:self.memoryCache];
            }
        });
        return;
    }

    if (statusCode != 200) {
        NSLog(@"[%@] WARNING: unexpected CDN status %ld", kLogTag, (long)statusCode);
        return;
    }

    if (!certsResponse) {
        NSLog(@"[%@] WARNING: failed to parse CDN response", kLogTag);
        return;
    }

    if (![certsResponse hasCompatibleSchemaVersion]) {
        NSLog(@"[%@] WARNING: unsupported schema version: %@", kLogTag, certsResponse.schemaVersion);
        return;
    }

    if (certsResponse.entries.count == 0) {
        NSLog(@"[%@] WARNING: CDN response contained no entries, keeping existing cache", kLogTag);
        return;
    }

    JPDsCertificatesCache *newCache = [JPDsCertificatesCache new];
    newCache.etag = certsResponse.etag;
    newCache.lastModified = certsResponse.lastModified;
    newCache.fetchedAt = NSDate.date.timeIntervalSince1970;
    newCache.maxAge = certsResponse.maxAge > 0 ? certsResponse.maxAge : kDefaultMaxAge;
    newCache.entries = certsResponse.entries;

    dispatch_sync(self.cacheQueue, ^{
        self.memoryCache = newCache;
        [self.cacheStore save:newCache];
    });
}

@end
