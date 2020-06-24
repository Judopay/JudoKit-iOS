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
#import "JPApplePayService.h"
#import "JPConfiguration.h"
#import "JPConfigurationValidationService.h"
#import "JPError+Additions.h"
#import "JPPBBAConfiguration.h"
#import "JPPBBAService.h"
#import "JPPaymentMethod.h"
#import "JPPaymentMethodsBuilder.h"
#import "JPPaymentMethodsViewController.h"
#import "JPReceipt.h"
#import "JPResponse.h"
#import "JPSession.h"
#import "JPSliderTransitioningDelegate.h"
#import "JPTheme.h"
#import "JPTransaction.h"
#import "JPTransactionBuilder.h"
#import "JPTransactionEnricher.h"
#import "JPTransactionService.h"
#import "JPTransactionViewController.h"
#import "UIApplication+Additions.h"

@interface JudoKit ()

@property (nonatomic, strong) JPTransactionService *transactionService;
@property (nonatomic, strong) JPApplePayService *applePayService;
@property (nonatomic, strong) JPPBBAService *pbbaService;
@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, strong) JPCompletionBlock completionBlock;
@property (nonatomic, strong) JPSliderTransitioningDelegate *transitioningDelegate;
@property (nonatomic, strong) id<JPConfigurationValidationService> configurationValidationService;

@end

@implementation JudoKit

#pragma mark - Initializers

- (instancetype)initWithToken:(NSString *)token secret:(NSString *)secret {
    return [self initWithToken:token secret:secret allowJailbrokenDevices:YES];
}

- (instancetype)initWithToken:(NSString *)token
                       secret:(NSString *)secret
       allowJailbrokenDevices:(BOOL)jailbrokenDevicesAllowed {

    self = [super init];
    BOOL isDeviceSupported = !(!jailbrokenDevicesAllowed && UIApplication.isCurrentDeviceJailbroken);

    if (self && isDeviceSupported) {
        self.configurationValidationService = [JPConfigurationValidationServiceImp new];
        self.transactionService = [[JPTransactionService alloc] initWithToken:token
                                                                    andSecret:secret];
        return self;
    }

    return nil;
}

#pragma mark - Public methods

- (JPTransaction *)transactionWithType:(JPTransactionType)type
                         configuration:(JPConfiguration *)configuration {
    self.transactionService.transactionType = type;
    return [self.transactionService transactionWithConfiguration:configuration];
}

- (void)invokeTransactionWithType:(JPTransactionType)type
                    configuration:(JPConfiguration *)configuration
                       completion:(JPCompletionBlock)completion {

    UIViewController *controller = [self transactionViewControllerWithType:type
                                                             configuration:configuration
                                                                completion:completion];

    if (!controller) {
        return;
    }

    [UIApplication.topMostViewController presentViewController:controller
                                                      animated:YES
                                                    completion:nil];
}

- (UIViewController *)transactionViewControllerWithType:(JPTransactionType)type
                                          configuration:(JPConfiguration *)configuration
                                             completion:(JPCompletionBlock)completion {

    JPError *configurationError;
    configurationError = [self.configurationValidationService validateConfiguration:configuration
                                                                 forTransactionType:type];

    if (configurationError) {
        completion(nil, configurationError);
        return nil;
    }

    self.transactionService.transactionType = type;
    self.transactionService.mode = JPCardDetailsModeDefault;

    UIViewController *controller;
    controller = [JPTransactionBuilderImpl buildModuleWithTransactionService:self.transactionService
                                                               configuration:configuration
                                                                  completion:completion];

    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = self.transitioningDelegate;

    return controller;
}

- (void)invokeApplePayWithMode:(JPTransactionMode)mode
                 configuration:(JPConfiguration *)configuration
                    completion:(JPCompletionBlock)completion {

    UIViewController *controller = [self applePayViewControllerWithMode:mode
                                                          configuration:configuration
                                                             completion:completion];

    if (!controller) {
        return;
    }

    [UIApplication.topMostViewController presentViewController:controller
                                                      animated:YES
                                                    completion:nil];
}

- (UIViewController *)applePayViewControllerWithMode:(JPTransactionMode)mode
                                       configuration:(JPConfiguration *)configuration
                                          completion:(JPCompletionBlock)completion {

    JPError *configurationError = [self.configurationValidationService validateApplePayConfiguration:configuration];

    if (configurationError) {
        completion(nil, configurationError);
        return nil;
    }

    self.applePayService = [[JPApplePayService alloc] initWithConfiguration:configuration
                                                         transactionService:self.transactionService];

    return [self.applePayService applePayViewControllerWithMode:mode
                                                     completion:completion];
}

- (void)invokePBBAWithConfiguration:(nonnull JPConfiguration *)configuration
                         completion:(nullable JPCompletionBlock)completion {

    JPError *configurationError = [self.configurationValidationService validatePBBAConfiguration:configuration];
    if (configurationError) {
        completion(nil, configurationError);
        return;
    }
    self.configuration = configuration;
    self.pbbaService = [[JPPBBAService alloc] initWithConfiguration:configuration
                                                 transactionService:self.transactionService];

    if ([configuration.pbbaConfiguration hasDeepLinkURL]) {
        [self.pbbaService pollingOrderStatus:completion];
    } else {
        [self.pbbaService openPBBAMerchantApp:completion];
    }
}

- (void)invokePaymentMethodScreenWithMode:(JPTransactionMode)mode
                            configuration:(JPConfiguration *)configuration
                               completion:(JPCompletionBlock)completion {

    UIViewController *controller = [self paymentMethodViewControllerWithMode:mode
                                                               configuration:configuration
                                                                  completion:completion];

    if (!controller) {
        return;
    }

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.modalPresentationStyle = UIModalPresentationFullScreen;

    [UIApplication.topMostViewController presentViewController:navController
                                                      animated:YES
                                                    completion:nil];
}

- (UIViewController *)paymentMethodViewControllerWithMode:(JPTransactionMode)mode
                                            configuration:(JPConfiguration *)configuration
                                               completion:(JPCompletionBlock)completion {

    return [JPPaymentMethodsBuilderImpl buildModuleWithMode:mode
                                              configuration:configuration
                                         transactionService:self.transactionService
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
    self.transactionService.isSandboxed = isSandboxed;
}

@end
