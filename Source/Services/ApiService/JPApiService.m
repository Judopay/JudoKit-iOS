//
//  JPApiService.m
//  JudoKit_iOS
//
//  Copyright (c) 2019 Alternative Payments Ltd
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
#import "JPSession.h"
#import "JPTransaction.h"
#import "JPRequestEnricher.h"
#import "JPSessionConfiguration.h"
#import "JPError+Additions.h"
#import "JP3DSecureAuthenticationResult.h"
#import "NSObject+Additions.h"

static NSString *const kPaymentEndpoint = @"transactions/payments";
static NSString *const kPreauthEndpoint = @"transactions/preauths";
static NSString *const kRegisterCardEndpoint = @"transactions/registercard";
static NSString *const kSaveCardEndpoint = @"transactions/savecard";
static NSString *const kCheckCardEndpoint = @"transactions/checkcard";
static NSString *const kBankSaleEndpoint = @"order/bank/sale";
static NSString *const kBankStatusRequestEndpoint = @"order/bank/statusrequest";
static NSString *const kTransactionsEndpoint = @"transactions";

typedef NS_ENUM(NSUInteger, JPHTTPMethod) {
    JPHTTPMethodGET,
    JPHTTPMethodPOST,
    JPHTTPMethodPUT
};

@interface JPApiService ()

@property(nonatomic, strong) JPSession *session;
@property(nonatomic, strong) JPRequestEnricher *enricher;
@property(nonatomic, strong) NSArray<NSString *> *enricheablePaths;

@end

@implementation JPApiService

#pragma mark - Initializers

- (instancetype)initWithAuthorization:(id <Authorization>)authorization isSandboxed:(BOOL)sandboxed {
    if (self = [super init]) {
        JPSessionConfiguration *configuration = [JPSessionConfiguration configurationWithAuthorization:authorization];
        configuration.isSandboxed = sandboxed;

        _enricheablePaths = @[kPaymentEndpoint, kPreauthEndpoint, kRegisterCardEndpoint, kSaveCardEndpoint];
        _session = [JPSession sessionWithConfiguration:configuration];
        _enricher = [JPRequestEnricher new];
    }
    return self;
}

#pragma mark - Public methods

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
                completion(nil, JPError.judoParameterError);
        }
    };

    if (shouldEnrich) {
        [self.enricher enrichRequestParameters:parameters withCompletion:enricherCompletion];
    } else {
        enricherCompletion(parameters);
    }
}

- (void)invokePaymentWithRequest:(JPPaymentRequest *)request andCompletion:(JPCompletionBlock)completion {
    [self performRequestWithMethod:JPHTTPMethodPOST endpoint:kPaymentEndpoint parameters:request andCompletion:completion];
}

- (void)invokePreAuthPaymentWithRequest:(JPPaymentRequest *)request andCompletion:(JPCompletionBlock)completion {
    [self performRequestWithMethod:JPHTTPMethodPOST endpoint:kPreauthEndpoint parameters:request andCompletion:completion];
}

- (void)invokeTokenPaymentWithRequest:(JPTokenRequest *)request andCompletion:(JPCompletionBlock)completion {
    [self performRequestWithMethod:JPHTTPMethodPOST endpoint:kPaymentEndpoint parameters:request andCompletion:completion];
}

- (void)invokePreAuthTokenPaymentWithRequest:(JPTokenRequest *)request andCompletion:(JPCompletionBlock)completion {
    [self performRequestWithMethod:JPHTTPMethodPOST endpoint:kPreauthEndpoint parameters:request andCompletion:completion];
}

- (void)invokeComplete3dSecureWithReceiptId:(nonnull NSString *)receiptId
                       authenticationResult:(nonnull JP3DSecureAuthenticationResult *)result
                              andCompletion:(nullable JPCompletionBlock)completion {
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", kTransactionsEndpoint, receiptId];
    [self performRequestWithMethod:JPHTTPMethodPUT endpoint:endpoint parameters:[result toDictionary] andCompletion:completion];
}

- (void)invokeRegisterCardWithRequest:(JPRegisterCardRequest *)request andCompletion:(JPCompletionBlock)completion {
    [self performRequestWithMethod:JPHTTPMethodPOST endpoint:kRegisterCardEndpoint parameters:request andCompletion:completion];
}

- (void)invokeSaveCardWithRequest:(JPSaveCardRequest *)request andCompletion:(JPCompletionBlock)completion {
    [self performRequestWithMethod:JPHTTPMethodPOST endpoint:kSaveCardEndpoint parameters:request andCompletion:completion];
}

- (void)invokeCheckCardWithRequest:(JPCheckCardRequest *)request andCompletion:(JPCompletionBlock)completion {
    [self performRequestWithMethod:JPHTTPMethodPOST endpoint:kCheckCardEndpoint parameters:request andCompletion:completion];
}

- (void)invokeApplePayPaymentWithRequest:(JPApplePayRequest *)request andCompletion:(JPCompletionBlock)completion {
    [self performRequestWithMethod:JPHTTPMethodPOST endpoint:kPaymentEndpoint parameters:request andCompletion:completion];
}

- (void)invokePreAuthApplePayPaymentWithRequest:(JPApplePayRequest *)request andCompletion:(JPCompletionBlock)completion {
    [self performRequestWithMethod:JPHTTPMethodPOST endpoint:kPreauthEndpoint parameters:request andCompletion:completion];
}

- (void)invokeBankSaleWithRequest:(JPBankOrderSaleRequest *)request andCompletion:(JPCompletionBlock)completion {
    [self performRequestWithMethod:JPHTTPMethodPOST endpoint:kBankSaleEndpoint parameters:request andCompletion:completion];
}

- (void)invokeOrderStatusWithOrderId:(NSString *)orderId andCompletion:(JPCompletionBlock)completion {
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", kBankStatusRequestEndpoint, orderId];
    [self performRequestWithMethod:JPHTTPMethodGET endpoint:endpoint parameters:nil andCompletion:completion];
}

@end
