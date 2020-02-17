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

#import "JPApplePayConfiguration.h"
#import "JPCardNetwork.h"
#import "JPSession.h"
#import "JPTransaction.h"
#import <Foundation/Foundation.h>

@class JPAmount, JPReference, JPPaymentMethod, JPPrimaryAccountDetails, PaymentSummaryItem;

@interface JPConfiguration : NSObject
@property (nonatomic, strong, readonly) NSString *_Nullable judoId;
@property (nonatomic, strong, readonly) NSString *_Nullable receiptId;
@property (nonatomic, strong, readonly) JPAmount *_Nonnull amount;
@property (nonatomic, strong, readonly) JPReference *_Nonnull reference;
@property (nonatomic, assign) BOOL isAVSEnabled;
@property (nonatomic, strong) NSArray<JPPaymentMethod *> *_Nullable paymentMethods;
@property (nonatomic, assign) CardNetwork supportedCardNetworks;
@property (nonatomic, strong) JPPrimaryAccountDetails *_Nullable primaryAccountDetails;
@property (nonatomic, strong, readonly) JPApplePayConfiguration *_Nullable applePayConfiguration;

//---------------------------------------------------------------------------
#pragma mark - Initializer
//---------------------------------------------------------------------------

- (nonnull instancetype)initWithJudoID:(nonnull NSString *)judoId
                                amount:(nonnull JPAmount *)amount
                             reference:(nonnull JPReference *)reference;

//---------------------------------------------------------------------------
#pragma mark - Apple Pay Configuration
//---------------------------------------------------------------------------

- (void)configureApplePayWithMerchantId:(nonnull NSString *)merchantId
                            countryCode:(nonnull NSString *)countryCode
                    paymentSummaryItems:(nonnull NSArray<PaymentSummaryItem *> *)items;

//---------------------------------------------------------------------------
#pragma mark - Apple Pay Additional Fields
//---------------------------------------------------------------------------

- (void)setRequiredBillingContactFields:(ContactField)billingFields;
- (void)setRequiredShippingContactFields:(ContactField)shippingFields;
- (void)setReturnedContactInfo:(ReturnedInfo)returnedInfo;

@end
