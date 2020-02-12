//
//  JPConfiguration.h
//  JudoKitObjC
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
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHx3ANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <Foundation/Foundation.h>
#import "JPSession.h"
#import "JPCardNetwork.h"
#import "ApplePayConfiguration.h"

@class JPAmount, JPReference, JPPaymentMethod, PaymentSummaryItem;

@interface JPConfiguration : NSObject

@property (nonatomic, strong, readonly) NSString *_Nonnull judoId;
@property (nonatomic, assign) TransactionType transactionType;
@property (nonatomic, strong, readonly) JPAmount *_Nonnull amount;
@property (nonatomic, strong, readonly) JPReference *_Nonnull reference;
@property (nonatomic, strong, readonly) JudoCompletionBlock _Nonnull completion;
@property (nonatomic, strong, readonly) NSArray<JPPaymentMethod *> *_Nullable paymentMethods;
@property (nonatomic, assign) CardNetwork cardNetworks;
@property (nonatomic, strong, readonly) ApplePayConfiguration *_Nullable applePayConfiguration;

- (nonnull instancetype)initWithJudoID:(nonnull NSString *)judoId
                                amount:(nonnull JPAmount *)amount
                             reference:(nonnull JPReference *)reference
                            completion:(nonnull JudoCompletionBlock)completion;

- (void)addPaymentMethods:(nonnull NSArray<JPPaymentMethod *> *)methods;

- (void)addSupportedCardNetworks:(CardNetwork)network;

- (void)configureApplePayWithMerchantId:(nonnull NSString *)merchantId
                            countryCode:(nonnull NSString *)countryCode
                    paymentSummaryItems:(nonnull NSArray<PaymentSummaryItem *> *)items;

- (void)setRequiredBillingContactFields:(ContactField)billingFields;

- (void)setRequiredShippingContactFields:(ContactField)shippingFields;

- (void)setReturnedContactInfo:(ReturnedInfo)returnedInfo;

@end
