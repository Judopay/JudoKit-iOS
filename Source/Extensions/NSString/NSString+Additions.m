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
#import "JPError+Additions.h"
#import "JPTheme.h"
#import "NSBundle+Additions.h"
#import "NSString+Additions.h"
#import "UIFont+Additions.h"

@implementation NSString (Additions)

- (nonnull NSString *)localized {
    if (NSBundle.stringsBundle != nil) {
        return NSLocalizedStringFromTableInBundle(self, nil, NSBundle.stringsBundle, nil);
    }
    return NSLocalizedStringFromTableInBundle(self, nil, NSBundle.frameworkBundle, nil);
}

- (NSString *)toCurrencySymbol {
    return [NSLocale.currentLocale displayNameForKey:NSLocaleCurrencySymbol value:self];
}

- (JPCardNetworkType)cardNetwork {
    return [JPCardNetwork cardNetworkForCardNumber:self];
}

- (NSString *)stringByRemovingWhitespaces {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (nonnull NSString *)formatWithPattern:(nonnull NSString *)pattern {
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

- (BOOL)isNumeric {
    NSCharacterSet *nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange range = [self rangeOfCharacterFromSet:nonNumbers];
    return range.location == NSNotFound;
}

- (BOOL)isValidCardNumber {
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

- (BOOL)isExpiryDate {
    NSString *expiryDateFormay = @"^\\d{2}(\\/|-)\\d{2}$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expiryDateFormay
                                                                           options:NSRegularExpressionAnchorsMatchLines
                                                                             error:nil];

    NSRange range = NSMakeRange(0, self.length);
    NSUInteger matches = [regex numberOfMatchesInString:self options:0 range:range];
    return matches > 0;
}

- (nonnull NSMutableAttributedString *)attributedStringWithBoldSubstring:(nonnull NSString *)substring {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange substringRange = [self rangeOfString:substring];
    if (substringRange.location != NSNotFound) {
        [attributedString addAttributes:@{NSFontAttributeName : UIFont.captionBold} range:substringRange];
    }
    return attributedString;
}

@end
