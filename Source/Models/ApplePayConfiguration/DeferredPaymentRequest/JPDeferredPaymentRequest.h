//
//  JPDeferredPaymentRequest.h
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

#import <PassKit/PassKit.h>

@class JPDeferredPaymentSummaryItem;

API_AVAILABLE(ios(16.4))
API_UNAVAILABLE(watchos)
@interface JPDeferredPaymentRequest : NSObject

@property (nonatomic, strong, nonnull) NSString *paymentDescription;
@property (nonatomic, strong, nonnull) NSURL *managementURL;
@property (nonatomic, strong, nonnull) JPDeferredPaymentSummaryItem *deferredBilling;
@property (nonatomic, strong, nullable) NSString *billingAgreement;
@property (nonatomic, strong, nullable) NSDate *freeCancellationDate;
@property (nonatomic, strong, nullable) NSTimeZone *freeCancellationDateTimeZone;

+ (nonnull instancetype)requestWithPaymentDescription:(nonnull NSString *)paymentDescription
                                      deferredBilling:(nonnull JPDeferredPaymentSummaryItem *)deferredBilling
                                     andManagementURL:(nonnull NSURL *)managementURL;

- (nonnull instancetype)initWithPaymentDescription:(nonnull NSString *)paymentDescription
                                   deferredBilling:(nonnull JPDeferredPaymentSummaryItem *)deferredBilling
                                  andManagementURL:(nonnull NSURL *)managementURL;

- (nonnull instancetype)init NS_UNAVAILABLE;

- (nullable PKDeferredPaymentRequest *)toPKDeferredPaymentRequest;

@end
