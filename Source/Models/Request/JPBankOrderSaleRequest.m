//
//  JPBankOrderSaleRequest.m
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

#import "JPBankOrderSaleRequest.h"
#import "JPAmount.h"
#import "JPConfiguration.h"
#import "JPReference.h"

static NSString *const kIDEALAccountHolderName = @"IDEAL Bank";
static NSString *const kIDEALCountry = @"NL";
static NSString *const kPaymentMethodIDEAL = @"IDEAL";

@implementation JPBankOrderSaleRequest

- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration {
    if (self = [super init]) {
        JPAmount *amount = configuration.amount;
        JPReference *reference = configuration.reference;

        _judoId = configuration.judoId;

        _amount = amount.amount;
        _currency = amount.currency;

        _merchantPaymentReference = reference.paymentReference;
        _merchantConsumerReference = reference.consumerReference;
        _paymentMetadata = reference.metaData;
    }
    return self;
}

+ (nonnull instancetype)idealRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                               andBIC:(nonnull NSString *)bic {
    JPBankOrderSaleRequest *request = [[JPBankOrderSaleRequest alloc] initWithConfiguration:configuration];
    request.paymentMethod = kPaymentMethodIDEAL;
    request.country = kIDEALCountry;
    request.accountHolderName = kIDEALAccountHolderName;
    request.bic = bic;
    return request;
}

@end
