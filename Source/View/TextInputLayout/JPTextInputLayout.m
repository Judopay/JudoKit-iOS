//
//  JPTextInputLayout.m
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

#import "JPTextInputLayout.h"
#import "JPTheme.h"
#import "UIStackView+Additions.h"
#import "UIView+Additions.h"

@interface JPTextInputLayout ()

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UILabel *floatingLabel;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation JPTextInputLayout

#pragma mark - Constants

static const float kStackViewSpacing = 4.0F;
static const float kFloatingLabelTranslationTy = 20;
static const float kFloatingLabelAnimationDuration = 0.3F;
static const float kFloatingLabelAnimationDamping = 0.8F;
static const float kFloatingLabelAnimationVelocity = 0.5F;
static const float kPrefferedCompressedHeight = 40.0F;

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

- (void)commonInit {
    self.isAccessibilityElement = NO;

    [self addSubview:self.stackView];

    [self.stackView _jp_addArrangedSubviews:@[ self.floatingLabel, self.textField ]];
    [self.stackView _jp_pinToView:self withPadding:0];
}

#pragma mark - Theming

- (void)applyTheme:(JPTheme *)theme {
    self.floatingLabel.textColor = theme.jpRedColor;
    self.floatingLabel.font = theme.caption;
}

#pragma mark - View layout

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, kPrefferedCompressedHeight);
}

#pragma mark - Internal logic
- (void)displayFloatingLabelWithText:(NSString *)text {
    self.floatingLabel.text = text;

    if (!self.floatingLabel.hidden) {
        return;
    }

    self.floatingLabel.hidden = NO;
    self.floatingLabel.alpha = 0;
    self.floatingLabel.transform = CGAffineTransformMakeTranslation(0, kFloatingLabelTranslationTy);

    [UIView animateWithDuration:kFloatingLabelAnimationDuration
                          delay:0
         usingSpringWithDamping:kFloatingLabelAnimationDamping
          initialSpringVelocity:kFloatingLabelAnimationVelocity
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.floatingLabel.alpha = 1;
                         self.floatingLabel.transform = CGAffineTransformIdentity;
                         [self.stackView layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)hideFloatingLabel {
    if (self.floatingLabel.hidden) {
        return;
    }

    [UIView animateWithDuration:kFloatingLabelAnimationDuration
        delay:0
        options:UIViewAnimationOptionCurveEaseIn
        animations:^{
            self.floatingLabel.alpha = 0;
            self.floatingLabel.transform = CGAffineTransformMakeTranslation(0, kFloatingLabelTranslationTy);
            [self.stackView layoutIfNeeded];
        }
        completion:^(BOOL finished) {
            self.floatingLabel.hidden = YES;
            self.floatingLabel.transform = CGAffineTransformIdentity;
        }];
}

#pragma mark - Lazy properties

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [UIStackView _jp_verticalStackViewWithSpacing:kStackViewSpacing];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _stackView;
}

- (UILabel *)floatingLabel {
    if (!_floatingLabel) {
        _floatingLabel = [UILabel new];
        _floatingLabel.translatesAutoresizingMaskIntoConstraints = NO;

        _floatingLabel.numberOfLines = 0;
        _floatingLabel.lineBreakMode = NSLineBreakByWordWrapping;

        _floatingLabel.hidden = YES;

        _floatingLabel.isAccessibilityElement = YES;
        _floatingLabel.accessibilityIdentifier = @"Error Floating Label";
    }
    return _floatingLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textField;
}

@end
