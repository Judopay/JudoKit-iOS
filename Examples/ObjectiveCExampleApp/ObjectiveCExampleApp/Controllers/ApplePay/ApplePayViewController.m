//
//  ApplePayViewController.m
//  ObjectiveCExampleApp
//
//  Created by Mihai Petrenco on 12/29/20.
//  Copyright © 2020 Judopay. All rights reserved.
//

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
            [button.heightAnchor constraintEqualToConstant: 40.0]
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
            [button.heightAnchor constraintEqualToConstant: 40.0]
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
