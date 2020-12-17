//
//  JPUITestCard.h
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

@interface JPUITestCard : NSObject

/**
 * The NSString value of the card type
 */
@property (nonatomic, strong, nullable) NSString *cardType;

/**
 * The NSString value of the card number
 */
@property (nonatomic, strong, nullable) NSString *cardNumber;

/**
 * The NSString value of the cardholder name
 */
@property (nonatomic, strong, nullable) NSString *cardholderName;

/**
 * The NSString value of the expiry date
 */
@property (nonatomic, strong, nullable) NSString *expiryDate;

/**
 * The NSString value of the security code
 */
@property (nonatomic, strong, nullable) NSString *securityCode;

/**
 * The NSString value of the error message for invalid secure codes
 */
@property (nonatomic, strong, nullable) NSString *secureCodeErrorMessage;

/**
 * Designated initializer that creates a JPUITestCard object by parsing a JSON dictionary
 *
 * @returns a configured instance of JPUITestCard
 */
- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

/**
 * A method for fetching the correct fields from the card details, based on a provided field identifier
 *
 * @param field - the identifier, used in the JSON file, used to represent a specific card details field
 *
 * @returns an optional NSString, representing the card details field, if it exists
 */
- (nullable NSString *)valueForField:(nonnull NSString *)field;

@end
