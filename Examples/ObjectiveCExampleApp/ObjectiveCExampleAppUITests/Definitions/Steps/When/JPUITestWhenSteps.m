//
//  JPUITestWhenSteps.m
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

#import "JPUITestWhenSteps.h"
#import <Cucumberish/Cucumberish.h>

@implementation JPUITestWhenSteps

+ (void)setUp {

    /**
     * [WHEN] ^I tap on the \"(.*)\" (?:option|cell|item)$
     *
     * Description:
     *    A test step used to execute a tap action on a table view cell / list item, based on the item's title.
     *
     * Valid examples:
     *    - When I tap on the "Pay with card" option
     *    - When I tap on the "amount" cell
     *    - When I tap on the "Token payments" item
     */
    When(@"^I tap on the \"(.*)\" (?:option|cell|item)$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *cellTitle = args[0];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"label CONTAINS[c] %@",
                                  cellTitle];

        XCUIElement *cell = [application.cells containingPredicate:predicate].firstMatch;
        [cell tap];
    });

    /**
     * [WHEN] ^I enter \"(.*)\" (?:in|into) the (.*) (?:text|input) field$
     *
     * Description:
     *    A test step used to execute a tap and type input into a text field identified by its accessibility identifier
     *
     * Valid examples:
     *    - When I enter "4123 1234 1234 1234" into the Card Number text field
     *    - When I enter "John Rambo" in the Cardholder Name input field
     *    - When I enter "425" into the Secure Code field
     */
    When(@"^I enter \"(.*)\" (?:in|into) the (.*) (?:text|input) field$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];

        NSString *textInput = args[0];
        NSString *textFieldName = args[1];

        NSString *textFieldIdentifier = [NSString stringWithFormat:@"%@ Field", textFieldName];
        XCUIElement *textField = application.otherElements[textFieldIdentifier];

        [textField tap];
        [textField typeText:textInput];
    });

    /**
     * [WHEN] ^I (?:tap|press) on the \"(.*)\" button$
     *
     * Description:
     *    A test step used to execute a tap on a button identified by its title
     *
     * Valid examples:
     *    - When I tap on the "PAY NOW" button
     *    - When I press on the "REGISTER CARD" button
     */
    When(@"^I (?:tap|press) on the \"(.*)\" button$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *buttonTitle = args[0];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"label CONTAINS[c] %@",
                                  buttonTitle];

        XCUIElement *button = [application.buttons containingPredicate:predicate].firstMatch;
        [button tap];
    });

    /**
     * [WHEN] ^I (?:tap|press) on the (.*) (?:text|input) field$
     *
     * Description:
     *    A test step used to execute a tap on a text field identified by its accessibility identifier
     *
     * Valid examples:
     *    - When I tap on the "Card Number" text field
     *    - When I press on the "Cardholder Name" input field
     *    - When I tap on the "Secure Code" field
     */
    When(@"^I (?:tap|press) on the (.*) (?:text|input) field$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *textFieldName = args[0];
        NSString *textFieldIdentifier = [NSString stringWithFormat:@"%@ Field", textFieldName];

        XCUIElement *textField = application.otherElements[textFieldIdentifier];
        [textField tap];
    });

    /**
     * [WHEN] ^I select \"(.*)\" from the (.*) (?:dropdown|picker)$
     *
     * Description:
     *    A test step used to select a value from a dropdown / picker element, identified by its accessibility identifier
     *
     * Valid examples:
     *    - When I select "USA" from the Country dropdown
     *    - When I select "GBP" from the Currency picker
     */
    When(@"^I select \"(.*)\" from the (.*) (?:dropdown|picker)$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *selectedOption = args[0];
        NSString *pickerName = args[1];
        NSString *pickerIdentifier = [NSString stringWithFormat:@"%@ Picker", pickerName];

        XCUIElement *picker = application.pickers[pickerIdentifier].pickerWheels.element;

        [picker adjustToPickerWheelValue:selectedOption];
    });

    /**
     * [WHEN] ^I wait for \"(.*)\" seconds$
     *
     * Description:
     *    A test step used to toggle a waiting behavior for X seconds. Useful for handling asynchronous events.
     *
     * Valid examples:
     *    - When I wait for "10" seconds
     */
    When(@"^I wait for \"(.*)\" seconds$", ^void(NSArray *args, id userInfo) {
        NSString *duration = args[0];
        [NSThread sleepForTimeInterval:duration.doubleValue];
    });
}

@end
