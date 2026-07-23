//
//  JPDeferredPaymentRequest.m
//  JudoKit_iOS
//
//  Copyright (c) 2026 Alternative Payments Ltd
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

#import "JPDeferredPaymentRequest.h"
#import "JPDeferredPaymentSummaryItem.h"

@implementation JPDeferredPaymentRequest

+ (instancetype)requestWithPaymentDescription:(NSString *)paymentDescription
                              deferredBilling:(JPDeferredPaymentSummaryItem *)deferredBilling
                             andManagementURL:(NSURL *)managementURL {
    return [[JPDeferredPaymentRequest alloc] initWithPaymentDescription:paymentDescription
                                                        deferredBilling:deferredBilling
                                                       andManagementURL:managementURL];
}

- (instancetype)initWithPaymentDescription:(NSString *)paymentDescription
                           deferredBilling:(JPDeferredPaymentSummaryItem *)deferredBilling
                          andManagementURL:(NSURL *)managementURL {
    if (self = [super init]) {
        _paymentDescription = paymentDescription;
        _deferredBilling = deferredBilling;
        _managementURL = managementURL;
    }
    return self;
}

- (PKDeferredPaymentRequest *)toPKDeferredPaymentRequest {
    if (self) {
        PKDeferredPaymentSummaryItem *item = self.deferredBilling.toPKDeferredPaymentSummaryItem;
        PKDeferredPaymentRequest *request = [[PKDeferredPaymentRequest alloc] initWithPaymentDescription:self.paymentDescription
                                                                                         deferredBilling:item
                                                                                           managementURL:self.managementURL];
        request.billingAgreement = self.billingAgreement;
        request.tokenNotificationURL = self.tokenNotificationURL;
        request.freeCancellationDate = self.freeCancellationDate;
        request.freeCancellationDateTimeZone = self.freeCancellationDateTimeZone;
        return request;
    }
    return nil;
}

@end
