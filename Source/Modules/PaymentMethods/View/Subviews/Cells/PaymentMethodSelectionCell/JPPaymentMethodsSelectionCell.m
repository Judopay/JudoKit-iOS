//
//  JPPaymentMethodsSelectionCell.m
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

#import "JPPaymentMethodsSelectionCell.h"
#import "JPPaymentMethod.h"
#import "JPPaymentMethodsViewModel.h"
#import "JPSection.h"
#import "JPSectionView.h"
#import "NSLayoutConstraint+Additions.h"
#import "UIImage+Additions.h"
#import "UIView+Additions.h"

@interface JPPaymentMethodsSelectionCell ()

@property (nonatomic, strong) JPTheme *theme;

@end

@implementation JPPaymentMethodsSelectionCell

#pragma mark - Constants

static const float kSectionViewHeight = 64.0F;
static const int kConstraintPriority = 999;

#pragma mark - Theming

- (void)applyTheme:(JPTheme *)theme {
    self.theme = theme;
    self.backgroundColor = UIColor.whiteColor;
}

#pragma mark - Layout setup

- (void)setupSectionViewWithSections:(NSArray *)sections {
    [self.contentView _jp_removeAllSubviews];

    self.sectionView = [[JPSectionView alloc] initWithSections:sections
                                                      andTheme:self.theme];
    self.sectionView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.contentView addSubview:self.sectionView];
    [self setupSectionViewConstraints];
}

- (void)setupSectionViewConstraints {
    NSArray *constraints = @[
        [self.sectionView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.sectionView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        [self.sectionView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.sectionView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.sectionView.heightAnchor constraintEqualToConstant:kSectionViewHeight],
    ];

    [NSLayoutConstraint _jp_activateConstraints:constraints
                                   withPriority:kConstraintPriority];
}

#pragma mark - View model configuration

- (void)configureWithViewModel:(JPPaymentMethodsModel *)viewModel {

    JPPaymentMethodsSelectionModel *selectionModel = (JPPaymentMethodsSelectionModel *)viewModel;
    NSMutableArray *sections = [NSMutableArray new];

    for (JPPaymentMethod *paymentMethod in selectionModel.paymentMethods) {
        UIImage *image = [UIImage _jp_imageWithIconName:paymentMethod.iconName];
        JPSection *section = [JPSection sectionWithImage:image andTitle:paymentMethod.title];

        switch (paymentMethod.type) {
            case JPPaymentMethodTypeCard:
                section.accessibilityIdentifier = @"Card Selector View";
                break;

            case JPPaymentMethodTypeApplePay:
                section.accessibilityIdentifier = @"Apple Pay Selector View";
        }

        [sections addObject:section];
    }

    [self setupSectionViewWithSections:sections];

    if (selectionModel.selectedPaymentMethod != 0) {
        [self.sectionView switchToSectionAtIndex:selectionModel.selectedIndex];
    }
}

@end
