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
#import "NSString+Additions.h"

@interface JPCardDetails ()
@property (nonatomic, strong) NSDateFormatter *expiryDateFormatter;
@end

@implementation JPCardDetails

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
        self.cardNetwork = [self cardNetworkTypeFromRawValue:dictionary[@"cardType"]];
    }
    return self;
}

- (JPCardNetworkType)cardNetworkTypeFromRawValue:(NSNumber *)rawValue {
    switch (rawValue.unsignedIntegerValue) {
        case 1:
        case 3:  // VISA ELECTRON
        case 11: // VISA DEBIT
        case 13: // VISA PURCHASING
            return JPCardNetworkTypeVisa;

        case 2:
        case 12: // MASTERCARD DEBIT
            return JPCardNetworkTypeMasterCard;

        case 7:
            return JPCardNetworkTypeChinaUnionPay;

        case 8:
            return JPCardNetworkTypeAMEX;

        case 9:
            return JPCardNetworkTypeJCB;

        case 10:
            return JPCardNetworkTypeMaestro;

        case 14:
            return JPCardNetworkTypeDiscover;

        case 17:
            return JPCardNetworkTypeDinersClub;

        default:
            return JPCardNetworkTypeUnknown;
    }
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
            self.endDate = [self.expiryDateFormatter stringFromDate:expiryDate];
        }
        self.cardNumber = cardNumber;
    }
    return self;
}

- (JPCardNetworkType)cardNetwork {
    if (_cardNetwork == JPCardNetworkTypeUnknown && self.cardNumber) {
        _cardNetwork = self.cardNumber.cardNetwork;
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

#pragma mark - Lazy Loading

- (NSDateFormatter *)expiryDateFormatter {
    if (!_expiryDateFormatter) {
        _expiryDateFormatter = [NSDateFormatter new];
        _expiryDateFormatter.dateFormat = kMonthYearDateFormat;
    }
    return _expiryDateFormatter;
}

@end
