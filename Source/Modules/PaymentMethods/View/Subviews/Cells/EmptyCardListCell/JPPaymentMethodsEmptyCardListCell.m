//
//  JPPaymentMethodsEmptyCardListCell.m
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

#import "JPPaymentMethodsEmptyCardListCell.h"
#import "JPPaymentMethodsViewModel.h"
#import "JPTheme.h"
#import "JPTransactionButton.h"
#import "NSLayoutConstraint+Additions.h"
#import "UIImage+Additions.h"
#import "UIStackView+Additions.h"
#import "UIView+Additions.h"

@interface JPPaymentMethodsEmptyCardListCell ()
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) JPTransactionButton *addCardButton;
@property (nonatomic, copy) void (^onTransactionButtonTapHandler)(void);
@end

@implementation JPPaymentMethodsEmptyCardListCell

#pragma mark - Constants

static const float kHorizontalEdgeInsets = 12.0F;
static const float kStackViewSpacing = 16.0F;
static const float kStackViewTopPadding = 60.0F;
static const float kAddCardButtonHeight = 36.0F;
static const float kAddCardBorderWidth = 1.0F;
static const float kAddCardCornerRadius = 4.0F;
static const int kConstraintPriority = 999;

#pragma mark - View model configuration

- (void)configureWithViewModel:(JPPaymentMethodsModel *)viewModel {

    [self setupViews];
    [self setupConstraints];

    JPPaymentMethodsEmptyListModel *emptyViewModel = (JPPaymentMethodsEmptyListModel *)viewModel;

    if (!emptyViewModel)
        return;

    self.titleLabel.text = emptyViewModel.title;

    [self.addCardButton setTitle:emptyViewModel.addCardButtonTitle
                        forState:UIControlStateNormal];

    UIImage *buttonImage = [UIImage _jp_imageWithIconName:emptyViewModel.addCardButtonIconName];
    [self.addCardButton setImage:buttonImage forState:UIControlStateNormal];
    self.addCardButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.addCardButton.imageEdgeInsets = UIEdgeInsetsMake(kHorizontalEdgeInsets, 0, kHorizontalEdgeInsets, 0);
    self.addCardButton.contentEdgeInsets = UIEdgeInsetsMake(kHorizontalEdgeInsets, 0, kHorizontalEdgeInsets, kHorizontalEdgeInsets);

    self.onTransactionButtonTapHandler = emptyViewModel.onTransactionButtonTapHandler;
}

#pragma mark - User actions

- (void)onTransactionButtonTap {
    self.onTransactionButtonTapHandler();
}

#pragma mark - Theming

- (void)applyTheme:(JPTheme *)theme {
    self.titleLabel.font = theme.headline;
    self.titleLabel.textColor = theme.jpBlackColor;
    self.addCardButton.titleLabel.font = theme.bodyBold;
    self.addCardButton.tintColor = theme.jpBlackColor;
    [self.addCardButton _jp_setBorderWithColor:theme.jpBlackColor
                                         width:kAddCardBorderWidth
                               andCornerRadius:kAddCardCornerRadius];
    [self.addCardButton setTitleColor:theme.jpBlackColor
                             forState:UIControlStateNormal];
}

#pragma mark - Layout setup

- (void)setupViews {
    self.backgroundColor = UIColor.clearColor;
    self.stackView = [UIStackView _jp_verticalStackViewWithSpacing:kStackViewSpacing];
    self.stackView.alignment = UIStackViewAlignmentCenter;
    [self.stackView addArrangedSubview:self.titleLabel];
    [self.stackView addArrangedSubview:self.addCardButton];
    [self.contentView addSubview:self.stackView];
}

- (void)setupConstraints {
    NSArray *constraints = @[
        [self.stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor
                                                 constant:kStackViewTopPadding],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        [self.addCardButton.heightAnchor constraintEqualToConstant:kAddCardButtonHeight],
    ];

    [NSLayoutConstraint _jp_activateConstraints:constraints withPriority:kConstraintPriority];

    [self.addCardButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.addCardButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - Lazy properties

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)addCardButton {
    if (!_addCardButton) {
        _addCardButton = [JPTransactionButton buttonWithType:UIButtonTypeSystem];
        [_addCardButton addTarget:self
                           action:@selector(onTransactionButtonTap)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _addCardButton;
}

@end
