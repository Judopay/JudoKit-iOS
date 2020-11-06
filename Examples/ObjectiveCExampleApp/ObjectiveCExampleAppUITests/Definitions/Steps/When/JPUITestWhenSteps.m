//
//  JPUITestWhenSteps.m
//  ObjectiveCExampleAppUITests
//
//  Created by Mihai Petrenco on 11/3/20.
//  Copyright © 2020 Judopay. All rights reserved.
//

#import "JPUITestWhenSteps.h"
#import <Cucumberish/Cucumberish.h>

@implementation JPUITestWhenSteps

+ (void)setUp {
    
    When(@"^I tap on the \"(.*)\" (?:option|cell|item)$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *cellTitle = args[0];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"label CONTAINS[c] %@",
                                  cellTitle];

        XCUIElement *cell = [application.cells containingPredicate:predicate].firstMatch;
        [cell tap];
    });

    When(@"^I enter \"(.*)\" (?:in|into) the (.*) (?:text|input) field$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];

        NSString *textInput = args[0];
        NSString *textFieldName = args[1];

        NSString *textFieldIdentifier = [NSString stringWithFormat:@"%@ Field", textFieldName];

        XCUIElement *textField = application.otherElements[textFieldIdentifier];

        [textField tap];
        [textField typeText:textInput];
    });

    When(@"^I (?:tap|press) on the \"(.*)\" button$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *buttonTitle = args[0];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"label CONTAINS[c] %@",
                                  buttonTitle];

        XCUIElement *button = [application.buttons containingPredicate:predicate].firstMatch;
        [button tap];
    });

    When(@"^I (?:tap|press) on the (.*) (?:text|input) field$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *textFieldName = args[0];
        NSString *textFieldIdentifier = [NSString stringWithFormat:@"%@ Field", textFieldName];

        XCUIElement *textField = application.otherElements[textFieldIdentifier];
        [textField tap];
    });

    When(@"^I select \"(.*)\" from the (.*) dropdown$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *selectedOption = args[0];
        NSString *pickerName = args[1];
        NSString *pickerIdentifier = [NSString stringWithFormat:@"%@ Picker", pickerName];

        XCUIElement *picker = application.pickers[pickerIdentifier].pickerWheels.element;

        [picker adjustToPickerWheelValue:selectedOption];
    });

    When(@"^I wait for \"(.*)\" seconds$", ^void(NSArray *args, id userInfo) {
        NSString *duration = args[0];
        [NSThread sleepForTimeInterval:duration.doubleValue];
    });
}

@end
