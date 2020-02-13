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

#import "ApplePayConfiguration.h"
#import "JPCardNetwork.h"
#import "JPSession.h"
#import <Foundation/Foundation.h>

@class JPAmount, JPReference, JPPaymentMethod, PaymentSummaryItem;

@interface JPConfiguration : NSObject

/**
 * The merchant's Judo ID
 */
@property (nonatomic, strong, readonly) NSString *_Nonnull judoId;

/**
 * The currently set transaction type (only TransactionTypePayment or TransactionTypePreAuth are valid)
 */
@property (nonatomic, assign) TransactionType transactionType;

/**
 * The amount and currency of the current transaction
 */
@property (nonatomic, strong, readonly) JPAmount *_Nonnull amount;

/**
 * An instance of JPReference which holds both the consumer and the payment reference
 */
@property (nonatomic, strong, readonly) JPReference *_Nonnull reference;

/**
 * The completion block that will be called once the transaction finishes with either a response or an error
 */
@property (nonatomic, strong, readonly) JudoCompletionBlock _Nonnull completion;

/**
 * An array of payment methods that will be displayed on the Payment Method UI
 */
@property (nonatomic, strong, readonly) NSArray<JPPaymentMethod *> *_Nullable paymentMethods;

/**
 * The card networks supported by the merchant
 */
@property (nonatomic, assign) CardNetwork cardNetworks;

/**
 * The Apple Pay configuration object used to configure the Apple Pay flow
 */
@property (nonatomic, strong, readonly) ApplePayConfiguration *_Nullable applePayConfiguration;

/**
 * The designated initializer
 *
 * @param judoId - the Judo ID of the merchant
 * @param amount - the amount and currency of the transaction
 * @param reference - the JPReference object which holds both the consumer and the payment reference
 * @param completion - the completion block that will be called once the transaction finishes with either a response or an error
 */
- (nonnull instancetype)initWithJudoID:(nonnull NSString *)judoId
                                amount:(nonnull JPAmount *)amount
                             reference:(nonnull JPReference *)reference
                            completion:(nonnull JudoCompletionBlock)completion;

/**
 * A method which allows the merchant to set his preferred payment methods.
 * If not specified, the payment method defaults to Card payment and Apple Pay.
 * The payment methods will be displayed in the order they are added in the array
 *
 * @param methods - an array of JPPaymentMethod objects.
 */
- (void)addPaymentMethods:(nonnull NSArray<JPPaymentMethod *> *)methods;

/**
 * A method which allows the user to specify his supported card networks.
 * If not specified, it will accept all available card networks [Visa, MasterCard, AMEX, Maestro, JCB, China Union Pay, Discover]
 *
 * @param network - an NS_OPTION enumeration which allows you to specify multiple payment networks
 */
- (void)addSupportedCardNetworks:(CardNetwork)network;

/**
 * A method which allows the user to set all Apple Pay required parameters.
 * If no configuration is set, Apple Pay will not be displayed on the Payment Method screen, even though it has been selected as one of the payment methods.
 *
 * @param merchantId - the merchant ID related to Apple Pay
 * @param countryCode - the ISO 3166 country code (ex: GB, US, CA)
 * @param items - an array of PaymentSummaryItem objects used to describe the purchase. The last item of the array must always specify the total amount.
 */
- (void)configureApplePayWithMerchantId:(nonnull NSString *)merchantId
                            countryCode:(nonnull NSString *)countryCode
                    paymentSummaryItems:(nonnull NSArray<PaymentSummaryItem *> *)items;

/**
 * A method for setting the required billing fields that must be added by the user in the Apple Pay flow
 *
 * @param billingFields - an NS_OPTION enumeration which allows the merchant to specify multiple ContactField values
 */
- (void)setRequiredBillingContactFields:(ContactField)billingFields;

/**
 * A method for setting the required shipping fields that must be added by the user in the Apple Pay flow
 *
 * @param shippingFields - an NS_OPTION enumeration which allows the merchant to specify multiple ContactField values
 */
- (void)setRequiredShippingContactFields:(ContactField)shippingFields;

/**
 * A method which allows merchants to specify the contact info that they want returned in the response after the Apple Pay transaction
 *
 * @param returnedInfo - an NS_OPTION enumeration which allows the merchant to specify multiple ReturnInfo values
 */
- (void)setReturnedContactInfo:(ReturnedInfo)returnedInfo;

@end
