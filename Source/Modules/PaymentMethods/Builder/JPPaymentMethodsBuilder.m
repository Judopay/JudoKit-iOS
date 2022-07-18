//
//  JPPaymentMethodsBuilder.m
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

#import "JPPaymentMethodsBuilder.h"
#import "JPAmount.h"
#import "JPApplePayService.h"
#import "JPConfiguration.h"
#import "JPConstants.h"
#import "JPError+Additions.h"
#import "JPPBBAConfiguration.h"
#import "JPPaymentMethod.h"
#import "JPPaymentMethodsInteractor.h"
#import "JPPaymentMethodsPresenter.h"
#import "JPPaymentMethodsRouter.h"
#import "JPPaymentMethodsViewController.h"
#import "NSBundle+Additions.h"

@implementation JPPaymentMethodsBuilderImpl

#pragma mark - Public methods

+ (JPPaymentMethodsViewController *)buildModuleWithMode:(JPTransactionMode)mode
                                          configuration:(JPConfiguration *)configuration
                                             apiService:(JPApiService *)apiService
                                  transitioningDelegate:(JPSliderTransitioningDelegate *)transitioningDelegate
                                      completionHandler:(JPCompletionBlock)completion {

    for (JPPaymentMethod *paymentMethod in configuration.paymentMethods) {
        BOOL isPbBAPresent = (paymentMethod.type == JPPaymentMethodTypePbba);
        BOOL isIDEALPresent = (paymentMethod.type == JPPaymentMethodTypeIDeal);
        BOOL isApplePayPresent = (paymentMethod.type == JPPaymentMethodTypeApplePay);
        BOOL isCurrencyPounds = [configuration.amount.currency isEqualToString:kCurrencyPounds];
        BOOL isCurrencyEUR = [configuration.amount.currency isEqualToString:kCurrencyEuro];
        BOOL isOnlyPaymentMethod = (configuration.paymentMethods.count == 1);
        BOOL isApplePaySupported = [JPApplePayService isApplePaySupported];
        BOOL isURLSchemeMissing = ((!NSBundle._jp_appURLScheme.length) || (!configuration.pbbaConfiguration.deeplinkScheme.length));

        if (isIDEALPresent && isOnlyPaymentMethod && !isCurrencyEUR) {
            completion(nil, JPError._jp_invalidIDEALCurrencyError);
            return nil;
        }

        if (isApplePayPresent && isOnlyPaymentMethod && !isApplePaySupported) {
            completion(nil, JPError._jp_applePayNotSupportedError);
            return nil;
        }

        if (isPbBAPresent && isOnlyPaymentMethod && !isCurrencyPounds) {
            completion(nil, JPError._jp_invalidPBBACurrencyError);
            return nil;
        }

        if (isPbBAPresent && isOnlyPaymentMethod && isURLSchemeMissing) {
            completion(nil, JPError._jp_PBBAURLSchemeMissingError);
            return nil;
        }
    }

    JPPaymentMethodsViewController *viewController = [JPPaymentMethodsViewController new];
    JPPaymentMethodsPresenterImpl *presenter = [[JPPaymentMethodsPresenterImpl alloc] initWithConfiguration:configuration];

    JPPaymentMethodsRouterImpl *router;
    router = [[JPPaymentMethodsRouterImpl alloc] initWithConfiguration:configuration
                                                            apiService:apiService
                                                 transitioningDelegate:transitioningDelegate
                                                            completion:completion];

    JPPaymentMethodsInteractorImpl *interactor;
    interactor = [[JPPaymentMethodsInteractorImpl alloc] initWithMode:mode
                                                        configuration:configuration
                                                           apiService:apiService
                                                           completion:completion];

    presenter.view = viewController;
    presenter.interactor = interactor;
    presenter.router = router;

    router.viewController = viewController;

    viewController.presenter = presenter;
    viewController.configuration = configuration;

    return viewController;
}

@end
