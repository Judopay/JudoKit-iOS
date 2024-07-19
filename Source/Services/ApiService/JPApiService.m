//
//  JPApiService.m
//  JudoKit_iOS
//
//  Copyright (c) 2020 Alternative Payments Ltd
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
#import "JPBankOrderSaleRequest.h"
#import "JPCheckCardRequest.h"
#import "JPComplete3DS2Request.h"
#import "JPError+Additions.h"
#import "JPPaymentRequest.h"
#import "JPPreAuthApplePayRequest.h"
#import "JPPreAuthRequest.h"
#import "JPPreAuthTokenRequest.h"
#import "JPRegisterCardRequest.h"
#import "JPRequestEnricher.h"
#import "JPSaveCardRequest.h"
#import "JPSession.h"
#import "JPSessionConfiguration.h"
#import "JPTokenRequest.h"
#import "NSObject+Additions.h"

static NSString *const kPaymentEndpoint = @"transactions/payments";
static NSString *const kPreauthEndpoint = @"transactions/preauths";
static NSString *const kRegisterCardEndpoint __deprecated = @"transactions/registercard";
static NSString *const kSaveCardEndpoint = @"transactions/savecard";
static NSString *const kTransactionStatusPathKey = @"transactions/";
static NSString *const kCheckCardEndpoint = @"transactions/checkcard";
static NSString *const kBankSaleEndpoint = @"order/bank/sale";
static NSString *const kBankStatusRequestEndpoint = @"order/bank/statusrequest";
static NSString *const kTransactionsEndpoint = @"transactions";
static NSString *const kComplete3DS2TransactionsEndpoint = @"transactions/%@/complete3ds";

typedef NS_ENUM(NSUInteger, JPHTTPMethod) {
    JPHTTPMethodGET,
    JPHTTPMethodPOST,
    JPHTTPMethodPUT
};

@interface JPApiService ()

@property (nonatomic, strong) JPSession *session;
@property (nonatomic, strong) JPRequestEnricher *enricher;
@property (nonatomic, strong) NSArray<NSString *> *enricheablePaths;

@end

@implementation JPApiService

#pragma mark - Initializers

- (instancetype)initWithAuthorization:(id<JPAuthorization>)authorization
                          isSandboxed:(BOOL)sandboxed {

    if (self = [super init]) {
        _isSandboxed = sandboxed;
        _authorization = authorization;
        _enricheablePaths = @[ kPaymentEndpoint, kPreauthEndpoint, kRegisterCardEndpoint, kSaveCardEndpoint, kCheckCardEndpoint ];
        _enricher = [JPRequestEnricher new];

        [self setUpSession];
    }
    return self;
}

- (void)setUpSession {
    JPSessionConfiguration *configuration = [JPSessionConfiguration configurationWithAuthorization:self.authorization];
    configuration.isSandboxed = self.isSandboxed;
    configuration.subProductInfo = self.subProductInfo;

    _session = [JPSession sessionWithConfiguration:configuration];
}

#pragma mark - Public methods

- (void)setIsSandboxed:(BOOL)isSandboxed {
    _isSandboxed = isSandboxed;
    [self setUpSession];
}

- (void)setSubProductInfo:(JPSubProductInfo *)subProductInfo {
    _subProductInfo = subProductInfo;
    [self setUpSession];
}

- (void)setAuthorization:(id<JPAuthorization>)authorization {
    _authorization = authorization;
    [self setUpSession];
}

- (void)invokePaymentWithRequest:(JPPaymentRequest *)request
                   andCompletion:(JPCompletionBlock)completion {

    NSDictionary *parameters = [request _jp_toDictionary];
    [self performRequestWithMethod:JPHTTPMethodPOST
                          endpoint:kPaymentEndpoint
                        parameters:parameters
                     andCompletion:completion];
}

- (void)invokePreAuthPaymentWithRequest:(JPPreAuthRequest *)request
                          andCompletion:(JPCompletionBlock)completion {

    NSDictionary *parameters = [request _jp_toDictionary];
    [self performRequestWithMethod:JPHTTPMethodPOST
                          endpoint:kPreauthEndpoint
                        parameters:parameters
                     andCompletion:completion];
}

- (void)invokeTokenPaymentWithRequest:(JPTokenRequest *)request
                        andCompletion:(JPCompletionBlock)completion {

    NSDictionary *parameters = [request _jp_toDictionary];
    [self performRequestWithMethod:JPHTTPMethodPOST
                          endpoint:kPaymentEndpoint
                        parameters:parameters
                     andCompletion:completion];
}

- (void)invokePreAuthTokenPaymentWithRequest:(JPPreAuthTokenRequest *)request
                               andCompletion:(JPCompletionBlock)completion {

    NSDictionary *parameters = [request _jp_toDictionary];
    [self performRequestWithMethod:JPHTTPMethodPOST
                          endpoint:kPreauthEndpoint
                        parameters:parameters
                     andCompletion:completion];
}

- (void)invokeComplete3dSecureWithReceiptId:(NSString *)receiptId
                       authenticationResult:(JP3DSecureAuthenticationResult *)result
                              andCompletion:(JPCompletionBlock)completion {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", kTransactionsEndpoint, receiptId];
    NSDictionary *parameters = [result _jp_toDictionary];
    [self performRequestWithMethod:JPHTTPMethodPUT
                          endpoint:endpoint
                        parameters:parameters
                     andCompletion:completion];
}

- (void)invokeComplete3dSecureTwoWithReceiptId:(NSString *)receiptId
                                       request:(JPComplete3DS2Request *)request
                                 andCompletion:(JPCompletionBlock)completion {
    NSString *endpoint = [NSString stringWithFormat:kComplete3DS2TransactionsEndpoint, receiptId];
    NSDictionary *parameters = [request _jp_toDictionary];
    [self performRequestWithMethod:JPHTTPMethodPUT
                          endpoint:endpoint
                        parameters:parameters
                     andCompletion:completion];
}

- (void)invokeRegisterCardWithRequest:(JPRegisterCardRequest *)request
                        andCompletion:(JPCompletionBlock)completion {

    NSDictionary *parameters = [request _jp_toDictionary];
    [self performRequestWithMethod:JPHTTPMethodPOST
                          endpoint:kRegisterCardEndpoint
                        parameters:parameters
                     andCompletion:completion];
}

- (void)invokeSaveCardWithRequest:(JPSaveCardRequest *)request
                    andCompletion:(JPCompletionBlock)completion {

    NSDictionary *parameters = [request _jp_toDictionary];
    [self performRequestWithMethod:JPHTTPMethodPOST
                          endpoint:kSaveCardEndpoint
                        parameters:parameters
                     andCompletion:completion];
}

- (void)invokeCheckCardWithRequest:(JPCheckCardRequest *)request
                     andCompletion:(JPCompletionBlock)completion {
    NSDictionary *parameters = [request _jp_toDictionary];
    [self performRequestWithMethod:JPHTTPMethodPOST
                          endpoint:kCheckCardEndpoint
                        parameters:parameters
                     andCompletion:completion];
}

- (void)invokeApplePayPaymentWithRequest:(JPApplePayRequest *)request
                           andCompletion:(JPCompletionBlock)completion {

    NSDictionary *parameters = [request _jp_toDictionary];
    [self performRequestWithMethod:JPHTTPMethodPOST
                          endpoint:kPaymentEndpoint
                        parameters:parameters
                     andCompletion:completion];
}

- (void)invokePreAuthApplePayPaymentWithRequest:(JPPreAuthApplePayRequest *)request
                                  andCompletion:(JPCompletionBlock)completion {

    NSDictionary *parameters = [request _jp_toDictionary];
    [self performRequestWithMethod:JPHTTPMethodPOST
                          endpoint:kPreauthEndpoint
                        parameters:parameters
                     andCompletion:completion];
}

- (void)invokeBankSaleWithRequest:(JPBankOrderSaleRequest *)request
                    andCompletion:(JPCompletionBlock)completion {

    NSDictionary *parameters = [request _jp_toDictionary];
    [self performRequestWithMethod:JPHTTPMethodPOST
                          endpoint:kBankSaleEndpoint
                        parameters:parameters
                     andCompletion:completion];
}

- (void)invokeOrderStatusWithOrderId:(NSString *)orderId
                       andCompletion:(JPCompletionBlock)completion {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", kBankStatusRequestEndpoint, orderId];
    [self performRequestWithMethod:JPHTTPMethodGET
                          endpoint:endpoint
                        parameters:nil
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
            case JPHTTPMethodGET:
                [self.session GET:endpoint parameters:enrichedRequest andCompletion:completion];
                break;

            case JPHTTPMethodPOST:
                [self.session POST:endpoint parameters:enrichedRequest andCompletion:completion];
                break;

            case JPHTTPMethodPUT:
                [self.session PUT:endpoint parameters:enrichedRequest andCompletion:completion];
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

- (void)fetchTransactionWithReceiptId:(nonnull NSString *)receiptId
                           completion:(nullable JPCompletionBlock)completion {
    NSString *transactionEndpoint = [NSString stringWithFormat:@"%@%@", kTransactionStatusPathKey, receiptId];
    [self performRequestWithMethod:JPHTTPMethodGET
                          endpoint:transactionEndpoint
                        parameters:nil
                     andCompletion:completion];
}

@end
