//
//  JPPaymentMethodsPresenter.m
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

#import "JPPaymentMethodsPresenter.h"
#import "JPAmount.h"
#import "JPCardNetwork.h"
#import "JPCardTransactionDetails.h"
#import "JPConfiguration.h"
#import "JPError+Additions.h"
#import "JPPaymentMethod.h"
#import "JPPaymentMethodsInteractor.h"
#import "JPPaymentMethodsRouter.h"
#import "JPPaymentMethodsViewController.h"
#import "JPPaymentMethodsViewModel.h"
#import "JPPresentationMode.h"
#import "JPResponse.h"
#import "JPStoredCardDetails.h"
#import "JPTransactionType.h"
#import "JPUIConfiguration.h"
#import "NSString+Additions.h"

@interface JPPaymentMethodsPresenterImpl ()
@property (nonatomic, strong) JPPaymentMethodsViewModel *viewModel;
@property (nonatomic, strong) JPPaymentMethodsHeaderModel *headerModel;
@property (nonatomic, strong) JPPaymentMethodsSelectionModel *paymentSelectionModel;
@property (nonatomic, strong) JPPaymentMethodsEmptyListModel *emptyListModel;
@property (nonatomic, strong) JPPaymentMethodsCardHeaderModel *cardHeaderModel;
@property (nonatomic, strong) JPPaymentMethodsCardFooterModel *cardFooterModel;
@property (nonatomic, strong) JPPaymentMethodsCardListModel *cardListModel;
@property (nonatomic, strong) JPTransactionButtonViewModel *paymentButtonModel;

@property (nonatomic, assign) NSUInteger previousSectionIndex;
@property (nonatomic, assign) NSUInteger selectedSectionIndex;

@property (nonatomic, assign) NSUInteger selectedBankIndex;
@property (nonatomic, strong) NSArray<JPPaymentMethod *> *paymentMethods;
@property (nonatomic, strong) JPConfiguration *configuration;

@end

@implementation JPPaymentMethodsPresenterImpl

#pragma mark - Initializers
- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration {
    if (self = [super init]) {
        self.configuration = configuration;
    }
    return self;
}

#pragma mark - Protocol Conformance

- (void)viewModelNeedsUpdate {
    [self updateViewModelWithAnimationType:JPAnimationTypeSetup];
    [self.view configureWithViewModel:self.viewModel shouldAnimateChange:NO];
}

- (void)viewModelNeedsUpdateWithAnimationType:(JPAnimationType)animationType shouldAnimateChange:(BOOL)shouldAnimate {
    [self updateViewModelWithAnimationType:animationType];
    [self.view configureWithViewModel:self.viewModel shouldAnimateChange:shouldAnimate];
}

- (void)didSelectCardAtIndex:(NSUInteger)index
               isEditingMode:(BOOL)isEditing {

    if (isEditing) {
        [self.router navigateToCardCustomizationWithIndex:index];
        return;
    }

    [self.interactor selectCardAtIndex:index];

    JPAnimationType animationType;
    animationType = self.headerModel.cardModel ? JPAnimationTypeBottomToTop : JPAnimationTypeSetup;

    [self viewModelNeedsUpdateWithAnimationType:animationType
                            shouldAnimateChange:YES];
}

- (void)didSelectBankAtIndex:(NSUInteger)index {
    self.selectedBankIndex = index;
    [self viewModelNeedsUpdateWithAnimationType:JPAnimationTypeBottomToTop
                            shouldAnimateChange:YES];
}

#pragma mark - Action Handlers

- (void)handleAddCardButtonTap {
    __weak typeof(self) weakSelf = self;
    [self.router navigateToSaveCardModuleWithCompletion:^(JPResponse *response, NSError *error) {
        [weakSelf handleSaveCardResponse:response andError:error];
    }];
}

- (void)handleSaveCardResponse:(JPResponse *)response andError:(NSError *)error {
    [self.view endEditingCardListIfNeeded];

    if (error && error.code != JudoUserDidCancelError) {
        [self.view _jp_displayAlertWithTitle:@"jp_error"._jp_localized andError:error];
        return;
    }

    if (response) {
        JPCardDetails *details = response.cardDetails;

        if (!details) {
            [self.view _jp_displayAlertWithTitle:@"jp_error"._jp_localized andError:JPError.responseParseError];
            return;
        }

        [self.interactor updateKeychainWithCardDetails:details];
        [self setLastAddedCardAsSelected];
        [self viewModelNeedsUpdate];
    }
}

- (void)handleBackButtonTap {
    __weak typeof(self) weakSelf = self;
    [self.router dismissViewControllerWithCompletion:^{
        [weakSelf.interactor completeTransactionWithResponse:nil andError:JPError.userDidCancelError];
    }];
}

- (void)handlePayButtonTap {
    [self.view setIsPaymentInProgress:YES];

    __weak typeof(self) weakSelf = self;

    if (self.interactor.configuredTransactionMode == JPTransactionModeServerToServer) {
        [self.interactor processServerToServerCardPayment:^(JPResponse *response, NSError *error) {
            [weakSelf handleCallbackWithResponse:response andError:error];
        }];
        return;
    }

    JPTransactionType type = self.interactor.configuredTransactionMode == JPTransactionModePayment ? JPTransactionTypePayment : JPTransactionTypePreAuth;
    JPCardTransactionDetails *details = [[JPCardTransactionDetails alloc] initWithConfiguration:self.configuration
                                                                           andStoredCardDetails:self.selectedCard];

    [self.router navigateToTokenTransactionModuleWithType:type
                                              cardDetails:details
                                            andCompletion:^(JPResponse *response, NSError *error) {
                                                [weakSelf handleCallbackWithResponse:response andError:error];
                                            }];
}

- (void)handleApplePayButtonTap {
    __weak typeof(self) weakSelf = self;
    [self.interactor processApplePaymentWithCompletion:^(JPResponse *response, JPError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleCallbackWithResponse:response andError:error];
    }];
}

- (void)handlePaymentResponse:(JPResponse *)response {
    NSInteger selectedCardIndex = [self indexOfSelectedCard];
    if (selectedCardIndex >= 0) {
        [self.interactor setLastUsedCardAtIndex:selectedCardIndex];
    }

    __weak typeof(self) weakSelf = self;
    [self.router dismissViewControllerWithCompletion:^{
        [weakSelf.interactor completeTransactionWithResponse:response andError:nil];
    }];
}

- (void)handlePaymentError:(NSError *)error {
    [self.interactor storeError:error];
    [self.view _jp_displayAlertWithTitle:@"jp_transaction_unsuccessful"._jp_localized andError:error];
}

- (void)deleteCardWithIndex:(NSUInteger)index {
    NSArray *storedCards = [self.interactor getStoredCardDetails];
    JPStoredCardDetails *selectedCard = storedCards[index];

    [self.interactor deleteCardWithIndex:index];
    [self.cardListModel.cardModels removeObjectAtIndex:index];
    self.viewModel.headerModel.cardModel = nil;

    if (selectedCard.isSelected && storedCards.count - 1 > 0) {
        [self.interactor setCardAsSelectedAtIndex:0];
    }
    [self viewModelNeedsUpdateWithAnimationType:JPAnimationTypeBottomToTop
                            shouldAnimateChange:YES];
}

- (void)changeHeaderButtonTitle:(BOOL)isEditing {
    NSString *title = isEditing ? @"jp_button_done" : @"jp_button_edit";
    self.cardHeaderModel.editButtonTitle = title._jp_localized.uppercaseString;

    [self viewModelNeedsUpdateWithAnimationType:JPAnimationTypeNone
                            shouldAnimateChange:NO];
}

- (void)changePaymentMethodToIndex:(NSUInteger)index {

    if (index == self.previousSectionIndex) {
        return;
    }

    JPAnimationType animationType = JPAnimationTypeLeftToRight;

    if (index < self.previousSectionIndex) {
        animationType = JPAnimationTypeRightToLeft;
    }

    JPPaymentMethod *previousMethod = self.paymentSelectionModel.paymentMethods[self.previousSectionIndex];
    if (previousMethod.type == JPPaymentMethodTypeCard && self.cardListModel.cardModels.count == 0) {
        animationType = JPAnimationTypeSetup;
    }

    self.previousSectionIndex = index;
    self.selectedSectionIndex = index;

    self.paymentSelectionModel.selectedIndex = index;
    self.paymentSelectionModel.selectedPaymentMethod = self.paymentMethods[index].type;

    [self viewModelNeedsUpdateWithAnimationType:animationType shouldAnimateChange:YES];
}

- (void)orderCards {
    [self.interactor orderCards];
}

#pragma mark - Helper methods

- (void)handleCallbackWithResponse:(JPResponse *)response andError:(NSError *)error {
    [self.view setIsPaymentInProgress:NO];

    if (response) {
        [self handlePaymentResponse:response];
        return;
    }

    if (error && error.code != JudoUserDidCancelError) {
        [self handlePaymentError:error];
    }
}

- (void)setLastAddedCardAsSelected {
    NSArray *cards = [self.interactor getStoredCardDetails];
    [self.interactor setCardAsSelectedAtIndex:cards.count - 1];
}

- (void)updateViewModelWithAnimationType:(JPAnimationType)animationType {
    [self.viewModel.items removeAllObjects];

    [self prepareHeaderModel];
    self.viewModel.headerModel.animationType = animationType;
    [self preparePaymentMethodModels];
}

- (void)preparePaymentMethodModels {

    self.paymentSelectionModel.paymentMethods = self.paymentMethods;

    if (self.paymentMethods.count > 1) {
        [self.viewModel.items addObject:self.paymentSelectionModel];
    }

    self.viewModel.headerModel.paymentMethodType = self.paymentSelectionModel.selectedPaymentMethod;
    self.viewModel.headerModel.isApplePaySetUp = [self.interactor isApplePaySetUp];

    switch (self.paymentSelectionModel.selectedPaymentMethod) {
        case JPPaymentMethodTypeCard:
            [self prepareCardListModels];
            break;
        case JPPaymentMethodTypeApplePay:
            break;
        default:
            break;
    }
}

- (void)prepareCardListModels {
    NSArray<JPStoredCardDetails *> *cardDetailsArray = [self.interactor getStoredCardDetails];

    if (cardDetailsArray.count == 0) {
        [self.viewModel.items addObject:self.emptyListModel];
    } else {
        [self prepareCardModelsForStoredCardDetails:cardDetailsArray];
        [self.viewModel.items addObject:self.cardHeaderModel];
        [self.viewModel.items addObject:self.cardListModel];
        [self.viewModel.items addObject:self.cardFooterModel];
    }
}

- (void)prepareHeaderModel {
    self.headerModel.amount = [self.interactor getAmount];
    self.headerModel.payButtonModel = self.paymentButtonModel;
    self.headerModel.payButtonModel.isEnabled = NO;
    NSArray *storedCardDetails = [self.interactor getStoredCardDetails];

    for (JPStoredCardDetails *cardDetails in storedCardDetails) {
        if (cardDetails.isSelected) {
            self.headerModel.cardModel = [self cardModelFromStoredCardDetails:cardDetails];
            BOOL isCardExpired = self.headerModel.cardModel.cardExpirationStatus != JPCardExpirationStatusExpired;
            self.headerModel.payButtonModel.isEnabled = isCardExpired;
        }
    }

    self.viewModel.headerModel = self.headerModel;
}

- (void)prepareCardModelsForStoredCardDetails:(NSArray<JPStoredCardDetails *> *)storedCardDetails {
    [self.cardListModel.cardModels removeAllObjects];
    for (JPStoredCardDetails *cardDetails in storedCardDetails) {
        JPPaymentMethodsCardModel *cardModel = [self cardModelFromStoredCardDetails:cardDetails];
        [self.cardListModel.cardModels addObject:cardModel];
    }
}

- (JPPaymentMethodsCardModel *)cardModelFromStoredCardDetails:(JPStoredCardDetails *)cardDetails {
    JPPaymentMethodsCardModel *cardModel = [JPPaymentMethodsCardModel new];
    cardModel.cardTitle = cardDetails.cardTitle;
    cardModel.cardNetwork = cardDetails.cardNetwork;
    cardModel.cardNumberLastFour = cardDetails.cardLastFour;
    cardModel.cardExpiryDate = cardDetails.expiryDate;
    cardModel.cardPatternType = cardDetails.patternType;
    cardModel.isDefaultCard = cardDetails.isDefault;
    cardModel.isSelected = cardDetails.isSelected;
    cardModel.cardExpirationStatus = cardDetails.expirationStatus;
    return cardModel;
}

- (JPStoredCardDetails *)selectedCard {
    for (JPStoredCardDetails *card in [self.interactor getStoredCardDetails]) {
        if (card.isSelected) {
            return card;
        }
    }
    return nil;
}

- (NSInteger)indexOfSelectedCard {
    NSInteger cardIndex = 0;
    for (JPStoredCardDetails *card in [self.interactor getStoredCardDetails]) {
        if (card.isSelected) {
            return cardIndex;
        }
        cardIndex++;
    }
    return -1;
}

#pragma mark - Lazy properties

- (JPPaymentMethodsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [JPPaymentMethodsViewModel new];
        _viewModel.items = [NSMutableArray new];
    }
    return _viewModel;
}

- (JPPaymentMethodsHeaderModel *)headerModel {
    if (!_headerModel) {
        _headerModel = [JPPaymentMethodsHeaderModel new];
        _headerModel.amount = [JPAmount amount:@"0.0" currency:@"GBP"];
    }
    return _headerModel;
}

- (JPPaymentMethodsSelectionModel *)paymentSelectionModel {
    if (!_paymentSelectionModel) {
        _paymentSelectionModel = [JPPaymentMethodsSelectionModel new];
        _paymentSelectionModel.identifier = @"JPPaymentMethodsSelectionCell";
        _paymentSelectionModel.selectedPaymentMethod = self.paymentMethods.firstObject.type;
    }
    return _paymentSelectionModel;
}

- (JPPaymentMethodsEmptyListModel *)emptyListModel {
    if (!_emptyListModel) {
        _emptyListModel = [JPPaymentMethodsEmptyListModel new];
        _emptyListModel.identifier = @"JPPaymentMethodsEmptyCardListCell";
        _emptyListModel.title = @"jp_no_connected_cards"._jp_localized;
        _emptyListModel.addCardButtonTitle = @"jp_add_card"._jp_localized.uppercaseString;
        _emptyListModel.addCardButtonIconName = @"plus-icon";

        __weak typeof(self) weakSelf = self;
        _emptyListModel.onTransactionButtonTapHandler = ^{
            [weakSelf handleAddCardButtonTap];
        };
    }
    return _emptyListModel;
}

- (JPPaymentMethodsCardHeaderModel *)cardHeaderModel {
    if (!_cardHeaderModel) {
        _cardHeaderModel = [JPPaymentMethodsCardHeaderModel new];
        _cardHeaderModel.title = @"jp_connected_cards"._jp_localized;
        _cardHeaderModel.editButtonTitle = @"jp_button_edit"._jp_localized.uppercaseString;
        _cardHeaderModel.identifier = @"JPPaymentMethodsCardListHeaderCell";
    }
    return _cardHeaderModel;
}

- (JPPaymentMethodsCardFooterModel *)cardFooterModel {
    if (!_cardFooterModel) {
        _cardFooterModel = [JPPaymentMethodsCardFooterModel new];
        _cardFooterModel.addCardButtonTitle = @"jp_add_card"._jp_localized.uppercaseString;
        _cardFooterModel.addCardButtonIconName = @"plus-icon";
        _cardFooterModel.identifier = @"JPPaymentMethodsCardListFooterCell";

        __weak typeof(self) weakSelf = self;
        _cardFooterModel.onTransactionButtonTapHandler = ^{
            [weakSelf handleAddCardButtonTap];
        };
    }
    return _cardFooterModel;
}

- (JPPaymentMethodsCardListModel *)cardListModel {
    if (!_cardListModel) {
        _cardListModel = [JPPaymentMethodsCardListModel new];
        _cardListModel.cardModels = [NSMutableArray new];
        _cardListModel.identifier = @"JPPaymentMethodsCardCell";
    }
    return _cardListModel;
}

- (JPPaymentMethodsCardModel *)cardModel {
    JPPaymentMethodsCardModel *cardModel = [JPPaymentMethodsCardModel new];
    return cardModel;
}

- (JPTransactionButtonViewModel *)paymentButtonModel {
    if (!_paymentButtonModel) {
        _paymentButtonModel = [JPTransactionButtonViewModel new];
        _paymentButtonModel.title = @"jp_pay_now"._jp_localized.uppercaseString;
        _paymentButtonModel.isEnabled = NO;
    }
    return _paymentButtonModel;
}

- (NSArray<JPPaymentMethod *> *)paymentMethods {
    if (!_paymentMethods) {
        _paymentMethods = [self.interactor getPaymentMethods];
    }
    return _paymentMethods;
}

@end
