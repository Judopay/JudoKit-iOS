//
//  JPUITestSteps.m
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

#import "JPUITestSteps.h"
#import <Cucumberish/Cucumberish.h>

@implementation JPUITestSteps

+ (void)setUp {

    Given(@"^I am on the (.*) (?:screen|view|page)$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *screenName = args[0];
        NSString *screenIdentifier = [NSString stringWithFormat:@"%@ Screen", screenName];
        XCTAssert(application.otherElements[screenIdentifier].exists);
    });

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
}

@end
