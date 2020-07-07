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
#import "JPConfiguration.h"
#import "JPConfigurationValidationService.h"
#import "JPError+Additions.h"
#import "JPPBBAConfiguration.h"
#import "JPPBBAService.h"
#import "JPPaymentMethodsBuilder.h"
#import "JPPaymentMethodsViewController.h"
#import "JPResponse.h"
#import "JPSliderTransitioningDelegate.h"
#import "JPTransactionBuilder.h"
#import "JPTransactionViewController.h"
#import "UIApplication+Additions.h"

@interface JudoKit ()

@property (nonatomic, strong) JPApiService *apiService;
@property (nonatomic, strong) JPApplePayService *applePayService;
@property (nonatomic, strong) JPPBBAService *pbbaService;
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

    self = [super init];
    BOOL isDeviceSupported = !(!jailbrokenDevicesAllowed && UIApplication.isCurrentDeviceJailbroken);

    if (self && isDeviceSupported) {
        self.configurationValidationService = [JPConfigurationValidationServiceImp new];
        self.apiService = [[JPApiService alloc] initWithAuthorization:authorization isSandboxed:self.isSandboxed];
        return self;
    }

    return nil;
}

#pragma mark - Public methods

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

    UIViewController *controller =
        [JPTransactionBuilderImpl buildModuleWithApiService:self.apiService
                                              configuration:configuration
                                            transactionType:type
                                            cardDetailsMode:JPCardDetailsModeDefault
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
                                                              andApiService:self.apiService];

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
                                                         apiService:self.apiService];

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
}

@end
