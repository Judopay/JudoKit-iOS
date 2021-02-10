//
//  JPApplePayButton.h
//  JudoKit_iOS
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
#import <PassKit/PassKit.h>

API_AVAILABLE(ios(8.3))
@interface JPApplePayButton : PKPaymentButton

/**
 * An enum used to define the Apple Pay button styling
 */
typedef NS_ENUM(NSUInteger, JPApplePayButtonStyle) {
    JPApplePayButtonStyleWhite,
    JPApplePayButtonStyleWhiteOutline,
    JPApplePayButtonStyleBlack,
    JPApplePayButtonStyleAutomatic API_AVAILABLE(ios(14.0))
};

/**
 * An enum used to define the Apple Pay button type
 */
typedef NS_ENUM(NSUInteger, JPApplePayButtonType) {
    JPApplePayButtonTypePlain,
    JPApplePayButtonTypeBuy,
    JPApplePayButtonTypeSetUp,
    JPApplePayButtonTypeInStore,
    JPApplePayButtonTypeDonate,
    JPApplePayButtonTypeCheckout API_AVAILABLE(ios(12.0)),
    JPApplePayButtonTypeBook API_AVAILABLE(ios(12.0)),
    JPApplePayButtonTypeSubscribe API_AVAILABLE(ios(12.0)),
    JPApplePayButtonTypeReload API_AVAILABLE(ios(14.0)),
    JPApplePayButtonTypeAddMoney API_AVAILABLE(ios(14.0)),
    JPApplePayButtonTypeTopUp API_AVAILABLE(ios(14.0)),
    JPApplePayButtonTypeOrder API_AVAILABLE(ios(14.0)),
    JPApplePayButtonTypeRent API_AVAILABLE(ios(14.0)),
    JPApplePayButtonTypeSupport API_AVAILABLE(ios(14.0)),
    JPApplePayButtonTypeContribute API_AVAILABLE(ios(14.0)),
    JPApplePayButtonTypeTip API_AVAILABLE(ios(14.0)),
};

/**
 * Designated initializer used to create an branded Apple Pay button with a distinct type and style
 *
 * @param buttonType - the Apple Pay button type
 * @param buttonStyle - the Apple Pay button style
 *
 * @returns a configured instance of JPApplePayButton
 */
+ (nonnull instancetype)buttonWithType:(JPApplePayButtonType)buttonType
                                 style:(JPApplePayButtonStyle)buttonStyle;

/**
 * Designated initializer used to create an branded Apple Pay button with a distinct type and style
 *
 * @param buttonType - the Apple Pay button type
 * @param buttonStyle - the Apple Pay button style
 *
 * @returns a configured instance of JPApplePayButton
 */
- (nonnull instancetype)initWithType:(JPApplePayButtonType)buttonType
                               style:(JPApplePayButtonStyle)buttonStyle;

@end
