//
//  RecommendationSession.m
//  JudoKit_iOS
//
//  Copyright (c) 2023 Alternative Payments Ltd
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

#import "Functions.h"
#import "JPAuthorization.h"
#import "JPError+Additions.h"
#import "JudoKit.h"
#import "RecommendationSessionConfiguration.h"
#import "RecommendationSession.h"
#import "NSObject+Additions.h"

#pragma mark - Constants

static NSString *const kContentTypeJSON = @"application/json";
static NSString *const kHeaderFieldContentType = @"Content-Type";
static NSString *const kHeaderFieldAccept = @"Accept";

@interface RecommendationSession () <NSURLSessionDelegate>
@property (nonatomic, strong, readwrite) RecommendationSessionConfiguration *configuration;
@property (nonatomic, strong, readwrite) NSDictionary<NSString *, NSString *> *requestHeaders;
@end

@implementation RecommendationSession

#pragma mark - Initializers

+ (instancetype)sessionWithConfiguration:(RecommendationSessionConfiguration *)configuration {
    return [[RecommendationSession alloc] initWithConfiguration:configuration];
}

- (instancetype)initWithConfiguration:(RecommendationSessionConfiguration *)configuration {
    if (self = [super init]) {
        NSAssert(configuration, @"Configuration should not be nil");
        _configuration = configuration;
    }
    return self;
}

#pragma mark - REST API methods

- (void)POST:(NSString *)endpoint parameters:(NSDictionary *)parameters andCompletion:(RecommendationCompletionBlock)completion {
    [self performRequestWithEndpoint:endpoint parameters:parameters andCompletion:completion];
}

#pragma mark - Private implementation

- (NSDictionary<NSString *, NSString *> *)requestHeaders {
    if (!_requestHeaders) {
        // Todo: Confirm with Stefan whether we can pass all of these headers to Recommendation API.
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:self.configuration.authorization.headers];
        headers[kHeaderFieldContentType] = kContentTypeJSON;
        headers[kHeaderFieldAccept] = kContentTypeJSON;
        _requestHeaders = [NSDictionary dictionaryWithDictionary:headers];
    }
    return _requestHeaders;
}

- (void)performRequestWithEndpoint:(NSString *)path
                        parameters:(NSDictionary *)parameters
                     andCompletion:(RecommendationCompletionBlock)completion {
    NSURL *_Nullable url = [NSURL URLWithString:path];
    if (url != nil) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";

        [self.requestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *__unused stop) {
            [request addValue:obj forHTTPHeaderField:key];
        }];

        if (parameters) {
            // Todo: Should we rename _jp_toJSONObjectData to _toJSONObjectData?
            request.HTTPBody = [parameters _jp_toJSONObjectData];
        }

        NSURLSessionDataTask *task = [self task:request completion:completion];
        [task resume];
    } else {
        // Todo: JP error
        completion(nil, JPError.requestFailedError);
    }
}

- (NSURLSessionDataTask *)task:(NSURLRequest *)request completion:(RecommendationCompletionBlock)completion {

    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                             delegate:self
                                                        delegateQueue:nil];

    return [urlSession dataTaskWithRequest:request
                         completionHandler:^(NSData *data, NSURLResponse *__unused response, NSError *error) {
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
       andCompletion:(RecommendationCompletionBlock)completion {

    if (error || !data) {
        // Todo: JP error
        JPError *jpError = error ? (JPError *)error : JPError.requestFailedError;
        completion(nil, jpError);
        return;
    }

    // Todo: JP error
    __block JPError *jsonError = nil;
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&jsonError];

    if (jsonError || !responseJSON) {
        if (!jsonError) {
            // Todo: JP error
            jsonError = [JPError JSONSerializationFailedWithError:jsonError];
        }
        completion(nil, jsonError);
        return;
    }

    RecommendationResult *result = [[RecommendationResult alloc] initWithDictionary:responseJSON];
    completion(result, nil);
}

#pragma mark - URLSession SSL pinning

- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler {
    // Todo: do we need this?
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    [session finishTasksAndInvalidate];
}

@end
