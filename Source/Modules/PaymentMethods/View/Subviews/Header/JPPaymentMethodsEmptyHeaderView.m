//
//  JPPaymentMethodsEmptyHeaderView.m
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

#import "JPPaymentMethodsEmptyHeaderView.h"
#import "JPPaymentMethodsViewModel.h"
#import "JPTheme.h"
#import "NSString+Additions.h"
#import "UIStackView+Additions.h"

@interface JPPaymentMethodsEmptyHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation JPPaymentMethodsEmptyHeaderView

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
    self.titleLabel.font = theme.title;
    self.titleLabel.textColor = theme.jpBlackColor;
    self.textLabel.font = theme.body;
    self.textLabel.textColor = theme.jpBlackColor;
}

#pragma mark - Layout Setup

- (void)setupViews {
    UIStackView *stackView = [UIStackView verticalStackViewWithSpacing:8.0];

    [stackView addArrangedSubview:self.titleLabel];
    [stackView addArrangedSubview:self.textLabel];

    [self addSubview:stackView];

    [stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:24].active = YES;
    [stackView.widthAnchor constraintEqualToConstant:227.0].active = YES;
    [stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:50].active = YES;
}

#pragma mark - Lazy Properties

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"choose_payment_method".localized;
        _titleLabel.numberOfLines = 0;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.numberOfLines = 0;
        _textLabel.text = @"no_cards_added".localized;
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textLabel;
}

@end
