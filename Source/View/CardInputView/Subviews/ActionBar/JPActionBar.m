//
//  JPActionBar.m
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

#import "JPActionBar.h"
#import "JPTheme.h"
#import "JPTransactionButton.h"
#import "JPTransactionScanCardButton.h"
#import "UIColor+Additions.h"
#import "UIStackView+Additions.h"
#import "UIView+Additions.h"

@implementation JPActionBar

#pragma mark - Constants

static const float kScanButtonCornerRadius = 4.0F;
static const float kButtonsContentSpacing = 20.0F;
static const float kScanButtonBorderWidth = 1.0F;
static const float kActionButtonHeight = 56.0F;
static const float kScanCardHeight = 36.0F;

- (instancetype)init {
    if (self = [super init]) {
        _actions = JPActionBarActionTypeUnknown;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithActions:(JPActionBarActionType)actions {
    if (self = [super init]) {
        _actions = actions;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.axis = UILayoutConstraintAxisHorizontal;
    self.spacing = kButtonsContentSpacing;

    self.cancelButton = [JPTransactionButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;

    self.scanCardButton = [JPTransactionScanCardButton buttonWithType:UIButtonTypeSystem];
    self.scanCardButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.scanCardButton.imageView.bounds = CGRectMake(0, 0, 24, 24);
    self.scanCardButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.scanCardButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.scanCardButton.contentEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 10);

    self.backButton = [JPTransactionButton buttonWithType:UIButtonTypeSystem];
    self.backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 30);
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.backButton.accessibilityIdentifier = @"Back Button";
    self.backButton.clipsToBounds = YES;

    self.submitButton = [JPTransactionButton new];
    self.submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.submitButton.accessibilityIdentifier = @"Submit Button";
    self.submitButton.clipsToBounds = YES;

    [self reloadArrangedSubviews];
    [self setupConstraints];
    [self setupCallbacks];
}

- (void)reloadArrangedSubviews {
    [self _jp_removeArrangedSubviews];

    if (self.actions & JPActionBarActionTypeCancel) {
        [self addArrangedSubview:self.cancelButton];
        [self addArrangedSubview:[UIView new]];
    }

    if (self.actions & JPActionBarActionTypeScanCard) {
        [self addArrangedSubview:self.scanCardButton];
    }

    if (self.actions & JPActionBarActionTypeNavigateBack) {
        [self addArrangedSubview:self.backButton];
    }

    if (self.actions & JPActionBarActionTypeSubmit) {
        [self addArrangedSubview:self.submitButton];
    }
}

- (void)setupConstraints {
    [self.cancelButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.cancelButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.scanCardButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.scanCardButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.backButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.backButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.submitButton setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    [NSLayoutConstraint activateConstraints:@[
        [self.cancelButton.heightAnchor constraintEqualToConstant:kScanCardHeight],
        [self.scanCardButton.heightAnchor constraintEqualToConstant:kScanCardHeight],
        [self.backButton.heightAnchor constraintEqualToConstant:kActionButtonHeight],
        [self.submitButton.heightAnchor constraintEqualToConstant:kActionButtonHeight],
    ]];
}

- (void)setupCallbacks {
    [self.cancelButton addTarget:self action:@selector(onButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.scanCardButton addTarget:self action:@selector(onButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(onButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton addTarget:self action:@selector(onButtonTap:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onButtonTap:(UIButton *)sender {
    if (sender == self.cancelButton) {
        [self.delegate actionBar:self didPerformAction:JPActionBarActionTypeCancel];
    }

    if (sender == self.scanCardButton) {
        [self.delegate actionBar:self didPerformAction:JPActionBarActionTypeScanCard];
    }

    if (sender == self.backButton) {
        [self.delegate actionBar:self didPerformAction:JPActionBarActionTypeNavigateBack];
    }

    if (sender == self.submitButton) {
        [self.delegate actionBar:self didPerformAction:JPActionBarActionTypeSubmit];
    }
}

- (void)applyTheme:(JPTheme *)theme {
    self.cancelButton.titleLabel.font = theme.bodyBold;
    [self.cancelButton setTitleColor:theme.jpBlackColor forState:UIControlStateNormal];

    self.scanCardButton.titleLabel.font = theme.bodyBold;
    [self.scanCardButton setTitleColor:theme.jpBlackColor forState:UIControlStateNormal];
    [self.scanCardButton setTintColor:theme.jpBlackColor];
    [self.scanCardButton _jp_setBorderWithColor:theme.jpBlackColor
                                          width:kScanButtonBorderWidth
                                andCornerRadius:kScanButtonCornerRadius];

    self.submitButton.titleLabel.font = theme.headline;
    self.submitButton.layer.cornerRadius = theme.buttonCornerRadius;
    [self.submitButton setBackgroundImage:theme.buttonColor._jp_asImage forState:UIControlStateNormal];
    [self.submitButton setTitleColor:theme.buttonTitleColor forState:UIControlStateNormal];

    self.backButton.titleLabel.font = theme.bodyBold;
    [self.backButton setTitleColor:theme.jpBlackColor forState:UIControlStateNormal];
    self.backButton.titleLabel.font = theme.headline;
}

- (void)setActions:(JPActionBarActionType)actions {
    _actions = actions;
    [self reloadArrangedSubviews];
    [self setupConstraints];
}

@end
