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
#import "JP3DSViewController.h"
#import "JPApiService.h"
#import "JPCReqParameters.h"
#import "JPCardTransactionDetails+Additions.h"
#import "JPCardTransactionDetails.h"
#import "JPCheckCardRequest.h"
#import "JPComplete3DS2Request.h"
#import "JPConfiguration.h"
#import "JPError+Additions.h"
#import "JPPaymentRequest.h"
#import "JPRegisterCardRequest.h"
#import "JPResponse+Additions.h"
#import "JPResponse.h"
#import "JPSaveCardRequest.h"
#import "JPTokenRequest.h"
#import "UIApplication+Additions.h"

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

    JPComplete3DS2Request *request = [[JPComplete3DS2Request alloc] initWithVersion:self.response.cReqParameters.messageVersion
                                                                      andSecureCode:self.details.secureCode];

    [self.apiService invokeComplete3dSecureTwoWithReceiptId:self.response.receiptId
                                                    request:request
                                              andCompletion:self.completion];
}

- (void)transactionCancelled {
    self.completion(nil, JPError.judoUserDidCancelError);
}

- (void)transactionTimedOut {
    self.completion(nil, JPError.judoRequestTimeoutError);
}

- (void)transactionFailedWithProtocolErrorEvent:(JP3DSProtocolErrorEvent *)protocolErrorEvent {
    self.completion(nil, JPError.judoRequestFailedError);
}

- (void)transactionFailedWithRuntimeErrorEvent:(JP3DSRuntimeErrorEvent *)runtimeErrorEvent {
    self.completion(nil, JPError.judoRequestFailedError);
}

@end

typedef NS_ENUM(NSUInteger, JPCardTransactionType) {
    JPCardTransactionTypePayment,
    JPCardTransactionTypePreAuth,
    JPCardTransactionTypePaymentWithToken,
    JPCardTransactionTypePreAuthWithToken,
    JPCardTransactionTypeSave,
    JPCardTransactionTypeCheck,
    JPCardTransactionTypeRegister
};

@interface JPCardTransactionService ()

@property (strong, nonatomic) JPConfiguration *configuration;
@property (strong, nonatomic) JPApiService *apiService;

@property (strong, nonatomic) JP3DS2Service *threeDSTwoService;
@property (strong, nonatomic) JP3DSConfigParameters *threeDSTwoConfigParameters;

@property (strong, nonatomic) JP3DSTransaction *transaction;
@end

@implementation JPCardTransactionService

- (instancetype)initWithAPIService:(JPApiService *)apiService
                  andConfiguration:(JPConfiguration *)configuration {
    if (self = [super init]) {
        _configuration = configuration;
        _apiService = apiService;

        [self.threeDSTwoService initializeWithConfigParameters:self.threeDSTwoConfigParameters locale:nil uiCustomization:nil];
    }
    return self;
}

- (instancetype)initWithAuthorization:(id<JPAuthorization>)authorization
                          isSandboxed:(BOOL)sandboxed
                     andConfiguration:(JPConfiguration *)configuration {
    if (self = [super init]) {
        _configuration = configuration;
        _apiService = [[JPApiService alloc] initWithAuthorization:authorization isSandboxed:sandboxed];

        [self.threeDSTwoService initializeWithConfigParameters:self.threeDSTwoConfigParameters locale:nil uiCustomization:nil];
    }
    return self;
}

- (void)performTransactionWithType:(JPCardTransactionType)type
                           details:(JPCardTransactionDetails *)details
                     andCompletion:(JPCompletionBlock)completion {
    @try {
        NSString *dsServerID;
        switch (details.cardType) {
            case JPCardNetworkTypeVisa:
                dsServerID = _apiService.isSandboxed ? @"F055545342" : @"A000000003";
                break;
            case JPCardNetworkTypeMasterCard:
                dsServerID = _apiService.isSandboxed ? @"F155545342" : @"A000000004";
                break;
            default:
                break;
        }
        if (!dsServerID) {
            NSDictionary *info = @{
                NSLocalizedDescriptionKey : @"Unsupported card type. Only Visa and Mastercard are supported at this time."
            };
            JPError *error = [[JPError alloc] initWithDomain:JudoErrorDomain code:JudoErrorThreeDSTwo userInfo:info];
            completion(nil, error);
            return;
        }

        NSString *messageVersion = self.configuration.threeDSTwoMessageVersion;
        JP3DSTransaction *transaction = [self.threeDSTwoService createTransactionWithDirectoryServerID:dsServerID
                                                                                        messageVersion:messageVersion];

        JPCompletionBlock completionHandler = ^(JPResponse *response, JPError *error) {
            if (response) {
                if ([response isThreeDSecureOneRequired]) {
                    JP3DSConfiguration *configuration = [JP3DSConfiguration configurationWithResponse:response];
                    JP3DSViewController *controller = [[JP3DSViewController alloc] initWithConfiguration:configuration completion:completion];
                    controller.apiService = self.apiService;

                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
                    navController.modalPresentationStyle = UIModalPresentationFullScreen;
                    [UIApplication.topMostViewController presentViewController:navController animated:YES completion:nil];
                } else if ([response isThreeDSecureTwoRequired]) {
                    JP3DSChallengeStatusReceiverImpl *receiverImpl = [[JP3DSChallengeStatusReceiverImpl alloc] initWithApiService:self.apiService
                                                                                                                          details:details
                                                                                                                         response:response
                                                                                                                    andCompletion:completion];

                    JPCReqParameters *cReqParameters = [response cReqParameters];
                    JP3DSChallengeParameters *params = [[JP3DSChallengeParameters alloc] initWithThreeDSServerTransactionID:cReqParameters.threeDSServerTransID
                                                                                                           acsTransactionID:cReqParameters.acsTransID
                                                                                                               acsRefNumber:response.rawData[@"acsReferenceNumber"]
                                                                                                           acsSignedContent:response.rawData[@"acsSignedContent"]
                                                                                                     threeDSRequestorAppURL:nil];

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
                                                                        andTransaction:transaction];
                [self.apiService invokePaymentWithRequest:request andCompletion:completionHandler];
                break;
            }

            case JPCardTransactionTypePreAuth: {
                JPPaymentRequest *request = [details toPaymentRequestWithConfiguration:self.configuration
                                                                        andTransaction:transaction];
                [self.apiService invokePreAuthPaymentWithRequest:request andCompletion:completionHandler];
                break;
            }

            case JPCardTransactionTypePaymentWithToken: {
                JPTokenRequest *request = [details toTokenRequestWithConfiguration:self.configuration
                                                                    andTransaction:transaction];
                [self.apiService invokeTokenPaymentWithRequest:request andCompletion:completionHandler];
                break;
            }

            case JPCardTransactionTypePreAuthWithToken: {
                JPTokenRequest *request = [details toTokenRequestWithConfiguration:self.configuration
                                                                    andTransaction:transaction];
                [self.apiService invokePreAuthTokenPaymentWithRequest:request andCompletion:completionHandler];
                break;
            }

            case JPCardTransactionTypeSave: {
                JPSaveCardRequest *request = [details toSaveCardRequestWithConfiguration:self.configuration
                                                                          andTransaction:transaction];
                [self.apiService invokeSaveCardWithRequest:request andCompletion:completionHandler];
                break;
            }

            case JPCardTransactionTypeCheck: {
                JPCheckCardRequest *request = [details toCheckCardRequestWithConfiguration:self.configuration
                                                                            andTransaction:transaction];
                [self.apiService invokeCheckCardWithRequest:request andCompletion:completionHandler];
                break;
            }

            case JPCardTransactionTypeRegister: {
                JPRegisterCardRequest *request = [details toRegisterCardRequestWithConfiguration:self.configuration
                                                                                  andTransaction:transaction];
                [self.apiService invokeRegisterCardWithRequest:request andCompletion:completionHandler];
                break;
            }
            default: {
                completion(nil, [[JPError alloc] initWithDomain:JudoErrorDomain code:JudoErrorThreeDSTwo userInfo:nil]);
                break;
            }
        }
    } @catch (NSException *exception) {
        NSDictionary *info = @{
            @"ExceptionName" : exception.name,
            @"ExceptionReason" : exception.reason,
            @"ExceptionCallStackReturnAddresses" : exception.callStackReturnAddresses,
            @"ExceptionCallStackSymbols" : exception.callStackSymbols,
            @"ExceptionUserInfo" : exception.userInfo
        };

        JPError *error = [[JPError alloc] initWithDomain:JudoErrorDomain code:JudoErrorThreeDSTwo userInfo:info];
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
