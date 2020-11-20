//
//  JPUITestThenSteps.m
//  ObjectiveCExampleAppUITests
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

#import "JPUITestThenSteps.h"
#import "XCUIElement+Additions.h"
#import <Cucumberish/Cucumberish.h>

@implementation JPUITestThenSteps

+ (void)setUp {

    /**
     * [THEN] ^the (.*) (?:screen|page|view|option|item) should be visible
     *
     * Description:
     *    A test step used to validate that a screen is visible.
     *
     * Valid examples:
     *    - Then the Receipt screen should be visible
     *    - Then the Settings page should be visible
     *    - Then the Main view should be visible
     *    - Then the Card Selector option should be visible
     *    - Then the Apple Pay Header item should be visible
     */
    Then(@"^the (.*) (?:screen|page|view|option|item) should be visible$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *screenName = args[0];
        NSString *screenIdentifier = [NSString stringWithFormat:@"%@ View", screenName];

        BOOL isViewVisible = [application.otherElements[screenIdentifier] waitForExistenceWithTimeout:3.0];
        BOOL isTableVisible = [application.tables[screenIdentifier] waitForExistenceWithTimeout:3.0];
        BOOL isImageViewVisible = [application.images[screenIdentifier] waitForExistenceWithTimeout:3.0];

        XCTAssert(isViewVisible || isTableVisible || isImageViewVisible);
    });

    /**
     * [THEN] ^the \"(.*)\" (?:list\\s)?(?:item|option|cell) should contain \"(.*)\"$
     *
     * Description:
     *    A test step used to validate that a table view cell / list item, identified by it's title, contains some specified text
     *
     * Valid examples:
     *    - Then the "amount" list item should contain "1.01"
     *    - Then the "receiptId" option should contain "123456"
     *    - Then the "consumerReference" cell should contain "exampleReference"
     */
    Then(@"^the \"(.*)\" (?:list\\s)?(?:item|option|cell) should contain \"(.*)\"$", ^void(NSArray *args, id userInfo) {
        NSString *cellTitle = args[0];
        NSString *cellValue = args[1];

        XCUIElement *selectedCell = [XCUIElement cellWithStaticText:cellTitle];
        [selectedCell swipeUpToElement];

        if ([selectedCell.staticTexts[cellValue] waitForExistenceWithTimeout:3.0]) {
            XCTAssertTrue(selectedCell.staticTexts[cellValue].exists);
            return;
        }

        [selectedCell tap];

        selectedCell = [XCUIElement cellWithStaticText:cellTitle];
        XCTAssertTrue([selectedCell.staticTexts[cellValue] waitForExistenceWithTimeout:3.0]);
    });

    /**
     * [THEN] ^(?:the|an|a) \"(.*)\" (?:label|text) should be visible$
     *
     * Description:
     *    A test step used to validate that a label/text element is visible on the screen
     *
     * Valid examples:
     *    - Then a "Transaction Successful!" label should be visible
     *    - Then the "Settings" text should be visible
     */
    Then(@"^(?:the|an|a) \"(.*)\" (?:label|text) should be visible$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *text = args[0];
        XCTAssertTrue([application.staticTexts[text] waitForExistenceWithTimeout:3.0]);
    });

    /**
     * [THEN] ^the \"(.*)\" button should be disabled$
     *
     * Description:
     *    A test step used to validate that a button element, identified by its title, is disabled
     *
     * Valid examples:
     *    - Then the "PAY NOW" button should be disabled
     *    - Then the "SCAN CARD" button should be disabled
     */
    Then(@"^the \"(.*)\" button should be disabled$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *buttonTitle = args[0];
        XCTAssertFalse(application.buttons[buttonTitle].isEnabled);
    });

    /**
     * [THEN] ^the value in (.*) (?:text|input) field should be \"(.*)\"$
     *
     * Description:
     *    A test step used to validate that a text/input field, identified by its accessibility identifier, contains a specified value.
     *
     * Valid examples:
     *    - Then the value in Card Number input field should be "4111 1111 1111 1111"
     *    - Then the value in Secure Code text field should be "452"
     */
    Then(@"^the value in (.*) (?:text|input) field should be \"(.*)\"$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];

        NSString *fieldName = args[0];
        NSString *fieldIdentifier = [NSString stringWithFormat:@"%@ Field", fieldName];
        NSString *fieldValue = args[1];

        XCTAssertEqual(application.otherElements[fieldIdentifier].textFields.element.value, fieldValue);
    });

    /**
     * [THEN] ^the (.*) button title should be \"(.*)\"$
     *
     * Description:
     *    A test step used to validate that a button, identified by its accessibility identifier, should have a specified title.
     *
     * Valid examples:
     *    - Then the Transaction button title should be "Register Card"
     *    - Then the PBBA button title should be "Pay by Bank App"
     */
    Then(@"^the (.*) button title should be \"(.*)\"$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];

        NSString *buttonTitle = args[0];
        NSString *buttonIdentifier = [NSString stringWithFormat:@"%@ Button", buttonTitle];
        NSString *buttonValue = args[1];

        NSString *actualValue = application.buttons[buttonIdentifier].label;
        XCTAssertTrue([actualValue isEqualToString:buttonValue]);
    });

    /**
     * [THEN] ^(?:the|an|a) \"(.*)\" (?:item|cell|option) should be selected$
     *
     * Description:
     *    A test step used to validate that an item/cell, identified by its title, should be selected
     *
     * Valid examples:
     *    - Then the "Visa Ending 1111" item should be selected
     *    - Then the "Card for shopping" item should be selected
     */
    Then(@"^(?:the|an|a) \"(.*)\" (?:item|cell|option) should be selected$", ^void(NSArray *args, id userInfo) {
        NSString *cellTitle = args[0];
        XCUIElement *selectedCell = [XCUIElement cellWithStaticText:cellTitle];

        XCTAssertTrue([selectedCell waitForExistenceWithTimeout:3.0]);
        XCTAssertTrue([selectedCell.identifier containsString:@"[SELECTED]"]);
    });

    /**
     * [THEN] ^(?:the|an|a) \"(.*)\" alert should be visible$
     *
     * Description:
     *    A test step used to validate that an alert, containing a specific title, should be visible
     *
     * Valid examples:
     *    - Then the "Transaction Cancelled" alert should be visible
     *    - Then the "GBP is not supported for iDEAL transactions" alert should be visible
     */
    Then(@"^(?:the|an|a) \"(.*)\" alert should be visible$", ^void(NSArray *args, id userInfo) {
        NSString *alertText = args[0];
        XCUIApplication *app = [XCUIApplication new];
        XCTAssertTrue(app.alerts.staticTexts[alertText].exists);
    });
}

@end
