//
//  NSString+Additions.m
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

#import "JPCardNetwork.h"
#import "JPConstants.h"
#import "JPError+Additions.h"
#import "JPTheme.h"
#import "NSBundle+Additions.h"
#import "NSString+Additions.h"
#import "UIFont+Additions.h"

@implementation NSString (Additions)

- (nonnull NSString *)_jp_localized {
    return NSLocalizedStringFromTableInBundle(self, nil, NSBundle._jp_frameworkBundle, nil);
}

- (NSString *)_jp_toCurrencySymbol {
    return [NSLocale.currentLocale displayNameForKey:NSLocaleCurrencySymbol value:self];
}

- (JPCardNetworkType)_jp_cardNetwork {
    return [JPCardNetwork cardNetworkForCardNumber:self];
}

- (NSString *)_jp_stringByRemovingWhitespaces {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (nonnull NSString *)_jp_formatWithPattern:(nonnull NSString *)pattern {
    const char *patternString = pattern.UTF8String;
    NSString *returnString = @"";
    NSUInteger patternIndex = 0;

    for (int i = 0; i < self.length; i++) {
        const char element = patternString[patternIndex];

        if (element == 'X') {
            unichar num = [self characterAtIndex:i];
            returnString = [returnString stringByAppendingString:[NSString stringWithFormat:@"%c", num]];
        } else {
            unichar num = [self characterAtIndex:i];
            returnString = [returnString stringByAppendingString:[NSString stringWithFormat:@" %c", num]];
            patternIndex++;
        }

        patternIndex++;
    }

    return returnString;
}

- (BOOL)_jp_isNumeric {
    NSCharacterSet *nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange range = [self rangeOfCharacterFromSet:nonNumbers];
    return range.location == NSNotFound;
}

- (BOOL)_jp_isValidCardNumber {
    NSUInteger total = 0;
    NSUInteger len = [self length];

    for (NSUInteger index = len; index > 0;) {
        BOOL odd = (len - index) & 1;
        --index;
        unichar character = [self characterAtIndex:index];
        if (character < '0' || character > '9')
            continue;
        character -= '0';
        if (odd)
            character *= 2;
        if (character >= 10) {
            total += 1;
            character -= 10;
        }
        total += character;
    }

    return (total % 10) == 0;
}

- (BOOL)_jp_isExpiryDate {
    /* Expected date formats:
     * 12/22
     * 12-22
     * 12-2022
     * 12/2022
     */
    NSString *expiryDateFormat = @"^\\d{2}(\\/|-)(\\d{2}|\\d{4})$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expiryDateFormat
                                                                           options:NSRegularExpressionAnchorsMatchLines
                                                                             error:nil];

    NSRange range = NSMakeRange(0, self.length);
    NSUInteger matches = [regex numberOfMatchesInString:self options:0 range:range];
    return matches > 0;
}

- (NSString *)_jp_sanitizedExpiryDate {

    if (!self._jp_isExpiryDate) {
        return nil;
    }

    // 1. in case of a '-' character, replace it with '/'
    NSString *sanitized = [self stringByReplacingOccurrencesOfString:@"-" withString:@"/"];

    // 2. expected length is 5 or 7 chars, everithing else is not valid
    // (at this point only these 2 options are possible because of `self.isExpiryDate` validation from above)
    if (sanitized.length == 7) {
        // in case the date format is '12/2021', transform it to '12/21'
        NSArray *components = [sanitized componentsSeparatedByString:@"/"];
        if (components.count == 2) {
            NSString *fullYear = components.lastObject;
            if (fullYear.length == 4) {
                NSString *yearLastTwo = [fullYear substringFromIndex:fullYear.length - 2];
                return [NSString stringWithFormat:@"%@/%@", components.firstObject, yearLastTwo];
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    }

    return sanitized;
}

- (BOOL)_jp_isEmail {
    NSString *emailRegEx = @"[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+";
    NSPredicate *emailPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [emailPred evaluateWithObject:self];
}

- (BOOL)_jp_isPhoneCode {
    return [self _jp_isNumeric];
}

- (BOOL)_jp_isPhoneNumber {
    NSPredicate *phoneNumberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kRegExMobileNumber];
    return [phoneNumberPredicate evaluateWithObject:self] && self._jp_isNumeric;
}

- (nonnull NSMutableAttributedString *)_jp_attributedStringWithBoldSubstring:(nonnull NSString *)substring {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange substringRange = [self rangeOfString:substring];
    if (substringRange.location != NSNotFound) {
        [attributedString addAttributes:@{NSFontAttributeName : UIFont._jp_captionBold} range:substringRange];
    }
    return attributedString;
}

- (BOOL)_jp_isNotNullOrEmpty {
    return ![self _jp_isNullOrEmpty];
}

- (BOOL)_jp_isNullOrEmpty {
    return !self || self.length == 0;
}

- (BOOL)_jp_isValidCardholderName {
    NSPredicate *cardholderNamePred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kRegExCardholderName];
    return [cardholderNamePred evaluateWithObject:self];
}

- (BOOL)_jp_isValidAddressLine {
    NSPredicate *addressLinePred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kRegExAddressLine];
    return [addressLinePred evaluateWithObject:self];
}

- (BOOL)_jp_isValidCity {
    NSPredicate *cityPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kRegExCity];
    return [cityPred evaluateWithObject:self];
}

- (BOOL)_jp_isEqualIgnoringCaseToString:(NSString *)aString {
    return self && aString && [self caseInsensitiveCompare:aString] == NSOrderedSame;
}

@end
