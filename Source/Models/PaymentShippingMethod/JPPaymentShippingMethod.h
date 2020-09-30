//
//  JPPaymentShippingMethod.h
//  JudoKit_iOS
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

#import "JPPaymentSummaryItem.h"
#import <Foundation/Foundation.h>

@interface JPPaymentShippingMethod : JPPaymentSummaryItem

/**
 * Identifier for the shipping method, used by the app.
 */
@property (nonatomic, strong) NSString *_Nonnull identifier;

/**
 * A user-readable description of the shipping method.
 */
@property (nonatomic, strong) NSString *_Nonnull detail;

/**
 * Designated initializer
 *
 * @param identifier - identifier for the shipping method, used by the app.
 * @param detail  - a user-readable description of the shipping method.
 * @param label  - title of the item
 * @param amount - amount to be payed for this item
 * @param type   - payment type for this item ( _Nonnull final / pending)
 */
- (_Nonnull instancetype)initWithIdentifier:(NSString *_Nonnull)identifier
                                     detail:(NSString *_Nonnull)detail
                                      label:(NSString *_Nonnull)label
                                     amount:(NSDecimalNumber *_Nonnull)amount
                                       type:(JPPaymentSummaryItemType)type;

@end
