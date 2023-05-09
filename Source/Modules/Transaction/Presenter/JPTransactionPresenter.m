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
#import "JPPresentationMode.h"
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
@property (nonatomic, strong) JPTransactionViewModel *viewModel;
@end

@implementation JPTransactionPresenterImpl

#pragma mark - Protocol methods

- (void)onViewDidLoad {
    [self prepareInitialViewModel];
    
    [self.view applyConfiguredTheme:[self.interactor getConfiguredTheme]];
    [self.view updateViewWithViewModel:self.viewModel];
    
    if (self.interactor.getConfiguredCardTransactionDetails && self.viewModel.mode == JPPresentationModeNone) {
        [self handleSubmitButtonTap];
    }
}

- (void)prepareInitialViewModel {
    JPTransactionType type = self.interactor.transactionType;
    JPPresentationMode mode = self.interactor.presentationMode;
    
    self.viewModel.type = type;
    self.viewModel.mode = mode;

    NSArray<JPCountry *> *countries = [self.interactor getFilteredCountriesBySearchString:nil];
    JPCountry *currentSelectedCountry = countries.firstObject;

    NSString *defaultSubmitButtonTitle = [self transactionButtonTitleForType:type];;
    NSString *cardDetailsSubmitButtonTitle = defaultSubmitButtonTitle;
    
    if (self.viewModel.shouldDisplayBillingInformationSection) {
        cardDetailsSubmitButtonTitle = @"continue"._jp_localized;;
    }

    // Card details screen
    JPTransactionCardDetailsViewModel *cardDetailsViewModel = self.viewModel.cardDetailsViewModel;
    NSString *securityCodePlaceholder = [JPCardNetwork secureCodePlaceholderForNetworkType:self.interactor.cardNetworkType];

    cardDetailsViewModel.cancelButtonViewModel.title = @"cancel"._jp_localized.uppercaseString;
    cardDetailsViewModel.cancelButtonViewModel.isEnabled = YES;
    
    cardDetailsViewModel.scanCardButtonViewModel.isEnabled = YES;

    if (@available(iOS 13.0, *)) {
        BOOL isHidden = mode == JPPresentationModeCardInfo || mode == JPPresentationModeCardInfoAndAVS || mode == JPPresentationModeCardAndBillingInfo;
        cardDetailsViewModel.scanCardButtonViewModel.isHidden = !isHidden;
    } else {
        cardDetailsViewModel.scanCardButtonViewModel.isHidden = YES;
    }

    cardDetailsViewModel.cardNumberViewModel.placeholder = @"card_number_hint"._jp_localized;
    cardDetailsViewModel.cardholderNameViewModel.placeholder = @"card_holder_hint"._jp_localized;
    cardDetailsViewModel.expiryDateViewModel.placeholder = @"expiry_date"._jp_localized;
    cardDetailsViewModel.securityCodeViewModel.placeholder = securityCodePlaceholder;
    
    cardDetailsViewModel.countryViewModel.placeholder = @"card_holder_country_hint"._jp_localized;
    cardDetailsViewModel.countryViewModel.options = countries;
    cardDetailsViewModel.countryViewModel.text = currentSelectedCountry.name;

    cardDetailsViewModel.postalCodeViewModel.placeholder = @"post_code_hint"._jp_localized;
    
    cardDetailsViewModel.submitButtonViewModel.title = cardDetailsSubmitButtonTitle.uppercaseString;
    cardDetailsViewModel.submitButtonViewModel.isEnabled = NO;

    // Billing information screen
    JPTransactionBillingInformationViewModel *billingInformationViewModel = self.viewModel.billingInformationViewModel;
    
    billingInformationViewModel.cancelButtonViewModel.title = @"cancel"._jp_localized.uppercaseString;
    billingInformationViewModel.cancelButtonViewModel.isEnabled = YES;

    billingInformationViewModel.emailViewModel.placeholder = @"card_holder_email_hint"._jp_localized;

    billingInformationViewModel.countryViewModel.placeholder = @"card_holder_country_hint"._jp_localized;
    billingInformationViewModel.countryViewModel.options = countries;
    billingInformationViewModel.countryViewModel.text = currentSelectedCountry.name;

    billingInformationViewModel.stateViewModel.placeholder = @"card_holder_state_hint"._jp_localized;
    billingInformationViewModel.stateViewModel.options = @[];
    
    billingInformationViewModel.phoneCodeViewModel.text = currentSelectedCountry.dialCode;
    billingInformationViewModel.phoneViewModel.placeholder = @"card_holder_phone_hint"._jp_localized;
    billingInformationViewModel.addressLine1ViewModel.placeholder = [NSString stringWithFormat:@"card_holder_adress_line_hint"._jp_localized, @(1)];
    
    billingInformationViewModel.addressLine2ViewModel.placeholder = [NSString stringWithFormat:@"card_holder_adress_line_hint"._jp_localized, @(2)];
    billingInformationViewModel.addressLine2ViewModel.isValid = YES;
    
    billingInformationViewModel.addressLine3ViewModel.placeholder = [NSString stringWithFormat:@"card_holder_adress_line_hint"._jp_localized, @(3)];
    billingInformationViewModel.addressLine3ViewModel.isValid = YES;
    
    billingInformationViewModel.cityViewModel.placeholder = @"card_holder_city_hint"._jp_localized;
    billingInformationViewModel.postalCodeViewModel.placeholder = @"post_code_hint"._jp_localized;

    billingInformationViewModel.backButtonViewModel.title = @"back"._jp_localized.uppercaseString;
    billingInformationViewModel.backButtonViewModel.isEnabled = YES;
    billingInformationViewModel.backButtonViewModel.isHidden = mode == JPPresentationModeBillingInfo;

    billingInformationViewModel.submitButtonViewModel.title = defaultSubmitButtonTitle.uppercaseString;
    billingInformationViewModel.submitButtonViewModel.isEnabled = NO;
    
    self.viewModel.isLoading = NO;
}

#pragma mark - Input Handler

- (void)handleInputChange:(NSString *)input forType:(JPInputType)type showError:(BOOL)showError {

    BOOL shouldMoveFocusToCardholderName = NO;
    BOOL shouldMoveFocusToCardSecureCode = NO;
    
    switch (type) {
        case JPInputTypeCardNumber:
            shouldMoveFocusToCardholderName = [self updateCardNumberViewModelForInput:input showError:showError];
            break;
        case JPInputTypeCardholderName:
            [self updateCardholderNameViewModelForInput:input showError:showError];
            break;
        case JPInputTypeCardExpiryDate:
            shouldMoveFocusToCardSecureCode = [self updateExpiryDateViewModelForInput:input showError:showError];
            break;
        case JPInputTypeCardSecureCode:
            [self updateSecureCodeViewModelForInput:input showError:showError updateWithFormattedInput:YES];
            break;
        case JPInputTypeCardAVSCountry:
            [self updateCountryViewModelForInput:input showError:showError];
            break;
        case JPInputTypeCardAVSPostalCode:
            [self updatePostalCodeViewModelForInput:input showError:showError];
            break;

        case JPInputTypeBillingEmail:
            [self updateBillingEmailViewModelForInput:input showError:showError];
            break;
        case JPInputTypeBillingCountry:
            [self updateBillingCountryViewModelForInput:input showError:showError];
            break;
        case JPInputTypeBillingState:
            [self updateBillingStateViewModelForInput:input showError:showError];
            break;
        case JPInputTypeBillingPhoneCode:
            [self updateBillingPhoneCodeViewModelForInput:input showError:showError];
            break;
        case JPInputTypeBillingPhone:
            [self updateBillingPhoneViewModelForInput:input showError:showError];
            break;
        case JPInputTypeBillingAddressLine1:
        case JPInputTypeBillingAddressLine2:
        case JPInputTypeBillingAddressLine3:
            [self updateBillingAddressLineViewModelForInput:input inputType:type showError:showError];
            break;
        case JPInputTypeBillingCity:
            [self updateBillingCityViewModelForInput:input showError:showError];
            break;
        case JPInputTypeBillingPostalCode:
            [self updateBillingPostalCodeViewModelForInput:input showError:showError];
            break;
    }

    [self updateSubmitButtonViewModel];
    [self.view updateViewWithViewModel:self.viewModel];
    
    if (shouldMoveFocusToCardholderName) {
        [self.view moveFocusToInput:JPInputTypeCardholderName];
    }

    if (shouldMoveFocusToCardSecureCode) {
        [self.view moveFocusToInput:JPInputTypeCardSecureCode];
    }
}

#pragma mark - Transaction Button Tap

- (void)handleSubmitButtonTap {
    
    self.viewModel.isLoading = YES;
    [self.view updateViewWithViewModel:self.viewModel];

    __weak typeof(self) weakSelf = self;
    JPCompletionBlock completion = ^(JPResponse *response, JPError *error) {
        if (error) {
            [weakSelf handleError:error];
            return;
        }
        [weakSelf handleResponse:response];
    };

    if (self.interactor.getConfiguredCardTransactionDetails) {
        JPCardTransactionDetails *details = self.interactor.getConfiguredCardTransactionDetails;
        [self enrichDetails:details withViewModel:self.viewModel];
        [self.interactor sendTokenTransactionWithDetails:details completionHandler:completion];
    } else {
        JPCardTransactionDetails *details = [self cardTransactionDetailsFromViewModel:self.viewModel];
        [self.interactor sendTransactionWithDetails:details completionHandler:completion];
    }
}

- (void)enrichDetails:(JPCardTransactionDetails *)details withViewModel:(JPTransactionViewModel *)viewModel {
    JPTransactionCardDetailsViewModel *cardDetailsViewModel = viewModel.cardDetailsViewModel;
    JPTransactionInputFieldViewModel *cardholderNameViewModel = cardDetailsViewModel.cardholderNameViewModel;
    JPTransactionInputFieldViewModel *securityCodeViewModel = cardDetailsViewModel.securityCodeViewModel;
    
    switch (self.interactor.presentationMode) {
        case JPPresentationModeSecurityCode:
        case JPPresentationModeSecurityCodeAndBillingInfo:
            details.securityCode = securityCodeViewModel.text;
            break;

        case JPPresentationModeCardholderName:
        case JPPresentationModeCardholderNameAndBillingInfo:
            details.cardholderName = cardholderNameViewModel.text;
            break;

        case JPPresentationModeSecurityCodeAndCardholderName:
        case JPPresentationModeSecurityCodeAndCardholderNameAndBillingInfo:
            details.cardholderName = cardholderNameViewModel.text;
            details.securityCode = securityCodeViewModel.text;
            break;
            
        default:
            break;
    }
    
    if (viewModel.shouldDisplayBillingInformationSection) {
        details.billingAddress = [self billingAddressFromViewModel:viewModel];
        [self enrichWithExtraBillingInformationDetails:details withViewModel:viewModel];
    }
}

- (void)handleError:(JPError *)error {
    self.viewModel.isLoading = NO;
    [self.view updateViewWithViewModel:self.viewModel];
    [self.view updateViewWithError:error];

    __weak typeof(self) weakSelf = self;
    [self.router dismissViewControllerWithCompletion:^{
        JPError *judoError = error;

        if (error.code == JudoUserDidCancelError) {
            judoError = JPError.userDidCancelError;
        }

        [weakSelf.interactor completeTransactionWithResponse:nil error:judoError];
    }];
}

- (void)handleResponse:(JPResponse *)response {
    __weak typeof(self) weakSelf = self;
    [self.router dismissViewControllerWithCompletion:^{
        [weakSelf.interactor completeTransactionWithResponse:response error:nil];
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
        [weakSelf.interactor completeTransactionWithResponse:nil error:JPError.userDidCancelError];
    }];
}

#pragma mark - Helper methods

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

- (void)updateViewModelWithCardNumber:(NSString *)cardNumber andExpiryDate:(NSString *)expiryDate {
    [self.interactor resetCardValidationResults];

    [self updateCardNumberViewModelForInput:cardNumber showError:NO];
    [self updateExpiryDateViewModelForInput:expiryDate showError:NO];
    
    [self.view updateViewWithViewModel:self.viewModel];
    
    [self updateSubmitButtonViewModel];
}

- (BOOL)updateCardNumberViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateCardNumberInput:input];
    JPTransactionNumberInputViewModel *cardNumberViewModel = self.viewModel.cardDetailsViewModel.cardNumberViewModel;
    
    cardNumberViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    cardNumberViewModel.isValid = result.isValid;

    [self updateSecurityCodePlaceholderForNetworkType:result.cardNetwork];

    if (result.isInputAllowed) {
        cardNumberViewModel.text = result.formattedInput;
        cardNumberViewModel.cardNetwork = result.cardNetwork;
    }

    return result.isValid;
}

- (void)updateSecurityCodePlaceholderForNetworkType:(JPCardNetworkType)cardNetwork {
    JPTransactionNumberInputViewModel *cardNumberViewModel = self.viewModel.cardDetailsViewModel.cardNumberViewModel;
    JPTransactionInputFieldViewModel *securityCodeViewModel = self.viewModel.cardDetailsViewModel.securityCodeViewModel;

    if (cardNumberViewModel.cardNetwork != cardNetwork) {
        [self updateSecureCodeViewModelForInput:@"" showError:YES updateWithFormattedInput:NO];
        securityCodeViewModel.placeholder = [JPCardNetwork secureCodePlaceholderForNetworkType:cardNetwork];
    }
}

- (void)updateSecureCodeViewModelForInput:(NSString *)input showError:(BOOL)showError updateWithFormattedInput:(BOOL)updateWithFormattedInput {
    JPValidationResult *result = [self.interactor validateSecureCodeInput:input trimIfTooLong:updateWithFormattedInput];
    JPTransactionInputFieldViewModel *securityCodeViewModel = self.viewModel.cardDetailsViewModel.securityCodeViewModel;
    
    securityCodeViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    securityCodeViewModel.isValid = result.isValid;
    
    if (updateWithFormattedInput) {
        securityCodeViewModel.text = result.formattedInput;
    }
}

- (void)updateCardholderNameViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateCardholderNameInput:input];
    JPTransactionInputFieldViewModel *cardholderNameViewModel = self.viewModel.cardDetailsViewModel.cardholderNameViewModel;
    
    cardholderNameViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    cardholderNameViewModel.isValid = result.isValid;

    if (result.isInputAllowed) {
        cardholderNameViewModel.text = result.formattedInput;
    }
}

- (BOOL)updateExpiryDateViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateExpiryDateInput:input];
    JPTransactionInputFieldViewModel *expiryDateViewModel = self.viewModel.cardDetailsViewModel.expiryDateViewModel;
    
    expiryDateViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    expiryDateViewModel.isValid = result.isValid;

    if (result.isInputAllowed) {
        expiryDateViewModel.text = result.formattedInput;
    }

    return result.isValid && result.formattedInput.length > 4;
}

- (void)updateCountryViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPCountry *country = [JPCountry forCountryName:input];
    JPTransactionOptionSelectionInputViewModel *countryViewModel = self.viewModel.cardDetailsViewModel.countryViewModel;

    JPValidationResult *result = [self.interactor validateCountryInput:input];
    
    countryViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    countryViewModel.isValid = result.isValid;
    
    if (result.isInputAllowed) {
        countryViewModel.text = country.name;
    }
    
    [self updatePostalCodeViewModelForInput:@"" showError:showError];
}

- (void)updatePostalCodeViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validatePostalCodeInput:input];
    JPTransactionInputFieldViewModel *postalCodeViewModel = self.viewModel.cardDetailsViewModel.postalCodeViewModel;
    
    postalCodeViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    postalCodeViewModel.isValid = result.isValid;
    
    if (result.isInputAllowed) {
        postalCodeViewModel.text = result.formattedInput;
    }
}

- (void)updateSubmitButtonViewModel {
    // Card details section
    JPTransactionCardDetailsViewModel *cardDetailsViewModel = self.viewModel.cardDetailsViewModel;
    cardDetailsViewModel.submitButtonViewModel.isEnabled = self.viewModel.isCardDetailsValid;
    
    // Billing info section
    JPTransactionBillingInformationViewModel *billingInformationViewModel = self.viewModel.billingInformationViewModel;
    billingInformationViewModel.submitButtonViewModel.isEnabled = self.viewModel.isBillingInformationValid;
}

#pragma mark - Billing Information feilds

- (void)updateBillingEmailViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateBillingEmailInput:input];
    JPTransactionInputFieldViewModel *emailViewModel = self.viewModel.billingInformationViewModel.emailViewModel;
    
    emailViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    emailViewModel.isValid = result.isValid;
    emailViewModel.text = result.formattedInput;
}

- (void)updateBillingPhoneCodeViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateBillingPhoneCodeInput:input];
    JPTransactionInputFieldViewModel *phoneCodeViewModel = self.viewModel.billingInformationViewModel.phoneCodeViewModel;

    phoneCodeViewModel.isValid = result.isValid;
    phoneCodeViewModel.text = result.formattedInput;
}

- (void)updateBillingPhoneViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateBillingPhoneInput:input];
    JPTransactionInputFieldViewModel *phoneViewModel = self.viewModel.billingInformationViewModel.phoneViewModel;
    
    phoneViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    phoneViewModel.isValid = result.isValid;
    phoneViewModel.text = result.formattedInput;
}

- (void)updateBillingAddressLineViewModelForInput:(NSString *)input inputType:(JPInputType)inputType showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateBillingAddressLineInput:input];
    JPTransactionBillingInformationViewModel *billingInformationViewModel = self.viewModel.billingInformationViewModel;
    JPTransactionInputFieldViewModel *addressViewModel;
    
    switch (inputType) {
        case JPInputTypeBillingAddressLine1:
            addressViewModel = billingInformationViewModel.addressLine1ViewModel;
            break;
        case JPInputTypeBillingAddressLine2:
            addressViewModel = billingInformationViewModel.addressLine2ViewModel;
            break;
        case JPInputTypeBillingAddressLine3:
            addressViewModel = billingInformationViewModel.addressLine3ViewModel;
            break;
        default:
            break;
    }
    
    addressViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    addressViewModel.isValid = result.isValid;
    addressViewModel.text = input;
}

- (void)updateBillingCityViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateBillingCity:input];
    JPTransactionInputFieldViewModel *cityViewModel = self.viewModel.billingInformationViewModel.cityViewModel;
    
    cityViewModel.isValid = result.isValid;
    NSString *errorMessage = result.isValid ? nil : result.errorMessage;
    cityViewModel.errorText = (showError && input.length > 0) ? errorMessage : nil;
    cityViewModel.text = result.formattedInput;
}

- (void)updateBillingCountryViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPCountry *country = [JPCountry forCountryName:input];
    JPTransactionOptionSelectionInputViewModel *countryViewModel = self.viewModel.billingInformationViewModel.countryViewModel;
    JPTransactionOptionSelectionInputViewModel *stateViewModel = self.viewModel.billingInformationViewModel.stateViewModel;

    JPValidationResult *result = [self.interactor validateBillingCountryInput:input];

    countryViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    countryViewModel.isValid = result.isValid;
    
    if (result.isInputAllowed) {
        countryViewModel.text = country.name;
    }
    
    [self updateBillingPhoneCodeViewModelForInput:[JPCountry dialCodeForCountry:input].stringValue showError:showError];
    [self updateBillingPostalCodeViewModelForInput:@"" showError:showError];
    [self updateBillingStateViewModelForInput:@"" showError:showError];
    
    if (country.isUSA) {
        stateViewModel.options = JPStateList.usStateList.states;
        stateViewModel.placeholder = @"card_holder_state_hint"._jp_localized;
        stateViewModel.isValid = NO;
    } else if (country.isCanada) {
        stateViewModel.options = JPStateList.caStateList.states;
        stateViewModel.placeholder = @"card_holder_province_hint"._jp_localized;
        stateViewModel.isValid = NO;
    } else {
        stateViewModel.isValid = YES;
    }
}

- (void)updateBillingStateViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPTransactionOptionSelectionInputViewModel *countryViewModel = self.viewModel.billingInformationViewModel.countryViewModel;
    JPTransactionOptionSelectionInputViewModel *stateViewModel = self.viewModel.billingInformationViewModel.stateViewModel;
    NSString *countryCode = [JPCountry forCountryName:countryViewModel.text].alpha2Code;
    
    if (!countryCode) {
        return;
    }
    
    JPState *state = [JPState forStateName:input andCountryCode:countryCode];
    JPValidationResult *result = [self.interactor validateBillingStateInput:input];
    
    stateViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    stateViewModel.isValid = result.isValid;
    
    if (result.isInputAllowed) {
        stateViewModel.text = state.name;
    }
}

- (void)updateBillingPostalCodeViewModelForInput:(NSString *)input showError:(BOOL)showError {
    JPValidationResult *result = [self.interactor validateBillingPostalCodeInput:input];
    JPTransactionInputFieldViewModel *postalCodeViewModel = self.viewModel.billingInformationViewModel.postalCodeViewModel;
    
    postalCodeViewModel.errorText = (showError && input.length > 0) ? result.errorMessage : nil;
    postalCodeViewModel.isValid = result.isValid;
    
    if (result.isInputAllowed) {
        postalCodeViewModel.text = result.formattedInput;
    }
}

- (void)enrichWithExtraBillingInformationDetails:(JPCardTransactionDetails *)details withViewModel:(JPTransactionViewModel *)viewModel {
    JPTransactionBillingInformationViewModel *billingInformationViewModel = viewModel.billingInformationViewModel;
    
    JPTransactionInputFieldViewModel *emailViewModel = billingInformationViewModel.emailViewModel;
    JPTransactionInputFieldViewModel *phoneCodeViewModel = billingInformationViewModel.phoneCodeViewModel;
    JPTransactionInputFieldViewModel *phoneViewModel = billingInformationViewModel.phoneViewModel;

    if (emailViewModel.text.length > 0) {
        details.emailAddress = emailViewModel.text;
    }

    if (phoneCodeViewModel.text.length > 0 && phoneViewModel.text.length > 0) {
        details.phoneCountryCode = phoneCodeViewModel.text;
        details.mobileNumber = phoneViewModel.text;
    }
}

- (JPCardTransactionDetails *)cardTransactionDetailsFromViewModel:(JPTransactionViewModel *)viewModel {
    JPCard *card = [self cardFromViewModel:viewModel];
    JPConfiguration *configuration = self.interactor.configuration;
    JPCardTransactionDetails *details = [[JPCardTransactionDetails alloc] initWithConfiguration:configuration andCard:card];
    
    [self enrichWithExtraBillingInformationDetails:details withViewModel:viewModel];
    
    return details;
}

- (JPCard *)cardFromViewModel:(JPTransactionViewModel *)viewModel {
    JPTransactionCardDetailsViewModel *cardDetailsViewModel = viewModel.cardDetailsViewModel;

    JPCard *card = [[JPCard alloc] initWithCardNumber:cardDetailsViewModel.cardNumberViewModel.text
                                       cardholderName:cardDetailsViewModel.cardholderNameViewModel.text
                                           expiryDate:cardDetailsViewModel.expiryDateViewModel.text
                                           secureCode:cardDetailsViewModel.securityCodeViewModel.text];

    card.cardAddress = [self.interactor getConfiguredCardAddress];

    if (viewModel.shouldDisplayBillingInformationSection) {
        card.cardAddress = [self billingAddressFromViewModel:viewModel];
    } else if (viewModel.mode == JPPresentationModeCardInfoAndAVS) {
        if (!card.cardAddress) {
            card.cardAddress = [JPAddress new];
        }
        card.cardAddress.countryCode = [JPCountry isoCodeForCountry:cardDetailsViewModel.countryViewModel.text];
        card.cardAddress.postCode = cardDetailsViewModel.postalCodeViewModel.text;
    }

    // TODO: Handle Maestro-specific logic
    //  card.startDate = viewModel.startDateViewModel.text;
    //  card.issueNumber = viewModel.issueNumberViewModel.text;

    return card;
}

- (JPAddress *)billingAddressFromViewModel:(JPTransactionViewModel *)viewModel {
    JPTransactionBillingInformationViewModel *billingInformationViewModel = viewModel.billingInformationViewModel;
    JPTransactionOptionSelectionInputViewModel *countryViewModel = billingInformationViewModel.countryViewModel;
    JPTransactionOptionSelectionInputViewModel *stateViewModel = billingInformationViewModel.stateViewModel;
    JPTransactionInputFieldViewModel *addressLine1ViewModel = billingInformationViewModel.addressLine1ViewModel;
    JPTransactionInputFieldViewModel *addressLine2ViewModel = billingInformationViewModel.addressLine2ViewModel;
    JPTransactionInputFieldViewModel *addressLine3ViewModel = billingInformationViewModel.addressLine3ViewModel;
    JPTransactionInputFieldViewModel *cityViewModel = billingInformationViewModel.cityViewModel;
    JPTransactionInputFieldViewModel *postalCodeViewModel = billingInformationViewModel.postalCodeViewModel;

    JPCountry *country = [JPCountry forCountryName:countryViewModel.text];
    NSNumber *countryCode = country ? @(country.numericCode.intValue) : nil;
    
    NSString *state = nil;
    
    if (country.hasStates) {
        state = [JPState forStateName:stateViewModel.text andCountryCode:country.alpha2Code].alpha2Code;
    }
    
    return [[JPAddress alloc] initWithAddress1:addressLine1ViewModel.text
                                      address2:addressLine2ViewModel.text
                                      address3:addressLine3ViewModel.text
                                          town:cityViewModel.text
                                      postCode:postalCodeViewModel.text
                                   countryCode:countryCode
                                         state:state];
}
   
#pragma mark - Lazy properties

- (JPTransactionViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [JPTransactionViewModel new];
    }
    return _viewModel;
}

@end
