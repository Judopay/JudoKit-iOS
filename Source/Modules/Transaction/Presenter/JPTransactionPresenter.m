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

@property (nonatomic, assign) BOOL isEmailValid;
@property (nonatomic, assign) BOOL isPhoneCodeValid;
@property (nonatomic, assign) BOOL isCountryNameValid;
@property (nonatomic, assign) BOOL isCityNameValid;
@property (nonatomic, assign) BOOL isPhoneNumberValid;
@property (nonatomic, assign) BOOL isAddressLine1Valid;
@end

@implementation JPTransactionPresenterImpl

#pragma mark - Initializer

- (instancetype)init {
    if (self = [super init]) {
        self.isCardNumberValid = NO;
        self.isCardholderNameValid = NO;
        self.isEmailValid = NO;
        self.isExpiryDateValid = NO;
        self.isSecureCodeValid = NO;
        self.isPostalCodeValid = NO;
        self.isCountryNameValid = NO;
        self.isCityNameValid = NO;
        self.isPhoneNumberValid = NO;
        self.isAddressLine1Valid = NO;
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
    self.addCardViewModel.cardholderEmailViewModel.placeholder = @"card_holder_email_hint".localized;

    self.addCardViewModel.cardholderAddressLine1ViewModel.placeholder = [NSString stringWithFormat:@"card_holder_adress_line_hint".localized, @(1)];
    self.addCardViewModel.cardholderAddressLine2ViewModel.placeholder = [NSString stringWithFormat:@"card_holder_adress_line_hint".localized, @(2)];
    self.addCardViewModel.cardholderAddressLine3ViewModel.placeholder = [NSString stringWithFormat:@"card_holder_adress_line_hint".localized, @(3)];
    self.addCardViewModel.cardholderPhoneViewModel.placeholder = @"card_holder_phone_hint".localized;
    self.addCardViewModel.cardholderCityViewModel.placeholder = @"card_holder_city_hint".localized;

    self.addCardViewModel.expiryDateViewModel.placeholder = @"expiry_date".localized;

    NSString *placeholder = [JPCardNetwork secureCodePlaceholderForNetworkType:[self.interactor cardNetworkType]];
    self.addCardViewModel.secureCodeViewModel.placeholder = placeholder;

    NSArray *selectableCountries = [self.interactor getFilteredCountriesBySearchString:nil];
    
    if (selectableCountries.count > 0) {
        self.addCardViewModel.countryPickerViewModel.placeholder = @"card_holder_country_hint".localized;
        self.addCardViewModel.pickerCountries = selectableCountries;
        JPCountry *country = selectableCountries.firstObject;
        self.addCardViewModel.countryPickerViewModel.text = country.name;
        self.addCardViewModel.cardholderPhoneCodeViewModel.text = country.dialCode;
    }
   
    self.addCardViewModel.postalCodeInputViewModel.placeholder = @"post_code_hint".localized;

    self.addCardViewModel.addCardButtonViewModel.title = buttonTitle.uppercaseString;
    self.addCardViewModel.addCardButtonViewModel.isEnabled = false;

    self.addCardViewModel.backButtonViewModel.title = @"back".uppercaseString;
    self.addCardViewModel.backButtonViewModel.isEnabled = YES;

    [self.view applyConfiguredTheme:[self.interactor getConfiguredTheme]];
    [self.view updateViewWithViewModel:self.addCardViewModel shouldUpdateTargets:YES];
}

#pragma mark - Input Handler

- (void)handleInputChange:(NSString *)input forType:(JPInputType)type showError:(BOOL)showError {

    switch (type) {
        case JPInputTypeCardNumber:
            [self updateCardNumberViewModelForInput:input];
            break;
        case JPInputTypeCardholderEmail:
            [self updateCardholderEmailViewModelForInput:input showError:showError];
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
        case JPInputTypeCardholderPhone:
            [self updateCardholderPhoneViewModelForInput:input];
            break;
        case JPInputTypeCardholderAddressLine1:
        case JPInputTypeCardholderAddressLine2:
        case JPInputTypeCardholderAddressLine3:
            [self updateCardholderAddressLineViewModelForInput:input inputType:type];
            break;
        case JPInputTypeCardholderPhoneCode:
            [self updateCardholderPhoneCodeViewModelForInput:input showError:showError];
            break;
        case JPInputTypeCardholderCity:
            [self updateCardholderCityViewModelForInput:input];
            break;
    }

    [self updateTransactionButtonModelIfNeeded];
    [self.view updateViewWithViewModel:self.addCardViewModel shouldUpdateTargets:NO];
}

#pragma mark - Transaction Button Tap

- (void)handleTransactionButtonTap {
    self.addCardViewModel.mode = [self.interactor cardDetailsMode];
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

- (void)handleContinueButtonTap {
    self.addCardViewModel.mode = JPCardDetailsMode3DS2BillingDetails;
    [self.view updateViewWithViewModel:self.addCardViewModel shouldUpdateTargets:YES];
}

- (void)handleBackButtonTap {
    self.addCardViewModel.mode = JPCardDetailsMode3DS2;
    [self.view updateViewWithViewModel:self.addCardViewModel shouldUpdateTargets:YES];
}

- (void)handleError:(JPError *)error {
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

- (void)handleResponse:(JPResponse *)response {
    if (self.interactor.transactionType == JPTransactionTypeSaveCard) {
        NSString *token = response.cardDetails.cardToken;
        [self.interactor updateKeychainWithCardModel:self.addCardViewModel
                                            andToken:token];
    }

    __weak typeof(self) weakSelf = self;
    [self.router dismissViewControllerWithCompletion:^{
        [weakSelf.interactor completeTransactionWithResponse:response error:nil];
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

- (void)handleAddAddressLineTap {
    [self.view updateViewWithViewModel:self.addCardViewModel shouldUpdateTargets:NO];
}

#pragma mark - Helper methods

- (void)updateViewModelWithCardNumber:(NSString *)cardNumber
                        andExpiryDate:(NSString *)expiryDate {

    [self.interactor resetCardValidationResults];

    [self updateCardNumberViewModelForInput:cardNumber];
    [self updateExpiryDateViewModelForInput:expiryDate];
    [self updateTransactionButtonModelIfNeeded];

    [self.view updateViewWithViewModel:self.addCardViewModel shouldUpdateTargets:NO];
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
        case JPCardDetailsMode3DS2:
            self.addCardViewModel.addCardButtonViewModel.isEnabled = self.isSecureCodeValid;
            break;
        case JPCardDetailsMode3DS2BillingDetails: {
            BOOL is3DS2Valid = self.isEmailValid && self.isCountryNameValid && self.isAddressLine1Valid && self.isPhoneNumberValid && self.isCityNameValid && self.isPostalCodeValid;
            self.addCardViewModel.addCardButtonViewModel.isEnabled = is3DS2Valid;
        } break;
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

- (void)updateCardholderEmailViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateCardholderEmailInput:input];
    self.addCardViewModel.cardholderEmailViewModel.errorText = showError ? result.errorMessage : nil;
    self.isEmailValid = result.isValid;
    self.addCardViewModel.cardholderEmailViewModel.text = result.formattedInput;
}

- (void)updateCardholderPhoneCodeViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateCardholderPhoneInput:input];
    self.addCardViewModel.cardholderPhoneCodeViewModel.text = result.formattedInput;
    self.addCardViewModel.cardholderPhoneCodeViewModel.errorText = showError ? result.errorMessage : nil;
    self.isPhoneCodeValid = result.isValid;
}

- (void)updateCardholderCityViewModelForInput:(NSString *)input {
    self.isCityNameValid = YES;
    self.addCardViewModel.cardholderCityViewModel.text = input;
}

- (void)updateCardholderPhoneViewModelForInput:(NSString *)input {
    JPValidationResult *result = [self.interactor validateCardholderPhoneInput:input];
    self.addCardViewModel.cardholderPhoneViewModel.errorText = result.errorMessage;
    self.isPhoneNumberValid = result.isValid;
    self.addCardViewModel.cardholderPhoneViewModel.text = result.formattedInput;
}

- (void)updateCardholderAddressLineViewModelForInput:(NSString *)input inputType:(JPInputType)inputType {
    switch (inputType) {
        case JPInputTypeCardholderAddressLine1: {
            _isAddressLine1Valid = YES;
            self.addCardViewModel.cardholderAddressLine1ViewModel.text = input;
        } break;
        case JPInputTypeCardholderAddressLine2:
            self.addCardViewModel.cardholderAddressLine2ViewModel.text = input;
            break;
        case JPInputTypeCardholderAddressLine3:
            self.addCardViewModel.cardholderAddressLine3ViewModel.text = input;
            break;
        default:
            break;
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
    self.addCardViewModel.cardholderPhoneCodeViewModel.text = [[JPCountry isoCodeForCountry:input] stringValue];
   // self.addCardViewModel.pickerCountries = [self.interactor getFilteredCountriesBySearchString:input];
    [self.view updateViewWithViewModel:self.addCardViewModel shouldUpdateTargets:NO];
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

    // TODO: Handle Maestro-specific logic
    //  card.startDate = viewModel.startDateViewModel.text;
    //  card.issueNumber = viewModel.issueNumberViewModel.text;

    return card;
}

#pragma mark - Lazy properties

- (JPTransactionViewModel *)addCardViewModel {
    if (!_addCardViewModel) {
        _addCardViewModel = [JPTransactionViewModel new];
        _addCardViewModel.cardNumberViewModel = [JPTransactionNumberInputViewModel new];
        _addCardViewModel.cardholderNameViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderName];
        _addCardViewModel.cardholderEmailViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderEmail];
        _addCardViewModel.cardholderPhoneViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderPhone];
        _addCardViewModel.cardholderCityViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderCity];
        _addCardViewModel.cardholderAddressLine1ViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderAddressLine1];
        _addCardViewModel.cardholderAddressLine2ViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderAddressLine2];
        _addCardViewModel.cardholderAddressLine3ViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderAddressLine3];
        _addCardViewModel.cardholderPhoneCodeViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderPhoneCode];
        _addCardViewModel.expiryDateViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardExpiryDate];
        _addCardViewModel.secureCodeViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardSecureCode];
        _addCardViewModel.countryPickerViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardCountry];
        _addCardViewModel.postalCodeInputViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardPostalCode];
        _addCardViewModel.addCardButtonViewModel = [JPTransactionButtonViewModel new];
        _addCardViewModel.backButtonViewModel = [JPTransactionButtonViewModel new];
    }
    return _addCardViewModel;
}

@end
