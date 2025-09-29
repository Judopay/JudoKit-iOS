//
//  JPCardCustomizationIsDefaultCell.m
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

#import "JPCardCustomizationIsDefaultCell.h"
#import "JPCardCustomizationViewModel.h"
#import "JPTheme.h"
#import "NSString+Additions.h"
#import "UIImage+Additions.h"
#import "UIStackView+Additions.h"
#import "UIColor+Additions.h"

@interface JPCardCustomizationIsDefaultCell ()
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIImageView *checkmarkImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation JPCardCustomizationIsDefaultCell

#pragma mark - Constants

const float kIsDefaultStackViewSpacing = 8.0F;
const float kIsDefaultStackViewVerticalPadding = 0.0F;
const float kIsDefaultStackViewHorizontalPadding = 24.0F;
const float kIsDefaultStackViewHeight = 23.0F;
const float kIsDefaultCheckmarkImageWidth = 23.0F;

#pragma mark - Theming

- (void)applyTheme:(JPTheme *)theme {
    self.titleLabel.textColor = theme.jpBlackColor;
    self.titleLabel.font = theme.body;
}

#pragma mark - Initializers

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

#pragma mark - View Model Configuration

- (void)configureWithViewModel:(JPCardCustomizationViewModel *)viewModel {
    if ([viewModel isKindOfClass:JPCardCustomizationIsDefaultModel.class]) {
        JPCardCustomizationIsDefaultModel *isDefaultModel;
        isDefaultModel = (JPCardCustomizationIsDefaultModel *)viewModel;
        [self setCheckmarkIconForIsDefault:isDefaultModel.isDefault];
    }
}

- (void)setCheckmarkIconForIsDefault:(BOOL)isDefault {
    NSString *iconName = isDefault ? @"radio-on" : @"radio-off";
    UIImage *iconImage = [UIImage _jp_imageWithIconName:iconName];

    if (!isDefault) {
        // Apply extra tint for accessibility contrast.
        self.checkmarkImageView.tintColor = UIColor._jp_graphiteGrayColor;
        self.checkmarkImageView.image =
            [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else {
        self.checkmarkImageView.image = [UIImage _jp_imageWithIconName:iconName];
    }
}

#pragma mark - Layout setup

- (void)setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self.stackView addArrangedSubview:self.checkmarkImageView];
    [self.stackView addArrangedSubview:self.titleLabel];
    [self.contentView addSubview:self.stackView];
    [self setupConstraints];
}

- (void)setupConstraints {
    NSArray *constraints = @[
        [self.stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor
                                                 constant:kIsDefaultStackViewVerticalPadding],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor
                                                    constant:-kIsDefaultStackViewVerticalPadding],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor
                                                     constant:kIsDefaultStackViewHorizontalPadding],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor
                                                      constant:-kIsDefaultStackViewHorizontalPadding],
        [self.stackView.heightAnchor constraintEqualToConstant:kIsDefaultStackViewHeight],
        [self.checkmarkImageView.widthAnchor constraintEqualToConstant:kIsDefaultCheckmarkImageWidth],
    ];
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Lazy properties

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [UIStackView _jp_horizontalStackViewWithSpacing:kIsDefaultStackViewSpacing];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _stackView;
}

- (UIImageView *)checkmarkImageView {
    if (!_checkmarkImageView) {
        _checkmarkImageView = [UIImageView new];
        _checkmarkImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _checkmarkImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _checkmarkImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.text = @"jp_save_as_default_payment_method"._jp_localized;
    }
    return _titleLabel;
}

@end
