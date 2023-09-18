//
//  RecommendationApiService.m
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

#import "JPApiService.h"
#import "JP3DSecureAuthenticationResult.h"
#import "JPApplePayRequest.h"
#import "JPError+Additions.h"
#import "JPRequestEnricher.h"
#import "RecommendationSession.h"
#import "RecommendationSessionConfiguration.h"
#import "NSObject+Additions.h"
#import "RecommendationApiService.h"
#import "NSObject+Additions.h"
#import "RecommendationRequest.h"

typedef NS_ENUM(NSUInteger, JPHTTPMethod) {
    JPHTTPMethodGET,
    JPHTTPMethodPOST,
    JPHTTPMethodPUT
};

@interface RecommendationApiService ()

@property (nonatomic, strong) RecommendationSession *session;
@property (nonatomic, strong) JPRequestEnricher *enricher;
@property (nonatomic, strong) NSArray<NSString *> *enricheablePaths;

@end

@implementation RecommendationApiService

#pragma mark - Initializers

- (instancetype)initWithAuthorization:(id<JPAuthorization>)authorization {

    if (self = [super init]) {
        _authorization = authorization;
        _enricheablePaths = @[ @"" ];
        _enricher = [JPRequestEnricher new];

        [self setUpSession];
    }
    return self;
}

- (void)setUpSession {
    RecommendationSessionConfiguration *configuration = [RecommendationSessionConfiguration configurationWithAuthorization:self.authorization];
    _session = [RecommendationSession sessionWithConfiguration:configuration];
}

#pragma mark - Public methods

- (void)setAuthorization:(id<JPAuthorization>)authorization {
    _authorization = authorization;
    [self setUpSession];
}

- (void)invokeRecommendationRequest:(NSDictionary *)parameters
                   andRecommendationUrl:(NSString *)recommendationUrl
                          andCompletion:(JPCompletionBlock)completion{

    [self performRequestWithMethod:JPHTTPMethodPOST
                          endpoint:recommendationUrl
                        parameters:parameters
                     andCompletion:completion];
}


#pragma mark - Helper methods

- (void)performRequestWithMethod:(JPHTTPMethod)method
                        endpoint:(NSString *)endpoint
                      parameters:(NSDictionary *)parameters
                   andCompletion:(JPCompletionBlock)completion {

    BOOL shouldEnrich = [self.enricheablePaths containsObject:endpoint];

    JPEnricherCompletionBlock enricherCompletion = ^(NSDictionary *enrichedRequest) {
        switch (method) {
            case JPHTTPMethodPOST:
                [self.session POST:endpoint parameters:enrichedRequest andCompletion:completion];
                break;
            default:
                completion(nil, JPError.requestFailedError);
        }
    };

    if (shouldEnrich) {
        [self.enricher enrichRequestParameters:parameters withCompletion:enricherCompletion];
    } else {
        enricherCompletion(parameters);
    }
}

@end
