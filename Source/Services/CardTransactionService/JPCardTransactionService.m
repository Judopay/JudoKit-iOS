//
//  JPCardTransactionService.m
//  JudoKit_iOS
//
//  Copyright (c) 2022 Alternative Payments Ltd
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

#import "JPCardTransactionService.h"

#import <Judo3DS2_iOS/Judo3DS2_iOS.h>

#import "JP3DSConfiguration.h"
#import "JPApiService.h"
#import "RecommendationApiService.h"
#import "JPCReqParameters.h"
#import "JPCardTransactionDetails+Additions.h"
#import "JPCardTransactionDetails.h"
#import "JPCheckCardRequest.h"
#import "JPComplete3DS2Request.h"
#import "JPConfiguration.h"
#import "JPError+Additions.h"
#import "JPPaymentRequest.h"
#import "JPPreAuthRequest.h"
#import "JPPreAuthTokenRequest.h"
#import "JPRegisterCardRequest.h"
#import "JPResponse+Additions.h"
#import "JPResponse.h"
#import "JPSaveCardRequest.h"
#import "JPTokenRequest.h"
#import "JPUIConfiguration.h"
#import "RavelinCardEncryptionService.h"
#import "UIApplication+Additions.h"
#import "JPCardTransactionTypedefs.h"
#import "RecommendationConfiguration.h"
#import "RecommendationRequest.h"

@interface JP3DSChallengeStatusReceiverImpl : NSObject <JP3DSChallengeStatusReceiver>

@property (strong, nonatomic) JPApiService *apiService;
@property (strong, nonatomic) JPCompletionBlock completion;
@property (strong, nonatomic) JPCardTransactionDetails *details;
@property (strong, nonatomic) JPResponse *response;

- (instancetype)initWithApiService:(JPApiService *)apiService
                           details:(JPCardTransactionDetails *)details
                          response:(JPResponse *)response
                     andCompletion:(JPCompletionBlock)completion;

@end

@implementation JP3DSChallengeStatusReceiverImpl

- (instancetype)initWithApiService:(JPApiService *)apiService
                           details:(JPCardTransactionDetails *)details
                          response:(JPResponse *)response
                     andCompletion:(JPCompletionBlock)completion {
    if (self = [super init]) {
        _apiService = apiService;
        _completion = completion;
        _details = details;
        _response = response;
    }
    return self;
}

#pragma mark - JP3DSChallengeStatusReceiver

- (void)transactionCompletedWithCompletionEvent:(JP3DSCompletionEvent *)completionEvent {
    [self performComplete3DS2];
}

- (void)transactionCancelled {
    [self performComplete3DS2];
}

- (void)transactionTimedOut {
    [self performComplete3DS2];
}

- (void)transactionFailedWithProtocolErrorEvent:(JP3DSProtocolErrorEvent *)protocolErrorEvent {
    [self performComplete3DS2];
}

- (void)transactionFailedWithRuntimeErrorEvent:(JP3DSRuntimeErrorEvent *)runtimeErrorEvent {
    [self performComplete3DS2];
}

- (void)performComplete3DS2 {
    JPComplete3DS2Request *request = [[JPComplete3DS2Request alloc] initWithVersion:self.response.cReqParameters.messageVersion
                                                                      andSecureCode:self.details.securityCode];

    [self.apiService invokeComplete3dSecureTwoWithReceiptId:self.response.receiptId
                                                    request:request
                                              andCompletion:self.completion];
}

@end

@interface JPCardTransactionService ()

@property (strong, nonatomic) JPConfiguration *configuration;
@property (strong, nonatomic) JPApiService *apiService;
@property (strong, nonatomic) RecommendationApiService *recommendationApiService;
@property (strong, nonatomic) RavelinCardEncryptionService *encryptionService;

@property (strong, nonatomic) JP3DS2Service *threeDSTwoService;
@property (strong, nonatomic) JP3DSConfigParameters *threeDSTwoConfigParameters;

@property (strong, nonatomic) JP3DSTransaction *transaction;
@end

@implementation JPCardTransactionService

- (instancetype)initWithAPIService:(JPApiService *)apiService
                  andRecommendationApiService:(RecommendationApiService *)recommendationApiService
                  andConfiguration:(JPConfiguration *)configuration
   andRavelinCardEncryptionService:(nullable RavelinCardEncryptionService *)encryptionService {
    if (self = [super init]) {
        _configuration = configuration;
        _apiService = apiService;
        _recommendationApiService = recommendationApiService;
        _encryptionService = encryptionService;

        [self.threeDSTwoService initializeWithConfigParameters:self.threeDSTwoConfigParameters
                                                        locale:nil
                                               uiCustomization:configuration.uiConfiguration.threeDSUICustomization];
    }
    return self;
}

// Todo: Should I add Encryption Service also here? Check it.
- (instancetype)initWithAuthorization:(id<JPAuthorization>)authorization
                          isSandboxed:(BOOL)sandboxed
                     andConfiguration:(JPConfiguration *)configuration {
    if (self = [super init]) {
        _configuration = configuration;
        _apiService = [[JPApiService alloc] initWithAuthorization:authorization isSandboxed:sandboxed];
        _recommendationApiService = [[RecommendationApiService alloc] initWithAuthorization:authorization];

        [self.threeDSTwoService initializeWithConfigParameters:self.threeDSTwoConfigParameters locale:nil uiCustomization:configuration.uiConfiguration.threeDSUICustomization];
    }
    return self;
}

- (void)performTransactionWithType:(JPCardTransactionType)type
                           details:(JPCardTransactionDetails *)details
                     andCompletion:(JPCompletionBlock)completion {
    @try {
        NSString *dsServerID = _apiService.isSandboxed ? @"F000000000" : @"unknown-id";

        switch (details.cardType) {
            case JPCardNetworkTypeVisa:
                dsServerID = _apiService.isSandboxed ? @"F055545342" : @"A000000003";
                break;
            case JPCardNetworkTypeMasterCard:
            case JPCardNetworkTypeMaestro:
                dsServerID = _apiService.isSandboxed ? @"F155545342" : @"A000000004";
                break;
            case JPCardNetworkTypeAMEX:
                dsServerID = @"A000000025";
                break;
            default:
                break;
        }

        NSString *messageVersion = self.configuration.threeDSTwoMessageVersion;
        JP3DSTransaction *transaction = [self.threeDSTwoService createTransactionWithDirectoryServerID:dsServerID
                                                                                        messageVersion:messageVersion];

        JPCompletionBlock completionHandler = ^(JPResponse *response, JPError *error) {
            if (response) {
                if ([response isThreeDSecureTwoRequired]) {
                    JP3DSChallengeStatusReceiverImpl *receiverImpl = [[JP3DSChallengeStatusReceiverImpl alloc] initWithApiService:self.apiService
                                                                                                                          details:details
                                                                                                                         response:response
                                                                                                                    andCompletion:completion];

                    JPCReqParameters *cReqParameters = [response cReqParameters];
                    NSString *version = cReqParameters.messageVersion ? cReqParameters.messageVersion : messageVersion;
                    JP3DSChallengeParameters *params = [[JP3DSChallengeParameters alloc] initWithThreeDSServerTransactionID:cReqParameters.threeDSServerTransID
                                                                                                           acsTransactionID:cReqParameters.acsTransID
                                                                                                               acsRefNumber:response.rawData[@"acsReferenceNumber"]
                                                                                                           acsSignedContent:response.rawData[@"acsSignedContent"]
                                                                                                     threeDSRequestorAppURL:nil
                                                                                                             messageVersion:version];

                    [transaction doChallengeWithChallengeParameters:params
                                            challengeStatusReceiver:receiverImpl
                                                            timeOut:30];
                } else {
                    completion(response, nil);
                }
            } else {
                completion(nil, error);
            }
        };
        
        JPCompletionBlock recommendationCompletionHandler = ^(JPResponse *response, JPError *error) {
            if (response) {
                completion(response, nil);
                NSLog(@"TESTO 03");
            } else {
                completion(nil, error);
                NSLog(@"TESTO 04");
            }
        };
        
        // Todo: Encryption; hard-coded 'true' for isRavelinEncryptionEnabled
        Boolean isCardEncryptionRequired = [self.encryptionService isCardEncryptionRequiredWithType:type isRavelinEncryptionEnabled:true];
        if (isCardEncryptionRequired) {
            NSString *cardNumber = details.cardNumber;
            NSString *cardHolderName = details.cardholderName;
            NSString *expirationDate = details.expiryDate;
            NSString *rsaKey = self.configuration.recommendationConfiguration.rsaKey;
            
            // Encryption
            NSDictionary *encryptedCard = [self.encryptionService performCardEncryptionWithCardNumber:cardNumber cardHolderName:cardHolderName expirationDate:expirationDate rsaKey:rsaKey];
            if (encryptedCard != nil) {
                
                // Temporary here for development only, will be moved soon
                // Recommendation API Call
                NSString *recommendationUrl = self.configuration.recommendationConfiguration.recommendationURL;
                RecommendationRequest *request = [[RecommendationRequest alloc] initWithEncryptedCardDetails:encryptedCard];
                [self.recommendationApiService invokeRecommendationRequest:request andRecommendationUrl: recommendationUrl andCompletion:recommendationCompletionHandler];
            } else {
                // todo
            }
            
        }
        
        switch (type) {
            case JPCardTransactionTypePayment: {
                JPPaymentRequest *request = [details toPaymentRequestWithConfiguration:self.configuration
                                                                        andTransaction:transaction];
                [self.apiService invokePaymentWithRequest:request andCompletion:completionHandler];
            } break;

            case JPCardTransactionTypePreAuth: {
                JPPreAuthRequest *request = [details toPreAuthPaymentRequestWithConfiguration:self.configuration
                                                                               andTransaction:transaction];
                [self.apiService invokePreAuthPaymentWithRequest:request andCompletion:completionHandler];
            } break;

            case JPCardTransactionTypePaymentWithToken: {
                JPTokenRequest *request = [details toTokenRequestWithConfiguration:self.configuration
                                                                    andTransaction:transaction];
                [self.apiService invokeTokenPaymentWithRequest:request andCompletion:completionHandler];
            } break;

            case JPCardTransactionTypePreAuthWithToken: {
                JPPreAuthTokenRequest *request = [details toPreAuthTokenRequestWithConfiguration:self.configuration
                                                                                  andTransaction:transaction];
                [self.apiService invokePreAuthTokenPaymentWithRequest:request andCompletion:completionHandler];
            } break;

            case JPCardTransactionTypeSave: {
                JPSaveCardRequest *request = [details toSaveCardRequestWithConfiguration:self.configuration
                                                                          andTransaction:transaction];
                [self.apiService invokeSaveCardWithRequest:request andCompletion:completionHandler];
            } break;

            case JPCardTransactionTypeCheck: {
                JPCheckCardRequest *request = [details toCheckCardRequestWithConfiguration:self.configuration
                                                                            andTransaction:transaction];
                [self.apiService invokeCheckCardWithRequest:request andCompletion:completionHandler];
            } break;

            case JPCardTransactionTypeRegister: {
                JPRegisterCardRequest *request = [details toRegisterCardRequestWithConfiguration:self.configuration
                                                                                  andTransaction:transaction];
                [self.apiService invokeRegisterCardWithRequest:request andCompletion:completionHandler];
            } break;
            default:
                completion(nil, [[JPError alloc] initWithDomain:JudoErrorDomain code:JudoErrorThreeDSTwo userInfo:nil]);
                break;
        }
    } @catch (NSException *exception) {
        JPError *error = [JPError threeDSTwoErrorFromException:exception];
        completion(nil, error);
    }
}

- (void)invokePaymentWithDetails:(JPCardTransactionDetails *)details andCompletion:(JPCompletionBlock)completion {
    [self performTransactionWithType:JPCardTransactionTypePayment details:details andCompletion:completion];
}

- (void)invokePreAuthPaymentWithDetails:(JPCardTransactionDetails *)details andCompletion:(JPCompletionBlock)completion {
    [self performTransactionWithType:JPCardTransactionTypePreAuth details:details andCompletion:completion];
}

- (void)invokeTokenPaymentWithDetails:(JPCardTransactionDetails *)details andCompletion:(JPCompletionBlock)completion {
    [self performTransactionWithType:JPCardTransactionTypePaymentWithToken details:details andCompletion:completion];
}

- (void)invokePreAuthTokenPaymentWithDetails:(JPCardTransactionDetails *)details andCompletion:(JPCompletionBlock)completion {
    [self performTransactionWithType:JPCardTransactionTypePreAuthWithToken details:details andCompletion:completion];
}

- (void)invokeSaveCardWithDetails:(JPCardTransactionDetails *)details andCompletion:(JPCompletionBlock)completion {
    [self performTransactionWithType:JPCardTransactionTypeSave details:details andCompletion:completion];
}

- (void)invokeCheckCardWithDetails:(JPCardTransactionDetails *)details andCompletion:(JPCompletionBlock)completion {
    [self performTransactionWithType:JPCardTransactionTypeCheck details:details andCompletion:completion];
}

- (void)invokeRegisterCardWithDetails:(JPCardTransactionDetails *)details andCompletion:(JPCompletionBlock)completion {
    [self performTransactionWithType:JPCardTransactionTypeRegister details:details andCompletion:completion];
}

- (void)cleanup {
    [self.threeDSTwoService cleanUp];
}

#pragma mark - Lazy properties

- (JP3DSConfigParameters *)threeDSTwoConfigParameters {
    if (!_threeDSTwoConfigParameters) {
        _threeDSTwoConfigParameters = [JP3DSConfigParameters new];
    }

    return _threeDSTwoConfigParameters;
}

- (JP3DS2Service *)threeDSTwoService {
    if (!_threeDSTwoService) {
        _threeDSTwoService = [JP3DS2Service new];
    }
    return _threeDSTwoService;
}

@end
