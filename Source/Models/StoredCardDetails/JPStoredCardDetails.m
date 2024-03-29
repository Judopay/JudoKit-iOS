//
//  JPStoredCardDetails.m
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

#import "JPStoredCardDetails.h"
#import "JPConstants.h"
#import "JPFormatters.h"

@interface JPStoredCardDetails ()

@property (nonatomic, strong) NSDate *currentDate;

@end

@implementation JPStoredCardDetails

- (instancetype)initWithLastFour:(NSString *)lastFour
                      expiryDate:(NSString *)expiryDate
                     cardNetwork:(JPCardNetworkType)network
                       cardToken:(NSString *)cardToken
                  cardholderName:(NSString *)cardholderName {
    if (self = [super init]) {
        self.cardLastFour = lastFour;
        self.expiryDate = expiryDate;
        self.cardNetwork = network;
        self.cardToken = cardToken;
        self.expirationStatus = [self determineCardExpirationStatus];
        self.cardholderName = cardholderName;
    }
    return self;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    NSString *cardTitle = dictionary[@"cardTitle"];
    NSNumber *patternType = dictionary[@"cardPatternType"];
    NSString *cardLastFour = dictionary[@"cardLastFour"];
    NSString *expiryDate = dictionary[@"expiryDate"];
    NSNumber *cardNetwork = dictionary[@"cardNetwork"];
    NSString *cardToken = dictionary[@"cardToken"];
    NSNumber *isDefault = dictionary[@"isDefault"];
    NSNumber *isSelected = dictionary[@"isSelected"];
    NSString *cardholderName = dictionary[@"cardholderName"];

    JPStoredCardDetails *storedCardDetails = [self initWithLastFour:cardLastFour
                                                         expiryDate:expiryDate
                                                        cardNetwork:cardNetwork.intValue
                                                          cardToken:cardToken
                                                     cardholderName:cardholderName];

    storedCardDetails.cardTitle = cardTitle;
    storedCardDetails.patternType = patternType.intValue;
    storedCardDetails.isDefault = isDefault.boolValue;
    storedCardDetails.isSelected = isSelected.boolValue;

    return storedCardDetails;
}

+ (instancetype)cardDetailsWithLastFour:(NSString *)lastFour
                             expiryDate:(NSString *)expiryDate
                            cardNetwork:(JPCardNetworkType)network
                              cardToken:(NSString *)cardToken
                         cardHolderName:(NSString *)cardholderName {
    return [[JPStoredCardDetails new] initWithLastFour:lastFour
                                            expiryDate:expiryDate
                                           cardNetwork:network
                                             cardToken:cardToken
                                        cardholderName:cardholderName];
}

+ (instancetype)cardDetailsFromDictionary:(NSDictionary *)dictionary {
    return [[JPStoredCardDetails new] initFromDictionary:dictionary];
}

- (NSDictionary *)_jp_toDictionary {
    NSDictionary *data = @{
        @"cardTitle" : self.cardTitle ? self.cardTitle : @"",
        @"cardPatternType" : @(self.patternType),
        @"cardLastFour" : self.cardLastFour ? self.cardLastFour : @"",
        @"expiryDate" : self.expiryDate ? self.expiryDate : @"",
        @"cardNetwork" : @(self.cardNetwork),
        @"cardToken" : self.cardToken ? self.cardToken : @"",
        @"isDefault" : @(self.isDefault),
        @"isSelected" : @(self.isSelected),
        @"cardholderName" : self.cardholderName ? self.cardholderName : @""
    };
    return data;
}

- (JPCardExpirationStatus)determineCardExpirationStatus {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *cardExpirationDate = [JPFormatters.sharedInstance.expiryDateFormatter dateFromString:self.expiryDate];
    NSDate *dateInTwoMonths = [calendar dateByAddingUnit:NSCalendarUnitMonth
                                                   value:2
                                                  toDate:self.currentDate
                                                 options:0];

    NSDate *datePreviousMonth = [calendar dateByAddingUnit:NSCalendarUnitMonth
                                                     value:-1
                                                    toDate:self.currentDate
                                                   options:0];

    if ([cardExpirationDate compare:datePreviousMonth] == NSOrderedAscending) {
        return JPCardExpirationStatusExpired;
    }

    if ([cardExpirationDate compare:dateInTwoMonths] == NSOrderedAscending) {
        return JPCardExpirationStatusExpiresSoon;
    }

    return JPCardExpirationStatusNotExpired;
}

- (NSDate *)currentDate {
    if (!_currentDate) {
        _currentDate = [NSDate date];
    }
    return _currentDate;
}

@end
