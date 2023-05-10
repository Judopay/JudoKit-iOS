//
//  JPSecurityMessageView.m
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

#import "JPSecurityMessageView.h"
#import "JPTheme.h"
#import "JPTransactionViewModel.h"
#import "UIStackView+Additions.h"

@interface JPSecurityMessageView ()

@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation JPSecurityMessageView

#pragma mark - Constants

static const float kTightContentSpacing = 8.0F;
static const float kLockImageWidth = 17.0F;
static const float kLockImageHeight = 20.0F;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.lockImageView = [UIImageView new];
    self.lockImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.lockImageView.translatesAutoresizingMaskIntoConstraints = NO;

    self.messageLabel = [UILabel new];
    self.messageLabel.numberOfLines = 0;

    self.spacing = kTightContentSpacing;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.axis = UILayoutConstraintAxisHorizontal;
    self.alignment = UIStackViewAlignmentCenter;

    [self _jp_addArrangedSubviews:@[ self.lockImageView, self.messageLabel ]];

    [NSLayoutConstraint activateConstraints:@[
        [self.lockImageView.widthAnchor constraintEqualToConstant:kLockImageWidth],
        [self.lockImageView.heightAnchor constraintEqualToConstant:kLockImageHeight],
    ]];
}

- (void)applyTheme:(JPTheme *)theme {
    self.messageLabel.font = theme.caption;
    self.messageLabel.textColor = theme.jpDarkGrayColor;
}

- (void)configureWithViewModel:(JPTransactionSecurityMessageViewModel *)viewModel {
    self.messageLabel.text = viewModel.message;
    self.lockImageView.image = viewModel.iconLeft;
}

@end
