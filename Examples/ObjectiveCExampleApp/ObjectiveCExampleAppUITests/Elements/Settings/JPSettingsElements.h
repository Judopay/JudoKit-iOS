//
//  JPSettingsElements.h
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

@interface JPSettingsElements : NSObject

/**
 * The text field used to input the merchant's Judo ID
 */
+ (XCUIElement *)judoIDTextField;

/**
 * The switch element used to toggle basic authentication
 */
+ (XCUIElement *)basicAuthenticationSwitch;

/**
 * The switch element used to toggle payment session authentication
 */
+ (XCUIElement *)sessionAuthenticationSwitch;

/**
 * The text field used to input the merchant's token during basic authentication
 */
+ (XCUIElement *)basicTokenTextField;

/**
 * The text field used to input the merchant's token during basic authentication
 */
+ (XCUIElement *)basicSecretTextField;

/**
 * The switch element used to toggle Visa as an accepted card network
 */
+ (XCUIElement *)visaSwitch;

/**
 * The switch element used to toggle MasterCard as an accepted card network
 */
+ (XCUIElement *)masterCardSwitch;

/**
 * The switch element used to toggle Maestro as an accepted card network
 */
+ (XCUIElement *)maestroSwitch;

/**
 * The switch element used to toggle American Express as an accepted card network
 */
+ (XCUIElement *)amexSwitch;

/**
 * The switch element used to toggle China Union Pay as an accepted card network
 */
+ (XCUIElement *)chinaUnionPaySwitch;

/**
 * The switch element used to toggle JCB as an accepted card network
 */
+ (XCUIElement *)jcbSwitch;

/**
 * The switch element used to toggle Discover as an accepted card network
 */
+ (XCUIElement *)discoverSwitch;

/**
 * The switch element used to toggle Diners Club as an accepted card network
 */
+ (XCUIElement *)dinersClubSwitch;

/**
 * The switch element used to toggle Address Verification Service as a transaction requirement
 */
+ (XCUIElement *)avsSwitch;

/**
 * The switch element used to toggle amount visibility on the Judo UI Payment button
 */
+ (XCUIElement *)buttonAmountSwitch;

@end

