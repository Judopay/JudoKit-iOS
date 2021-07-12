//
//  ApplePayViewController.m
//  ObjectiveCExampleApp
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

#import "ApplePayViewController.h"

@interface ApplePayViewController ()

@property (nonatomic, weak) IBOutlet UIStackView *buttonStylesStackView;
@property (nonatomic, weak) IBOutlet UIStackView *buttonTypesStackView;

@end

@implementation ApplePayViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
}

- (IBAction)didSwitchSection:(UISegmentedControl *)sender {
    [self.buttonTypesStackView setHidden:sender.selectedSegmentIndex != 0];
    [self.buttonStylesStackView setHidden:sender.selectedSegmentIndex == 0];
}

#pragma mark - Layout setup

- (void)setupLayout {
    self.navigationItem.title = @"Apple Pay Buttons";
    [self setupButtonTypes];
    [self setupButtonStyles];
}

- (void)setupButtonTypes {
    NSArray *buttonTypes = [self getApplePayButtonTypes];

    for (NSNumber *type in buttonTypes) {
        JPApplePayButton *button = [JPApplePayButton buttonWithType:type.intValue
                                                              style:JPApplePayButtonStyleBlack];
        [self.buttonTypesStackView addArrangedSubview:button];

        [NSLayoutConstraint activateConstraints:@[
            [button.heightAnchor constraintEqualToConstant:40.0]
        ]];
    }
    [self.buttonTypesStackView addArrangedSubview:[UIView new]];
}

- (void)setupButtonStyles {
    NSArray *buttonStyles = [self getApplePayButtonStyles];

    for (NSNumber *style in buttonStyles) {
        JPApplePayButton *button = [JPApplePayButton buttonWithType:JPApplePayButtonTypeBuy
                                                              style:style.intValue];
        [self.buttonStylesStackView addArrangedSubview:button];

        [NSLayoutConstraint activateConstraints:@[
            [button.heightAnchor constraintEqualToConstant:40.0]
        ]];
    }
    [self.buttonStylesStackView addArrangedSubview:[UIView new]];
}

#pragma mark - Helpers

- (NSArray *)getApplePayButtonStyles {
    NSMutableArray *buttonStyles = [NSMutableArray new];

    NSArray *generalStyles = @[
        @(JPApplePayButtonStyleWhite),
        @(JPApplePayButtonStyleWhiteOutline),
        @(JPApplePayButtonStyleBlack)
    ];

    [buttonStyles addObjectsFromArray:generalStyles];

    if (@available(iOS 14.0, *)) {
        [buttonStyles addObject:@(JPApplePayButtonStyleAutomatic)];
    }

    return buttonStyles;
}

- (NSArray *)getApplePayButtonTypes {
    NSMutableArray *buttonTypes = [NSMutableArray new];

    NSArray *generalTypes = @[
        @(JPApplePayButtonTypePlain),
        @(JPApplePayButtonTypeBuy),
        @(JPApplePayButtonTypeSetUp),
        @(JPApplePayButtonTypeInStore),
        @(JPApplePayButtonTypeDonate),
    ];

    [buttonTypes addObjectsFromArray:generalTypes];

    if (@available(iOS 12.0, *)) {
        NSArray *ios12Types = @[
            @(JPApplePayButtonTypeCheckout),
            @(JPApplePayButtonTypeBook),
            @(JPApplePayButtonTypeSubscribe)
        ];
        [buttonTypes addObjectsFromArray:ios12Types];
    }

    if (@available(iOS 14.0, *)) {
        NSArray *ios14Types = @[
            @(JPApplePayButtonTypeReload),
            @(JPApplePayButtonTypeAddMoney),
            @(JPApplePayButtonTypeTopUp),
            @(JPApplePayButtonTypeOrder),
            @(JPApplePayButtonTypeRent),
            @(JPApplePayButtonTypeSupport),
            @(JPApplePayButtonTypeContribute),
            @(JPApplePayButtonTypeTip)
        ];
        [buttonTypes addObjectsFromArray:ios14Types];
    }

    return buttonTypes;
}

@end
