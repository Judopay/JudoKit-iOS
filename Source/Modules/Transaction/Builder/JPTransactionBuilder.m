//
//  JPTransactionBuilder.m
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

#import "JPTransactionBuilder.h"
#import "JPApiService.h"
#import "JPCardTransactionService.h"
#import "JPCardValidationService.h"
#import "JPConfiguration.h"
#import "JPTheme.h"
#import "JPTransactionInteractor.h"
#import "JPTransactionPresenter.h"
#import "JPTransactionRouter.h"
#import "JPTransactionViewController.h"
#import "JPUIConfiguration.h"
#import "JPValidationResult.h"

@implementation JPTransactionBuilderImpl

+ (JPTransactionViewController *)buildModuleWithApiService:(JPApiService *)apiService
                                             configuration:(JPConfiguration *)configuration
                                           transactionType:(JPTransactionType)type
                                           cardDetailsMode:(JPCardDetailsMode)mode
                                               cardNetwork:(JPCardNetworkType)cardNetwork
                                                completion:(JPCompletionBlock)completion {
    JPCardValidationService *cardValidationService = [JPCardValidationService new];
    cardValidationService.lastCardNumberValidationResult = [JPValidationResult new];
    cardValidationService.lastCardNumberValidationResult.cardNetwork = cardNetwork;

    JPCardTransactionService *transactionService = [[JPCardTransactionService alloc] initWithAPIService:apiService
                                                                                       andConfiguration:configuration];

    JPTransactionInteractorImpl *extractedExpr = [[JPTransactionInteractorImpl alloc] initWithCardValidationService:cardValidationService
                                                                                                 transactionService:transactionService
                                                                                                    transactionType:type
                                                                                                    cardDetailsMode:mode
                                                                                                      configuration:configuration
                                                                                                        cardNetwork:cardNetwork
                                                                                                         completion:completion];
    JPTransactionInteractorImpl *interactor =
        extractedExpr;

    JPTransactionViewController *viewController = [JPTransactionViewController new];
    JPTransactionPresenterImpl *presenter = [JPTransactionPresenterImpl new];
    JPTransactionRouterImpl *router = [JPTransactionRouterImpl new];

    presenter.view = viewController;
    presenter.interactor = interactor;
    presenter.router = router;

    router.viewController = viewController;
    router.presenter = presenter;
    router.theme = configuration.uiConfiguration.theme;

    viewController.presenter = presenter;
    viewController.theme = configuration.uiConfiguration.theme;

    return viewController;
}

+ (JPTransactionViewController *)buildModuleWithApiService:(JPApiService *)apiService
                                             configuration:(JPConfiguration *)configuration
                                           transactionType:(JPTransactionType)type
                                           cardDetailsMode:(JPCardDetailsMode)mode
                                                completion:(JPCompletionBlock)completion {
    return [JPTransactionBuilderImpl buildModuleWithApiService:apiService
                                                 configuration:configuration
                                               transactionType:type
                                               cardDetailsMode:mode
                                                   cardNetwork:JPCardNetworkTypeVisa
                                                    completion:completion];
}

@end
