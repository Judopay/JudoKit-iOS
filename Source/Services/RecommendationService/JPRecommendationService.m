//
//  JPRecommendationService.m
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

#import "JPRecommendationService.h"
#import "JPAuthorization.h"
#import "JPCardTransactionDetails.h"
#import "JPConstants.h"
#import "JPError+Additions.h"
#import "JPReachability.h"
#import "JPRecommendationConfiguration.h"
#import "JPRecommendationRequest.h"
#import "JPRecommendationResponse.h"
#import "NSObject+Additions.h"
#import <RavelinEncrypt/RavelinEncrypt.h>

@interface NSURLRequest (Additions)
+ (instancetype)requestWithConfiguration:(JPRecommendationConfiguration *)configuration
                           authorization:(id<JPAuthorization>)authorization
                          andCardDetails:(NSDictionary *)details;
@end

@implementation NSURLRequest (Additions)

+ (instancetype)requestWithConfiguration:(JPRecommendationConfiguration *)configuration
                           authorization:(id<JPAuthorization>)authorization
                          andCardDetails:(NSDictionary *)details {

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:configuration.URL];
    request.HTTPMethod = kMethodPOST;

    if (configuration.timeout) {
        request.timeoutInterval = configuration.timeout.doubleValue;
    }

    [request addValue:kContentTypeJSON forHTTPHeaderField:kHeaderFieldContentType];
    [request addValue:kContentTypeJSON forHTTPHeaderField:kHeaderFieldAccept];

    [request addValue:authorization.headers[kHeaderFieldPaymentSession]
   forHTTPHeaderField:kHeaderFieldPaymentSession.lowercaseString];

    JPRecommendationRequest *requestBody = [[JPRecommendationRequest alloc] initWithDictionary:details];
    request.HTTPBody = requestBody._jp_toJSONObjectData;

    return request;
}

@end

@interface JPRecommendationService () <NSURLSessionDelegate>

@property (nonatomic, strong) JPReachability *reachability;
@property (nonatomic, strong) NSURLSession *urlSession;

@end

@implementation JPRecommendationService

- (nonnull instancetype)initWithConfiguration:(JPRecommendationConfiguration *)configuration
                             andAuthorization:(id<JPAuthorization>)authorization {
    if (self = [super init]) {
        self.authorization = authorization;
        self.configuration = configuration;

        self.urlSession = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    }
    return self;
}

- (void)fetchOptimizationDataWithDetails:(JPCardTransactionDetails *)details
                         transactionType:(JPCardTransactionType)type
                           andCompletion:(JPRecommendationCompletionBlock)completion {
    if ([self shouldPreventRecommendationRequestForTransactionWithType:type]) {
        completion(nil);
        return;
    }

    NSDictionary *cardDetails = [self encryptCardDetails:details];

    if (!cardDetails) {
        completion(nil);
        return;
    }

    NSURLRequest *request = [NSURLRequest requestWithConfiguration:self.configuration
                                                     authorization:self.authorization
                                                    andCardDetails:cardDetails];

    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *__unused response, NSError *__unused error) {
                                                        if (!completion) {
                                                            return;
                                                        }
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            completion([JPRecommendationResponse responseWithJSONData:data]);
                                                        });
                                                    }];
    [task resume];
}

- (BOOL)shouldPreventRecommendationRequestForTransactionWithType:(JPCardTransactionType)type {
    BOOL isRecommendationFeatureAvailable = self.configuration && (type == JPCardTransactionTypePayment ||
                                                                   type == JPCardTransactionTypeCheck ||
                                                                   type == JPCardTransactionTypePreAuth);

    return !isRecommendationFeatureAvailable || !self.reachability.isReachable;
}

- (NSDictionary *)encryptCardDetails:(JPCardTransactionDetails *)details {
    RVNEncryption.sharedInstance.rsaKey = self.configuration.RSAPublicKey;

    NSError *error;
    NSArray *components = [details.expiryDate componentsSeparatedByString:@"/"];

    NSDictionary *payload = [RVNEncryption.sharedInstance encrypt:details.cardNumber
                                                            month:components.firstObject
                                                             year:components.lastObject
                                                       nameOnCard:details.cardholderName
                                                            error:&error];
    if (!error) {
        return payload;
    } else {
        return nil;
    }
}

- (void)setConfiguration:(JPRecommendationConfiguration *)configuration {
    _configuration = configuration;

    if (self.configuration.URL) {
        self.reachability = [JPReachability reachabilityWithURL:self.configuration.URL];
    }
}

@end
