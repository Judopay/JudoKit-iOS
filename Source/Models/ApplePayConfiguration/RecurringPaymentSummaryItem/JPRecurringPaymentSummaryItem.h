//
//  JPRecurringPaymentSummaryItem.h
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

#import "JPPaymentSummaryItem.h"
#import <PassKit/PassKit.h>

API_AVAILABLE(ios(15.0), watchos(8.0))
@interface JPRecurringPaymentSummaryItem : JPPaymentSummaryItem

@property (nonatomic, strong, nullable) NSDate *startDate;
@property (nonatomic, strong, nullable) NSDate *endDate;
@property (nonatomic, assign) NSCalendarUnit intervalUnit;
@property (nonatomic, assign) NSInteger intervalCount;

+ (nonnull instancetype)itemWithLabel:(nonnull NSString *)label
                               amount:(nonnull NSDecimalNumber *)amount
                         intervalUnit:(NSCalendarUnit)intervalUnit
                     andIntervalCount:(NSInteger)intervalCount;

+ (nonnull instancetype)itemWithLabel:(nonnull NSString *)label
                               amount:(nonnull NSDecimalNumber *)amount
                         intervalUnit:(NSCalendarUnit)intervalUnit
                        intervalCount:(NSInteger)intervalCount
                            startDate:(nullable NSDate *)startDate
                           andEndDate:(nullable NSDate *)endDate;

- (nonnull instancetype)initWithLabel:(nonnull NSString *)label
                               amount:(nonnull NSDecimalNumber *)amount
                         intervalUnit:(NSCalendarUnit)intervalUnit
                     andIntervalCount:(NSInteger)intervalCount;

- (nonnull instancetype)initWithLabel:(nonnull NSString *)label
                               amount:(nonnull NSDecimalNumber *)amount
                         intervalUnit:(NSCalendarUnit)intervalUnit
                        intervalCount:(NSInteger)intervalCount
                            startDate:(nullable NSDate *)startDate
                           andEndDate:(nullable NSDate *)endDate;

- (nonnull PKRecurringPaymentSummaryItem *)toPKRecurringPaymentSummaryItem;

@end
