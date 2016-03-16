//
//  JudoPayView.m
//  JudoKitObjC
//
//  Copyright (c) 2016 Alternative Payments Ltd
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

#import "JudoPayView.h"

#import "JPTransactionData.h"

#import "JPCardDetails.h"

#import "JPTheme.h"

#import "HintLabel.h"
#import "LoadingView.h"
#import "JP3DSWebView.h"
#import "FloatingTextField.h"

#import "CardInputField.h"
#import "DateInputField.h"
#import "IssueNumberInputField.h"
#import "SecurityCodeInputField.h"
#import "BillingCountryInputField.h"
#import "PostCodeInputField.h"

#import "NSTimer+Blocks.h"
#import "NSError+Judo.h"

static inline UIViewAnimationOptions animationOptionsWithCurve(UIViewAnimationCurve curve) {
    UIViewAnimationOptions opt = (UIViewAnimationOptions)curve;
    return opt << 16;
}

@interface JudoPayView () <JudoPayInputDelegate> {
    BOOL _paymentEnabled;
    CGFloat _currentKeyboardHeight;
}

@property (nonatomic, strong, readwrite) UIScrollView *contentView;

@property (nonatomic, strong) NSLayoutConstraint *keyboardHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *maestroFieldsHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *avsFieldsHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *securityMessageTopConstraint;

@property (nonatomic, strong) HintLabel *hintLabel;
@property (nonatomic, strong) UILabel *securityMessageLabel;

@property (nonatomic, strong, readwrite) UIButton *paymentButton;

@property (nonatomic, strong, readwrite) LoadingView *loadingView;
@property (nonatomic, strong, readwrite) JP3DSWebView *threeDSWebView;

@property (nonatomic, assign, readwrite) TransactionType transactionType;

@property (nonatomic, strong, readwrite) CardInputField *cardInputField;
@property (nonatomic, strong, readwrite) DateInputField *expiryDateInputField;
@property (nonatomic, strong, readwrite) SecurityCodeInputField *securityCodeInputField;
@property (nonatomic, strong, readwrite) DateInputField *startDateInputField;
@property (nonatomic, strong, readwrite) IssueNumberInputField *issueNumberInputField;
@property (nonatomic, strong, readwrite) PostCodeInputField *postCodeInputField;
@property (nonatomic, strong, readwrite) BillingCountryInputField *billingCountryInputField;

@end

@implementation JudoPayView

#pragma mark - Initialization

- (instancetype)initWithType:(TransactionType)type cardDetails:(JPCardDetails *)cardDetails theme:(JPTheme *)theme {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.cardDetails = cardDetails;
        self.transactionType = type;
        self.theme = theme;
        [self setupView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter defaultCenter];
}

#pragma mark - Keyboard notification configuration

- (void)keyboardWillShow:(NSNotification *)note {
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
        return; // BAIL
    }
    
    UIViewAnimationCurve animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat animationDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    _currentKeyboardHeight = keyboardRect.size.height;
    
    self.keyboardHeightConstraint.constant = -1 * keyboardRect.size.height + (_paymentEnabled ? 0 : self.paymentButton.bounds.size.height);
    
    [self.paymentButton setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:animationOptionsWithCurve(animationCurve) animations:^{
        [self.paymentButton layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)note {
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
        return; // BAIL
    }
    
    UIViewAnimationCurve animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat animationDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    _currentKeyboardHeight = 0.0;
    
    self.keyboardHeightConstraint.constant = (_paymentEnabled ? 0 : self.paymentButton.bounds.size.height);
    
    [self.paymentButton setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:animationOptionsWithCurve(animationCurve) animations:^{
        [self.paymentButton layoutIfNeeded];
    } completion:nil];
}

#pragma mark - View Lifecycle

/* 
 self.maestroFieldsHeightConstraint = NSLayoutConstraint(item: startDateInputField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 1.0)
 self.avsFieldsHeightConstraint = NSLayoutConstraint(item: billingCountryInputField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
 self.securityMessageTopConstraint = NSLayoutConstraint(item: securityMessageLabel, attribute: .Top, relatedBy: .Equal, toItem: self.hintLabel, attribute: .Bottom, multiplier: 1.0, constant: -self.hintLabel.bounds.height)

 */

- (void)setupView {
    
    NSString *paymentButtonTitle = self.transactionType == TransactionTypeRegisterCard ? self.theme.registerCardTitle : self.theme.paymentButtonTitle;
    
    self.loadingView.actionLabel.text = self.transactionType == TransactionTypeRegisterCard ? self.theme.loadingIndicatorRegisterCardTitle : self.theme.loadingIndicatorProcessingTitle;
    
    [self.paymentButton setTitle:paymentButtonTitle forState:UIControlStateNormal];
    
    self.startDateInputField.isStartDate = YES;
    
    // View
    [self addSubview:self.contentView];
    self.contentView.contentSize = self.bounds.size;
    
    self.backgroundColor = [self.theme judoContentViewBackgroundColor];
    
    [self.contentView addSubview:self.cardInputField];
    [self.contentView addSubview:self.startDateInputField];
    [self.contentView addSubview:self.issueNumberInputField];
    [self.contentView addSubview:self.expiryDateInputField];
    [self.contentView addSubview:self.securityCodeInputField];
    [self.contentView addSubview:self.billingCountryInputField];
    [self.contentView addSubview:self.postCodeInputField];
    [self.contentView addSubview:self.hintLabel];
    [self.contentView addSubview:self.securityMessageLabel];
    
    [self addSubview:self.paymentButton];
    [self addSubview:self.threeDSWebView];
    [self addSubview:self.loadingView];
    
    self.hintLabel.font = [UIFont systemFontOfSize:14];
    self.hintLabel.numberOfLines = 3;
    self.hintLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Delegates
    self.cardInputField.delegate = self;
    self.startDateInputField.delegate = self;
    self.issueNumberInputField.delegate = self;
    self.expiryDateInputField.delegate = self;
    self.securityCodeInputField.delegate = self;
    self.billingCountryInputField.delegate = self;
    self.postCodeInputField.delegate = self;
    
    // Layout Constraints
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[scrollView]|" options:0 metrics:nil views:@{@"scrollView":self.contentView}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]-1-[button]" options:0 metrics:nil views:@{@"scrollView":self.contentView, @"button":self.paymentButton}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[loadingView]|" options:0 metrics:nil views:@{@"loadingView":self.loadingView}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[loadingView]|" options:0 metrics:nil views:@{@"loadingView":self.loadingView}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[tdsecure]-|" options:0 metrics:nil views:@{@"tdsecure":self.threeDSWebView}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(68)-[tdsecure]-(30)-|" options:0 metrics:nil views:@{@"tdsecure":self.threeDSWebView}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[button]|" options:0 metrics:nil views:@{@"button":self.paymentButton}]];
    
    [self.paymentButton addConstraint:[NSLayoutConstraint constraintWithItem:self.paymentButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50]];
    
    self.keyboardHeightConstraint = [NSLayoutConstraint constraintWithItem:self.paymentButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:_paymentEnabled ? 0 : 50];
    
    [self addConstraint:self.keyboardHeightConstraint];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-1)-[card]-(-1)-|" options:0 metrics:nil views:@{@"card":self.cardInputField}]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cardInputField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:2]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-1)-[expiry]-(-1)-[security(==expiry)]-(-1)-|" options:0 metrics:nil views:@{@"expiry":self.expiryDateInputField, @"security":self.securityCodeInputField}]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-1)-[start]-(-1)-[issue(==start)]-(-1)-|" options:0 metrics:nil views:@{@"start":self.startDateInputField, @"issue":self.issueNumberInputField}]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-1)-[billing]-(-1)-[post(==billing)]-(-1)-|" options:0 metrics:nil views:@{@"billing":self.billingCountryInputField, @"post":self.postCodeInputField}]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(12)-[hint]-(12)-|" options:0 metrics:nil views:@{@"hint":self.hintLabel}]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(12)-[securityMessage]-(12)-|" options:0 metrics:nil views:@{@"securityMessage":self.securityMessageLabel}]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-75-[card(fieldHeight)]-(-1)-[start]-(-1)-[expiry(fieldHeight)]-(-1)-[billing]-(20)-[hint(18)]-(15)-|" options:0 metrics:@{@"fieldHeight":@(self.theme.inputFieldHeight)} views:@{@"card":self.cardInputField, @"start":self.startDateInputField, @"expiry":self.expiryDateInputField, @"billing":self.billingCountryInputField, @"hint":self.hintLabel}]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-75-[card(fieldHeight)]-(-1)-[issue(==start)]-(-1)-[security(fieldHeight)]-(-1)-[post]-(20)-[hint]-(15)-|" options:0 metrics:@{@"fieldHeight":@(self.theme.inputFieldHeight)} views:@{@"card":self.cardInputField, @"issue":self.issueNumberInputField, @"start":self.startDateInputField, @"security":self.securityCodeInputField, @"post":self.postCodeInputField, @"hint":self.hintLabel}]];
    
    self.maestroFieldsHeightConstraint = [NSLayoutConstraint constraintWithItem:self.startDateInputField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1.0];
    
    self.avsFieldsHeightConstraint = [NSLayoutConstraint constraintWithItem:self.billingCountryInputField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.0];
    
    self.securityMessageTopConstraint = [NSLayoutConstraint constraintWithItem:self.securityMessageLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hintLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.hintLabel.bounds.size.height];
    
    self.securityMessageLabel.hidden = !self.theme.showSecurityMessage;
    
    [self.startDateInputField addConstraint:self.maestroFieldsHeightConstraint];
    [self.billingCountryInputField addConstraint:self.avsFieldsHeightConstraint];
    
    [self.contentView addConstraint:self.securityMessageTopConstraint];
    
    if (self.cardDetails) {
        NSString *formattedLastFour = [self.cardDetails formattedCardLastFour];
        NSString *formattedExpiryDate = [self.cardDetails formattedExpiryDate];
        [self updateInputFieldsWithNetwork:self.cardDetails.cardNetwork];
        self.cardInputField.textField.text = formattedLastFour;
        self.expiryDateInputField.textField.text = formattedExpiryDate;
        [self updateInputFieldsWithNetwork:[self.cardDetails cardNetwork]];
        self.securityCodeInputField.isTokenPayment = YES;
        self.cardInputField.isTokenPayment = YES;
        self.cardInputField.userInteractionEnabled = NO;
        self.expiryDateInputField.userInteractionEnabled = NO;
    }
}

- (void)toggleStartDateVisibility:(BOOL)isVisible {
    self.maestroFieldsHeightConstraint.constant = isVisible ? self.theme.inputFieldHeight : 1;
    [self.issueNumberInputField setNeedsUpdateConstraints];
    [self.startDateInputField setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.issueNumberInputField layoutIfNeeded];
        [self.startDateInputField layoutIfNeeded];
        
        [self.expiryDateInputField layoutIfNeeded];
        [self.securityCodeInputField layoutIfNeeded];
    }];
}

- (void)toggleAVSVisibility:(BOOL)isVisible completion:(void (^)())completion {
    self.avsFieldsHeightConstraint.constant = isVisible ? self.theme.inputFieldHeight : 0;
    [self.billingCountryInputField setNeedsUpdateConstraints];
    [self.postCodeInputField setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.billingCountryInputField layoutIfNeeded];
        [self.postCodeInputField layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)updateInputFieldsWithNetwork:(CardNetwork)network {
    self.cardInputField.cardNetwork = network;
    [self.cardInputField updateCardLogo];
    self.securityCodeInputField.cardNetwork = network;
    [self.securityCodeInputField updateCardLogo];
    self.securityCodeInputField.textField.placeholder = [JPCardDetails titleForCardNetwork:network];
}

- (void)paymentEnabled:(BOOL)enabled {
    _paymentEnabled = enabled;
    self.paymentButton.hidden = !enabled;
    
    self.keyboardHeightConstraint.constant = -_currentKeyboardHeight + (_paymentEnabled ? 0 : self.paymentButton.bounds.size.height);
    
    [self.paymentButton setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:(enabled ? UIViewAnimationOptionCurveEaseOut : UIViewAnimationOptionCurveEaseIn) animations:^{
        [self.paymentButton layoutIfNeeded];
    } completion:nil];
    
    self.paymentNavBarButton.enabled = enabled;
}

- (void)showHintAfterDefaultDelay:(JPInputField *)input {
    if (self.securityCodeInputField.isTokenPayment && !self.securityCodeInputField.textField.text.length) {
        [self.hintLabel showHint:self.securityCodeInputField.hintLabelText];
    } else {
        [self.hintLabel hideHint];
    }
    
    [self updateSecurityMessagePosition:false];
    
    [NSTimer scheduleWithDelay:3.0 handler:^(CFRunLoopTimerRef runLoopTimerRef) {
        NSString *hintLabelText = input.hintLabelText;
        if (hintLabelText.length && !input.textField.text.length && input.textField.isFirstResponder) {
            [self updateSecurityMessagePosition:false];
            [self.hintLabel showHint:hintLabelText];
        }
    }];
}

- (void)updateSecurityMessagePosition:(BOOL)toggleUp {
    [self.contentView layoutIfNeeded];
    self.securityMessageTopConstraint.constant = (toggleUp && !self.hintLabel.isActive) ? -self.hintLabel.bounds.size.height : 14.0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView layoutIfNeeded];
    }];
}

- (void)showAlertOnHintLabel:(NSString *)message {
    [self.hintLabel showAlert:message];
    [self updateSecurityMessagePosition:NO];
}

- (void)hideAlertOnHintLabel {
    [self.hintLabel hideAlert];
    [self updateSecurityMessagePosition:YES];
}

#pragma mark - Lazy Loading

- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _contentView.directionalLockEnabled = YES;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentView;
}

- (LoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [LoadingView new];
    }
    return _loadingView;
}

- (JP3DSWebView *)threeDSWebView {
    if (!_threeDSWebView) {
        _threeDSWebView = [JP3DSWebView new];
        _threeDSWebView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _threeDSWebView;
}

- (CardInputField *)cardInputField {
    if (!_cardInputField) {
        _cardInputField = [CardInputField new];
        _cardInputField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _cardInputField;
}

- (DateInputField *)startDateInputField {
    if (!_startDateInputField) {
        _startDateInputField = [DateInputField new];
        _startDateInputField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _startDateInputField;
}

- (IssueNumberInputField *)issueNumberInputField {
    if (!_issueNumberInputField) {
        _issueNumberInputField = [IssueNumberInputField new];
        _issueNumberInputField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _issueNumberInputField;
}

- (DateInputField *)expiryDateInputField {
    if (!_expiryDateInputField) {
        _expiryDateInputField = [DateInputField new];
        _expiryDateInputField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _expiryDateInputField;
}

- (SecurityCodeInputField *)securityCodeInputField {
    if (!_securityCodeInputField) {
        _securityCodeInputField = [SecurityCodeInputField new];
        _securityCodeInputField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _securityCodeInputField;
}

- (BillingCountryInputField *)billingCountryInputField {
    if (!_billingCountryInputField) {
        _billingCountryInputField = [BillingCountryInputField new];
        _billingCountryInputField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _billingCountryInputField;
}

- (PostCodeInputField *)postCodeInputField {
    if (!_postCodeInputField) {
        _postCodeInputField = [PostCodeInputField new];
        _postCodeInputField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _postCodeInputField;
}

- (HintLabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [HintLabel new];
        _hintLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _hintLabel;
}

- (UILabel *)securityMessageLabel {
    if (!_securityMessageLabel) {
        _securityMessageLabel = [UILabel new];
        _securityMessageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _securityMessageLabel.numberOfLines = 0;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Secure server: " attributes:@{NSForegroundColorAttributeName:self.theme.judoDarkGrayColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:self.theme.securityMessageTextSize]}];
        
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:self.theme.securityMessageString attributes:@{NSForegroundColorAttributeName:self.theme.judoDarkGrayColor, NSFontAttributeName:[UIFont systemFontOfSize:self.theme.securityMessageTextSize]}]];
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment = NSTextAlignmentJustified;
        paragraphStyle.lineSpacing = 3.0f;
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
        _securityMessageLabel.attributedText = attributedString;
    }
    return _securityMessageLabel;
}

- (UIButton *)paymentButton {
	if (!_paymentButton) {
		_paymentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _paymentButton.translatesAutoresizingMaskIntoConstraints = NO;
        _paymentButton.backgroundColor = self.theme.judoButtonColor;
        [_paymentButton setTitle:@"Pay" forState:UIControlStateNormal];
        [_paymentButton setTitleColor:self.theme.judoButtonTitleColor forState:UIControlStateNormal];
        [_paymentButton.titleLabel setFont:[UIFont boldSystemFontOfSize:22.0]];
	}
	return _paymentButton;
}

- (NSString *)transactionTitle {
    switch (self.transactionType) {
        case TransactionTypePayment:
        case TransactionTypePreAuth:
            return self.theme.paymentTitle;
        case TransactionTypeRegisterCard:
            return self.theme.registerCardTitle;
        case TransactionTypeRefund:
            return self.theme.refundTitle;
        default:
            return @"Invalid";
    }
}

#pragma mark - JudoPayInputDelegate

- (void)cardInput:(CardInputField *)input didFailWithError:(NSError *)error {
    [input errorAnimation:(error.code != JudoErrorInputMismatchError)];
    if (error.userInfo[NSLocalizedDescriptionKey]) {
        [self showAlertOnHintLabel:error.userInfo[NSLocalizedDescriptionKey]];
    }
}

- (void)cardInput:(CardInputField *)input didFindValidNumber:(NSString *)cardNumberString {
    if (input.cardNetwork == CardNetworkMaestro) {
        [self.startDateInputField.textField becomeFirstResponder];
    } else {
        [self.expiryDateInputField.textField becomeFirstResponder];
    }
}

- (void)cardInput:(CardInputField *)input didDetectNetwork:(CardNetwork)network {
    [self updateInputFieldsWithNetwork:network];
    [self.hintLabel hideAlert];
    [self updateSecurityMessagePosition:YES];
}

- (void)dateInput:(DateInputField *)input didFailWithError:(NSError *)error {
    [input errorAnimation:(error.code == JudoErrorInputMismatchError)];
    if (error.userInfo[NSLocalizedDescriptionKey]) {
        [self showAlertOnHintLabel:error.userInfo[NSLocalizedDescriptionKey]];
    }
}

- (void)dateInput:(DateInputField *)input didFindValidDate:(NSDate *)date {
    [self hideAlertOnHintLabel];
    if (input == self.startDateInputField) {
        [self.issueNumberInputField.textField becomeFirstResponder];
    } else {
        [self.securityCodeInputField.textField becomeFirstResponder];
    }
}

- (void)issueNumberInputDidEnterCode:(IssueNumberInputField *)input withIssueNumber:(NSString *)issueNumber {
    if (issueNumber.length == 3) {
        [self.expiryDateInputField.textField becomeFirstResponder];
    }
}

- (void)billingCountryInput:(BillingCountryInputField *)input didSelect:(BillingCountry)billingCountry {
    self.postCodeInputField.billingCountry = billingCountry;
    self.postCodeInputField.textField.text = @"";
    self.postCodeInputField.userInteractionEnabled = billingCountry != BillingCountryOther;
    [self judoPayInputDidChangeText:self.billingCountryInputField];
}

- (void)postCodeInputField:(PostCodeInputField *)input didFailWithError:(NSError *)error {
    if (error.userInfo[NSLocalizedDescriptionKey]) {
        [self showAlertOnHintLabel:error.userInfo[NSLocalizedDescriptionKey]];
    }
}

- (void)judoPayInput:(JPInputField *)input didValidate:(BOOL)valid {
    if (input == self.securityCodeInputField) {
        if (self.theme.avsEnabled) {
            if (valid) {
                [self.postCodeInputField.textField becomeFirstResponder];
                [self toggleAVSVisibility:YES completion:^{
                    [self.contentView scrollRectToVisible:self.postCodeInputField.frame animated:YES];
                }];
            }
        }
    } else if (input == self.postCodeInputField) {
        [self hideAlertOnHintLabel];
    }
}

- (void)judoPayInputDidChangeText:(JPInputField *)input {
    [self showHintAfterDefaultDelay:input];
    BOOL allFieldsValid = NO;
    allFieldsValid = self.cardInputField.isValid && self.expiryDateInputField.isValid && self.securityCodeInputField.isValid;
    if (self.theme.avsEnabled) {
        allFieldsValid = allFieldsValid && self.postCodeInputField.isValid && self.billingCountryInputField.isValid;
    }
    if (self.cardInputField.cardNetwork == CardNetworkMaestro) {
        allFieldsValid = allFieldsValid && (self.issueNumberInputField.isValid || self.startDateInputField.isValid);
    }
    [self paymentEnabled:allFieldsValid];
}

@end
