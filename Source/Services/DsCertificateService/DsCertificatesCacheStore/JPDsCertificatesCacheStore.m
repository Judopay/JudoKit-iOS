//
//  JPDsCertificatesCacheStore.m
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

#import "JPDsCertificatesCacheStore.h"

static NSString *const kCacheKey = @"judokit_ds_certs_v1";

@implementation JPDsCertificatesCache

- (BOOL)isFreshForDate:(NSDate *)date {
    NSTimeInterval age = [date timeIntervalSince1970] - self.fetchedAt;
    return age < self.maxAge;
}

- (BOOL)hasNearExpiryEntryForDate:(NSDate *)date threshold:(NSTimeInterval)threshold {
    for (JPDsCertificateEntry *entry in self.entries) {
        if ([entry isNearExpiryForDate:date threshold:threshold]) {
            return YES;
        }
    }
    return NO;
}

@end

@implementation JPDsCertificatesCacheStore

+ (instancetype)sharedInstance {
    static JPDsCertificatesCacheStore *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [JPDsCertificatesCacheStore new];
    });
    return instance;
}

- (nullable JPDsCertificatesCache *)load {
    NSData *data = [NSUserDefaults.standardUserDefaults dataForKey:kCacheKey];
    if (!data) {
        return nil;
    }

    @try {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (![dict isKindOfClass:NSDictionary.class]) {
            return nil;
        }

        JPDsCertificatesCache *cache = [JPDsCertificatesCache new];
        cache.etag = dict[@"etag"];
        cache.lastModified = dict[@"lastModified"];
        cache.fetchedAt = [dict[@"fetchedAt"] doubleValue];
        cache.maxAge = [dict[@"maxAge"] doubleValue];

        NSMutableArray<JPDsCertificateEntry *> *entries = [NSMutableArray array];
        for (NSDictionary *entryDict in dict[@"entries"]) {
            JPDsCertificateEntry *entry = [JPDsCertificateEntry entryFromDictionary:entryDict];
            if (entry) {
                [entries addObject:entry];
            }
        }
        cache.entries = [entries copy];

        return cache;
    } @catch (NSException *__unused exception) {
        return nil;
    }
}

- (void)clear {
    [NSUserDefaults.standardUserDefaults removeObjectForKey:kCacheKey];
}

- (void)save:(JPDsCertificatesCache *)cache {
    NSMutableArray *entryDicts = [NSMutableArray array];
    for (JPDsCertificateEntry *entry in cache.entries) {
        [entryDicts addObject:[entry toDictionary]];
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (cache.etag)
        dict[@"etag"] = cache.etag;
    if (cache.lastModified)
        dict[@"lastModified"] = cache.lastModified;
    dict[@"fetchedAt"] = @(cache.fetchedAt);
    dict[@"maxAge"] = @(cache.maxAge);
    dict[@"entries"] = entryDicts;

    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    if (data) {
        [NSUserDefaults.standardUserDefaults setObject:data forKey:kCacheKey];
    }
}

@end
