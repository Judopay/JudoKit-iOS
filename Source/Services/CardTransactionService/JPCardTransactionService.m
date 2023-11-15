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
#import "UIApplication+Additions.h"
#import "JPCardTransactionTypedefs.h"
#import "RecommendationConfiguration.h"
#import "RecommendationApiService.h"
#import "RecommendationRequest.h"
#import "RecommendationResponse.h"
#import "RecommendationCardEncryptionService.h"
#import "RecommendationData.h"

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

BOOL canBeSoftDeclined(JPCardTransactionType type) {
    return type == JPCardTransactionTypePayment || type == JPCardTransactionTypePreAuth || type == JPCardTransactionTypePaymentWithToken || type == JPCardTransactionTypePreAuthWithToken || type == JPCardTransactionTypeRegister;
}

@interface JPCardTransactionService ()

@property (strong, nonatomic) JPConfiguration *configuration;
@property (strong, nonatomic) JPApiService *apiService;
@property (strong, nonatomic) RecommendationApiService *recommendationApiService;
@property (strong, nonatomic) RecommendationCardEncryptionService *encryptionService;

@property (strong, nonatomic) JP3DS2Service *threeDSTwoService;
@property (strong, nonatomic) JP3DSConfigParameters *threeDSTwoConfigParameters;

@property (strong, nonatomic) JP3DSTransaction *transaction;
@end

@implementation JPCardTransactionService

- (instancetype)initWithAPIService:(JPApiService *)apiService
          recommendationApiService:(RecommendationApiService *)recommendationApiService
                     configuration:(JPConfiguration *)configuration
recommendationCardEncryptionService:(nullable RecommendationCardEncryptionService *)encryptionService {
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

- (instancetype)initWithAuthorization:(id<JPAuthorization>)authorization
                          isSandboxed:(BOOL)sandboxed
                     andConfiguration:(JPConfiguration *)configuration {
    if (self = [super init]) {
        _configuration = configuration;
        _apiService = [[JPApiService alloc] initWithAuthorization:authorization isSandboxed:sandboxed];
        _recommendationApiService = [[RecommendationApiService alloc] initWithAuthorization:authorization];
        _encryptionService = [[RecommendationCardEncryptionService alloc] init];

        [self.threeDSTwoService initializeWithConfigParameters:self.threeDSTwoConfigParameters locale:nil uiCustomization:configuration.uiConfiguration.threeDSUICustomization];
    }
    return self;
}

- (void)performTransactionWithType:(JPCardTransactionType)type
                           details:(JPCardTransactionDetails *)details
              softDeclineReceiptId:(NSString *)receiptId
                     andCompletion:(JPCompletionBlock)completion {
    Boolean isCardEncryptionEnabled = self.configuration.recommendationConfiguration != nil;
    Boolean isCardEncryptionRequired = [self.encryptionService isCardEncryptionRequiredWithType:type
                                                                 isRecommendationFeatureEnabled:isCardEncryptionEnabled];
    if (isCardEncryptionRequired) {
        [self performRecommendationApiCall:details
                                      type:type
                                completion:completion];
    } else {
        [self performJudoApiCall:details
                            type:type
                      completion:completion
                       exemption:UNKNOWN_OR_NOT_PRESENT_EXCEPTION
       challengeRequestIndicator:nil];
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

- (BOOL)validateRecommendationResponse:(RecommendationResponse *)result {
    if (result == nil) {
        return NO;
    }

    if (result.data == nil) {
        return NO;
    }

    RecommendationData *data = result.data;

    if (data.action == UNKNOWN_RECOMMENDATION_ACTION || data.transactionOptimisation == nil) {
        return NO;
    }

    if (data.action == ALLOW || data.action == REVIEW) {
        if (data.transactionOptimisation.action == UNKNOWN_TRANSACTION_OPTIMISATION_ACTION) {
            return NO;
        }
        if (data.transactionOptimisation.exemption == UNKNOWN_OR_NOT_PRESENT_EXCEPTION && data.transactionOptimisation.threeDSChallengePreference == nil) {
            return NO;
        }
    }

    return YES;
}

- (void)performRecommendationApiCall:(JPCardTransactionDetails *)details
                                type:(JPCardTransactionType)type
                          completion:(JPCompletionBlock)completion {
    NSString *cardNumber = details.cardNumber;
    NSString *cardHolderName = details.cardholderName;
    NSString *expirationDate = details.expiryDate;
    NSString *rsaKey = self.configuration.recommendationConfiguration.rsaKey;

    // Encryption
    NSDictionary *encryptedCard = [self.encryptionService performCardEncryptionWithCardNumber:cardNumber cardHolderName:cardHolderName expirationDate:expirationDate rsaKey:rsaKey];
    if (encryptedCard != nil) {

        // Recommendation API Call
        NSString *recommendationUrl = self.configuration.recommendationConfiguration.recommendationURL;
        NSNumber *recommendationTimeout = self.configuration.recommendationConfiguration.recommendationTimeout;
        // Todo: Timeout in seconds, not minutes!
        RecommendationCompletionBlock recommendationCompletionHandler = ^(RecommendationResponse *response, NSString *error) {
            [self handleRecommendationApiResult:response
                                        details:details
                                           type:type
                                     completion:completion];
        };
        RecommendationRequest *request = [[RecommendationRequest alloc] initWithEncryptedCardDetails:encryptedCard];
        [self.recommendationApiService invokeRecommendationRequest:request
                                                 recommendationUrl:recommendationUrl
                                                           timeout:recommendationTimeout
                                                        completion:recommendationCompletionHandler];
    } else {
        // We allow Judo API call in this case, as the API will perform its own checks anyway.
        [self performJudoApiCall:details
                            type:type
                      completion:completion
                       exemption:nil
       challengeRequestIndicator:nil];
    }
}

- (void)performJudoApiCall:(JPCardTransactionDetails *)details
                      type:(JPCardTransactionType)type
                completion:(JPCompletionBlock)completion
                 exemption:(ScaExemption)exemption
 challengeRequestIndicator:(nullable NSString *)challengeRequestIndicator {
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

        __weak typeof(self) weakSelf = self;
        JPCompletionBlock completionHandler = ^(JPResponse *response, JPError *error) {
            if (response) {
                if (canBeSoftDeclined(type) && response.isSoftDeclined) {
                    [weakSelf performTransactionWithType:type details:details softDeclineReceiptId:response.receiptId andCompletion:completion];
                } else if ([response isThreeDSecureTwoRequired]) {
                    JP3DSChallengeStatusReceiverImpl *receiverImpl = [[JP3DSChallengeStatusReceiverImpl alloc] initWithApiService:weakSelf.apiService
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

        switch (type) {
            case JPCardTransactionTypePayment: {
                JPPaymentRequest *request = [details toPaymentRequestWithConfiguration:self.configuration
                                                                  softDeclineReceiptId:receiptId
                                                                           transaction:transaction
                                                            recommendationScaExemption:exemption
                                            andRecommendationChallengeRequestIndicator:challengeRequestIndicator];
                [self.apiService invokePaymentWithRequest:request andCompletion:completionHandler];
            } break;

            case JPCardTransactionTypePreAuth: {
                JPPreAuthRequest *request = [details toPreAuthPaymentRequestWithConfiguration:self.configuration
                                                                         softDeclineReceiptId:receiptId
                                                                                  transaction:transaction
                                                                   recommendationScaExemption:exemption
                                                   andRecommendationChallengeRequestIndicator:challengeRequestIndicator];
                [self.apiService invokePreAuthPaymentWithRequest:request andCompletion:completionHandler];
            } break;

            case JPCardTransactionTypePaymentWithToken: {
                JPTokenRequest *request = [details toTokenRequestWithConfiguration:self.configuration
                                                              softDeclineReceiptId:receiptId
                                                                    andTransaction:transaction];
                [self.apiService invokeTokenPaymentWithRequest:request andCompletion:completionHandler];
            } break;

            case JPCardTransactionTypePreAuthWithToken: {
                JPPreAuthTokenRequest *request = [details toPreAuthTokenRequestWithConfiguration:self.configuration
                                                                            softDeclineReceiptId:receiptId
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
                                                                               transaction:transaction
                                                                recommendationScaExemption:exemption
                                                   recommendationChallengeRequestIndicator:challengeRequestIndicator];
                [self.apiService invokeCheckCardWithRequest:request andCompletion:completionHandler];
            } break;

            case JPCardTransactionTypeRegister: {
                JPRegisterCardRequest *request = [details toRegisterCardRequestWithConfiguration:self.configuration
                                                                            softDeclineReceiptId:receiptId
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

- (void)handleRecommendationApiResult:(RecommendationResponse *)result
                              details:(JPCardTransactionDetails *)details
                                 type:(JPCardTransactionType)type
                           completion:(JPCompletionBlock)completion; {
    BOOL isRecommendationResponseValid = [self validateRecommendationResponse:result];
    if (isRecommendationResponseValid) {
        RecommendationAction recommendationAction = result.data.action;
        TransactionOptimisation *transactionOptimisation = result.data.transactionOptimisation;
        ScaExemption *exemptionReceived = transactionOptimisation.exemption;
        NSString *threeDSChallengePreferenceReceived = transactionOptimisation.threeDSChallengePreference;
        if (recommendationAction == ALLOW || recommendationAction == REVIEW) {
            [self performJudoApiCall:details
                                type:type
                          completion:completion
                           exemption:exemptionReceived
           challengeRequestIndicator:threeDSChallengePreferenceReceived];
        } else if (recommendationAction == PREVENT) {
            NSString * error = @"The Recommendation Feature has prevented this transaction.";
            completion(nil, error);
        }
    } else {
        // We allow Judo API call in this case, as the API will perform its own checks anyway.
        [self performJudoApiCall:details
                            type:type
                      completion:completion
                       exemption:UNKNOWN_OR_NOT_PRESENT_EXCEPTION
       challengeRequestIndicator:nil];
    }
}

- (void)invokePaymentWithDetails:(JPCardTransactionDetails *)details andCompletion:(JPCompletionBlock)completion {
    [self performTransactionWithType:JPCardTransactionTypePayment details:details softDeclineReceiptId:nil andCompletion:completion];
}

- (void)invokePreAuthPaymentWithDetails:(JPCardTransactionDetails *)details andCompletion:(JPCompletionBlock)completion {
    [self performTransactionWithType:JPCardTransactionTypePreAuth details:details softDeclineReceiptId:nil andCompletion:completion];
}

- (void)invokeTokenPaymentWithDetails:(JPCardTransactionDetails *)details andCompletion:(JPCompletionBlock)completion {
    [self performTransactionWithType:JPCardTransactionTypePaymentWithToken details:details softDeclineReceiptId:nil andCompletion:completion];

- (void)invokePreAuthTokenPaymentWithDetails:(JPCardTransactionDetails *)details andCompletion:(JPCompletionBlock)completion {
    [self performTransactionWithType:JPCardTransactionTypePreAuthWithToken details:details softDeclineReceiptId:nil andCompletion:completion];
}

- (void)invokeSaveCardWithDetails:(JPCardTransactionDetails *)details andCompletion:(JPCompletionBlock)completion {
    [self performTransactionWithType:JPCardTransactionTypeSave details:details softDeclineReceiptId:nil andCompletion:completion];
}

- (void)invokeCheckCardWithDetails:(JPCardTransactionDetails *)details andCompletion:(JPCompletionBlock)completion {
    [self performTransactionWithType:JPCardTransactionTypeCheck details:details softDeclineReceiptId:nil andCompletion:completion];
}

- (void)invokeRegisterCardWithDetails:(JPCardTransactionDetails *)details andCompletion:(JPCompletionBlock)completion {
    [self performTransactionWithType:JPCardTransactionTypeRegister details:details softDeclineReceiptId:nil andCompletion:completion];
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
