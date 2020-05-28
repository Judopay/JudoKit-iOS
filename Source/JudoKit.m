//
//  JudoKit.m
//  JudoKit-iOS
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
#import "JPPBBAService.h"
#import "JPConfiguration.h"
#import "JPConfigurationValidationService.h"
#import "JPError+Additions.h"
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
#import "JPTransactionStatusView.h"
#import "UIView+Additions.h"
#import "JPUIConfiguration.h"

@interface JudoKit ()  <JPStatusViewDelegate>

@property (nonatomic, strong) JPTransactionService *transactionService;
@property (nonatomic, strong) JPApplePayService *applePayService;
@property (nonatomic, strong) JPPBBAService *pbbaService;
@property (nonatomic, strong) JPCompletionBlock completionBlock;
@property (nonatomic, strong) JPSliderTransitioningDelegate *transitioningDelegate;
@property (nonatomic, strong) id<JPConfigurationValidationService> configurationValidationService;
@property (nonatomic, strong) JPTransactionStatusView *transactionStatusView;
@property (nonatomic, strong) JPConfiguration *configuration;

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

    JPError *configurationError = [self.configurationValidationService validateConfiguration:configuration
                                                                          forTransactionType:type];

    if (configurationError) {
        completion(nil, configurationError);
        return;
    }

    self.transactionService.transactionType = type;

    UIViewController *controller;
    controller = [JPTransactionBuilderImpl buildModuleWithTransactionService:self.transactionService
                                                               configuration:configuration
                                                                  completion:completion];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = self.transitioningDelegate;
    [UIApplication.topMostViewController presentViewController:controller
                                                      animated:YES
                                                    completion:nil];
}

- (void)invokeApplePayWithMode:(JPTransactionMode)mode
                 configuration:(JPConfiguration *)configuration
                    completion:(JPCompletionBlock)completion {

    JPError *configurationError = [self.configurationValidationService valiadateApplePayConfiguration:configuration];

    if (configurationError) {
        completion(nil, configurationError);
        return;
    }

    self.applePayService = [[JPApplePayService alloc] initWithConfiguration:configuration
                                                         transactionService:self.transactionService];
    [self.applePayService invokeApplePayWithMode:mode completion:completion];
}

- (void)invokePBBAWithMode:(nonnull JPConfiguration *)configuration
                completion:(nullable JPCompletionBlock)completion {
    
    JPError *configurationError = [self.configurationValidationService valiadatePBBAConfiguration:configuration];
    if (configurationError) {
        completion(nil, configurationError);
        return;
    }
    self.configuration = configuration;
    self.pbbaService = [[JPPBBAService alloc] initWithConfiguration:configuration
                                                 transactionService:self.transactionService];
    self.pbbaService.statusViewDelegate = self;
    [self.pbbaService openPBBAMerchantApp:completion];
}

- (void)invokePaymentMethodScreenWithMode:(JPTransactionMode)mode
                            configuration:(JPConfiguration *)configuration
                               completion:(JPCompletionBlock)completion {

    //TODO: No validation???

    UIViewController *controller;
    controller = [JPPaymentMethodsBuilderImpl buildModuleWithMode:mode
                                                    configuration:configuration
                                               transactionService:self.transactionService
                                            transitioningDelegate:self.transitioningDelegate
                                                completionHandler:completion];

    if (!controller) {
        return;
    }

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.modalPresentationStyle = UIModalPresentationFullScreen;

    [UIApplication.topMostViewController presentViewController:navController
                                                      animated:YES
                                                    completion:nil];
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

#pragma mark - JPStatusViewDelegate

-(void)showStatusViewWith:(JPTransactionStatus)status {
    [self hideStatusView];
    [UIApplication.topMostViewController.view addSubview:self.transactionStatusView];
    [self.transactionStatusView pinToView:UIApplication.topMostViewController.view withPadding:0.0];
    [self.transactionStatusView applyTheme:self.configuration.uiConfiguration.theme];
    [self.transactionStatusView changeToTransactionStatus:status];
}

-(void)hideStatusView {
    [self.transactionStatusView removeFromSuperview];
}

#pragma mark - lazy init transactionStatusView

- (JPTransactionStatusView *)transactionStatusView {
    if (!_transactionStatusView) {
        _transactionStatusView = [JPTransactionStatusView new];
        _transactionStatusView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _transactionStatusView;
}

@end
