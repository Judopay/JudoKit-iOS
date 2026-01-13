//
//  JudoKit.m
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

#import "JudoKit.h"
#import "JPApiService.h"
#import "JPApplePayService.h"
#import "JPApplePayWrappers.h"
#import "JPCardTransactionDetails.h"
#import "JPConfiguration+Additions.h"
#import "JPConfiguration.h"
#import "JPConfigurationValidationService.h"
#import "JPError+Additions.h"
#import "JPNavigationController.h"
#import "JPPaymentMethodsBuilder.h"
#import "JPPaymentMethodsViewController.h"
#import "JPResponse.h"
#import "JPSliderTransitioningDelegate.h"
#import "JPTransactionBuilder.h"
#import "JPTransactionViewController.h"
#import "JPUIConfiguration.h"
#import "UIApplication+Additions.h"
#import <PassKit/PassKit.h>

@interface JudoKit ()

@property (nonatomic, strong) JPApiService *apiService;
@property (nonatomic, strong) JPApplePayService *applePayService;
@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, strong) JPSliderTransitioningDelegate *transitioningDelegate;
@property (nonatomic, strong) id<JPConfigurationValidationService> configurationValidationService;
@end

@implementation JudoKit

#pragma mark - Initializers

- (instancetype)initWithAuthorization:(nonnull id<JPAuthorization>)authorization {
    return [self initWithAuthorization:authorization allowJailbrokenDevices:YES];
}

- (instancetype)initWithAuthorization:(nonnull id<JPAuthorization>)authorization
               allowJailbrokenDevices:(BOOL)jailbrokenDevicesAllowed {

    if (!jailbrokenDevicesAllowed && UIApplication._jp_isCurrentDeviceJailbroken) {
        return nil;
    }

    if (self = [super init]) {
        self.configurationValidationService = [[JPConfigurationValidationServiceImp alloc] initWithAuthorization:authorization];
        self.apiService = [[JPApiService alloc] initWithAuthorization:authorization isSandboxed:self.isSandboxed];
    }

    return self;
}

#pragma mark - Public methods

- (void)invokeTransactionWithType:(JPTransactionType)type
                    configuration:(JPConfiguration *)configuration
                       completion:(JPCompletionBlock)completion {
    UIViewController *topMostViewController = UIApplication._jp_topMostViewController;

    if (!topMostViewController) {
        completion(nil, JPError.invalidPresentingViewControllerError);
        return;
    }

    UIViewController *controller = [self transactionViewControllerWithType:type
                                                             configuration:configuration
                                                                completion:completion];

    if (!controller) {
        return;
    }

    [topMostViewController presentViewController:controller animated:YES completion:nil];
}

- (UIViewController *)transactionViewControllerWithType:(JPTransactionType)type
                                          configuration:(JPConfiguration *)configuration
                                             completion:(JPCompletionBlock)completion {
    return [self transactionViewControllerWithType:type
                                     configuration:configuration
                                       cardDetails:nil
                                        completion:completion];
}

- (UIViewController *)transactionViewControllerWithType:(JPTransactionType)type
                                          configuration:(JPConfiguration *)configuration
                                            cardDetails:(JPCardTransactionDetails *)details
                                             completion:(JPCompletionBlock)completion {

    JPError *error;

    if (details) {
        error = [self.configurationValidationService validateTokenPaymentConfiguration:configuration forTransactionType:type];
    } else {
        error = [self.configurationValidationService validateConfiguration:configuration forTransactionType:type];
    }

    if (error) {
        completion(nil, error);
        return nil;
    }

    JPPresentationMode presentationMode = configuration.presentationModeForCardPayments;

    if (details) {
        presentationMode = configuration.presentationModeForTokenPayments;
    }

    UIViewController *controller =
        [JPTransactionBuilderImpl buildModuleWithApiService:self.apiService
                                              configuration:configuration
                                            transactionType:type
                                           presentationMode:presentationMode
                                         transactionDetails:details
                                                 completion:completion];

    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = self.transitioningDelegate;

    return controller;
}

- (void)invokeTokenTransactionWithType:(JPTransactionType)type
                         configuration:(JPConfiguration *)configuration
                               details:(JPCardTransactionDetails *)details
                            completion:(JPCompletionBlock)completion {
    UIViewController *topMostViewController = UIApplication._jp_topMostViewController;

    if (!topMostViewController) {
        completion(nil, JPError.invalidPresentingViewControllerError);
        return;
    }

    UIViewController *controller = [self transactionViewControllerWithType:type
                                                             configuration:configuration
                                                               cardDetails:details
                                                                completion:completion];

    if (!controller) {
        return;
    }

    [topMostViewController presentViewController:controller animated:YES completion:nil];
}

- (void)invokeApplePayWithMode:(JPTransactionMode)mode
                 configuration:(JPConfiguration *)configuration
                    completion:(JPCompletionBlock)completion {
    [self invokeApplePayWithMode:mode
                   configuration:configuration
        presentingViewController:UIApplication._jp_topMostViewController
                      completion:completion];
}

- (void)invokeApplePayWithMode:(JPTransactionMode)mode
                 configuration:(JPConfiguration *)configuration
      presentingViewController:(UIViewController *)controller
                    completion:(JPCompletionBlock)completion {
    if (!controller) {
        completion(nil, JPError.invalidPresentingViewControllerError);
        return;
    }

    JPError *configurationError = [self.configurationValidationService validateApplePayConfiguration:configuration];

    if (configurationError) {
        completion(nil, configurationError);
    } else {
        self.applePayService = [[JPApplePayService alloc] initWithApiService:self.apiService];
        [self.applePayService processPaymentWithConfiguration:configuration
                                              transactionMode:mode
                                                andCompletion:completion];
    }
}

+ (BOOL)isApplePayAvailableWithConfiguration:(JPConfiguration *)configuration {
    return [JPApplePayService canMakePaymentsUsingConfiguration:configuration];
}

- (void)invokePaymentMethodScreenWithMode:(JPTransactionMode)mode
                            configuration:(JPConfiguration *)configuration
                               completion:(JPCompletionBlock)completion {
    JPError *error = [self.configurationValidationService validatePaymentMethodsConfiguration:configuration
                                                                           forTransactionMode:mode];

    if (error) {
        completion(nil, error);
        return;
    }

    UIViewController *topMostViewController = UIApplication._jp_topMostViewController;

    if (!topMostViewController) {
        completion(nil, JPError.invalidPresentingViewControllerError);
        return;
    }

    UIViewController *controller = [self paymentMethodViewControllerWithMode:mode
                                                               configuration:configuration
                                                                  completion:completion];

    if (!controller) {
        return;
    }

    JPNavigationController *navController = [[JPNavigationController alloc] initWithRootViewController:controller];
    navController.modalPresentationStyle = UIModalPresentationFullScreen;

    [topMostViewController presentViewController:navController animated:YES completion:nil];
}

- (UIViewController *)paymentMethodViewControllerWithMode:(JPTransactionMode)mode
                                            configuration:(JPConfiguration *)configuration
                                               completion:(JPCompletionBlock)completion {

    return [JPPaymentMethodsBuilderImpl buildModuleWithMode:mode
                                              configuration:configuration
                                                 apiService:self.apiService
                                      transitioningDelegate:self.transitioningDelegate
                                          completionHandler:completion];
}

#pragma mark - Getters & Setters

- (JPSliderTransitioningDelegate *)transitioningDelegate {
    if (!_transitioningDelegate) {
        _transitioningDelegate = [JPSliderTransitioningDelegate new];
    }
    return _transitioningDelegate;
}

- (void)setIsSandboxed:(BOOL)isSandboxed {
    _isSandboxed = isSandboxed;
    self.apiService.isSandboxed = isSandboxed;
}

- (void)setAuthorization:(id<JPAuthorization>)authorization {
    _authorization = authorization;
    self.apiService.authorization = authorization;
    [self.configurationValidationService setAuthorization:authorization];
}

- (void)setSubProductInfo:(JPSubProductInfo *)subProductInfo {
    _subProductInfo = subProductInfo;
    self.apiService.subProductInfo = subProductInfo;
}

- (void)fetchTransactionWithReceiptId:(NSString *)receiptId
                           completion:(JPCompletionBlock)completion {
    [self.apiService fetchTransactionWithReceiptId:receiptId completion:completion];
}

@end
