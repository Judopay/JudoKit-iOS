//
//  JPPhoneCodeInputField.m
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

#import "JPPhoneCodeInputField.h"
#import "JPFloatingTextField.h"
#import "JPTheme.h"

@interface JPPhoneCodeInputField ()

@property (nonatomic, strong) JPTheme *theme;
@property (nonatomic, strong) JPFloatingTextField *floatingTextField;
@property (nonatomic, strong) UILabel *leftDecorationLabel;
@property (nonatomic, strong) UILabel *rightDecorationLabel;

@end

@implementation JPPhoneCodeInputField

@dynamic theme;
@dynamic floatingTextField;

#pragma mark - Initializers

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Overrides
- (void)configureWithViewModel:(JPTransactionInputFieldViewModel *)viewModel {
    [super configureWithViewModel:viewModel];
    [self invalidateIntrinsicContentSize];
}

#pragma mark - Theming

- (void)applyTheme:(JPTheme *)theme {
    [super applyTheme:theme];

    self.leftDecorationLabel.textColor = self.theme.jpBlackColor;
    self.rightDecorationLabel.textColor = self.theme.jpBlackColor;

    self.leftDecorationLabel.font = self.theme.caption;
    self.rightDecorationLabel.font = self.theme.caption;
}

#pragma mark - Helpers

- (void)commonInit {
    self.leftDecorationLabel = [self sideViewWithText:@"+("];
    self.rightDecorationLabel = [self sideViewWithText:@")"];

    self.floatingTextField.leftView = self.leftDecorationLabel;
    self.floatingTextField.rightView = self.rightDecorationLabel;
    self.floatingTextField.leftViewMode = UITextFieldViewModeAlways;
    self.floatingTextField.rightViewMode = UITextFieldViewModeAlways;
}

- (UILabel *)sideViewWithText:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    label.textColor = self.floatingTextField.textColor;
    label.font = self.floatingTextField.font;
    if (@available(iOS 13.0, *)) {
        label.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    [label sizeToFit];
    return label;
}

- (CGSize)intrinsicContentSize {
    UITextField *textField = self.floatingTextField;
    UIFont *font = textField.font ?: [UIFont systemFontOfSize:17.0];
    NSString *text = textField.text ?: @"";

    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName : font}];
    CGFloat width = textSize.width;

    if (textField.leftView && textField.leftViewMode != UITextFieldViewModeNever) {
        width += CGRectGetWidth(textField.leftView.frame);
    }

    if (textField.rightView && textField.rightViewMode != UITextFieldViewModeNever) {
        width += CGRectGetWidth(textField.rightView.frame);
    }

    CGFloat height = textField.intrinsicContentSize.height;

    return CGSizeMake(width, height);
}

@end
