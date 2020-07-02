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
#import "JPError+Additions.h"
#import "JPPagination.h"
#import "JPReachability.h"
#import "JPResponse.h"
#import "JPTransactionData.h"
#import "JudoKit.h"
#import "JPSessionConfiguration.h"
#import "Authorization.h"
#import "NSMutableURLRequest/NSMutableURLRequest+Additions.h"
#import "NSObject+Additions.h"

#import <TrustKit/TrustKit.h>

@interface JPSession () <NSURLSessionDelegate>
@property(nonatomic, strong, readwrite) TrustKit *trustKit;
@property(nonatomic, strong, readwrite) JPReachability *reachability;
@property(nonatomic, strong, readwrite) JPSessionConfiguration *configuration;
@property(nonatomic, strong, readwrite) NSDictionary<NSString *, NSString *> *requestHeaders;
@end

@implementation JPSession

#pragma mark - Constants

static NSString *const kAPIVersion = @"5.6.0";
static NSString *const kContentTypeJSON = @"application/json";
static NSString *const kHeaderFieldContentType = @"Content-Type";
static NSString *const kHeaderFieldAccept = @"Accept";
static NSString *const kHeaderFieldAPIVersion = @"API-Version";
static NSString *const kHeaderFieldUserAgent = @"User-Agent";

static NSString *const kMethodGET = @"GET";
static NSString *const kMethodPOST = @"POST";
static NSString *const kMethodPUT = @"PUT";

#pragma mark - Initializers

+ (instancetype)sessionWithConfiguration:(JPSessionConfiguration *)configuration {
    return [[JPSession alloc] initWithConfiguration:configuration];
}

- (instancetype)initWithConfiguration:(JPSessionConfiguration *)configuration {
    if (self = [super init]) {
        NSAssert(configuration, @"Configuration should not be nil");

        _configuration = configuration;
        _reachability = [JPReachability reachabilityWithURL:self.configuration.apiBaseURL];

        [self setupTrustKit];
    }
    return self;
}

#pragma mark - Setup methods

- (void)setupTrustKit {
    NSDictionary *trustKitConfig =
            @{
                    kTSKPinnedDomains: @{
                    @"judopay-sandbox.com": @{
                            kTSKPublicKeyHashes: @[
                                    @"mpCgFwbYmjH0jpQ3EruXVo+/S73NOAtPeqtGJE8OdZ0=",
                                    @"SRjoMmxuXogV8jKdDUKPgRrk9YihOLsrx7ila3iDns4="
                            ],
                            kTSKIncludeSubdomains: @YES
                    },
                    @"gw1.judopay.com": @{
                            kTSKPublicKeyHashes: @[
                                    @"SuY75QgkSNBlMtHNPeW9AayE7KNDAypMBHlJH9GEhXs=",
                                    @"c4zbAoMygSbepJKqU3322FvFv5unm+TWZROW3FHU1o8=",
                            ],
                            kTSKIncludeSubdomains: @YES
                    }
            }
            };

    self.trustKit = [[TrustKit alloc] initWithConfiguration:trustKitConfig];
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

#pragma mark - Private implementation

- (NSDictionary<NSString *, NSString *> *)requestHeaders {
    if (!_requestHeaders) {
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:self.configuration.authorization.headers];
        headers[kHeaderFieldContentType] = kContentTypeJSON;
        headers[kHeaderFieldAccept] = kContentTypeJSON;
        headers[kHeaderFieldAPIVersion] = kAPIVersion;
        headers[kHeaderFieldUserAgent] = getUserAgent();
        _requestHeaders = [NSDictionary dictionaryWithDictionary:headers];
    }
    return _requestHeaders;
}

- (void)performRequestWithMethod:(NSString *)HTTPMethod
                        endpoint:(NSString *)path
                      parameters:(NSDictionary *)parameters
                   andCompletion:(JPCompletionBlock)completion {

    if (!self.reachability.isReachable) {
        completion(nil, JPError.judoInternetConnectionError);
        return;
    }

    NSURL *url = [self.configuration.apiBaseURL URLByAppendingPathComponent:path];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = HTTPMethod;

    [self.requestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [request addValue:obj forHTTPHeaderField:key];
    }];

    if (parameters) {
        //TODO: handle serialization errors
        request.HTTPBody = [parameters toJSONObjectData];
    }

    NSURLSessionDataTask *task = [self task:request completion:completion];
    [task resume];
}

- (NSURLSessionDataTask *)task:(NSURLRequest *)request completion:(JPCompletionBlock)completion {

    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                             delegate:self
                                                        delegateQueue:nil];

    return [urlSession dataTaskWithRequest:request
                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                             if (!completion) {
                                 return;
                             }

                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [self handleResult:data error:error andCompletion:completion];
                             });
                         }];
}

- (void)handleResult:(NSData *)data
               error:(NSError *)error
       andCompletion:(JPCompletionBlock)completion {

    if (error || !data) {
        JPError *jpError = error ? (JPError *) error : JPError.judoRequestFailedError;
        completion(nil, jpError);
        return;
    }

    __block JPError *jsonError = nil;
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&jsonError];

    if (jsonError || !responseJSON) {
        if (!jsonError) {
            jsonError = [JPError judoJSONSerializationFailedWithError:jsonError];
        }
        completion(nil, jsonError);
        return;
    }

    if (responseJSON[@"code"]) {
        completion(nil, [JPError judoErrorFromDictionary:responseJSON]);
        return;
    }

    if (responseJSON[@"acsUrl"] && responseJSON[@"paReq"]) {
        completion(nil, [JPError judo3DSRequestWithPayload:responseJSON]);
        return;
    }

    JPResponse *result = [[JPResponse alloc] initWithPagination:nil];

    [result appendItem:responseJSON];

    switch (result.items.firstObject.result) {
        case JPTransactionResultSuccess:
            completion(result, nil);
            break;

        case JPTransactionResultDeclined:
            completion(nil, [JPError judoErrorCardDeclined]);
            break;

        case JPTransactionResultError:
        default:
            completion(nil, [JPError judoErrorFromTransactionData:result.items.firstObject]);
    }
}

#pragma mark - URLSession SSL pinning

- (void) URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
  completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler {

    TSKPinningValidator *pinningValidator = self.trustKit.pinningValidator;
    if (![pinningValidator handleChallenge:challenge completionHandler:completionHandler]) {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }

    [session finishTasksAndInvalidate];
}

@end
