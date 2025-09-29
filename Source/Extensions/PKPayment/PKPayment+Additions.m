//
//  PKPayment+Additions.m
//  JudoKit_iOS
//
//  Copyright (c) 2025 Alternative Payments Ltd
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
#import "JPConfiguration.h"
#import "JPConsumer.h"
#import "JPFormatters.h"
#import "JPReference.h"
#import "JPResponse.h"
#import "PKPayment+Additions.h"

@implementation PKPayment (Additions)

- (JPResponse *)toJPResponseWithConfiguration:(JPConfiguration *)configuration {
    if (self && configuration) {
        JPResponse *response = [JPResponse new];

        response.judoId = configuration.judoId;
        response.paymentReference = configuration.reference.paymentReference;

        response.createdAt = [JPFormatters.sharedInstance.rfc3339DateFormatter stringFromDate:NSDate.date];

        response.consumer = [JPConsumer new];
        response.consumer.consumerReference = configuration.reference.consumerReference;

        response.amount = configuration.amount;

        response.cardDetails = [JPCardDetails new];
        response.cardDetails.cardToken = self.token.transactionIdentifier;
        response.cardDetails.cardScheme = self.token.paymentMethod.network;
        return response;
    }

    return nil;
}

@end
