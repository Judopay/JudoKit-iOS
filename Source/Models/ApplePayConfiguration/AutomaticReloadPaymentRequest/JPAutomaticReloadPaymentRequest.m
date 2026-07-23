//
//  JPAutomaticReloadPaymentRequest.m
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

#import "JPAutomaticReloadPaymentRequest.h"
#import "JPAutomaticReloadPaymentSummaryItem.h"

@implementation JPAutomaticReloadPaymentRequest

+ (instancetype)requestWithPaymentDescription:(NSString *)paymentDescription
                       automaticReloadBilling:(JPAutomaticReloadPaymentSummaryItem *)automaticReloadBilling
                             andManagementURL:(NSURL *)managementURL {
    return [[JPAutomaticReloadPaymentRequest alloc] initWithPaymentDescription:paymentDescription
                                                        automaticReloadBilling:automaticReloadBilling
                                                              andManagementURL:managementURL];
}

- (instancetype)initWithPaymentDescription:(NSString *)paymentDescription
                    automaticReloadBilling:(JPAutomaticReloadPaymentSummaryItem *)automaticReloadBilling
                          andManagementURL:(NSURL *)managementURL {
    if (self = [super init]) {
        _paymentDescription = paymentDescription;
        _automaticReloadBilling = automaticReloadBilling;
        _managementURL = managementURL;
    }
    return self;
}

- (PKAutomaticReloadPaymentRequest *)toPKAutomaticReloadPaymentRequest {
    if (self) {
        PKAutomaticReloadPaymentSummaryItem *item = self.automaticReloadBilling.toPKAutomaticReloadPaymentSummaryItem;
        PKAutomaticReloadPaymentRequest *request = [[PKAutomaticReloadPaymentRequest alloc] initWithPaymentDescription:self.paymentDescription
                                                                                                automaticReloadBilling:item
                                                                                                         managementURL:self.managementURL];
        request.billingAgreement = self.billingAgreement;
        request.tokenNotificationURL = self.tokenNotificationURL;
        return request;
    }
    return nil;
}

@end
