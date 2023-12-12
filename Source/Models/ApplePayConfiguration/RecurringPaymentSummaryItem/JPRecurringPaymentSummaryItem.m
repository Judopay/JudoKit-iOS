//
//  JPRecurringPaymentSummaryItem.m
//  JudoKit_iOS
//
//  Copyright (c) 2023 Alternative Payments Ltd
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

#import "JPRecurringPaymentSummaryItem.h"

@implementation JPRecurringPaymentSummaryItem

+ (instancetype)itemWithLabel:(NSString *)label
                       amount:(NSDecimalNumber *)amount
                 intervalUnit:(NSCalendarUnit)intervalUnit
             andIntervalCount:(NSInteger)intervalCount {
    return [[JPRecurringPaymentSummaryItem alloc] initWithLabel:label
                                                         amount:amount
                                                   intervalUnit:intervalUnit
                                               andIntervalCount:intervalCount];
}

+ (instancetype)itemWithLabel:(NSString *)label
                       amount:(NSDecimalNumber *)amount
                 intervalUnit:(NSCalendarUnit)intervalUnit
                intervalCount:(NSInteger)intervalCount
                    startDate:(NSDate *)startDate
                   andEndDate:(NSDate *)endDate {
    return [[JPRecurringPaymentSummaryItem alloc] initWithLabel:label
                                                         amount:amount
                                                   intervalUnit:intervalUnit
                                                  intervalCount:intervalCount
                                                      startDate:startDate
                                                     andEndDate:endDate];
}

- (instancetype)initWithLabel:(NSString *)label
                       amount:(NSDecimalNumber *)amount
                 intervalUnit:(NSCalendarUnit)intervalUnit
             andIntervalCount:(NSInteger)intervalCount {
    if (self = [super initWithLabel:label amount:amount]) {
        _intervalUnit = intervalUnit;
        _intervalCount = intervalCount;
    }
    return self;
}

- (instancetype)initWithLabel:(NSString *)label
                       amount:(NSDecimalNumber *)amount
                 intervalUnit:(NSCalendarUnit)intervalUnit
                intervalCount:(NSInteger)intervalCount
                    startDate:(NSDate *)startDate
                   andEndDate:(NSDate *)endDate {
    if (self = [super initWithLabel:label amount:amount]) {
        _intervalUnit = intervalUnit;
        _intervalCount = intervalCount;
        _startDate = startDate;
        _endDate = endDate;
    }
    return self;
}

- (PKRecurringPaymentSummaryItem *)toPKRecurringPaymentSummaryItem {
    PKRecurringPaymentSummaryItem *item = [PKRecurringPaymentSummaryItem summaryItemWithLabel:self.label
                                                                                       amount:self.amount];
    item.startDate = self.startDate;
    item.endDate = self.endDate;
    item.intervalUnit = self.intervalUnit;
    item.intervalCount = self.intervalCount;
    return item;
}

@end
