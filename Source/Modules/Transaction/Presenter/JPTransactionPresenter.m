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
#import "JPCardDetailsMode.h"
#import "JPCardNetwork.h"
#import "JPCardTransactionDetails.h"
#import "JPConstants.h"
#import "JPCountry.h"
#import "JPError+Additions.h"
#import "JPInputType.h"
#import "JPResponse.h"
#import "JPState.h"
#import "JPTransactionInteractor.h"
#import "JPTransactionRouter.h"
#import "JPTransactionViewController.h"
#import "JPValidationResult.h"
#import "NSString+Additions.h"

@interface JPTransactionPresenterImpl ()
@property (nonatomic, strong) JPTransactionViewModel *transactionViewModel;
@property (nonatomic, assign) BOOL isCardNumberValid;
@property (nonatomic, assign) BOOL isCardholderNameValid;
@property (nonatomic, assign) BOOL isExpiryDateValid;
@property (nonatomic, assign) BOOL isSecureCodeValid;
@property (nonatomic, assign) BOOL isPostalCodeValid;
@property (nonatomic, assign) BOOL isEmailValid;
@property (nonatomic, assign) BOOL isPhoneCodeValid;
@property (nonatomic, assign) BOOL isCountryNameValid;
@property (nonatomic, assign) BOOL isStateNameValid;
@property (nonatomic, assign) BOOL isCityNameValid;
@property (nonatomic, assign) BOOL isPhoneNumberValid;
@property (nonatomic, assign) BOOL isAddressLine1Valid;
@property (nonatomic, assign) BOOL isAddressLine2Valid;
@property (nonatomic, assign) BOOL isAddressLine3Valid;

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
        self.isEmailValid = NO;
        self.isPhoneCodeValid = NO;
        self.isCountryNameValid = YES;
        self.isStateNameValid = YES;
        self.isCityNameValid = NO;
        self.isPhoneNumberValid = NO;
        self.isAddressLine1Valid = NO;
        self.isAddressLine2Valid = YES;
        self.isAddressLine3Valid = YES;
    }
    return self;
}

#pragma mark - Protocol methods

- (void)prepareInitialViewModel {
    JPTransactionType type = self.interactor.transactionType;
    self.transactionViewModel.type = type;
    self.transactionViewModel.mode = [self.interactor cardDetailsMode];

    self.transactionViewModel.cardNumberViewModel.placeholder = @"card_number_hint"._jp_localized;
    self.transactionViewModel.cardholderNameViewModel.placeholder = @"card_holder_hint"._jp_localized;
    self.transactionViewModel.cardholderEmailViewModel.placeholder = @"card_holder_email_hint"._jp_localized;
    self.transactionViewModel.cardholderAddressLine1ViewModel.placeholder = [NSString stringWithFormat:@"card_holder_adress_line_hint"._jp_localized, @(1)];
    self.transactionViewModel.cardholderAddressLine2ViewModel.placeholder = [NSString stringWithFormat:@"card_holder_adress_line_hint"._jp_localized, @(2)];
    self.transactionViewModel.cardholderAddressLine3ViewModel.placeholder = [NSString stringWithFormat:@"card_holder_adress_line_hint"._jp_localized, @(3)];
    self.transactionViewModel.cardholderPhoneViewModel.placeholder = @"card_holder_phone_hint"._jp_localized;
    self.transactionViewModel.cardholderCityViewModel.placeholder = @"card_holder_city_hint"._jp_localized;
    self.transactionViewModel.expiryDateViewModel.placeholder = @"expiry_date"._jp_localized;

    NSString *secureCodePlaceholder = [JPCardNetwork secureCodePlaceholderForNetworkType:[self.interactor cardNetworkType]];
    self.transactionViewModel.secureCodeViewModel.placeholder = secureCodePlaceholder;

    NSArray *selectableCountries = [self.interactor getFilteredCountriesBySearchString:nil];
    if (selectableCountries.count > 0) {
        self.transactionViewModel.countryPickerViewModel.placeholder = @"card_holder_country_hint"._jp_localized;
        self.transactionViewModel.pickerCountries = selectableCountries;
        JPCountry *country = selectableCountries.firstObject;
        self.transactionViewModel.countryPickerViewModel.text = country.name;
        self.transactionViewModel.cardholderPhoneCodeViewModel.text = country.dialCode;
    }

    self.transactionViewModel.statePickerViewModel.placeholder = @"card_holder_state_hint"._jp_localized;
    self.transactionViewModel.pickerStates = @[];

    self.transactionViewModel.postalCodeInputViewModel.placeholder = @"post_code_hint"._jp_localized;

    NSString *buttonTitle = [self transactionButtonTitleForType:type];

    if (self.transactionViewModel.mode == JPCardDetailsModeThreeDS2) {
        buttonTitle = @"continue"._jp_localized;
    }

    self.transactionViewModel.addCardButtonViewModel.title = buttonTitle.uppercaseString;
    self.transactionViewModel.addCardButtonViewModel.isEnabled = NO;

    self.transactionViewModel.backButtonViewModel.title = @"back".uppercaseString;
    self.transactionViewModel.backButtonViewModel.isEnabled = YES;

    [self.view applyConfiguredTheme:[self.interactor getConfiguredTheme]];
    [self.view updateViewWithViewModel:self.transactionViewModel shouldUpdateTargets:YES];
}

#pragma mark - Input Handler

- (void)handleInputChange:(NSString *)input
                  forType:(JPInputType)type
                showError:(BOOL)showError {
    switch (type) {
        case JPInputTypeCardNumber:
            [self updateCardNumberViewModelForInput:input showError:showError];
            break;
        case JPInputTypeCardholderEmail:
            [self updateCardholderEmailViewModelForInput:input showError:showError];
            break;
        case JPInputTypeCardholderName:
            [self updateCardholderNameViewModelForInput:input showError:showError];
            break;
        case JPInputTypeCardExpiryDate:
            [self updateExpiryDateViewModelForInput:input showError:showError];
            break;
        case JPInputTypeCardSecureCode:
            [self updateSecureCodeViewModelForInput:input showError:showError];
            break;
        case JPInputTypeCardCountry:
            [self updateCountryViewModelForInput:input showError:showError];
            [self updatePostalCodeViewModelForInput:@"" showError:showError];
            break;
        case JPInputTypeCardholderState:
            [self updateStateViewModelForInput:input showError:showError];
            break;
        case JPInputTypeCardPostalCode:
            [self updatePostalCodeViewModelForInput:input showError:showError];
            break;
        case JPInputTypeCardholderPhone:
            [self updateCardholderPhoneViewModelForInput:input showError:showError];
            break;
        case JPInputTypeCardholderAddressLine1:
        case JPInputTypeCardholderAddressLine2:
        case JPInputTypeCardholderAddressLine3:
            [self updateCardholderAddressLineViewModelForInput:input inputType:type showError:showError];
            break;
        case JPInputTypeCardholderPhoneCode:
            [self updateCardholderPhoneCodeViewModelForInput:input showError:showError];
            break;
        case JPInputTypeCardholderCity:
            [self updateCardholderCityViewModelForInput:input showError:showError];
            break;
    }

    [self updateTransactionButtonModelIfNeeded];
    [self.view updateViewWithViewModel:self.transactionViewModel shouldUpdateTargets:NO];
}

#pragma mark - Transaction Button Tap

- (void)handleTransactionButtonTap {
    JPCardTransactionDetails *details = [self cardTransactionDetailsFromViewModel:self.transactionViewModel];

    __weak typeof(self) weakSelf = self;
    [self.interactor sendTransactionWithDetails:details
                              completionHandler:^(JPResponse *response, JPError *error) {
                                  if (error) {
                                      [weakSelf handleError:error];
                                      return;
                                  }
                                  [weakSelf handleResponse:response];
                              }];
}

- (void)handleContinueButtonTap {
    self.transactionViewModel.mode = JPCardDetailsModeThreeDS2BillingDetails;
    [self.view updateViewWithViewModel:self.transactionViewModel shouldUpdateTargets:YES];
    [self updateTransactionButtonModelIfNeeded];
}

- (void)handleBackButtonTap {
    self.transactionViewModel.mode = JPCardDetailsModeThreeDS2;
    [self updateTransactionButtonModelIfNeeded];
    [self.view updateViewWithViewModel:self.transactionViewModel shouldUpdateTargets:YES];
}

- (void)handleError:(JPError *)error {
    [self.view updateViewWithError:error];

    __weak typeof(self) weakSelf = self;
    [self.router dismissViewControllerWithCompletion:^{
        JPError *judoError = error;

        if (error.code == JudoUserDidCancelError) {
            judoError = JPError.userDidCancelError;
        }

        [weakSelf.interactor completeTransactionWithResponse:nil
                                                       error:judoError];
    }];
}

- (void)handleResponse:(JPResponse *)response {
    if (self.interactor.transactionType == JPTransactionTypeSaveCard) {
        NSString *token = response.cardDetails.cardToken;
        [self.interactor updateKeychainWithCardModel:self.transactionViewModel
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
                                                       error:JPError.userDidCancelError];
    }];
}

- (void)handleAddAddressLineTap {
    [self.view updateViewWithViewModel:self.transactionViewModel shouldUpdateTargets:NO];
}

#pragma mark - Helper methods

- (void)updateViewModelWithCardNumber:(NSString *)cardNumber
                        andExpiryDate:(NSString *)expiryDate {

    [self.interactor resetCardValidationResults];

    [self updateCardNumberViewModelForInput:cardNumber showError:NO];
    [self updateExpiryDateViewModelForInput:expiryDate showError:NO];
    [self updateTransactionButtonModelIfNeeded];

    [self.view updateViewWithViewModel:self.transactionViewModel shouldUpdateTargets:NO];
}

- (NSString *)transactionButtonTitleForType:(JPTransactionType)type {
    switch (type) {
        case JPTransactionTypePayment:
        case JPTransactionTypePreAuth:
            return [self.interactor generatePayButtonTitle];
        case JPTransactionTypeSaveCard:
            return @"save_card"._jp_localized;
        case JPTransactionTypeRegisterCard:
            return @"register_card"._jp_localized;
        case JPTransactionTypeCheckCard:
            return @"check_card"._jp_localized;
        default:
            return nil;
    }
}

- (void)updateTransactionButtonModelIfNeeded {
    NSString *buttonTitle = [self transactionButtonTitleForType:self.transactionViewModel.type];
    if (self.transactionViewModel.mode == JPCardDetailsModeThreeDS2) {
        buttonTitle = @"continue"._jp_localized;
    }

    self.transactionViewModel.addCardButtonViewModel.title = buttonTitle.uppercaseString;

    BOOL isDefaultValid = self.isCardNumberValid && self.isCardholderNameValid && self.isExpiryDateValid && self.isSecureCodeValid;
    switch (self.transactionViewModel.mode) {
        case JPCardDetailsModeSecurityCode:
            self.transactionViewModel.addCardButtonViewModel.isEnabled = self.isSecureCodeValid;
            break;
        case JPCardDetailsModeCardholderName:
            self.transactionViewModel.addCardButtonViewModel.isEnabled = self.isCardholderNameValid;
            break;
        case JPCardDetailsModeSecurityCodeAndCardholderName:
            self.transactionViewModel.addCardButtonViewModel.isEnabled = self.isSecureCodeValid && self.isCardholderNameValid;
            break;
        case JPCardDetailsModeThreeDS2BillingDetails: {
            BOOL is3DS2Valid = self.isEmailValid && self.isCountryNameValid && self.isStateNameValid && self.isAddressLine1Valid && self.isAddressLine2Valid && self.isAddressLine3Valid && self.isPhoneNumberValid && self.isCityNameValid && self.isPostalCodeValid;
            self.transactionViewModel.addCardButtonViewModel.isEnabled = is3DS2Valid;
        } break;
        case JPCardDetailsModeDefault:
        case JPCardDetailsModeThreeDS2:
            self.transactionViewModel.addCardButtonViewModel.isEnabled = isDefaultValid;
            break;
        case JPCardDetailsModeAVS:
            self.transactionViewModel.addCardButtonViewModel.isEnabled = isDefaultValid && self.isPostalCodeValid;
            break;
        default:
            break;
    }
}

- (void)updateCardNumberViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateCardNumberInput:input];
    self.transactionViewModel.cardNumberViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    self.isCardNumberValid = result.isValid;

    [self updateSecureCodePlaceholderForNetworkType:result.cardNetwork];

    if (result.isInputAllowed) {
        self.transactionViewModel.cardNumberViewModel.text = result.formattedInput;
        self.transactionViewModel.cardNumberViewModel.cardNetwork = result.cardNetwork;
    }

    if (result.isValid) {
        [self.view changeFocusToInputType:JPInputTypeCardholderName];
    }
}

- (void)updateCardholderEmailViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateCardholderEmailInput:input];
    self.isEmailValid = result.isValid;
    self.transactionViewModel.cardholderEmailViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    self.transactionViewModel.cardholderEmailViewModel.text = result.formattedInput;
}

- (void)updateCardholderPhoneCodeViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateCardholderPhoneCodeInput:input];
    self.transactionViewModel.cardholderPhoneCodeViewModel.text = result.formattedInput;
    self.isPhoneCodeValid = result.isValid;
}

- (void)updateCardholderCityViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateCity:input];
    self.isCityNameValid = result.isValid;
    NSString *errorMessage = result.isValid ? nil : result.errorMessage;

    self.transactionViewModel.cardholderCityViewModel.errorText = (showError && input.length > 0) ? errorMessage : nil;
    self.transactionViewModel.cardholderCityViewModel.text = result.formattedInput;
}

- (void)updateCardholderPhoneViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateCardholderPhoneInput:input];
    self.transactionViewModel.cardholderPhoneViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    self.isPhoneNumberValid = result.isValid;
    self.transactionViewModel.cardholderPhoneViewModel.text = result.formattedInput;
}

- (void)updateCardholderAddressLineViewModelForInput:(NSString *)input inputType:(JPInputType)inputType showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateAddressLineInput:input];

    switch (inputType) {
        case JPInputTypeCardholderAddressLine1: {
            self.isAddressLine1Valid = result.isValid;
            self.transactionViewModel.cardholderAddressLine1ViewModel.text = input;
            self.transactionViewModel.cardholderAddressLine1ViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
        } break;
        case JPInputTypeCardholderAddressLine2: {
            self.isAddressLine2Valid = result.isValid;
            self.transactionViewModel.cardholderAddressLine2ViewModel.text = input;
            self.transactionViewModel.cardholderAddressLine2ViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
        } break;
        case JPInputTypeCardholderAddressLine3: {
            self.isAddressLine3Valid = result.isValid;
            self.transactionViewModel.cardholderAddressLine3ViewModel.text = input;
            self.transactionViewModel.cardholderAddressLine3ViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
        } break;
        default:
            break;
    }
}

- (void)updateSecureCodePlaceholderForNetworkType:(JPCardNetworkType)cardNetwork {
    if (self.transactionViewModel.cardNumberViewModel.cardNetwork != cardNetwork) {
        self.transactionViewModel.secureCodeViewModel.text = @"";
        self.isSecureCodeValid = NO;
        NSString *placeholder = [JPCardNetwork secureCodePlaceholderForNetworkType:cardNetwork];
        self.transactionViewModel.secureCodeViewModel.placeholder = placeholder;
    }
}

- (void)updateCardholderNameViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateCardholderNameInput:input];
    self.transactionViewModel.cardholderNameViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    self.isCardholderNameValid = result.isValid;

    if (result.isInputAllowed) {
        self.transactionViewModel.cardholderNameViewModel.text = result.formattedInput;
    }
}

- (void)updateExpiryDateViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateExpiryDateInput:input];
    self.transactionViewModel.expiryDateViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    self.isExpiryDateValid = result.isValid;

    if (result.isInputAllowed) {
        self.transactionViewModel.expiryDateViewModel.text = result.formattedInput;
    }

    if (result.isValid && result.formattedInput.length > 4) {
        [self.view changeFocusToInputType:JPInputTypeCardSecureCode];
    }
}

- (void)updateSecureCodeViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateSecureCodeInput:input];
    self.transactionViewModel.secureCodeViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    self.isSecureCodeValid = result.isValid;
    self.transactionViewModel.secureCodeViewModel.text = result.formattedInput;
}

- (void)updateCountryViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPCountry *country = [JPCountry forCountryName:input];
    NSString *postcodeValidationCountryName;
    if ([country.alpha2Code isEqualToString:kAlpha2CodeUSA]) {
        self.transactionViewModel.pickerStates = JPStateList.usStateList.states;
        self.transactionViewModel.statePickerViewModel.placeholder = @"card_holder_state_hint"._jp_localized;
        self.isStateNameValid = NO;
        postcodeValidationCountryName = @"country_usa"._jp_localized;
    } else if ([country.alpha2Code isEqualToString:kAlpha2CodeUK]) {
        postcodeValidationCountryName = @"country_uk"._jp_localized;
        self.isStateNameValid = YES;
    } else if ([country.alpha2Code isEqualToString:kAlpha2CodeCanada]) {
        self.transactionViewModel.pickerStates = JPStateList.caStateList.states;
        self.transactionViewModel.statePickerViewModel.placeholder = @"card_holder_province_hint"._jp_localized;
        self.isStateNameValid = NO;
        postcodeValidationCountryName = @"country_canada"._jp_localized;
    } else {
        postcodeValidationCountryName = @"country_other"._jp_localized;
        self.isStateNameValid = YES;
    }

    JPValidationResult *result = [self.interactor validateCountryInput:postcodeValidationCountryName];
    self.isCountryNameValid = result.isValid;
    self.transactionViewModel.countryPickerViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    self.transactionViewModel.cardholderPhoneCodeViewModel.text = [[JPCountry dialCodeForCountry:input] stringValue];
    self.transactionViewModel.statePickerViewModel.text = @"";
    [self.view updateViewWithViewModel:self.transactionViewModel shouldUpdateTargets:NO];
    if (result.isInputAllowed) {
        self.transactionViewModel.countryPickerViewModel.text = country.name;
    }
}

- (void)updateStateViewModelForInput:(NSString *)input showError:(BOOL)showError {
    NSString *countryCode = [JPCountry forCountryName:self.transactionViewModel.countryPickerViewModel.text].alpha2Code;
    if (!countryCode) {
        return;
    }
    JPState *state = [JPState forStateName:input andCountryCode:countryCode];

    JPValidationResult *result = [self.interactor validateStateInput:input];
    self.isStateNameValid = result.isValid;
    self.transactionViewModel.statePickerViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    [self.view updateViewWithViewModel:self.transactionViewModel shouldUpdateTargets:NO];
    if (result.isInputAllowed) {
        self.transactionViewModel.statePickerViewModel.text = state.name;
    }
}

- (void)updatePostalCodeViewModelForInput:(NSString *)input showError:(BOOL)showError {
    if (!input && self.transactionViewModel.mode == JPCardDetailsModeThreeDS2BillingDetails) {
        self.transactionViewModel.postalCodeInputViewModel.errorText = nil;
        self.isPostalCodeValid = YES;
        self.transactionViewModel.postalCodeInputViewModel.text = nil;
        return;
    }

    JPValidationResult *result = [self.interactor validatePostalCodeInput:input];
    self.transactionViewModel.postalCodeInputViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    self.isPostalCodeValid = result.isValid;
    if (result.isInputAllowed) {
        self.transactionViewModel.postalCodeInputViewModel.text = result.formattedInput;
    }
}

- (JPCardTransactionDetails *)cardTransactionDetailsFromViewModel:(JPTransactionViewModel *)viewModel {
    JPCard *card = [self cardFromViewModel:viewModel];
    JPConfiguration *configuration = self.interactor.configuration;
    JPCardTransactionDetails *details = [[JPCardTransactionDetails alloc] initWithConfiguration:configuration
                                                                                        andCard:card];

    if (viewModel.cardholderEmailViewModel.text.length > 0) {
        details.emailAddress = viewModel.cardholderEmailViewModel.text;
    }

    if (viewModel.cardholderPhoneCodeViewModel.text.length > 0 && viewModel.cardholderPhoneViewModel.text.length > 0) {
        details.phoneCountryCode = viewModel.cardholderPhoneCodeViewModel.text;
        details.mobileNumber = viewModel.cardholderPhoneViewModel.text;
    }

    return details;
}

- (JPCard *)cardFromViewModel:(JPTransactionViewModel *)viewModel {
    JPCard *card = [[JPCard alloc] initWithCardNumber:viewModel.cardNumberViewModel.text
                                       cardholderName:viewModel.cardholderNameViewModel.text
                                           expiryDate:viewModel.expiryDateViewModel.text
                                           secureCode:viewModel.secureCodeViewModel.text];

    card.cardAddress = [self.interactor getConfiguredCardAddress];

    if ([self.interactor isAVSEnabled]) {
        if (!card.cardAddress) {
            card.cardAddress = [JPAddress new];
        }
        card.cardAddress.countryCode = [JPCountry isoCodeForCountry:viewModel.countryPickerViewModel.text];
        card.cardAddress.postCode = viewModel.postalCodeInputViewModel.text;
    }

    if (viewModel.mode == JPCardDetailsModeThreeDS2BillingDetails) {
        JPCountry *country = [JPCountry forCountryName:viewModel.countryPickerViewModel.text];
        NSNumber *countryCode = country ? @([country.numericCode intValue]) : nil;
        NSString *state = country ? [JPState forStateName:viewModel.statePickerViewModel.text andCountryCode:country.alpha2Code].alpha2Code : nil;
        JPAddress *billingAddress = [[JPAddress alloc] initWithAddress1:viewModel.cardholderAddressLine1ViewModel.text
                                                               address2:viewModel.cardholderAddressLine2ViewModel.text
                                                               address3:viewModel.cardholderAddressLine3ViewModel.text
                                                                   town:viewModel.cardholderCityViewModel.text
                                                               postCode:viewModel.postalCodeInputViewModel.text
                                                            countryCode:countryCode
                                                                  state:state];
        card.cardAddress = billingAddress;
    }

    // TODO: Handle Maestro-specific logic
    //  card.startDate = viewModel.startDateViewModel.text;
    //  card.issueNumber = viewModel.issueNumberViewModel.text;

    return card;
}

#pragma mark - Lazy properties

- (JPTransactionViewModel *)transactionViewModel {
    if (!_transactionViewModel) {
        _transactionViewModel = [JPTransactionViewModel new];
        _transactionViewModel.cardNumberViewModel = [JPTransactionNumberInputViewModel new];
        _transactionViewModel.cardholderNameViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderName];
        _transactionViewModel.cardholderEmailViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderEmail];
        _transactionViewModel.cardholderPhoneViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderPhone];
        _transactionViewModel.cardholderCityViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderCity];
        _transactionViewModel.cardholderAddressLine1ViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderAddressLine1];
        _transactionViewModel.cardholderAddressLine2ViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderAddressLine2];
        _transactionViewModel.cardholderAddressLine3ViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderAddressLine3];
        _transactionViewModel.cardholderPhoneCodeViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderPhoneCode];
        _transactionViewModel.expiryDateViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardExpiryDate];
        _transactionViewModel.secureCodeViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardSecureCode];
        _transactionViewModel.countryPickerViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardCountry];
        _transactionViewModel.statePickerViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderState];
        _transactionViewModel.postalCodeInputViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardPostalCode];
        _transactionViewModel.addCardButtonViewModel = [JPTransactionButtonViewModel new];
        _transactionViewModel.backButtonViewModel = [JPTransactionButtonViewModel new];
    }
    return _transactionViewModel;
}

@end
