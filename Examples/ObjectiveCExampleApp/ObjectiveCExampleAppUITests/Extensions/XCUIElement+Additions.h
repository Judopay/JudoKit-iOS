//
//  XCUIElement+Additions.h
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

#import <XCTest/XCTest.h>

@interface XCUIElement (Additions)

/**
 * A method used to find a UITableViewCell XCUIElement based on it's child text elements.
 *
 * @param staticText - the NSString that is used to identify the cell
 *
 * @returns an instance of XCUIElement used to represent the UITableViewCell instance
 */
+ (XCUIElement *)cellWithStaticText:(NSString *)staticText;

/**
 * A method used for clearing the existing text from a UITextField and replacing it with new input.
 *
 * @param text - the new text value to be added after the text field is cleared
 */
- (void)clearAndEnterText:(NSString *)text;

/**
 * A method that will continuously perform a swipe down action until it finds the XCUIElement.
 */
- (void)swipeDownToElement;

/**
 * A method that will continuously perform a swipe up action until it finds the XCUIElement.
 */
- (void)swipeUpToElement;

/**
 * A method that will toggle on any XCUIElement switch buttons.
 */
- (void)switchOn;

/**
 * A method that will toggle off any XCUIElement switch buttons.
 */
- (void)switchOff;

@end
