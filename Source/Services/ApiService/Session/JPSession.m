//
//  JPSession.m
//  JudoKit_iOS
//
//  Copyright (c) 2016 Alternative Payments Ltd
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

#import "JPSession.h"
#import "Functions.h"
#import "JPAuthorization.h"
#import "JPConstants.h"
#import "JPError+Additions.h"
#import "JPReachability.h"
#import "JPResponse.h"
#import "JPSessionConfiguration.h"
#import "NSObject+Additions.h"

#if SWIFT_PACKAGE
@import TrustKit;
#else
#import <TrustKit/TrustKit.h>
#endif

#pragma mark - Constants

static NSString *const kAPIVersion = @"6.20.0.0";
static NSString *const kBankPrefix = @"order/bank";
static NSString *const kBankSaleAPIVersion = @"2.0.0.0";
static NSString *const kHeaderFieldAPIVersion = @"API-Version";
static NSString *const kHeaderFieldUserAgent = @"User-Agent";

@interface JPSession () <NSURLSessionDelegate>
@property (nonatomic, strong) JPReachability *reachability;
@property (nonatomic, strong) JPSessionConfiguration *configuration;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *requestHeaders;
@property (nonatomic, strong) TrustKit *trustKit;
@property (nonatomic, strong) NSURLSession *urlSession;
@end

@implementation JPSession

#pragma mark - Initializers

+ (instancetype)sessionWithConfiguration:(JPSessionConfiguration *)configuration {
    return [[JPSession alloc] initWithConfiguration:configuration];
}

- (instancetype)initWithConfiguration:(JPSessionConfiguration *)configuration {
    if (self = [super init]) {
        NSAssert(configuration, @"Configuration should not be nil");

        _configuration = configuration;
        _reachability = [JPReachability reachabilityWithURL:self.configuration.apiBaseURL];
    }
    return self;
}

#pragma mark - REST API methods

- (void)POST:(NSString *)endpoint parameters:(NSDictionary *)parameters andCompletion:(JPCompletionBlock)completion {
    [self performRequestWithMethod:kMethodPOST endpoint:endpoint parameters:parameters andCompletion:completion];
}

- (void)PUT:(NSString *)endpoint parameters:(NSDictionary *)parameters andCompletion:(JPCompletionBlock)completion {
    [self performRequestWithMethod:kMethodPUT endpoint:endpoint parameters:parameters andCompletion:completion];
}

- (void)GET:(NSString *)endpoint parameters:(NSDictionary *)parameters andCompletion:(JPCompletionBlock)completion {
    [self performRequestWithMethod:kMethodGET endpoint:endpoint parameters:parameters andCompletion:completion];
}

#pragma mark - Lazily loaded properties

- (TrustKit *)trustKit {
    if (!_trustKit) {
        NSDictionary *trustKitConfig =
            @{
                kTSKPinnedDomains : @{
                    @"judopay.com" : @{
                        kTSKPublicKeyHashes : @[
                            @"SuY75QgkSNBlMtHNPeW9AayE7KNDAypMBHlJH9GEhXs=",
                            @"c4zbAoMygSbepJKqU3322FvFv5unm+TWZROW3FHU1o8=",
                        ],
                        kTSKIncludeSubdomains : @YES
                    }
                }
            };

        _trustKit = [[TrustKit alloc] initWithConfiguration:trustKitConfig];
    }
    return _trustKit;
}

- (NSURLSession *)urlSession {
    if (!_urlSession) {
        NSURLSessionConfiguration *configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration;
        NSOperationQueue *queue = NSOperationQueue.mainQueue;

        _urlSession = [NSURLSession sessionWithConfiguration:configuration
                                                    delegate:self
                                               delegateQueue:queue];
    }
    return _urlSession;
}

- (NSDictionary<NSString *, NSString *> *)requestHeaders {
    if (!_requestHeaders) {
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:self.configuration.authorization.headers];
        headers[kHeaderFieldContentType] = kContentTypeJSON;
        headers[kHeaderFieldAccept] = kContentTypeJSON;
        headers[kHeaderFieldAPIVersion] = kAPIVersion;
        headers[kHeaderFieldUserAgent] = getUserAgent(self.configuration.subProductInfo);
        _requestHeaders = [NSDictionary dictionaryWithDictionary:headers];
    }
    return _requestHeaders;
}

#pragma mark - Private implementation

- (void)performRequestWithMethod:(NSString *)HTTPMethod
                        endpoint:(NSString *)path
                      parameters:(NSDictionary *)parameters
                   andCompletion:(JPCompletionBlock)completion {

    if (!self.reachability.isReachable) {
        completion(nil, JPError.internetConnectionError);
        return;
    }

    NSURL *_Nullable url = [self.configuration.apiBaseURL URLByAppendingPathComponent:path];
    if (url != nil) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = HTTPMethod;

        [self.requestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *__unused stop) {
            [request addValue:obj forHTTPHeaderField:key];
        }];

        if ([path hasPrefix:kBankPrefix]) {
            [request setValue:kBankSaleAPIVersion forHTTPHeaderField:kHeaderFieldAPIVersion];
        }

        if (parameters) {
            request.HTTPBody = [parameters _jp_toJSONObjectData];
        }

        NSURLSessionDataTask *task = [self task:request completion:completion];
        [task resume];
    } else {
        completion(nil, JPError.requestFailedError);
    }
}

- (NSURLSessionDataTask *)task:(NSURLRequest *)request completion:(JPCompletionBlock)completion {
    __weak typeof(self) weakSelf = self;

    return [self.urlSession dataTaskWithRequest:request
                              completionHandler:^(NSData *data, NSURLResponse *__unused response, NSError *error) {
                                  __strong typeof(self) strongSelf = weakSelf;

                                  if (!completion) {
                                      return;
                                  }

                                  [strongSelf handleResult:data error:error andCompletion:completion];
                              }];
}

- (void)handleResult:(NSData *)data
               error:(NSError *)error
       andCompletion:(JPCompletionBlock)completion {

    if (error || !data) {
        JPError *jpError = error ? (JPError *)error : JPError.requestFailedError;
        completion(nil, jpError);
        return;
    }

    __block JPError *jsonError = nil;
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&jsonError];

    if (jsonError || !responseJSON) {
        if (!jsonError) {
            jsonError = [JPError JSONSerializationFailedWithError:jsonError];
        }
        completion(nil, jsonError);
        return;
    }

    if (responseJSON[@"code"]) {
        completion(nil, [JPError errorFromDictionary:responseJSON]);
        return;
    }

    JPResponse *result = [[JPResponse alloc] initWithDictionary:responseJSON];
    completion(result, nil);
}

#pragma mark - URLSession SSL pinning

- (void)URLSession:(NSURLSession *)session
    didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
      completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    // Pass the authentication challenge to the validator; if the validation fails, the connection will be blocked
    if (![self.trustKit.pinningValidator handleChallenge:challenge completionHandler:completionHandler]) {
        // TrustKit did not handle this challenge: perhaps it was not for server trust
        // or the domain was not pinned. Fall back to the default behavior
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

@end
