//
//  JPBillingInformationForm.m
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

#import "JPBillingInformationForm.h"
#import "JPActionBar.h"
#import "JPActionBarDelegate.h"
#import "JPAdministrativeDivision.h"
#import "JPCardInputField.h"
#import "JPCountry.h"
#import "JPPhoneCodeInputField.h"
#import "JPTheme.h"
#import "JPTransactionButton.h"
#import "JPTransactionViewModel.h"
#import "NSString+Additions.h"
#import "UIStackView+Additions.h"

@interface JPBillingInformationForm () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UILabel *headingLabel;
@property (nonatomic, strong) JPCardInputField *emailTextField;
@property (nonatomic, strong) JPCardInputField *countryTextField;
@property (nonatomic, strong) UIPickerView *countryPickerView;
@property (nonatomic, strong) JPCardInputField *administrativeDivisionTextField;
@property (nonatomic, strong) UIPickerView *administrativeDivisionPickerView;
@property (nonatomic, strong) JPPhoneCodeInputField *phoneCodeTextField;
@property (nonatomic, strong) JPCardInputField *phoneTextField;
@property (nonatomic, strong) JPCardInputField *line1TextField;
@property (nonatomic, strong) JPCardInputField *line2TextField;
@property (nonatomic, strong) JPCardInputField *line3TextField;
@property (nonatomic, strong) JPTransactionButton *addAddressLineButton;
@property (nonatomic, strong) JPCardInputField *cityTextField;
@property (nonatomic, strong) JPCardInputField *postcodeTextField;

@property (nonatomic, strong) JPTransactionBillingInformationViewModel *viewModel;

@end

@implementation JPBillingInformationForm

#pragma mark - Constants

static const float kSeparatorContentSpacing = 8.0F;
static const float kButtonAddAddressLineMinHeight = 56.0F;
static const float kButtonContentPadding = 16.0F;
static const float kPhoneCodeWidth = 45.0F;

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.topActionBar.actions = JPActionBarActionTypeCancel;
    self.bottomActionBar.actions = JPActionBarActionTypeNavigateBack | JPActionBarActionTypeSubmit;

    self.headingLabel = [UILabel new];
    self.headingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.headingLabel.text = @"jp_billing_details_title"._jp_localized;
    self.headingLabel.numberOfLines = 0;

    self.emailTextField = [JPCardInputField new];
    self.emailTextField.accessibilityIdentifier = @"Cardholder Email Field";
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailTextField.textContentType = UITextContentTypeEmailAddress;

    self.countryPickerView = [UIPickerView new];
    self.countryPickerView.delegate = self;
    self.countryPickerView.dataSource = self;
    self.countryPickerView.accessibilityIdentifier = @"Country Picker";

    self.administrativeDivisionPickerView = [UIPickerView new];
    self.administrativeDivisionPickerView.delegate = self;
    self.administrativeDivisionPickerView.dataSource = self;
    self.administrativeDivisionPickerView.accessibilityIdentifier = @"Administrative Division Picker";

    self.countryTextField = [JPCardInputField new];
    self.countryTextField.inputView = self.countryPickerView;
    self.countryTextField.accessibilityIdentifier = @"Country Field";
    self.countryTextField.textContentType = UITextContentTypeCountryName;

    self.administrativeDivisionTextField = [JPCardInputField new];
    self.administrativeDivisionTextField.inputView = self.administrativeDivisionPickerView;
    self.administrativeDivisionTextField.accessibilityIdentifier = @"Administrative Division Field";
    self.administrativeDivisionTextField.hidden = YES;
    self.administrativeDivisionTextField.textContentType = UITextContentTypeAddressState;

    self.phoneCodeTextField = [JPPhoneCodeInputField new];
    self.phoneCodeTextField.accessibilityIdentifier = @"Cardholder phone code Field";
    self.phoneCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneCodeTextField.backgroundMaskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner;

    self.phoneTextField = [JPCardInputField new];
    self.phoneTextField.accessibilityIdentifier = @"Cardholder phone number Field";
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextField.backgroundMaskedCorners = kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner;
    self.phoneTextField.textContentType = UITextContentTypeTelephoneNumber;

    self.line1TextField = [JPCardInputField new];
    self.line1TextField.accessibilityIdentifier = @"Cardholder address line 1 code Field";
    self.line1TextField.keyboardType = UIKeyboardTypeDefault;
    self.line1TextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.line1TextField.textContentType = UITextContentTypeStreetAddressLine1;

    self.addAddressLineButton = [JPTransactionButton buttonWithType:UIButtonTypeSystem];
    self.addAddressLineButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.addAddressLineButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.addAddressLineButton.accessibilityIdentifier = @"Add address line Button";
    self.addAddressLineButton.titleLabel.numberOfLines = 0;
    self.addAddressLineButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.addAddressLineButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    self.addAddressLineButton.contentEdgeInsets = UIEdgeInsetsMake(kButtonContentPadding, 0, kButtonContentPadding, kButtonContentPadding);
    [self.addAddressLineButton addTarget:self action:@selector(showNewAddressLine:) forControlEvents:UIControlEventTouchUpInside];

    NSString *title = [NSString stringWithFormat:@"jp_button_add_address_line_card"._jp_localized, @(2)];
    [self.addAddressLineButton setTitle:title forState:UIControlStateNormal];

    self.line2TextField = [JPCardInputField new];
    self.line2TextField.accessibilityIdentifier = @"Cardholder address line 2 Field";
    self.line2TextField.keyboardType = UIKeyboardTypeDefault;
    self.line2TextField.hidden = YES;
    self.line2TextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.line2TextField.textContentType = UITextContentTypeStreetAddressLine2;

    self.line3TextField = [JPCardInputField new];
    self.line3TextField.accessibilityIdentifier = @"Cardholder address line 3 Field";
    self.line3TextField.keyboardType = UIKeyboardTypeDefault;
    self.line3TextField.hidden = YES;
    self.line3TextField.autocapitalizationType = UITextAutocapitalizationTypeWords;

    self.cityTextField = [JPCardInputField new];
    self.cityTextField.accessibilityIdentifier = @"Cardholder city Field";
    self.cityTextField.keyboardType = UIKeyboardTypeDefault;
    self.cityTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.cityTextField.textContentType = UITextContentTypeAddressCity;

    self.postcodeTextField = [JPCardInputField new];
    self.postcodeTextField.keyboardType = UIKeyboardTypeDefault;
    self.postcodeTextField.accessibilityIdentifier = @"Post Code Field";
    self.postcodeTextField.textContentType = UITextContentTypePostalCode;

    UIStackView *phoneNumberStackView = [UIStackView _jp_horizontalStackViewWithSpacing:kSeparatorContentSpacing
                                                                    andArrangedSubviews:@[ self.phoneCodeTextField, self.phoneTextField ]];

    NSLayoutConstraint *widthLayout = [self.phoneTextField.widthAnchor constraintGreaterThanOrEqualToConstant:kPhoneCodeWidth];
    [widthLayout setActive:YES];
    widthLayout.priority = UILayoutPriorityDefaultHigh;

    NSLayoutConstraint *widthCodeLayout = [self.phoneCodeTextField.widthAnchor constraintEqualToConstant:53];
    [widthCodeLayout setActive:YES];
    widthCodeLayout.priority = UILayoutPriorityDefaultLow;

    [self.inputFieldsStackView _jp_addArrangedSubviews:@[
        self.headingLabel,
        self.emailTextField,
        self.countryTextField,
        self.administrativeDivisionTextField,
        phoneNumberStackView,
        self.line1TextField,
        self.line2TextField,
        self.line3TextField,
        self.addAddressLineButton,
        self.cityTextField,
        self.postcodeTextField
    ]];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.addAddressLineButton.heightAnchor constraintGreaterThanOrEqualToConstant:kButtonAddAddressLineMinHeight]
    ]];
}

- (void)showNewAddressLine:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2
                     animations:^{
                         if (weakSelf.line2TextField.hidden) {
                             weakSelf.line2TextField.hidden = NO;
                             [weakSelf.addAddressLineButton setTitle:[NSString stringWithFormat:@"jp_button_add_address_line_card"._jp_localized, @(3)]
                                                            forState:UIControlStateNormal];
                             return;
                         }

                         if (weakSelf.line3TextField.hidden) {
                             weakSelf.line3TextField.hidden = NO;
                             weakSelf.addAddressLineButton.hidden = YES;
                         }
                     }];
}

- (void)updateBillingAddressAdministrativeDivisionPicker:(NSString *)countryName {
    JPCountry *country = [JPCountry forCountryName:countryName];

    if (!country || self.administrativeDivisionTextField.hidden == !country.hasAdministrativeDivisions) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2
                     animations:^{
                         weakSelf.administrativeDivisionTextField.hidden = !country.hasAdministrativeDivisions;
                     }];
}

- (void)applyTheme:(JPTheme *)theme {
    [super applyTheme:theme];

    self.headingLabel.font = theme.headline;
    self.headingLabel.textColor = theme.jpBrownGrayColor;

    [self.emailTextField applyTheme:theme];
    [self.countryTextField applyTheme:theme];
    [self.administrativeDivisionTextField applyTheme:theme];
    [self.phoneCodeTextField applyTheme:theme];
    [self.phoneTextField applyTheme:theme];
    [self.line1TextField applyTheme:theme];
    [self.line2TextField applyTheme:theme];
    [self.line3TextField applyTheme:theme];

    self.addAddressLineButton.titleLabel.font = theme.bodyBold;
    [self.addAddressLineButton setTitleColor:theme.jpBlackColor forState:UIControlStateNormal];

    [self.cityTextField applyTheme:theme];
    [self.postcodeTextField applyTheme:theme];
}

- (void)configureWithViewModel:(JPTransactionBillingInformationViewModel *)viewModel {
    self.viewModel = viewModel;

    [self.addAddressLineButton setEnabled:!viewModel.isLoading];

    [self.topActionBar.cancelButton configureWithViewModel:viewModel.cancelButtonViewModel];
    [self.bottomActionBar.backButton configureWithViewModel:viewModel.backButtonViewModel];
    [self.bottomActionBar.submitButton configureWithViewModel:viewModel.submitButtonViewModel];

    [self.emailTextField configureWithViewModel:viewModel.emailViewModel];
    [self.countryTextField configureWithViewModel:viewModel.countryViewModel];
    [self.administrativeDivisionTextField configureWithViewModel:viewModel.administrativeDivisionViewModel];
    [self.phoneCodeTextField configureWithViewModel:viewModel.phoneCodeViewModel];
    [self.phoneTextField configureWithViewModel:viewModel.phoneViewModel];
    [self.line1TextField configureWithViewModel:viewModel.addressLine1ViewModel];
    [self.line2TextField configureWithViewModel:viewModel.addressLine2ViewModel];
    [self.line3TextField configureWithViewModel:viewModel.addressLine3ViewModel];
    [self.cityTextField configureWithViewModel:viewModel.cityViewModel];
    [self.postcodeTextField configureWithViewModel:viewModel.postalCodeViewModel];

    [self updateBillingAddressAdministrativeDivisionPicker:viewModel.countryViewModel.text];
    [self.countryPickerView reloadAllComponents];
    [self.administrativeDivisionPickerView reloadAllComponents];
}

- (void)setInputFieldDelegate:(id<JPInputFieldDelegate>)delegate {
    [super setInputFieldDelegate:delegate];

    self.emailTextField.delegate = delegate;
    self.countryTextField.delegate = delegate;
    self.administrativeDivisionTextField.delegate = delegate;
    self.phoneCodeTextField.delegate = delegate;
    self.phoneTextField.delegate = delegate;
    self.line1TextField.delegate = delegate;
    self.line2TextField.delegate = delegate;
    self.line3TextField.delegate = delegate;
    self.cityTextField.delegate = delegate;
    self.postcodeTextField.delegate = delegate;
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (pickerView == self.countryPickerView) {
        return self.viewModel.countryViewModel.options.count;
    }

    if (pickerView == self.administrativeDivisionPickerView) {
        return self.viewModel.administrativeDivisionViewModel.options.count;
    }

    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if (pickerView == self.countryPickerView) {
        JPCountry *country = self.viewModel.countryViewModel.options[row];
        [self.inputFieldDelegate inputField:self.countryTextField didEndEditing:country.name];
    }

    if (pickerView == self.administrativeDivisionPickerView) {
        JPAdministrativeDivision *division = self.viewModel.administrativeDivisionViewModel.options[row];
        [self.inputFieldDelegate inputField:self.administrativeDivisionTextField didEndEditing:division.name];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    if (pickerView == self.countryPickerView) {
        return self.viewModel.countryViewModel.options[row].name;
    }

    if (pickerView == self.administrativeDivisionPickerView) {
        return self.viewModel.administrativeDivisionViewModel.options[row].name;
    }

    return @"";
}

@end
