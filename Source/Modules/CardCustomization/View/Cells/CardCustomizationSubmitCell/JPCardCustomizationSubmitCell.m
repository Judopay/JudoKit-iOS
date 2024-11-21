//
//  JPCardCustomizationSubmitCell.m
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

#import "JPCardCustomizationSubmitCell.h"
#import "Functions.h"
#import "JPCardCustomizationViewModel.h"
#import "JPTheme.h"
#import "NSString+Additions.h"
#import "UIColor+Additions.h"
#import "UIStackView+Additions.h"

@interface JPCardCustomizationSubmitCell ()

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation JPCardCustomizationSubmitCell

#pragma mark - Constants

const float kSubmitStackViewSpacing = 3.0F;
const float kSubmitStackViewTop = 70.0F;
const float kSubmitStackViewBottom = 30.0F;
const float kSubmitStackViewLeading = 0.0F;
const float kSubmitStackViewTrailing = 24.0F;
const float kSubmitStackViewHeight = 46.0F;
const float kSubmitSaveButtonWidth = 200.0F;

#pragma mark - Theming

- (void)applyTheme:(JPTheme *)theme {
    self.cancelButton.titleLabel.font = theme.headline;
    [self.cancelButton setTitleColor:theme.jpBlackColor
                            forState:UIControlStateNormal];
    self.saveButton.titleLabel.font = theme.headline;
    [self.saveButton setBackgroundImage:theme.buttonColor._jp_asImage
                               forState:UIControlStateNormal];
    [self.saveButton setTitleColor:theme.buttonTitleColor
                          forState:UIControlStateNormal];
    self.saveButton.layer.cornerRadius = theme.buttonCornerRadius;
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
    if ([viewModel isKindOfClass:JPCardCustomizationSubmitModel.class]) {
        JPCardCustomizationSubmitModel *submitModel;
        submitModel = (JPCardCustomizationSubmitModel *)viewModel;
        self.saveButton.enabled = submitModel.isSaveEnabled;
    }
}

#pragma mark - User Actions

- (void)didTapSaveButton {
    [self.delegate didTapSaveForSubmitCell:self];
}

- (void)didTapCancelButton {
    [self.delegate didTapCancelForSubmitCell:self];
}

#pragma mark - Layout setup

- (void)setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self.stackView addArrangedSubview:self.cancelButton];
    [self.stackView addArrangedSubview:self.saveButton];
    [self.contentView addSubview:self.stackView];

    [self setupConstraints];
}

- (void)setupConstraints {
    NSArray *constraints = @[
        [self.stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor
                                                 constant:kSubmitStackViewTop],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor
                                                    constant:-kSubmitStackViewBottom],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor
                                                     constant:kSubmitStackViewLeading],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor
                                                      constant:-kSubmitStackViewTrailing],
        [self.stackView.heightAnchor constraintEqualToConstant:kSubmitStackViewHeight],
        [self.saveButton.widthAnchor constraintEqualToConstant:kSubmitSaveButtonWidth * getWidthAspectRatio()],
    ];
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Lazy properties

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [UIStackView _jp_horizontalStackViewWithSpacing:kSubmitStackViewSpacing];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _stackView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_cancelButton setTitle:@"jp_cancel"._jp_localized.uppercaseString
                       forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(didTapCancelButton)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton new];
        _saveButton.translatesAutoresizingMaskIntoConstraints = NO;
        _saveButton.layer.masksToBounds = YES;
        [_saveButton setTitle:@"jp_save"._jp_localized.uppercaseString
                     forState:UIControlStateNormal];
        [_saveButton addTarget:self
                        action:@selector(didTapSaveButton)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

@end
