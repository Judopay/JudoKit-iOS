//
//  JPApplePayService.m
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

#import "JPApplePayService.h"
#import "JPApiService.h"
#import "JPApplePayConfiguration.h"
#import "JPApplePayRequest.h"
#import "JPApplePayWrappers.h"
#import "JPConfiguration.h"
#import "JPError+Additions.h"
#import "JPPreAuthApplePayRequest.h"
#import "JPResponse+Additions.h"
#import "JPResponse.h"
#import "PKPayment+Additions.h"
#import "UIApplication+Additions.h"
#import "UIViewController+Additions.h"
#import <PassKit/PassKit.h>

@interface JPApplePayPaymentContext : NSObject
@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, assign) JPTransactionMode transactionMode;
@property (nonatomic, strong) PKPayment *payment;
@property (nonatomic, strong) JPResponse *response;
@property (nonatomic, strong) JPError *error;
@property (nonatomic, readonly) BOOL isPaymentAuthorized;

@end

@implementation JPApplePayPaymentContext

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration
                              andMode:(JPTransactionMode)transactionMode {
    if (self = [super init]) {
        _configuration = configuration;
        _transactionMode = transactionMode;
    }
    return self;
}

- (BOOL)isPaymentAuthorized {
    return self.payment != nil;
}

@end

typedef void (^JPApplePayMiddlewareBlock)(JPApplePayPaymentContext *context, void (^next)(void));

@interface JPApplePayMiddlewareChain : NSObject

@property (nonatomic, strong) NSMutableArray<JPApplePayMiddlewareBlock> *middlewareChain;
@property (nonatomic, strong) JPApplePayPaymentContext *context;

- (void)configureWith:(JPConfiguration *)configuration andMode:(JPTransactionMode)transactionMode;
- (void)processPayment:(PKPayment *)payment completion:(JPCompletionBlock)completion;
- (void)addMiddleware:(JPApplePayMiddlewareBlock)middleware;

@end

@implementation JPApplePayMiddlewareChain

- (void)configureWith:(JPConfiguration *)configuration andMode:(JPTransactionMode)transactionMode {
    self.context = [[JPApplePayPaymentContext alloc] initWithConfiguration:configuration andMode:transactionMode];
}

- (void)addMiddleware:(JPApplePayMiddlewareBlock)middleware {
    [self.middlewareChain addObject:[middleware copy]];
}

- (void)processPayment:(PKPayment *)payment completion:(JPCompletionBlock)completion {
    self.context.payment = payment;
    self.context.error = nil;
    self.context.response = nil;
    [self executeMiddlewareChainWithIndex:0 completion:completion];
}

- (void)executeMiddlewareChainWithIndex:(NSUInteger)index completion:(JPCompletionBlock)completion {
    if (self.context.error || index >= self.middlewareChain.count) {
        completion(self.context.response, self.context.error);
        return;
    }

    JPApplePayMiddlewareBlock middleware = self.middlewareChain[index];
    middleware(self.context, ^{
        [self executeMiddlewareChainWithIndex:index + 1 completion:completion];
    });
}

- (NSMutableArray<JPApplePayMiddlewareBlock> *)middlewareChain {
    if (!_middlewareChain) {
        _middlewareChain = [NSMutableArray array];
    }
    return _middlewareChain;
}

@end

typedef NS_ENUM(NSInteger, JPApplePayState) {
    JPApplePayStateIdle,
    JPApplePayStateProcessing,
};

@interface JPApplePayService () <PKPaymentAuthorizationViewControllerDelegate>
@property (nonatomic, strong) JPApplePayMiddlewareChain *middlewareChain;
@property (nonatomic, strong) JPApiService *apiService;

@property (nonatomic, copy, nullable) JPCompletionBlock completion;

@property (nonatomic, assign) JPApplePayState state;
@end

@implementation JPApplePayService

#pragma mark - Initializers

- (instancetype)initWithApiService:(JPApiService *)apiService {
    if (self = [super init]) {
        self.apiService = apiService;
        self.state = JPApplePayStateIdle;

        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    __weak typeof(self) weakSelf = self;
    [self.middlewareChain addMiddleware:^(JPApplePayPaymentContext *context, void (^next)(void)) {
        JPCompletionBlock completion = ^(JPResponse *response, JPError *error) {
            context.error = error;
            context.response = response;
            next();
        };

        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (strongSelf == nil) {
            completion(nil, [JPError unexpectedStateErrorWithDebugDecription:@"Invalid SDK state: self was deallocated before completion handler executed."]);
            return;
        }

        switch (context.transactionMode) {
            case JPTransactionModeServerToServer:
                completion([context.payment toJPResponseWithConfiguration:context.configuration], nil);
                break;

            case JPTransactionModePreAuth: {
                JPPreAuthApplePayRequest *request = [[JPPreAuthApplePayRequest alloc] initWithConfiguration:context.configuration andPayment:context.payment];
                [strongSelf.apiService invokePreAuthApplePayPaymentWithRequest:request andCompletion:completion];
            } break;

            default: {
                JPApplePayRequest *request = [[JPApplePayRequest alloc] initWithConfiguration:context.configuration andPayment:context.payment];
                [strongSelf.apiService invokeApplePayPaymentWithRequest:request andCompletion:completion];
            } break;
        }
    }];

    [self.middlewareChain addMiddleware:^(JPApplePayPaymentContext *context, void (^next)(void)) {
        if (context.response) {
            JPReturnedInfo info = context.configuration.applePayConfiguration.returnedContactInfo;
            [context.response enrichWith:info from:context.payment];
        }
        next();
    }];

    [self.middlewareChain addMiddleware:^(JPApplePayPaymentContext *context, void (^next)(void)) {
        // to make sure we catch it if it ever happens, this custom error is set here
        if (context.response == nil && context.error == nil) {
            context.error = [JPError unexpectedStateErrorWithDebugDecription:@"Invalid SDK state: operation completed with no response and no error."];
        }
        next();
    }];
}

#pragma mark - Public methods

+ (BOOL)isApplePaySupported {
    return PKPaymentAuthorizationController.canMakePayments;
}

+ (BOOL)canMakePaymentsUsingConfiguration:(JPConfiguration *)configuration {
    if (JPApplePayService.isApplePaySupported) {
        NSArray *paymentNetworks = [JPApplePayWrappers pkPaymentNetworksForConfiguration:configuration];
        PKMerchantCapability capabilities = [JPApplePayWrappers pkMerchantCapabilitiesForConfiguration:configuration];
        return [PKPaymentAuthorizationController canMakePaymentsUsingNetworks:paymentNetworks capabilities:capabilities];
    }
    return NO;
}

- (void)processPaymentWithConfiguration:(JPConfiguration *)configuration
                        transactionMode:(JPTransactionMode)transactionMode
                          andCompletion:(JPCompletionBlock)completion {
    [self processPaymentWithConfiguration:configuration
                 presentingViewController:UIApplication._jp_topMostViewController
                          transactionMode:transactionMode
                            andCompletion:completion];
}

- (void)processPaymentWithConfiguration:(JPConfiguration *)configuration
               presentingViewController:(UIViewController *)presentingController
                        transactionMode:(JPTransactionMode)transactionMode
                          andCompletion:(JPCompletionBlock)completion {
    if (self.state == JPApplePayStateIdle) {
        if (presentingController == nil) {
            completion(nil, JPError.invalidPresentingViewControllerError);
            return;
        }

        if ([presentingController _jp_canPresentViewController] == NO) {
            completion(nil, [JPError unexpectedStateErrorWithDebugDecription:@"The presenting view controller is either not in the window hierarchy, already presenting another controller, or being dismissed."]);
            return;
        }

        PKPaymentAuthorizationViewController *controller = [JPApplePayWrappers pkPaymentControllerForConfiguration:configuration];

        if (controller == nil) {
            completion(nil, [JPError unexpectedStateErrorWithDebugDecription:@"Unable to create PKPaymentAuthorizationViewController with the provided configuration."]);
            return;
        }

        self.completion = [completion copy];
        [self.middlewareChain configureWith:configuration andMode:transactionMode];

        controller.delegate = self;

        [presentingController presentViewController:controller animated:YES completion:nil];

        self.state = JPApplePayStateProcessing;
    } else {
        completion(nil, JPError.operationNotAllowedError);
    }
}

#pragma mark - PKPaymentAuthorizationViewControllerDelegate

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                   handler:(void (^)(PKPaymentAuthorizationResult *result))completion {
    [self.middlewareChain processPayment:payment
                              completion:^(JPResponse *response, JPError *error) {
                                  PKPaymentAuthorizationStatus status = response ? PKPaymentAuthorizationStatusSuccess : PKPaymentAuthorizationStatusFailure;
                                  NSArray *errors = (error && response == nil) ? @[ error ] : nil;
                                  PKPaymentAuthorizationResult *result = [[PKPaymentAuthorizationResult alloc] initWithStatus:status errors:errors];

                                  completion(result);
                              }];
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    /**
     * When the host app is moved to the background, the `paymentAuthorizationViewControllerDidFinish`
     * is invoked twice; hence, to avoid calling `didFinishBlock` twice, this workaround is in place
     */
    if (self.state == JPApplePayStateProcessing) {
        [controller dismissViewControllerAnimated:YES
                                       completion:^{
                                           [self onPaymentAuthorizationViewControllerDidFinish];
                                       }];

        self.state = JPApplePayStateIdle;
    }
}

#pragma mark - Helper methods
- (void)onPaymentAuthorizationViewControllerDidFinish {
    if (self.completion == nil)
        return;

    JPResponse *response;
    JPError *error;

    if (self.middlewareChain.context.isPaymentAuthorized) {
        response = self.middlewareChain.context.response;
        error = self.middlewareChain.context.error;
    } else {
        error = JPError.userDidCancelError;
    }

    self.completion(response, error);
    self.completion = nil;
}

- (JPApplePayMiddlewareChain *)middlewareChain {
    if (_middlewareChain == nil) {
        _middlewareChain = [JPApplePayMiddlewareChain new];
    }
    return _middlewareChain;
}

@end
