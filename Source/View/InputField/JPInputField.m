//
//  JPInputField.m
//  JudoKit_iOS
//
//  Copyright (c) 2020 Alternative Payments Ltd
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

#import "JPInputField.h"
#import "JPInputType.h"
#import "JPTextInputLayout.h"
#import "JPTheme.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIStackView+Additions.h"
#import "UITextField+Additions.h"
#import "UIView+Additions.h"

@interface JPInputField ()
@property (nonatomic, strong) JPTheme *theme;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) JPTextInputLayout *textInputLayout;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, assign) BOOL isSettingText;
@end

@implementation JPInputField

#pragma mark - Constants
static const float kStackViewSpacing = 4.0F;
static const float kEdgeInsets = 8.0F;
static const float kBorderWidth = 1.0F;
static const float kCornerRadius = 6.0F;

#pragma mark - Initializers

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupViews];
    }
    return self;
}

#pragma mark - Theming

- (void)applyTheme:(JPTheme *)theme {
    self.theme = theme;
    self.textColor = theme.jpBlackColor;
    self.font = theme.headlineLight;
    self.placeholderFont = theme.headlineLight;
    self.placeholderColor = theme.jpNeutralGrayColor;
    [self.textInputLayout applyTheme:theme];
}

#pragma mark - Property setters

- (void)setText:(NSString *)text {
    _text = text;
    self.textInputLayout.textField.text = text;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.textInputLayout.textField.textColor = textColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.textInputLayout.textField.font = font;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    self.textInputLayout.placeholderFont = placeholderFont;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.textInputLayout.placeholderColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    UIColor *color = self.placeholderColor ? self.placeholderColor : UIColor._jp_redColor;
    UIFont *font = self.placeholderFont ? self.placeholderFont : UIFont._jp_caption;
    [self.textInputLayout.textField _jp_placeholderWithText:placeholder color:color andFont:font];
}

- (void)setType:(JPInputType)type {
    _type = type;
}

- (void)setInputView:(UIView *)inputView {
    _inputView = inputView;
    self.textInputLayout.textField.inputView = inputView;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;

    if (self.textInputLayout.textField.enabled == enabled) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.1
                     animations:^{
                         weakSelf.textInputLayout.textField.enabled = enabled;
                         weakSelf.alpha = (enabled) ? 1.0 : 0.5;
                     }];
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.textInputLayout.textField.keyboardType = keyboardType;
}

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType {
    _autocapitalizationType = autocapitalizationType;
    self.textInputLayout.textField.autocapitalizationType = autocapitalizationType;
}

- (void)setReturnType:(UIReturnKeyType)returnType {
    _returnType = returnType;
    self.textInputLayout.textField.returnKeyType = returnType;
}

- (void)setTextContentType:(UITextContentType)textContentType {
    if (@available(iOS 10.0, *)) {
        _textContentType = textContentType;
        self.textInputLayout.textField.textContentType = textContentType;
    }
}

- (void)setBackgroundMaskedCorners:(CACornerMask)backgroundMaskedCorners {
    self.layer.maskedCorners = backgroundMaskedCorners;
}

#pragma mark - User Actions

- (void)displayErrorWithText:(NSString *)text {
    self.textInputLayout.textField.textColor = self.theme.jpRedColor;
    [self.textInputLayout displayFloatingLabelWithText:text];
}

- (void)clearError {
    self.textInputLayout.textField.textColor = self.textColor;
    [self.textInputLayout hideFloatingLabel];
}

- (CGSize)intrinsicContentSize {
    CGSize textFieldSize = [self.textInputLayout.textField systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return CGSizeMake(UIViewNoIntrinsicMetric, textFieldSize.height + (kEdgeInsets * 2));
}

- (BOOL)becomeFirstResponder {
    return [self.textInputLayout.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.textInputLayout.textField resignFirstResponder];
}

#pragma mark - Layout setup

- (void)setupViews {
    self.backgroundColor = UIColor._jp_lightGrayColor;

    [self _jp_setBorderWithColor:UIColor._jp_graphiteGrayColor
                           width:kBorderWidth
                 andCornerRadius:kCornerRadius];

    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.isAccessibilityElement = NO;

    [self addSubview:self.stackView];
    [self.stackView addArrangedSubview:self.textInputLayout];
    [self.stackView _jp_pinToView:self withPadding:kEdgeInsets];

    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.textInputLayout.textField action:@selector(becomeFirstResponder)];
    [self addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)dealloc {
    [self removeGestureRecognizer:self.tapGestureRecognizer];
}

- (JPTextInputLayout *)textInputLayout {
    if (!_textInputLayout) {
        _textInputLayout = [JPTextInputLayout new];
        _textInputLayout.translatesAutoresizingMaskIntoConstraints = NO;

        _textInputLayout.textField.font = UIFont._jp_headlineLight;
        _textInputLayout.textField.delegate = self;
        _textInputLayout.textField.textContentType = _textContentType;
    }
    return _textInputLayout;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [UIStackView _jp_horizontalStackViewWithSpacing:kStackViewSpacing];
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _stackView;
}

@end

@implementation JPInputField (UITextFieldDelegate)

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_isSettingText) {
        return NO;
    }
    _isSettingText = YES;
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL shouldChange = [self.delegate inputField:self shouldChangeText:newString];
    _isSettingText = NO;
    return shouldChange;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(inputField:didEndEditing:)]) {
        [self.delegate inputField:self didEndEditing:textField.text];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(inputFieldDidBeginEditing:)]) {
        [self.delegate inputFieldDidBeginEditing:self];
    }
}

@end
