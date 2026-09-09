//
//  JPDsCdnApiService.m
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

#import "JPDsCdnApiService.h"
#import "Functions.h"
#import "JPConstants.h"
#import "JPDsCertificatesResponse.h"
#import "JPSubProductInfo.h"
#import "NSString+Additions.h"

#if SWIFT_PACKAGE
@import TrustKit;
#else
#import <TrustKit/TrustKit.h>
#endif

static NSString *const kCDNPath = @"judokit/ds-certs";
static NSString *const kHeaderUserAgent = @"User-Agent";
static NSString *const kHeaderIfNoneMatch = @"If-None-Match";
static NSString *const kHeaderIfModifiedSince = @"If-Modified-Since";
static NSString *const kHeaderETag = @"ETag";
static NSString *const kHeaderLastModified = @"Last-Modified";
static NSString *const kHeaderCacheControl = @"Cache-Control";

@interface JPDsCdnApiService () <NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) TrustKit *trustKit;
@property (nonatomic, strong, nullable) JPSubProductInfo *subProductInfo;
@property (nonatomic, assign) BOOL isSandboxed;
@end

@implementation JPDsCdnApiService

- (instancetype)initWithSubProductInfo:(JPSubProductInfo *)subProductInfo
                           isSandboxed:(BOOL)isSandboxed {
    if (self = [super init]) {
        _subProductInfo = subProductInfo;
        _isSandboxed = isSandboxed;
    }
    return self;
}

- (TrustKit *)trustKit {
    if (!_trustKit) {
        _trustKit = makeTrustKit();
    }
    return _trustKit;
}

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration;
        NSOperationQueue *queue = NSOperationQueue.mainQueue;

        _session = [NSURLSession sessionWithConfiguration:configuration
                                                 delegate:self
                                            delegateQueue:queue];
    }
    return _session;
}

- (void)fetchCertsWithEtag:(NSString *)etag
              lastModified:(NSString *)lastModified
                completion:(JPDsCertHTTPCompletion)completion {
    NSString *baseURLString = self.isSandboxed ? kJudoSandboxBaseURL : kJudoBaseURL;
    NSURL *url = [[NSURL URLWithString:baseURLString] URLByAppendingPathComponent:kCDNPath];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.timeoutInterval = 10;
    [request setValue:getUserAgent(self.subProductInfo) forHTTPHeaderField:kHeaderUserAgent];
    if (etag) {
        [request setValue:etag forHTTPHeaderField:kHeaderIfNoneMatch];
    }
    if (lastModified) {
        [request setValue:lastModified forHTTPHeaderField:kHeaderIfModifiedSince];
    }
    [[self.session dataTaskWithRequest:request
                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                         NSInteger statusCode = httpResponse.statusCode;

                         if (error) {
                             completion(nil, error, statusCode);
                             return;
                         }

                         if (!data || data.length == 0) {
                             completion(nil, nil, statusCode);
                             return;
                         }

                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                         JPDsCertificatesResponse *certsResponse = [JPDsCertificatesResponse responseFromDictionary:json];

                         if (certsResponse) {
                             certsResponse.etag = httpResponse.allHeaderFields[kHeaderETag];
                             certsResponse.lastModified = httpResponse.allHeaderFields[kHeaderLastModified];
                             certsResponse.maxAge = [httpResponse.allHeaderFields[kHeaderCacheControl] _jp_cacheControlMaxAge];
                         }

                         completion(certsResponse, nil, statusCode);
                     }] resume];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session
    didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
      completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    if (![self.trustKit.pinningValidator handleChallenge:challenge completionHandler:completionHandler]) {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

@end
