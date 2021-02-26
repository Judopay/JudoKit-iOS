//
//  JPTransactionPresenter.m
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

#import "JPTransactionPresenter.h"
#import "JPAddress.h"
#import "JPCard.h"
#import "JPCardDetails.h"
#import "JPCountry.h"
#import "JPError+Additions.h"
#import "JPResponse.h"
#import "JPTransactionInteractor.h"
#import "JPTransactionRouter.h"
#import "JPTransactionViewController.h"
#import "JPValidationResult.h"
#import "NSString+Additions.h"

@interface JPTransactionPresenterImpl ()
@property (nonatomic, strong) JPTransactionViewModel *addCardViewModel;
@property (nonatomic, assign) BOOL isCardNumberValid;
@property (nonatomic, assign) BOOL isCardholderNameValid;
@property (nonatomic, assign) BOOL isExpiryDateValid;
@property (nonatomic, assign) BOOL isSecureCodeValid;
@property (nonatomic, assign) BOOL isPostalCodeValid;
@end

@implementation JPTransactionPresenterImpl

#pragma mark - Initializer

- (instancetype)init {
    if (self = [super init]) {
        self.isCardNumberValid = NO;
        self.isCardholderNameValid = NO;
        self.isExpiryDateValid = NO;
        self.isSecureCodeValid = NO;
        self.isPostalCodeValid = NO;
    }
    return self;
}

#pragma mark - Protocol methods

- (void)prepareInitialViewModel {

    JPTransactionType type = self.interactor.transactionType;
    NSString *buttonTitle = [self transactionButtonTitleForType:type];
    self.addCardViewModel.type = type;
    self.addCardViewModel.mode = [self.interactor cardDetailsMode];

    self.addCardViewModel.cardNumberViewModel.placeholder = @"card_number_hint".localized;
    self.addCardViewModel.cardholderNameViewModel.placeholder = @"card_holder_hint".localized;
    self.addCardViewModel.expiryDateViewModel.placeholder = @"expiry_date".localized;
    NSString *placeholder = [JPCardNetwork secureCodePlaceholderForNetworkType:[self.interactor cardNetworkType]];
    self.addCardViewModel.secureCodeViewModel.placeholder = placeholder;

    NSArray *selectableCountryNames = [self.interactor getSelectableCountryNames];
    self.addCardViewModel.countryPickerViewModel.placeholder = @"country".localized;
    self.addCardViewModel.countryPickerViewModel.pickerTitles = selectableCountryNames;
    self.addCardViewModel.countryPickerViewModel.text = selectableCountryNames.firstObject;

    self.addCardViewModel.postalCodeInputViewModel.placeholder = @"post_code_hint".localized;

    self.addCardViewModel.addCardButtonViewModel.title = buttonTitle.uppercaseString;
    self.addCardViewModel.addCardButtonViewModel.isEnabled = false;

    [self.view loadViewWithMode:self.addCardViewModel.mode];
    [self.view updateViewWithViewModel:self.addCardViewModel];
}

#pragma mark - Input Handler

- (void)handleInputChange:(NSString *)input forType:(JPInputType)type {

    switch (type) {
        case JPInputTypeCardNumber:
            [self updateCardNumberViewModelForInput:input];
            break;
        case JPInputTypeCardholderName:
            [self updateCardholderNameViewModelForInput:input];
            break;
        case JPInputTypeCardExpiryDate:
            [self updateExpiryDateViewModelForInput:input];
            break;
        case JPInputTypeCardSecureCode:
            [self updateSecureCodeViewModelForInput:input];
            break;
        case JPInputTypeCardCountry:
            [self updateCountryViewModelForInput:input];
            [self updatePostalCodeViewModelForInput:@""];
            break;
        case JPInputTypeCardPostalCode:
            [self updatePostalCodeViewModelForInput:input];
            break;
    }

    [self updateTransactionButtonModelIfNeeded];
    [self.view updateViewWithViewModel:self.addCardViewModel];
}

#pragma mark - Transaction Button Tap

- (void)handleTransactionButtonTap {
    JPCard *card = [self cardFromViewModel:self.addCardViewModel];

    __weak typeof(self) weakSelf = self;
    [self.interactor sendTransactionWithCard:card
                           completionHandler:^(JPResponse *response, JPError *error) {
                               if (error) {
                                   [weakSelf handleError:error];
                                   return;
                               }

                               [weakSelf handleResponse:response];
                           }];
}

- (void)handleError:(JPError *)error {
    if (error.code == Judo3DSRequestError) {
        [self handle3DSecureTransactionFromError:error];
        return;
    }

    JPError *transactionError = [JPError formattedErrorFromError:error];

    if (error.code == JudoUserDidCancelError) {
        __weak typeof(self) weakSelf = self;
        [self.router dismissViewControllerWithCompletion:^{
            [weakSelf.interactor completeTransactionWithResponse:nil
                                                           error:JPError.judoUserDidCancelError];
        }];
        return;
    }

    [self.view updateViewWithError:transactionError];
    [self.interactor storeError:transactionError];
}

- (void)handle3DSecureTransactionFromError:(NSError *)error {
    __weak typeof(self) weakSelf = self;
    [self.interactor handle3DSecureTransactionFromError:error
                                             completion:^(JPResponse *response, JPError *transactionError) {
                                                 if (transactionError) {
                                                     [weakSelf handleError:transactionError];
                                                     return;
                                                 }

                                                 [weakSelf handleResponse:response];
                                             }];
}

- (void)handleResponse:(JPResponse *)response {

    if (self.interactor.transactionType == JPTransactionTypeSaveCard) {
        NSString *token = response.cardDetails.cardToken;
        [self.interactor updateKeychainWithCardModel:self.addCardViewModel
                                            andToken:token];
    }

    [self.interactor completeTransactionWithResponse:response
                                               error:nil];

    __weak typeof(self) weakSelf = self;
    [self.router dismissViewControllerWithCompletion:^{
        [weakSelf.view didFinishAddingCard];
    }];
}

#pragma mark - Scan Card Tap

- (void)handleScanCardButtonTap {
#if TARGET_OS_SIMULATOR
    [self.view displayCameraSimulatorAlert];
#else
    [self handleCameraPermissions];
#endif
}

- (void)handleCameraPermissions {
    __weak typeof(self) weakSelf = self;
    [self.interactor handleCameraPermissionsWithCompletion:^(AVAuthorizationStatus authorizationStatus) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (authorizationStatus) {
                case AVAuthorizationStatusDenied:
                    [weakSelf.view displayCameraPermissionsAlert];
                    break;

                case AVAuthorizationStatusAuthorized:
                    [weakSelf.router navigateToScanCamera];
                    break;

                default:
                    [weakSelf.view displayCameraRestrictionAlert];
            }
        });
    }];
}

- (void)handleCancelButtonTap {
    __weak typeof(self) weakSelf = self;
    [self.router dismissViewControllerWithCompletion:^{
        [weakSelf.interactor completeTransactionWithResponse:nil
                                                       error:JPError.judoUserDidCancelError];
    }];
}

#pragma mark - Helper methods

- (void)updateViewModelWithCardNumber:(NSString *)cardNumber
                        andExpiryDate:(NSString *)expiryDate {

    [self.interactor resetCardValidationResults];

    [self updateCardNumberViewModelForInput:cardNumber];
    [self updateExpiryDateViewModelForInput:expiryDate];
    [self updateTransactionButtonModelIfNeeded];

    [self.view updateViewWithViewModel:self.addCardViewModel];
}

- (NSString *)transactionButtonTitleForType:(JPTransactionType)type {
    switch (type) {
        case JPTransactionTypePayment:
        case JPTransactionTypePreAuth:
            return [self.interactor generatePayButtonTitle];
        case JPTransactionTypeSaveCard:
            return @"save_card".localized;
        case JPTransactionTypeRegisterCard:
            return @"register_card".localized;
        case JPTransactionTypeCheckCard:
            return @"check_card".localized;
        default:
            return nil;
    }
}

- (void)updateTransactionButtonModelIfNeeded {
    JPCardDetailsMode mode = [self.interactor cardDetailsMode];
    BOOL isDefaultValid = self.isCardNumberValid && self.isCardholderNameValid && self.isExpiryDateValid && self.isSecureCodeValid;
    switch (mode) {
        case JPCardDetailsModeSecurityCode:
            self.addCardViewModel.addCardButtonViewModel.isEnabled = self.isSecureCodeValid;
            break;
        case JPCardDetailsModeDefault:
            self.addCardViewModel.addCardButtonViewModel.isEnabled = isDefaultValid;
            break;
        case JPCardDetailsModeAVS:
            self.addCardViewModel.addCardButtonViewModel.isEnabled = isDefaultValid && self.isPostalCodeValid;
            break;
        default:
            break;
    }
}

- (void)updateCardNumberViewModelForInput:(NSString *)input {
    JPValidationResult *result = [self.interactor validateCardNumberInput:input];
    self.addCardViewModel.cardNumberViewModel.errorText = result.errorMessage;
    self.isCardNumberValid = result.isValid;

    [self updateSecureCodePlaceholderForNetworkType:result.cardNetwork];

    if (result.isInputAllowed) {
        self.addCardViewModel.cardNumberViewModel.text = result.formattedInput;
        self.addCardViewModel.cardNumberViewModel.cardNetwork = result.cardNetwork;
        return;
    }
}

- (void)updateSecureCodePlaceholderForNetworkType:(JPCardNetworkType)cardNetwork {
    if (self.addCardViewModel.cardNumberViewModel.cardNetwork != cardNetwork) {
        self.addCardViewModel.secureCodeViewModel.text = @"";
        self.isSecureCodeValid = false;
        NSString *placeholder = [JPCardNetwork secureCodePlaceholderForNetworkType:cardNetwork];
        self.addCardViewModel.secureCodeViewModel.placeholder = placeholder;
    }
}

- (void)updateCardholderNameViewModelForInput:(NSString *)input {
    JPValidationResult *result = [self.interactor validateCardholderNameInput:input];
    self.addCardViewModel.cardholderNameViewModel.errorText = result.errorMessage;
    self.isCardholderNameValid = result.isValid;

    if (result.isInputAllowed) {
        self.addCardViewModel.cardholderNameViewModel.text = result.formattedInput;
        return;
    }
}

- (void)updateExpiryDateViewModelForInput:(NSString *)input {
    JPValidationResult *result = [self.interactor validateExpiryDateInput:input];
    self.addCardViewModel.expiryDateViewModel.errorText = result.errorMessage;
    self.isExpiryDateValid = result.isValid;

    if (result.isValid && result.formattedInput.length > 4) {
        [self.view changeFocusToSecurityCodeField];
    }

    if (result.isInputAllowed) {
        self.addCardViewModel.expiryDateViewModel.text = result.formattedInput;
        return;
    }
}

- (void)updateSecureCodeViewModelForInput:(NSString *)input {
    JPValidationResult *result = [self.interactor validateSecureCodeInput:input];
    self.addCardViewModel.secureCodeViewModel.errorText = result.errorMessage;
    self.isSecureCodeValid = result.isValid;
    self.addCardViewModel.secureCodeViewModel.text = result.formattedInput;
}

- (void)updateCountryViewModelForInput:(NSString *)input {
    JPValidationResult *result = [self.interactor validateCountryInput:input];
    self.addCardViewModel.countryPickerViewModel.errorText = result.errorMessage;

    if (result.isInputAllowed) {
        self.addCardViewModel.countryPickerViewModel.text = result.formattedInput;
        return;
    }
}

- (void)updatePostalCodeViewModelForInput:(NSString *)input {
    JPValidationResult *result = [self.interactor validatePostalCodeInput:input];
    self.addCardViewModel.postalCodeInputViewModel.errorText = result.errorMessage;
    self.isPostalCodeValid = result.isValid;

    if (result.isInputAllowed) {
        self.addCardViewModel.postalCodeInputViewModel.text = result.formattedInput;
        return;
    }
}

- (JPCard *)cardFromViewModel:(JPTransactionViewModel *)viewModel {
    JPCard *card = [[JPCard alloc] initWithCardNumber:viewModel.cardNumberViewModel.text
                                       cardholderName:viewModel.cardholderNameViewModel.text
                                           expiryDate:viewModel.expiryDateViewModel.text
                                           secureCode:viewModel.secureCodeViewModel.text];

    JPAddress *configuredAddress = [self.interactor getConfiguredCardAddress];
    card.cardAddress = configuredAddress ? configuredAddress : [JPAddress new];

    if ([self.interactor isAVSEnabled]) {
        card.cardAddress.countryCode = [JPCountry isoCodeForCountry:viewModel.countryPickerViewModel.text];
        card.cardAddress.postCode = viewModel.postalCodeInputViewModel.text;
    }

    //TODO: Handle Maestro-specific logic
    // card.startDate = viewModel.startDateViewModel.text;
    // card.issueNumber = viewModel.issueNumberViewModel.text;

    return card;
}

#pragma mark - Lazy properties

- (JPTransactionViewModel *)addCardViewModel {
    if (!_addCardViewModel) {
        _addCardViewModel = [JPTransactionViewModel new];
        _addCardViewModel.cardNumberViewModel = [JPTransactionNumberInputViewModel new];
        _addCardViewModel.cardholderNameViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderName];
        _addCardViewModel.expiryDateViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardExpiryDate];
        _addCardViewModel.secureCodeViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardSecureCode];
        _addCardViewModel.countryPickerViewModel = [JPTransactionPickerViewModel new];
        _addCardViewModel.postalCodeInputViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardPostalCode];
        _addCardViewModel.addCardButtonViewModel = [JPTransactionButtonViewModel new];
    }
    return _addCardViewModel;
}

@end
