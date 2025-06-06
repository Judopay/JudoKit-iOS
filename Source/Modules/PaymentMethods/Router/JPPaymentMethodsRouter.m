//
//  JPPaymentMethodsRouter.m
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

#import "JPPaymentMethodsRouter.h"
#import "JPApiService.h"
#import "JPCardCustomizationBuilder.h"
#import "JPCardCustomizationViewController.h"
#import "JPConfiguration+Additions.h"
#import "JPConfiguration.h"
#import "JPError+Additions.h"
#import "JPPaymentMethodsPresenter.h"
#import "JPPaymentMethodsViewController.h"
#import "JPSliderTransitioningDelegate.h"
#import "JPTransactionBuilder.h"
#import "JPTransactionViewController.h"
#import "JPUIConfiguration.h"

@interface JPPaymentMethodsRouterImpl ()

@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, strong) JPApiService *apiService;
@property (nonatomic, strong) JPCompletionBlock completionHandler;
@property (nonatomic, strong) JPSliderTransitioningDelegate *transitioningDelegate;

@end

@implementation JPPaymentMethodsRouterImpl

#pragma mark - Initializers

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration
                           apiService:(JPApiService *)apiService
                transitioningDelegate:(JPSliderTransitioningDelegate *)transitioningDelegate
                           completion:(JPCompletionBlock)completion {
    if (self = [super init]) {
        self.configuration = configuration;
        self.apiService = apiService;
        self.transitioningDelegate = transitioningDelegate;
        self.completionHandler = completion;
    }
    return self;
}

#pragma mark - Protocol Conformance

- (void)navigateToSaveCardModuleWithCompletion:(JPCompletionBlock)completion {
    JPPresentationMode mode = self.configuration.presentationModeForCardPayments;
    [self navigateToTransactionModuleWithType:JPTransactionTypeSaveCard presentationMode:mode cardDetails:nil andCompletion:completion];
}

- (void)navigateToTokenTransactionModuleWithType:(JPTransactionType)type
                                     cardDetails:(JPCardTransactionDetails *)details
                                   andCompletion:(JPCompletionBlock)completion {
    JPPresentationMode mode = [self.configuration presentationModeForTokenPaymentsForPaymentMethods:YES];
    [self navigateToTransactionModuleWithType:type presentationMode:mode cardDetails:details andCompletion:completion];
}

- (void)navigateToTransactionModuleWithType:(JPTransactionType)type
                           presentationMode:(JPPresentationMode)mode
                                cardDetails:(JPCardTransactionDetails *)details
                              andCompletion:(JPCompletionBlock)completion {
    JPTransactionViewController *controller =
        [JPTransactionBuilderImpl buildModuleWithApiService:self.apiService
                                              configuration:self.configuration
                                            transactionType:type
                                           presentationMode:mode
                                         transactionDetails:details
                                                 completion:completion];

    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = self.transitioningDelegate;

    [self.viewController presentViewController:controller animated:YES completion:nil];
}

- (void)navigateToCardCustomizationWithIndex:(NSUInteger)index {
    JPCardCustomizationViewController *viewController;
    JPTheme *theme = self.configuration.uiConfiguration.theme;
    viewController = [JPCardCustomizationBuilderImpl buildModuleWithCardIndex:index andTheme:theme];
    [self.viewController.navigationController pushViewController:viewController animated:YES];
}

- (void)dismissViewControllerWithCompletion:(void (^)(void))completion {
    [self.viewController dismissViewControllerAnimated:YES completion:completion];
}

@end
