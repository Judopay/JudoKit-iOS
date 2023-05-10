//
//  JPCardDetails.m
//  JudoKit_iOS
//
//  Copyright (c) 2016 Alternative Payments Ltd
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
#import "JPConstants.h"
#import "JPFormatters.h"
#import "NSNumber+Additions.h"
#import "NSString+Additions.h"

@implementation JPCardDetails

#pragma mark - Constants

// The card scheme for a card number. This is the name of the card scheme as it appears on the card.
// As it is returned by the API in the cardDetails object, it is not localized.
static NSString *const kCardSchemeVisa = @"Visa";
static NSString *const kCardSchemeMastercard = @"Mastercard";
static NSString *const kCardSchemeMaestro = @"Maestro";
static NSString *const kCardSchemeAMEX = @"AMEX";
static NSString *const kCardSchemeChinaUnionPay = @"China Union Pay";
static NSString *const kCardSchemeJCB = @"JCB";
static NSString *const kCardSchemeDiscover = @"Discover";

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.cardLastFour = dictionary[@"cardLastfour"];
        self.endDate = dictionary[@"endDate"];
        self.cardToken = dictionary[@"cardToken"];
        self.cardNumber = dictionary[@"cardNumber"];
        self.bank = dictionary[@"bank"];
        self.cardCategory = dictionary[@"cardCategory"];
        self.cardCountry = dictionary[@"cardCountry"];
        self.cardFunding = dictionary[@"cardFunding"];
        self.cardScheme = dictionary[@"cardScheme"];
        self.cardHolderName = dictionary[@"cardHolderName"];

        self.rawCardNetwork = dictionary[@"cardType"];

        self.cardNetwork = JPCardNetworkTypeUnknown;

        if (self.rawCardNetwork || self.cardScheme) {
            self.cardNetwork = self.cardNetworkTypeDerivedFromCardType;

            // As a fallback, if the card scheme is provided, use it to determine the card network.
            if (self.cardNetwork == JPCardNetworkTypeUnknown) {
                self.cardNetwork = self.cardNetworkTypeDerivedFromCardScheme;
            }
        }
    }
    return self;
}

- (JPCardNetworkType)cardNetworkTypeDerivedFromCardType {
    return self.rawCardNetwork._jp_toCardNetworkType;
}

- (JPCardNetworkType)cardNetworkTypeDerivedFromCardScheme {
    NSString *scheme = self.cardScheme;

    if ([scheme isEqualToString:kCardSchemeVisa]) {
        return JPCardNetworkTypeVisa;
    }

    if ([scheme isEqualToString:kCardSchemeMastercard]) {
        return JPCardNetworkTypeMasterCard;
    }

    if ([scheme isEqualToString:kCardSchemeMaestro]) {
        return JPCardNetworkTypeMaestro;
    }

    if ([scheme isEqualToString:kCardSchemeAMEX]) {
        return JPCardNetworkTypeAMEX;
    }

    if ([scheme isEqualToString:kCardSchemeChinaUnionPay]) {
        return JPCardNetworkTypeChinaUnionPay;
    }

    if ([scheme isEqualToString:kCardSchemeJCB]) {
        return JPCardNetworkTypeJCB;
    }

    if ([scheme isEqualToString:kCardSchemeDiscover]) {
        return JPCardNetworkTypeDiscover;
    }

    return JPCardNetworkTypeUnknown;
}

- (instancetype)initWithCardNumber:(NSString *)cardNumber
                       expiryMonth:(NSUInteger)month
                        expiryYear:(NSUInteger)year {
    if (self = [super init]) {
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comp = [NSDateComponents new];
        comp.year = year;
        comp.month = month;
        NSDate *expiryDate = [calendar dateFromComponents:comp];
        if (expiryDate) {
            self.endDate = [JPFormatters.sharedInstance.expiryDateFormatter stringFromDate:expiryDate];
        }
        self.cardNumber = cardNumber;
    }
    return self;
}

- (JPCardNetworkType)cardNetwork {
    if (_cardNetwork == JPCardNetworkTypeUnknown && self.cardNumber) {
        _cardNetwork = self.cardNumber._jp_cardNetwork;
    }
    return _cardNetwork;
}

- (nullable NSString *)formattedCardLastFour {
    if (!self.cardLastFour && !self.cardNumber) {
        return nil;
    } else if (self.cardNumber) {
        self.cardLastFour = [self.cardNumber substringFromIndex:self.cardNumber.length - 4];
    }

    if (self.cardNetwork == JPCardNetworkTypeAMEX) {
        return [NSString stringWithFormat:@"**** ****** *%@", self.cardLastFour];
    }

    if (self.cardNetwork == JPCardNetworkTypeUnknown) {
        return [NSString stringWithFormat:@"**** %@", self.cardLastFour];
    }

    return [NSString stringWithFormat:@"**** **** **** %@", self.cardLastFour];
}

- (nullable NSString *)formattedExpiryDate {
    if (!self.endDate) {
        return nil;
    }

    if (self.endDate.length == 4) {
        NSString *prefix = [self.endDate substringToIndex:2];
        NSString *suffix = [self.endDate substringFromIndex:2];
        return [NSString stringWithFormat:@"%@/%@", prefix, suffix];
    }
    return self.endDate;
}

@end
