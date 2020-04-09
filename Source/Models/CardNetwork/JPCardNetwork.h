//
//  JPCardNetwork.h
//  JudoKitObjC
//
//  Copyright (c) 2019 Alternative Payments Ltd
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

#import "JPCardDetails.h"
#import <Foundation/Foundation.h>

@interface JPCardNetwork : NSObject

/**
 * The card network type
 */
@property (nonatomic, assign) CardNetwork network;

/**
 * Designated initializer that returns a configured JPCardNetwork based on a type
 *
 * @param networkType - the card network type.
 *
 * @returns a pattern for networkType
 */
+ (NSString *)cardPatternForType:(CardNetwork)networkType;

/**
 * A method that returns the name of the card network based on a specified network type
 *
 * @param network - the card network type
 *
 * @returns the card network name;
 */
+ (NSString *)nameOfCardNetwork:(CardNetwork)network;

/**
 * A method that returns the card network based on the provided card number
 *
 * @param cardNumber - the provided card number
 *
 * @returns one of the pre-defined card network types
 */
+ (CardNetwork)cardNetworkForCardNumber:(NSString *)cardNumber;

/**
 * An integer specifying the security code length for the network type
 *
 * @param networkType - the card network type
 *
 * @returns the card network security code length;
 */
+ (NSUInteger)secureCodeLengthForNetworkType:(CardNetwork)networkType;

/**
 * String specifying the security code placeholder
 *
 * @param networkType - the card network type
 *
 * @returns the card network security code placeholder;
 */
+ (NSString *)secureCodePlaceholderForNetworkType:(CardNetwork)networkType;

@end
