//  JPTransactionView.m
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

#import "JPCardInputView.h"
#import "JPCardDetailsMode.h"
#import "JPCardInputField.h"
#import "JPCardNumberField.h"
#import "JPLoadingButton.h"
#import "JPRoundedCornerView.h"
#import "JPTheme.h"
#import "JPTransactionButton.h"
#import "NSString+Additions.h"
#import "UIColor+Additions.h"
#import "UIImage+Additions.h"
#import "UIStackView+Additions.h"
#import "UIView+Additions.h"

@interface JPCardInputView ()

@property (nonatomic, strong) JPRoundedCornerView *bottomSlider;
@property (nonatomic, strong) UIStackView *mainStackView;
@property (nonatomic, strong) UIStackView *inputFieldsStackView;
@property (nonatomic, strong) UIStackView *billingDetails;
@property (nonatomic, strong) UIStackView *avsStackView;
@property (nonatomic, strong) UIStackView *bottomButtons;
@property (nonatomic, strong) UIStackView *securityMessageStackView;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) UILabel *securityMessageLabel;
@property (nonatomic, strong) NSLayoutConstraint *billingDetailsHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, copy) void (^onScanCardButtonTapHandler)(void);
@property (nonatomic, assign) JPCardDetailsMode mode;

@end

@implementation JPCardInputView

#pragma mark - Constants

static const float kScanButtonCornerRadius = 4.0F;
static const float kScanButtonBorderWidth = 1.0F;
static const float kContentHorizontalPadding = 24.0F;
static const float kContentVerticalPadding = 20.0F;
static const float kScanCardHeight = 36.0F;
static const float kInputFieldHeight = 44.0F;
static const float kAddCardButtonHeight = 46.0F;
static const float kLockImageWidth = 17.0F;
static const float kSliderCornerRadius = 10.0F;
static const float kTightContentSpacing = 8.0F;
static const float kLooseContentSpacing = 16.0F;
static const float kSeparatorContentSpacing = 1.0F;
static const float kButtonsContentSpacing = 40.0F;
static const float kAnimationTimeInterval = 0.3F;
static const float kPhoneCodeWidth = 45.0F;

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.mode = -1;
    [self addSubview:self.backgroundView];
    [self addSubview:self.bottomSlider];
    [self.bottomSlider addSubview:self.mainStackView];
    [self setupConstraints];
    [self.mainStackView addArrangedSubview:self.topButtonStackView];
    [self.mainStackView addArrangedSubview:self.secureCodeTextField];
    [self.mainStackView addArrangedSubview:self.inputFieldsStackView];

    UIScrollView *scrollView = [UIScrollView new];
    [self.mainStackView addArrangedSubview:scrollView];

    UIView *contentView = [UIView new];
    [scrollView addSubview:contentView];
    [contentView pinToView:scrollView withPadding:0];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;

    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    CGFloat topPadding = window.safeAreaInsets.top;
    _topConstraint = [_bottomSlider.topAnchor constraintGreaterThanOrEqualToAnchor:self.safeTopAnchor constant:topPadding];
    [_topConstraint setActive:YES];

    _billingDetailsHeightConstraint = [scrollView.heightAnchor constraintGreaterThanOrEqualToConstant:0];
    _billingDetailsHeightConstraint.priority = UILayoutPriorityDefaultLow;
    [_billingDetailsHeightConstraint setActive:YES];
    NSString *title = [NSString stringWithFormat:@"button_add_address_line_card".localized, @(2)];
    [_addAddressLineButton setTitle:title forState:UIControlStateNormal];
    _billingDetailsHeightConstraint.constant = 0;

    [[contentView.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor] setActive:YES];
    [contentView addSubview:[self billingDetails]];
    [_billingDetails pinToView:contentView withPadding:0];

    [self.mainStackView addArrangedSubview:self.buttonStackView];
    _bottomButtons.layoutMarginsRelativeArrangement = YES;
}

#pragma mark - Theming

- (void)applyTheme:(JPTheme *)theme {
    self.cancelButton.titleLabel.font = theme.bodyBold;
    [self.cancelButton setTitleColor:theme.jpBlackColor
                            forState:UIControlStateNormal];

    self.addAddressLineButton.titleLabel.font = theme.bodyBold;
    [self.addAddressLineButton setTitleColor:theme.jpBlackColor
                                    forState:UIControlStateNormal];

    self.scanCardButton.titleLabel.font = theme.bodyBold;
    [self.scanCardButton setTitleColor:theme.jpBlackColor
                              forState:UIControlStateNormal];
    [self.scanCardButton _jp_setBorderWithColor:theme.jpBlackColor
                                          width:kScanButtonBorderWidth
                                andCornerRadius:kScanButtonCornerRadius];

    self.addCardButton.titleLabel.font = theme.headline;
    self.addCardButton.layer.cornerRadius = theme.buttonCornerRadius;
    [self.addCardButton setBackgroundImage:theme.buttonColor._jp_asImage
                                  forState:UIControlStateNormal];
    [self.addCardButton setTitleColor:theme.buttonTitleColor
                             forState:UIControlStateNormal];

    self.backButton.titleLabel.font = theme.bodyBold;
    [self.backButton setTitleColor:theme.jpBlackColor
                          forState:UIControlStateNormal];
    self.backButton.titleLabel.font = theme.headline;

    self.securityMessageLabel.font = theme.caption;
    self.securityMessageLabel.textColor = theme.jpDarkGrayColor;

    [self.cardHolderEmailTextField applyTheme:theme];
    [self.cardHolderAddressLine1TextField applyTheme:theme];
    [self.cardHolderAddressLine2TextField applyTheme:theme];
    [self.cardHolderAddressLine3TextField applyTheme:theme];
    [self.cardHolderPhoneTextField applyTheme:theme];
    [self.cardHolderCityTextField applyTheme:theme];
    [self.cardHolderPhoneCodeTextField applyTheme:theme];
    [self.cardNumberTextField applyTheme:theme];
    [self.cardHolderTextField applyTheme:theme];
    [self.cardExpiryTextField applyTheme:theme];
    [self.secureCodeTextField applyTheme:theme];
    [self.countryTextField applyTheme:theme];
    [self.postcodeTextField applyTheme:theme];
}

- (void)setMode:(JPCardDetailsMode)mode {
    if (self.mode != mode) {
        _mode = mode;
        [self endEditing:YES];
        [UIView animateWithDuration:kAnimationTimeInterval
            animations:^{
                [self.mainStackView setAlpha:0.0];
            }
            completion:^(BOOL finished) {
                [self adjustSubviews];
                [UIView animateWithDuration:kAnimationTimeInterval
                                 animations:^{
                                     [self.mainStackView setAlpha:1.0];
                                 }
                                 completion:nil];
            }];
    }
}

- (void)adjustSubviews {
    [_topConstraint setActive:NO];
    [_scanCardButton setHidden:_mode == JPCardDetailsModeSecurityCode];
    [_avsStackView setHidden:_mode != JPCardDetailsModeAVS];
    [_billingDetails setHidden:_mode != JPCardDetailsModeThreeDS2BillingDetails];
    [_inputFieldsStackView setHidden:_mode == JPCardDetailsModeThreeDS2BillingDetails];
    [_backButton setHidden:_mode != JPCardDetailsModeThreeDS2BillingDetails];
    [_scanCardButton setHidden:(_mode == JPCardDetailsModeThreeDS2BillingDetails || _mode == JPCardDetailsModeSecurityCode)];
    _mode == JPCardDetailsModeAVS
        ? [_avsStackView addArrangedSubview:_postcodeTextField]
        : [_billingDetails addArrangedSubview:_postcodeTextField];
    CGFloat leftPadding = _mode == JPCardDetailsModeThreeDS2BillingDetails ? 30 : 0;
    _bottomButtons.layoutMargins = UIEdgeInsetsMake(0, leftPadding, 0, 0);
    _securityMessageStackView.hidden = _mode == JPCardDetailsModeThreeDS2BillingDetails;
    _billingDetailsHeightConstraint.constant = _mode == JPCardDetailsModeThreeDS2BillingDetails ? _billingDetails.frame.size.height : 0;
    [self adjustTopSpace];
}

- (IBAction)showNewAddressLine:(UIButton *)sender {
    NSInteger tag = sender.tag;
    _cardHolderAddressLine2TextField.hidden = NO;
    _cardHolderAddressLine3TextField.hidden = tag < 1;
    _addAddressLineButton.hidden = tag > 0;
    NSString *title = [NSString stringWithFormat:@"button_add_address_line_card".localized, @(tag + 3)];
    [_addAddressLineButton setTitle:title forState:UIControlStateNormal];
    sender.tag++;
    [self adjustTopSpace];
}

- (void)adjustTopSpace {
    [_topConstraint setActive:NO];
    [_bottomSlider layoutIfNeeded];
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    CGFloat topPadding = window.safeAreaInsets.top;
    [_topConstraint setActive:_bottomSlider.frame.origin.y < topPadding];
}

#pragma mark - View model configuration

- (void)configureWithViewModel:(JPTransactionViewModel *)viewModel {
    self.mode = viewModel.mode;
    switch (viewModel.mode) {
        case JPCardDetailsModeSecurityCode:
            [self.secureCodeTextField configureWithViewModel:viewModel.secureCodeViewModel];
            break;
        case JPCardDetailsModeDefault:
        case JPCardDetailsModeThreeDS2:
            [self.cardNumberTextField configureWithViewModel:viewModel.cardNumberViewModel];
            [self.cardHolderTextField configureWithViewModel:viewModel.cardholderNameViewModel];
            [self.cardExpiryTextField configureWithViewModel:viewModel.expiryDateViewModel];
            [self.secureCodeTextField configureWithViewModel:viewModel.secureCodeViewModel];
            break;
        case JPCardDetailsModeAVS:
            [self.cardNumberTextField configureWithViewModel:viewModel.cardNumberViewModel];
            [self.cardHolderTextField configureWithViewModel:viewModel.cardholderNameViewModel];
            [self.cardExpiryTextField configureWithViewModel:viewModel.expiryDateViewModel];
            [self.secureCodeTextField configureWithViewModel:viewModel.secureCodeViewModel];
            [self.countryTextField configureWithViewModel:viewModel.countryPickerViewModel];
            [self.postcodeTextField configureWithViewModel:viewModel.postalCodeInputViewModel];
            break;
        case JPCardDetailsModeThreeDS2BillingDetails:
            [self.cardHolderEmailTextField configureWithViewModel:viewModel.cardholderEmailViewModel];
            [self.cardHolderPhoneTextField configureWithViewModel:viewModel.cardholderPhoneViewModel];
            [self.cardHolderCityTextField configureWithViewModel:viewModel.cardholderCityViewModel];
            [self.cardHolderAddressLine1TextField configureWithViewModel:viewModel.cardholderAddressLine1ViewModel];
            [self.cardHolderAddressLine2TextField configureWithViewModel:viewModel.cardholderAddressLine2ViewModel];
            [self.cardHolderAddressLine3TextField configureWithViewModel:viewModel.cardholderAddressLine3ViewModel];
            [self.cardHolderPhoneCodeTextField configureWithViewModel:viewModel.cardholderPhoneCodeViewModel];
            [self.countryTextField configureWithViewModel:viewModel.countryPickerViewModel];
            [self.postcodeTextField configureWithViewModel:viewModel.postalCodeInputViewModel];
            break;
    }
    [_countryPickerView reloadAllComponents];
    [self.addCardButton configureWithViewModel:viewModel.addCardButtonViewModel];
    [self.backButton configureWithViewModel:viewModel.backButtonViewModel];
}

#pragma mark - Helper methods

- (void)enableUserInterface:(BOOL)shouldEnable {
    self.cancelButton.enabled = shouldEnable;
    self.scanCardButton.enabled = shouldEnable;
    self.cardNumberTextField.enabled = shouldEnable;
    self.cardHolderTextField.enabled = shouldEnable;
    self.cardHolderPhoneTextField.enabled = shouldEnable;
    self.cardHolderCityTextField.enabled = shouldEnable;
    self.cardHolderPhoneCodeTextField.enabled = shouldEnable;
    self.cardHolderEmailTextField.enabled = shouldEnable;
    self.cardExpiryTextField.enabled = shouldEnable;
    self.secureCodeTextField.enabled = shouldEnable;
    self.countryTextField.enabled = shouldEnable;
    self.postcodeTextField.enabled = shouldEnable;
    self.addCardButton.enabled = shouldEnable;
}

#pragma mark - Layout setup

- (void)setupConstraints {
    [self.backgroundView _jp_pinToView:self withPadding:0.0];
    [self setupBottomSliderConstraints];
    [self setupMainStackViewConstraints];
    [self setupContentsConstraints];
}

- (void)setupBottomSliderConstraints {
    [self.bottomSlider _jp_pinToAnchors:JPAnchorTypeLeading | JPAnchorTypeTrailing forView:self];
    [self.bottomSlider _jp_pinToAnchors:JPAnchorTypeBottom forView:self];

    if (self.bottomSliderConstraint == nil) {
        self.bottomSliderConstraint = [self.bottomSlider.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    }

    self.bottomSliderConstraint.active = YES;
}

- (void)setupMainStackViewConstraints {
    [self.mainStackView _jp_pinToAnchors:JPAnchorTypeTop | JPAnchorTypeBottom
                                 forView:self.bottomSlider
                             withPadding:kContentVerticalPadding];

    [self.mainStackView _jp_pinToAnchors:JPAnchorTypeLeading | JPAnchorTypeTrailing
                                 forView:self.bottomSlider
                             withPadding:kContentHorizontalPadding];
}

- (void)setupContentsConstraints {
    NSArray *constraints = @[
        [self.addAddressLineButton.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.cardHolderAddressLine1TextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.cardHolderAddressLine2TextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.cardHolderAddressLine3TextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.cardHolderPhoneCodeTextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.cardHolderPhoneCodeTextField.widthAnchor constraintGreaterThanOrEqualToConstant:0],
        [self.cardHolderPhoneTextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.cardHolderCityTextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.scanCardButton.heightAnchor constraintEqualToConstant:kScanCardHeight],
        [self.cardNumberTextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.cardHolderEmailTextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.cardHolderTextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.cardExpiryTextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.secureCodeTextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.countryTextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.postcodeTextField.heightAnchor constraintEqualToConstant:kInputFieldHeight],
        [self.backButton.heightAnchor constraintEqualToConstant:kAddCardButtonHeight],
        [self.addCardButton.heightAnchor constraintEqualToConstant:kAddCardButtonHeight],
        [self.lockImageView.widthAnchor constraintEqualToConstant:kLockImageWidth],
    ];

    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Lazily instantiated properties

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = UIColor.clearColor;
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _backgroundView;
}

- (UIView *)bottomSlider {
    if (!_bottomSlider) {
        UIRectCorner corners = UIRectCornerTopRight | UIRectCornerTopLeft;
        _bottomSlider = [[JPRoundedCornerView alloc] initWithRadius:kSliderCornerRadius forCorners:corners];
        _bottomSlider.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomSlider.backgroundColor = UIColor.whiteColor;
    }
    return _bottomSlider;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_cancelButton setTitle:@"cancel"._jp_localized.uppercaseString
                       forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (UIButton *)addAddressLineButton {
    if (!_addAddressLineButton) {
        _addAddressLineButton = [UIButton new];
        _addAddressLineButton.translatesAutoresizingMaskIntoConstraints = NO;
        _addAddressLineButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_addAddressLineButton addTarget:self action:@selector(showNewAddressLine:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addAddressLineButton;
}

- (UIButton *)scanCardButton {
    if (!_scanCardButton) {
        _scanCardButton = [UIButton new];
        _scanCardButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_scanCardButton setTitle:@"button_scan_card"._jp_localized.uppercaseString forState:UIControlStateNormal];
        [_scanCardButton setImage:[UIImage _jp_imageWithIconName:@"scan-card"]
                         forState:UIControlStateNormal];
        _scanCardButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _scanCardButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        _scanCardButton.contentEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 5);
        _scanCardButton.imageView.bounds = CGRectMake(0, 0, 24, 24);
    }
    return _scanCardButton;
}

- (JPCardNumberField *)cardNumberTextField {
    if (!_cardNumberTextField) {
        _cardNumberTextField = [JPCardNumberField new];
        _cardNumberTextField.accessibilityIdentifier = @"Card Number Field";
        _cardNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _cardNumberTextField;
}

- (JPCardInputField *)cardHolderTextField {
    if (!_cardHolderTextField) {
        _cardHolderTextField = [JPCardInputField new];
        _cardHolderTextField.accessibilityIdentifier = @"Cardholder Name Field";
        _cardHolderTextField.keyboardType = UIKeyboardTypeDefault;
    }
    return _cardHolderTextField;
}

- (JPCardInputField *)cardHolderEmailTextField {
    if (!_cardHolderEmailTextField) {
        _cardHolderEmailTextField = [JPCardInputField new];
        _cardHolderEmailTextField.accessibilityIdentifier = @"Cardholder Email Field";
        _cardHolderEmailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _cardHolderEmailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _cardHolderEmailTextField;
}

- (JPCardInputField *)cardHolderPhoneCodeTextField {
    if (!_cardHolderPhoneCodeTextField) {
        _cardHolderPhoneCodeTextField = [JPCardInputField new];
        _cardHolderPhoneCodeTextField.accessibilityIdentifier = @"Cardholder phone code Field";
        _cardHolderPhoneCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _cardHolderPhoneCodeTextField;
}

- (JPCardInputField *)cardHolderAddressLine1TextField {
    if (!_cardHolderAddressLine1TextField) {
        _cardHolderAddressLine1TextField = [JPCardInputField new];
        _cardHolderAddressLine1TextField.accessibilityIdentifier = @"Cardholder address line 1 code Field";
        _cardHolderAddressLine1TextField.keyboardType = UIKeyboardTypeDefault;
    }
    return _cardHolderAddressLine1TextField;
}

- (JPCardInputField *)cardHolderAddressLine2TextField {
    if (!_cardHolderAddressLine2TextField) {
        _cardHolderAddressLine2TextField = [JPCardInputField new];
        _cardHolderAddressLine2TextField.accessibilityIdentifier = @"Cardholder address line 2 Field";
        _cardHolderAddressLine2TextField.keyboardType = UIKeyboardTypeDefault;
        _cardHolderAddressLine2TextField.hidden = YES;
    }
    return _cardHolderAddressLine2TextField;
}

- (JPCardInputField *)cardHolderAddressLine3TextField {
    if (!_cardHolderAddressLine3TextField) {
        _cardHolderAddressLine3TextField = [JPCardInputField new];
        _cardHolderAddressLine3TextField.accessibilityIdentifier = @"Cardholder address line 3 Field";
        _cardHolderAddressLine3TextField.keyboardType = UIKeyboardTypeDefault;
        _cardHolderAddressLine3TextField.hidden = YES;
    }
    return _cardHolderAddressLine3TextField;
}

- (JPCardInputField *)cardHolderPhoneTextField {
    if (!_cardHolderPhoneTextField) {
        _cardHolderPhoneTextField = [JPCardInputField new];
        _cardHolderPhoneTextField.accessibilityIdentifier = @"Cardholder phone number Field";
        _cardHolderPhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _cardHolderPhoneTextField;
}

- (JPCardInputField *)cardHolderCityTextField {
    if (!_cardHolderCityTextField) {
        _cardHolderCityTextField = [JPCardInputField new];
        _cardHolderCityTextField.accessibilityIdentifier = @"Cardholder city Field";
        _cardHolderCityTextField.keyboardType = UIKeyboardTypeDefault;
    }
    return _cardHolderCityTextField;
}

- (JPCardInputField *)cardExpiryTextField {
    if (!_cardExpiryTextField) {
        _cardExpiryTextField = [JPCardInputField new];
        _cardExpiryTextField.accessibilityIdentifier = @"Expiry Date Field";
        _cardExpiryTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _cardExpiryTextField;
}

- (JPCardInputField *)secureCodeTextField {
    if (!_secureCodeTextField) {
        _secureCodeTextField = [JPCardInputField new];
        _secureCodeTextField.accessibilityIdentifier = @"Secure Code Field";
        _secureCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _secureCodeTextField;
}

- (JPCardInputField *)countryTextField {
    if (!_countryTextField) {
        _countryTextField = [JPCardInputField new];
        _countryTextField.inputView = self.countryPickerView;
        _countryTextField.accessibilityIdentifier = @"Country Field";
    }
    return _countryTextField;
}

- (UIPickerView *)countryPickerView {
    if (!_countryPickerView) {
        _countryPickerView = [UIPickerView new];
        _countryPickerView.accessibilityIdentifier = @"Country Picker";
    }
    return _countryPickerView;
}

- (JPCardInputField *)postcodeTextField {
    if (!_postcodeTextField) {
        _postcodeTextField = [JPCardInputField new];
        _postcodeTextField.keyboardType = UIKeyboardTypeDefault;
        _postcodeTextField.accessibilityIdentifier = @"Post Code Field";
    }
    return _postcodeTextField;
}

- (JPTransactionButton *)backButton {
    if (!_backButton) {
        _backButton = [JPTransactionButton new];
        _backButton.translatesAutoresizingMaskIntoConstraints = NO;
        _backButton.accessibilityIdentifier = @"Back Button";
        _backButton.clipsToBounds = YES;
    }
    return _backButton;
}

- (JPTransactionButton *)addCardButton {
    if (!_addCardButton) {
        _addCardButton = [JPTransactionButton new];
        _addCardButton.translatesAutoresizingMaskIntoConstraints = NO;
        _addCardButton.accessibilityIdentifier = @"Submit Button";
        _addCardButton.clipsToBounds = YES;
    }
    return _addCardButton;
}

- (UIImageView *)lockImageView {
    if (!_lockImageView) {
        _lockImageView = [UIImageView new];
        _lockImageView.contentMode = UIViewContentModeScaleAspectFit;
        _lockImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _lockImageView.image = [UIImage _jp_imageWithIconName:@"lock-icon"];
    }
    return _lockImageView;
}

- (UILabel *)securityMessageLabel {
    if (!_securityMessageLabel) {
        _securityMessageLabel = [UILabel new];
        _securityMessageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _securityMessageLabel.text = @"secure_server_transmission"._jp_localized;
        _securityMessageLabel.numberOfLines = 0;
    }
    return _securityMessageLabel;
}

#pragma mark - Stack Views

- (UIStackView *)mainStackView {
    if (!_mainStackView) {
        _mainStackView = [UIStackView _jp_verticalStackViewWithSpacing:kLooseContentSpacing];
    }
    return _mainStackView;
}

- (UIStackView *)billingDetails {
    if (!_billingDetails) {
        UIStackView *stackView = [UIStackView verticalStackViewWithSpacing:kTightContentSpacing];
        [stackView addArrangedSubview:self.cardHolderEmailTextField];
        if (_mode != JPCardDetailsModeAVS) {
            [stackView addArrangedSubview:self.countryTextField];
        }
        [stackView addArrangedSubview:self.phoneStackView];
        [stackView addArrangedSubview:self.cardHolderAddressLine1TextField];
        [stackView addArrangedSubview:self.cardHolderAddressLine2TextField];
        [stackView addArrangedSubview:self.cardHolderAddressLine3TextField];
        [stackView addArrangedSubview:self.addAddressLineButton];
        [stackView addArrangedSubview:self.cardHolderCityTextField];
        [stackView addArrangedSubview:self.postcodeTextField];
        _billingDetails = stackView;
        return stackView;
    }
    return _billingDetails;
}

- (UIStackView *)bottomButtons {
    UIStackView *stackView = [UIStackView horizontalStackViewWithSpacing:kButtonsContentSpacing];
    [stackView addArrangedSubview:self.backButton];
    [stackView addArrangedSubview:self.addCardButton];
    _bottomButtons = stackView;
    return stackView;
}

- (UIStackView *)phoneStackView {
    UIStackView *stackView = [UIStackView horizontalStackViewWithSpacing:kSeparatorContentSpacing];
    [stackView addArrangedSubview:self.cardHolderPhoneCodeTextField];
    [stackView addArrangedSubview:self.cardHolderPhoneTextField];
    NSLayoutConstraint *widthLayout = [self.cardHolderPhoneTextField.widthAnchor constraintGreaterThanOrEqualToConstant:kPhoneCodeWidth];
    [widthLayout setActive:YES];
    widthLayout.priority = UILayoutPriorityDefaultHigh;
    NSLayoutConstraint *widthCodeLayout = [self.cardHolderPhoneCodeTextField.widthAnchor constraintEqualToConstant:43];
    [widthCodeLayout setActive:YES];
    widthCodeLayout.priority = UILayoutPriorityDefaultLow;
    return stackView;
}

- (UIStackView *)topButtonStackView {
    UIStackView *stackView = [UIStackView new];
    [stackView addArrangedSubview:self.cancelButton];
    [stackView addArrangedSubview:[UIView new]];
    [stackView addArrangedSubview:self.scanCardButton];
    return stackView;
}

- (UIStackView *)additionalInputFieldsStackView {
    UIStackView *stackView = [UIStackView _jp_horizontalStackViewWithSpacing:kTightContentSpacing];
    stackView.distribution = UIStackViewDistributionFillEqually;

    [stackView addArrangedSubview:self.cardExpiryTextField];
    [stackView addArrangedSubview:self.secureCodeTextField];

    return stackView;
}

- (UIStackView *)inputFieldsStackView {
    UIStackView *stackView = [UIStackView _jp_verticalStackViewWithSpacing:kTightContentSpacing];

    [stackView addArrangedSubview:self.cardNumberTextField];
    [stackView addArrangedSubview:self.cardHolderTextField];
    [stackView addArrangedSubview:self.additionalInputFieldsStackView];

    return stackView;
}

- (UIStackView *)inputFieldsStackViewForAVS {
    UIStackView *stackView = [UIStackView _jp_verticalStackViewWithSpacing:kTightContentSpacing];

    [stackView addArrangedSubview:self.cardNumberTextField];
    [stackView addArrangedSubview:self.cardHolderTextField];
    [stackView addArrangedSubview:self.additionalInputFieldsStackView];
    _avsStackView = self.avsStackView;
    [stackView addArrangedSubview:_avsStackView];
    _inputFieldsStackView = stackView;
    return stackView;
}

- (UIStackView *)avsStackView {
    UIStackView *stackView = [UIStackView _jp_horizontalStackViewWithSpacing:kTightContentSpacing];
    stackView.distribution = UIStackViewDistributionFillEqually;
    [stackView addArrangedSubview:self.countryTextField];
    [stackView addArrangedSubview:self.postcodeTextField];
    _avsStackView = stackView;
    return stackView;
}

- (UIStackView *)securityMessageStackView {
    UIStackView *stackView = [UIStackView _jp_horizontalStackViewWithSpacing:kTightContentSpacing];
    [stackView addArrangedSubview:self.lockImageView];
    [stackView addArrangedSubview:self.securityMessageLabel];
    _securityMessageStackView = stackView;
    return stackView;
}

- (UIStackView *)buttonStackView {
    UIStackView *stackView = [UIStackView _jp_verticalStackViewWithSpacing:kLooseContentSpacing];
    [stackView addArrangedSubview:self.addCardButton];
    [stackView addArrangedSubview:self.securityMessageStackView];
    return stackView;
}

@end
