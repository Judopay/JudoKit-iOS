//
//  JPCardDetailsForm.m
//  JudoKit_iOS
//
//  Copyright (c) 2023 Alternative Payments Ltd
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

#import "JPCardDetailsForm.h"
#import "JPActionBar.h"
#import "JPCardInputField.h"
#import "JPCardNumberField.h"
#import "JPCountry.h"
#import "JPSecurityMessageView.h"
#import "JPTheme.h"
#import "JPTransactionButton.h"
#import "JPTransactionScanCardButton.h"
#import "JPTransactionViewModel.h"
#import "UIStackView+Additions.h"
#import "NSString+Additions.h"

@interface JPCardDetailsForm () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) JPTransactionCardDetailsViewModel *viewModel;

@property (nonatomic, strong) UILabel *headingLabel;
@property (nonatomic, strong) JPCardNumberField *cardNumberTextField;
@property (nonatomic, strong) JPCardInputField *cardHolderNameTextField;
@property (nonatomic, strong) JPCardInputField *expiryDateTextField;
@property (nonatomic, strong) JPCardInputField *cardSecurityCodeTextField;
@property (nonatomic, strong) JPCardInputField *countryTextField;
@property (nonatomic, strong) JPCardInputField *postcodeTextField;
@property (nonatomic, strong) UIPickerView *countryPickerView;
@property (nonatomic, strong) JPSecurityMessageView *securityMessageView;

@end

@implementation JPCardDetailsForm

#pragma mark - Constants

static const float kTightContentSpacing = 8.0F;
static const float kInputFieldHeight = 44.0F;

- (instancetype)initWithFieldsSet:(JPFormFieldsSet)fieldsSet {
    if (self = [super init]) {
        self.fieldsSet = fieldsSet;

        [self setupSubviews];
        [self setupInputFieldsConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.securityMessageView = [JPSecurityMessageView new];
    self.topActionBar.actions = JPActionBarActionTypeCancel | JPActionBarActionTypeScanCard;
    self.bottomActionBar.actions = JPActionBarActionTypeSubmit;
    [self setupHeading];
    [self addArrangedSubview:self.securityMessageView];
    [self setupInputFieldsStackView];
    [self setupInputFieldsConstraints];
}

- (void)setupHeading {
    self.headingLabel = [UILabel new];
    self.headingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.headingLabel.text = @"jp_card_information_title"._jp_localized;
    self.headingLabel.numberOfLines = 0;
}

- (void)setupInputFieldsStackView {
    [self.inputFieldsStackView _jp_removeArrangedSubviews];
    [self.inputFieldsStackView addArrangedSubview:self.headingLabel];

    switch (self.fieldsSet) {
        case JPFormFieldsSetCSC:
            [self.inputFieldsStackView addArrangedSubview:self.cardSecurityCodeTextField];
            break;

        case JPFormFieldsSetCardHolderName:
            [self.inputFieldsStackView addArrangedSubview:self.cardHolderNameTextField];
            break;

        case JPFormFieldsSetCardHolderNameAndCSC:
            [self.inputFieldsStackView _jp_addArrangedSubviews:@[ self.cardHolderNameTextField, self.cardSecurityCodeTextField ]];
            break;

        case JPFormFieldsSetFullCardDetails:
        case JPFormFieldsSetFullCardDetailsAndAVS:
            [self setupFullCardDetailsSubviews];
            break;

        default:
            break;
    }
}

- (void)setFieldsSet:(JPFormFieldsSet)fieldsSet {
    if (_fieldsSet == fieldsSet) {
        return;
    }

    _fieldsSet = fieldsSet;

    [self setupInputFieldsStackView];
    [self setupInputFieldsConstraints];
}

- (void)setupFullCardDetailsSubviews {
    UIStackView *expiryDateAndCSCStackView = [UIStackView _jp_horizontalStackViewWithSpacing:kTightContentSpacing
                                                                                distribution:UIStackViewDistributionFillEqually
                                                                         andArrangedSubviews:@[ self.expiryDateTextField, self.cardSecurityCodeTextField ]];
    expiryDateAndCSCStackView.accessibilityIdentifier = @"Expiry Date and Security Code Fields";

    NSMutableArray *fields = [NSMutableArray arrayWithArray:@[
        self.cardNumberTextField,
        self.cardHolderNameTextField,
        expiryDateAndCSCStackView
    ]];

    if (self.fieldsSet == JPFormFieldsSetFullCardDetailsAndAVS) {
        UIStackView *avsStackView = [UIStackView _jp_horizontalStackViewWithSpacing:kTightContentSpacing
                                                                       distribution:UIStackViewDistributionFillEqually
                                                                andArrangedSubviews:@[ self.countryTextField, self.postcodeTextField ]];
        avsStackView.accessibilityIdentifier = @"AVS fields";
        [fields addObject:avsStackView];
    }

    [self.inputFieldsStackView _jp_addArrangedSubviews:fields];
}

- (void)setupInputFieldsConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.cardNumberTextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.cardHolderNameTextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.expiryDateTextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.cardSecurityCodeTextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.countryTextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.postcodeTextField.heightAnchor constraintEqualToConstant:kInputFieldHeight]
    ]];
}

- (void)applyTheme:(JPTheme *)theme {
    [super applyTheme:theme];

    [self.securityMessageView applyTheme:theme];

    self.headingLabel.font = theme.headline;
    self.headingLabel.textColor = theme.jpDarkGrayColor;

    [self.cardNumberTextField applyTheme:theme];
    [self.cardHolderNameTextField applyTheme:theme];
    [self.expiryDateTextField applyTheme:theme];
    [self.cardSecurityCodeTextField applyTheme:theme];
    [self.countryTextField applyTheme:theme];
    [self.postcodeTextField applyTheme:theme];
}

- (void)configureWithViewModel:(JPTransactionCardDetailsViewModel *)viewModel {
    self.viewModel = viewModel;

    [self.topActionBar.cancelButton configureWithViewModel:viewModel.cancelButtonViewModel];
    [self.topActionBar.scanCardButton configureWithViewModel:viewModel.scanCardButtonViewModel];

    [self.bottomActionBar.submitButton configureWithViewModel:viewModel.submitButtonViewModel];

    [self.cardNumberTextField configureWithViewModel:viewModel.cardNumberViewModel];
    [self.cardHolderNameTextField configureWithViewModel:viewModel.cardholderNameViewModel];
    [self.expiryDateTextField configureWithViewModel:viewModel.expiryDateViewModel];
    [self.cardSecurityCodeTextField configureWithViewModel:viewModel.securityCodeViewModel];
    [self.countryTextField configureWithViewModel:viewModel.countryViewModel];
    [self.postcodeTextField configureWithViewModel:viewModel.postalCodeViewModel];
    [self.securityMessageView configureWithViewModel:viewModel.securityMessageViewModel];

    [self.countryPickerView reloadAllComponents];
}

- (void)moveFocusToInput:(JPInputType)type {
    switch (type) {
        case JPInputTypeCardholderName:
            [self.cardHolderNameTextField becomeFirstResponder];
            break;

        case JPInputTypeCardSecureCode:
            [self.cardSecurityCodeTextField becomeFirstResponder];
            break;
        default:
            break;
    }
}

- (void)setInputFieldDelegate:(id<JPInputFieldDelegate>)delegate {
    [super setInputFieldDelegate:delegate];

    self.cardNumberTextField.delegate = delegate;
    self.cardHolderNameTextField.delegate = delegate;
    self.expiryDateTextField.delegate = delegate;
    self.cardSecurityCodeTextField.delegate = delegate;
    self.countryTextField.delegate = delegate;
    self.postcodeTextField.delegate = delegate;
}

- (JPCardNumberField *)cardNumberTextField {
    if (!_cardNumberTextField) {
        _cardNumberTextField = [JPCardNumberField new];
        _cardNumberTextField.accessibilityIdentifier = @"Card Number Field";
        _cardNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _cardNumberTextField.textContentType = UITextContentTypeCreditCardNumber;
        _cardNumberTextField.delegate = self.inputFieldDelegate;
    }
    return _cardNumberTextField;
}

- (JPCardInputField *)cardHolderNameTextField {
    if (!_cardHolderNameTextField) {
        _cardHolderNameTextField = [JPCardInputField new];
        _cardHolderNameTextField.accessibilityIdentifier = @"Cardholder Name Field";
        _cardHolderNameTextField.keyboardType = UIKeyboardTypeDefault;
        _cardHolderNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;

// TODO: Remove after April 2024
#if defined(__IPHONE_17_0)
        if (@available(iOS 17.0, *)) {
            _cardHolderNameTextField.textContentType = UITextContentTypeCreditCardName;
        }
#endif

        _cardHolderNameTextField.delegate = self.inputFieldDelegate;
    }
    return _cardHolderNameTextField;
}

- (JPCardInputField *)expiryDateTextField {
    if (!_expiryDateTextField) {
        _expiryDateTextField = [JPCardInputField new];
        _expiryDateTextField.accessibilityIdentifier = @"Expiry Date Field";
        _expiryDateTextField.keyboardType = UIKeyboardTypeNumberPad;

// TODO: Remove after April 2024
#if defined(__IPHONE_17_0)
        if (@available(iOS 17.0, *)) {
            _expiryDateTextField.textContentType = UITextContentTypeCreditCardExpiration;
        }
#endif

        _expiryDateTextField.delegate = self.inputFieldDelegate;
    }
    return _expiryDateTextField;
}

- (JPCardInputField *)cardSecurityCodeTextField {
    if (!_cardSecurityCodeTextField) {
        _cardSecurityCodeTextField = [JPCardInputField new];
        _cardSecurityCodeTextField.accessibilityIdentifier = @"Security Code Field";
        _cardSecurityCodeTextField.keyboardType = UIKeyboardTypeNumberPad;

// TODO: Remove after April 2024
#if defined(__IPHONE_17_0)
        if (@available(iOS 17.0, *)) {
            _cardSecurityCodeTextField.textContentType = UITextContentTypeCreditCardSecurityCode;
        }
#endif

        _cardSecurityCodeTextField.delegate = self.inputFieldDelegate;
    }
    return _cardSecurityCodeTextField;
}

- (JPCardInputField *)countryTextField {
    if (!_countryTextField) {
        _countryTextField = [JPCardInputField new];
        _countryTextField.inputView = self.countryPickerView;
        _countryTextField.accessibilityIdentifier = @"Country Field";
        _countryTextField.textContentType = UITextContentTypeCountryName;
        _countryTextField.delegate = self.inputFieldDelegate;
    }
    return _countryTextField;
}

- (JPCardInputField *)postcodeTextField {
    if (!_postcodeTextField) {
        _postcodeTextField = [JPCardInputField new];
        _postcodeTextField.keyboardType = UIKeyboardTypeDefault;
        _postcodeTextField.accessibilityIdentifier = @"Post Code Field";
        _postcodeTextField.textContentType = UITextContentTypePostalCode;
        _postcodeTextField.delegate = self.inputFieldDelegate;
    }
    return _postcodeTextField;
}

- (UIPickerView *)countryPickerView {
    if (!_countryPickerView) {
        _countryPickerView = [UIPickerView new];
        _countryPickerView.accessibilityIdentifier = @"Country Picker";
        _countryPickerView.delegate = self;
        _countryPickerView.dataSource = self;
    }
    return _countryPickerView;
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.countryPickerView) {
        return self.viewModel.countryViewModel.options.count;
    }

    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.countryPickerView) {
        JPCountry *country = self.viewModel.countryViewModel.options[row];
        [self.inputFieldDelegate inputField:self.countryTextField didEndEditing:country.name];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.countryPickerView) {
        return self.viewModel.countryViewModel.options[row].name;
    }

    return @"";
}

@end
