//
//  NSString+Additions.h
//  JudoKit_iOS
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

#import "JPCardNetworkType.h"
#import <Foundation/Foundation.h>

@class JPTheme, JPCardNetwork;

@interface NSString (Additions)

/**
 * A method which returns the card network from the string
 */
@property (nonatomic, assign, readonly) JPCardNetworkType _jp_cardNetwork;

/**
 * A method which returns YES if the string represents a valid card number
 */
@property (nonatomic, assign, readonly) BOOL _jp_isValidCardNumber;

/**
 * A method which returns YES if the string represents a valid expiry date format
 */
@property (nonatomic, assign, readonly) BOOL _jp_isExpiryDate;

/**
 * A method which returns a sanitized string that represents a expire date in a valid format
 */
- (nullable NSString *)_jp_sanitizedExpiryDate;

/**
 * A method which returns YES if the string represents a valid email format
 */
@property (nonatomic, assign, readonly) BOOL isEmail;

/**
 * A method which returns YES if the string represents a valid email format
 */
@property (nonatomic, assign, readonly) BOOL isPhoneNumber;

/**
 * A method which returns YES if the string represents a valid phone dial number (country calling code)
 */
@property (nonatomic, assign, readonly) BOOL isPhoneCode;

/**
 * A method which returns YES if the string contains only digits
 */
@property (nonatomic, assign, readonly) BOOL _jp_isNumeric;

/**
 * Returns the localized string based on the input key
 */
- (nonnull NSString *)_jp_localized;

/**
 * Converts ISO 4217 currency codes into their symbolic equivalent
 */
- (nullable NSString *)_jp_toCurrencySymbol;

/**
 * A method which returns an instance of the NSString without any whitespaces
 */
- (nonnull NSString *)_jp_stringByRemovingWhitespaces;

/**
 * A method which formats the string based on a specified pattern
 */
- (nonnull NSString *)_jp_formatWithPattern:(nonnull NSString *)pattern;

/**
 * A method which makes a word in string bold
 * @param substring - the substring to be made bold
 * @return - a  NSMutableAttributedString where provided word is bold
 *
 */
- (nonnull NSMutableAttributedString *)_jp_attributedStringWithBoldSubstring:(nonnull NSString *)substring;

- (BOOL)_jp_isNotNullOrEmpty;
- (BOOL)_jp_isNullOrEmpty;

@end
