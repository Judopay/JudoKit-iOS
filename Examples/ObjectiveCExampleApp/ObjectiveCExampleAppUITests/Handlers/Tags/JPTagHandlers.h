//
//  JPTagHandlers.h
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

@interface JPTagHandlers : NSObject

/**
 * A method used to toggle the basic authorization switch and enter the non-3DS credentials.
 */
+ (void)handleRequireNon3DSConfig;

/**
 * A method used to toggle on all the card networks on the Settings page.
 */
+ (void)handleRequireAllCardNetworks;

/**
 * A method used to toggle on AVS on the Settings page.
 */
+ (void)handleRequireAVS;

/**
 * A method used to toggle on the "Display Button Amount" on the Settings page.
 */
+ (void)handleRequireButtonAmount;

/**
 * A method used to toggle on Card Payments on the Settings page.
 */
+ (void)handleRequireCardPaymentMethod;

/**
 * A method used to toggle on iDEAL Payments on the Settings page.
 */
+ (void)handleRequireIDEALPaymentMethod;

/**
 * A method used to toggle on Apple Pay Payments on the Settings page.
 */
+ (void)handleRequireApplePayPaymentMethod;

/**
 * A method used to toggle on PBBA Payments on the Settings page.
 */
+ (void)handleRequirePBBAPaymentMethod;

/**
 * A method used to toggle on all payment methods on the Settings page.
 */
+ (void)handleRequireAllPaymentMethods;

/**
 * A method used to select GBP as the transaction currency on the Settings page.
 */
+ (void)handleRequireCurrencyGBP;

/**
 * A method used to select EUR as the transaction currency on the Settings page.
 */
+ (void)handleRequireCurrencyEUR;

@end
