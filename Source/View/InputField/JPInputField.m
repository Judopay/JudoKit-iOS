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
#import "JPFloatingTextField.h"
#import "JPInputType.h"
#import "JPTheme.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UITextField+Additions.h"

@interface JPInputField ()
@property (nonatomic, strong) JPTheme *theme;
@property (nonatomic, strong) JPFloatingTextField *floatingTextField;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, assign) BOOL isSettingText;
@end

@implementation JPInputField

#pragma mark - Constants

static const float kHorizontalEdgeInsets = 10.0F;
static const float kVerticalEdgeInsets = 14.0F;

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
    [self.floatingTextField applyTheme:theme];
}

#pragma mark - Property setters

- (void)setText:(NSString *)text {
    _text = text;
    self.floatingTextField.text = text;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.floatingTextField.textColor = textColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.floatingTextField.font = font;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    self.floatingTextField.placeholderFont = placeholderFont;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.floatingTextField.placeholderColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    UIColor *color = self.placeholderColor ? self.placeholderColor : UIColor._jp_redColor;
    UIFont *font = self.placeholderFont ? self.placeholderFont : UIFont._jp_caption;
    [self.floatingTextField _jp_placeholderWithText:placeholder color:color andFont:font];
}

- (void)setType:(JPInputType)type {
    _type = type;
}

- (void)setInputView:(UIView *)inputView {
    _inputView = inputView;
    self.floatingTextField.inputView = inputView;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;

    if (self.floatingTextField.enabled == enabled) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.1
                     animations:^{
                         weakSelf.floatingTextField.enabled = enabled;
                         weakSelf.alpha = (enabled) ? 1.0 : 0.5;
                     }];
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.floatingTextField.keyboardType = keyboardType;
}

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType {
    _autocapitalizationType = autocapitalizationType;
    self.floatingTextField.autocapitalizationType = autocapitalizationType;
}

- (void)setReturnType:(UIReturnKeyType)returnType {
    _returnType = returnType;
    self.floatingTextField.returnKeyType = returnType;
}

- (void)setTextContentType:(UITextContentType)textContentType {
    if (@available(iOS 10.0, *)) {
        _textContentType = textContentType;
        self.floatingTextField.textContentType = textContentType;
    }
}

- (void)setBackgroundMaskedCorners:(CACornerMask)backgroundMaskedCorners {
    self.layer.maskedCorners = backgroundMaskedCorners;
}

#pragma mark - User Actions

- (void)displayErrorWithText:(NSString *)text {
    self.floatingTextField.textColor = self.theme.jpRedColor;
    [self.floatingTextField displayFloatingLabelWithText:text];
}

- (void)clearError {
    self.floatingTextField.textColor = self.textColor;
    [self.floatingTextField hideFloatingLabel];
}

- (BOOL)becomeFirstResponder {
    return [self.floatingTextField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.floatingTextField resignFirstResponder];
}

#pragma mark - Layout setup

- (void)setupViews {
    self.layer.cornerRadius = 6.0F;
    self.backgroundColor = UIColor._jp_lightGrayColor;

    self.layer.borderWidth = 1.0;
    self.layer.borderColor = UIColor._jp_graphiteGrayColor.CGColor;

    self.translatesAutoresizingMaskIntoConstraints = NO;

    self.isAccessibilityElement = NO;

    [self addSubview:self.stackView];
    [self.stackView addArrangedSubview:self.floatingTextField];

    [NSLayoutConstraint activateConstraints:@[
        [self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor
                                                 constant:kVerticalEdgeInsets],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor
                                                    constant:-kVerticalEdgeInsets],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor
                                                     constant:kHorizontalEdgeInsets],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor
                                                      constant:-kHorizontalEdgeInsets]
    ]];

    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.floatingTextField action:@selector(becomeFirstResponder)];
    [self addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)dealloc {
    [self removeGestureRecognizer:self.tapGestureRecognizer];
}

- (JPFloatingTextField *)floatingTextField {
    if (!_floatingTextField) {
        _floatingTextField = [JPFloatingTextField new];
        _floatingTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _floatingTextField.font = UIFont._jp_headlineLight;
        _floatingTextField.delegate = self;
        if (@available(iOS 10.0, *)) {
            _floatingTextField.textContentType = _textContentType;
        }
    }
    return _floatingTextField;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [UIStackView new];
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
