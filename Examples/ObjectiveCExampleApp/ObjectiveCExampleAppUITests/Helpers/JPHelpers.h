//
//  JPHelpers.h
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

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@interface JPHelpers : NSObject

/**
 * A convenience method for toggling on all XCUIElement switch elements.
 *
 * This method will scroll down till it finds the switch, and enable it if needed, meaning that the array elements
 * must be added in order of appearance.
 *
 * @param switches - an array of XCUIElement switches to be enabled
 */
void toggleOnSwitches(NSArray <XCUIElement *> *switches);

/**
 * A convenience method for toggling off all XCUIElement switch elements.
 *
 * This method will scroll down till it finds the switch, and disable it if needed, meaning that the array elements
 * must be added in order of appearance.
 *
 * @param switches - an array of XCUIElement switches to be enabled
 */
void toggleOffSwitches(NSArray <XCUIElement *> *switches);

@end