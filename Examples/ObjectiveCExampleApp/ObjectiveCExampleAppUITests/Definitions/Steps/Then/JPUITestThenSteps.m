//
//  JPUITestThenSteps.m
//  ObjectiveCExampleAppUITests
//
//  Created by Mihai Petrenco on 11/3/20.
//  Copyright © 2020 Judopay. All rights reserved.
//

#import "JPUITestThenSteps.h"
#import "XCUIElement+Additions.h"
#import <Cucumberish/Cucumberish.h>

@implementation JPUITestThenSteps

+ (void)setUp {

    Then(@"^the (.*) (?:screen|page|view) should be visible$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *screenName = args[0];
        NSString *screenIdentifier = [NSString stringWithFormat:@"%@ Screen", screenName];

        BOOL isViewVisible = application.otherElements[screenIdentifier].exists;
        BOOL isTableVisible = application.tables[screenIdentifier].exists;

        XCTAssert(isViewVisible || isTableVisible);
    });

    Then(@"^the \"(.*)\" (?:list\\s)?(?:item|option|cell) should contain \"(.*)\"$", ^void(NSArray *args, id userInfo) {
        NSString *cellTitle = args[0];
        NSString *cellValue = args[1];

        XCUIElement *selectedCell = [XCUIElement cellWithStaticText:cellTitle];

        if (selectedCell.staticTexts[cellValue].exists) {
            XCTAssertTrue(selectedCell.staticTexts[cellValue].exists);
            return;
        }

        [selectedCell tap];

        selectedCell = [XCUIElement cellWithStaticText:cellTitle];
        XCTAssertTrue(selectedCell.staticTexts[cellValue].exists);
    });

    Then(@"^an \"(.*)\" (?:label|text) should be visible$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *text = args[0];
        XCTAssertTrue(application.staticTexts[text].exists);
    });

    // an/a/the for all test cases | should/must/would for all widgets
    Then(@"^an \"(.*)\" (?:label|text) should be visible$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *text = args[0];
        XCTAssertTrue(application.staticTexts[text].exists);
    });

    Then(@"^the \"(.*)\" button should be disabled$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *buttonTitle = args[0];
        XCTAssertFalse(application.buttons[buttonTitle].isEnabled);
    });
}

@end
