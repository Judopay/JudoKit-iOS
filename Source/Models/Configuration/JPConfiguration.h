//
//  JPConfiguration.h
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

#import "JPCardNetworkType.h"
#import <Foundation/Foundation.h>

@class JPAmount, JPReference, JPPaymentMethod, JPPrimaryAccountDetails, JPPaymentSummaryItem, JPAddress, JPApplePayConfiguration, JPUIConfiguration, JPNetworkTimeout, JPRecommendationConfiguration;

@interface JPConfiguration : NSObject

/**
 * The Judo ID required for JudoKit transactions
 */
@property (nonatomic, strong, readonly) NSString *judoId;

/**
 * The Receipt ID required for Refund, Void and Collection transactions
 */
@property (nonatomic, strong, readonly, nullable) NSString *receiptId;

/**
 * An object describing the amount of the transaction
 */
@property (nonatomic, strong, nonnull) JPAmount *amount;

/**
 * An object containing transaction-related references
 */
@property (nonatomic, strong, nonnull) JPReference *reference;

/**
 * An object containing information about the card address.
 * If set, will be sent to the Judo backend as part of the card details
 */
@property (nonatomic, strong, nullable) JPAddress *cardAddress;

/**
 * An object responsible for handling UI-related configurations
 */
@property (nonatomic, strong, nonnull) JPUIConfiguration *uiConfiguration;

/**
 * An array of JPPaymentMethod instances used to specify the payment methods that are to be displayed on the Judo Payment Method screen.
 */
@property (nonatomic, strong, nullable) NSArray<JPPaymentMethod *> *paymentMethods;

/**
 * An NS_OPTION property used to pick between a set of supported card network values.
 */
@property (nonatomic, assign) JPCardNetworkType supportedCardNetworks;

/**
 * An instance of JPPrimaryAccountDetails that, if set, will be passed in the transaction's request body.
 */
@property (nonatomic, strong, nullable) JPPrimaryAccountDetails *primaryAccountDetails;

/**
 * An instance of JPApplePayConfiguration required for Apple Pay-related transactions.
 * Not setting this property will hide Apple Pay from the Judo Payment Method screen, even though it has been set as one of the payment methods.
 */
@property (nonatomic, strong, nullable) JPApplePayConfiguration *applePayConfiguration;

/**
 * A  flag to sign up for a subscription-based service
 */
@property (nonatomic, assign) BOOL isInitialRecurringPayment;

/**
 * Sets the network read, write and connect timeouts.
 */
@property (nonatomic, strong, nullable) JPNetworkTimeout *networkTimeout;

/**
 * 3DS  Challenge Request Indicator
 */
@property (nonatomic, strong, nonnull) NSString *challengeRequestIndicator;

/**
 * 3DS  SCA Exemption
 */
@property (nonatomic, strong, nonnull) NSString *scaExemption;

/**
 * The card holder email
 */
@property (nonatomic, strong, nullable) NSString *emailAddress;

/**
 * The card holder mobile number
 */
@property (nonatomic, strong, nullable) NSString *phoneCountryCode;
@property (nonatomic, strong, nullable) NSString *mobileNumber;

/**
 * Sets the maximum timeout for 3DS 2.0 transactions in minutes.
 */
@property (nonatomic, assign) int threeDSTwoMaxTimeout;

/**
 * Sets the protocol message version for 3DS 2.0 transactions.
 */
@property (nonatomic, strong, nullable) NSString *threeDSTwoMessageVersion;

@property (nonatomic, assign) BOOL isDelayedAuthorisation;

@property (nonatomic, assign) BOOL isAllowIncrement;

/**
 * An instance of JPRecommendationConfiguration required for Recommendation Feature.
 */
@property (nonatomic, strong, nullable) JPRecommendationConfiguration *recommendationConfiguration;

/**
 * Designated initializer that sets the required parameters for most Judo transations.
 *  - Compatible with Payment, PreAuth, Register Card, Check Card, Save Card transactions.
 *  - Compatible with Apple Pay transactions.
 *  - Compatible with Judo Payment Method Selection screen.
 *
 *  @param judoId - the Judo ID of the merchant.
 *  @param amount - the JPAmount instance, contaning the amount and the currency of the transaction.
 *  @param reference - the JPReference instance, containing the consumer/payment references.
 *
 *  @returns a configured instance of JPConfiguration
 */
- (nonnull instancetype)initWithJudoID:(nonnull NSString *)judoId
                                amount:(nullable JPAmount *)amount
                             reference:(nonnull JPReference *)reference;

@end
