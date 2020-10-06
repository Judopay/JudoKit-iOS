//
//  JPCardScanView.m
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

#import "JPCardScanView.h"
#import "UIImage+Additions.h"

@implementation JPCardScanView

//------------------------------------------------
// MARK: - Constants
//------------------------------------------------

static CGFloat kHorizontalPadding = 10.0f;
static CGFloat kTitleFontSize = 20.0f;
static CGFloat kSubtitleFontSize = 18.0f;
static CGFloat kTextSpacing = 10.0f;
static CGFloat kVerticalPadding = 60.0f;

//------------------------------------------------
// MARK: - Initializers
//------------------------------------------------

- (instancetype)init {
    if (self = [super init]) {
        [self setupLayout];
        [self setupConstraints];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupLayout];
        [self setupConstraints];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupLayout];
        [self setupConstraints];
    }
    return self;
}

//------------------------------------------------
// MARK: - Layout setup
//------------------------------------------------

- (void)setupLayout {
    [self.cardTextStackView addArrangedSubview:self.titleLabel];
    [self.cardTextStackView addArrangedSubview:self.subtitleLabel];
    [self addSubview:self.cardTextStackView];
    [self addSubview:self.backButton];
    [self addSubview:self.flashButton];
}

- (void)setupConstraints {
    NSArray *stackViewConstraints = @[
        [self.cardTextStackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.cardTextStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:kHorizontalPadding],
        [self.cardTextStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-kHorizontalPadding],
    ];

    NSArray *backButtonConstraints = @[
        [self.backButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:kHorizontalPadding * 2],
        [self.backButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:kVerticalPadding], //todo: safe anchor
    ];

    NSArray *flashButtonConstraints = @[
        [self.flashButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:kHorizontalPadding],
        [self.flashButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:kVerticalPadding],
        [self.flashButton.heightAnchor constraintEqualToConstant:30.0],
    ];

    [NSLayoutConstraint activateConstraints:stackViewConstraints];
    [NSLayoutConstraint activateConstraints:backButtonConstraints];
    [NSLayoutConstraint activateConstraints:flashButtonConstraints];
}

//------------------------------------------------
// MARK: - Lazy initializers
//------------------------------------------------

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton new];
        _backButton.translatesAutoresizingMaskIntoConstraints = NO;
        _backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_backButton setTitle:@"Cancel" forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UIButton *)flashButton {
    if (!_flashButton) {
        _flashButton = [UIButton new];
        _flashButton.translatesAutoresizingMaskIntoConstraints = NO;
        _flashButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_flashButton setImage:[UIImage imageWithIconName:@"flash"] forState:UIControlStateNormal];
    }
    return _flashButton;
}

- (UIStackView *)cardTextStackView {
    if (!_cardTextStackView) {
        _cardTextStackView = [UIStackView new];
        _cardTextStackView.axis = UILayoutConstraintAxisVertical;
        _cardTextStackView.alignment = UIStackViewAlignmentCenter;
        _cardTextStackView.spacing = kTextSpacing;
        _cardTextStackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _cardTextStackView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"Position your card in this frame";
        _titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize weight:UIFontWeightBold];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.text = @"We will do our best to scan it";
        _subtitleLabel.font = [UIFont systemFontOfSize:kSubtitleFontSize];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subtitleLabel;
}

@end
