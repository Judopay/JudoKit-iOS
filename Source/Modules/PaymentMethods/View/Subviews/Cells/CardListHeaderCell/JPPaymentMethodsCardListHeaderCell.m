//
//  JPPaymentMethodsCardListHeaderCell.m
//  JudoKit-iOS
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

#import "JPPaymentMethodsCardListHeaderCell.h"
#import "JPPaymentMethodsViewModel.h"
#import "JPTheme.h"
#import "UIView+Additions.h"

@implementation JPPaymentMethodsCardListHeaderCell

#pragma mark - Constants

const float kCardListHeaderHorizontalPadding = 24.0f;
const float kCardListHeaderCenterOffset = 10.0f;

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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

#pragma mark - View Model Configuration

- (void)configureWithViewModel:(JPPaymentMethodsModel *)viewModel {

    if (![viewModel isKindOfClass:JPPaymentMethodsCardHeaderModel.class]) {
        return;
    }

    JPPaymentMethodsCardHeaderModel *headerModel;
    headerModel = (JPPaymentMethodsCardHeaderModel *)viewModel;
    self.titleLabel.text = headerModel.title;
    [self.actionButton setTitle:headerModel.editButtonTitle forState:UIControlStateNormal];
}

#pragma mark - Theming

- (void)applyTheme:(JPTheme *)theme {
    self.titleLabel.textColor = theme.jpBlackColor;
    self.titleLabel.font = theme.headline;
    self.actionButton.titleLabel.font = theme.bodyBold;
    [self.actionButton setTitleColor:theme.jpBlackColor forState:UIControlStateNormal];
}

#pragma mark - Layout Setup

- (void)setupViews {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.titleLabel];
    [self addSubview:self.actionButton];

    [self.titleLabel pinToAnchors:JPAnchorTypeLeading
                          forView:self
                      withPadding:kCardListHeaderHorizontalPadding];

    [self.actionButton pinToAnchors:JPAnchorTypeTrailing
                            forView:self
                        withPadding:kCardListHeaderHorizontalPadding];

    [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor
                                                  constant:kCardListHeaderCenterOffset]
        .active = YES;

    [self.actionButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor
                                                    constant:kCardListHeaderCenterOffset]
        .active = YES;
}

#pragma mark - Lazy instantiated properties

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (void)didPressActionButton:(UIButton *)button {
    [self.delegate didTapActionButton];
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [UIButton new];
        _actionButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_actionButton addTarget:self
                          action:@selector(didPressActionButton:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

@end
