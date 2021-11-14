//
//  JPResponse.h
//  JudoKit_iOS
//
//  Copyright (c) 2016 Alternative Payments Ltd
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

#import "JPTransactionResult.h"
#import "JPTransactionType.h"
#import <Foundation/Foundation.h>

@class JPContactInformation, JPAmount, JPCardDetails, JPConsumer, JPOrderDetails;

/**
 *  JPResponse is an object that references all information in correspondence with a Transaction with the judo API
 */
@interface JPResponse : NSObject

/**
 *  Our reference for this transaction. Keep track of this as it's needed to process refunds or collections later
 */
@property (nonatomic, strong) NSString *_Nonnull receiptId;

/**
 *  Your original reference for this payment
 */
@property (nonatomic, strong) NSString *_Nonnull paymentReference;

/**
 *  The type of Transaction
 */
@property (nonatomic, assign) JPTransactionType type;

/**
 *  A redirect URL used for iDEAL bank transactions
 */
@property (nonatomic, strong) NSString *_Nullable redirectUrl;

/**
 *  An object describing the current payment method
 */
@property (nonatomic, strong) NSString *_Nullable paymentMethod;

/**
 *  An object containing information regarding the iDEAL transaction result
 */
@property (nonatomic, strong) JPOrderDetails *_Nullable orderDetails;

/**
 *  Date and time of the Transaction including time zone offset
 */
@property (nonatomic, strong) NSString *_Nonnull createdAt;

/**
 *  The result of this transactions, this will either be "Success" or "Declined"
 */
@property (nonatomic, assign) JPTransactionResult result;

/**
 *  A message detailing the result.
 */
@property (nonatomic, strong) NSString *_Nullable message;

/**
 *  The number (e.g. "123-456" or "654321") identifying the Merchant to whom payment has been made
 */
@property (nonatomic, strong) NSString *_Nonnull judoId;

/**
 *  The trading name of the Merchant to whom payment has been made
 */
@property (nonatomic, strong) NSString *_Nonnull merchantName;

/**
 *  How the Merchant will appear on the Consumers statement
 */
@property (nonatomic, strong) NSString *_Nonnull appearsOnStatementAs;

/**
 *  If present this will show the total value of refunds made against the original payment
 */
@property (nonatomic, strong) JPAmount *_Nullable refunds;

/**
 *  This is the original value of this transaction before refunds
 */
@property (nonatomic, strong) NSString *_Nullable originalAmount;

/**
 *  This will show the remaining balance of the transaction after refunds. You cannot refund more than the original payment
 */
@property (nonatomic, strong) NSString *_Nullable netAmount;

/**
 *  This is the value of this transaction (if refunds available it is the amount after refunds)
 */
@property (nonatomic, strong) JPAmount *_Nullable amount;

/**
 *  Information about the card used in this transaction
 */
@property (nonatomic, strong) JPCardDetails *_Nullable cardDetails;

/**
 *  Details of the Consumer for use in repeat payments
 */
@property (nonatomic, strong) JPConsumer *_Nonnull consumer;

/**
 * Billing contact information returned from ApplePay
 */
@property (nonatomic, strong) JPContactInformation *_Nullable billingInfo;

/**
 * Shipping contact information returned from ApplePay
 */
@property (nonatomic, strong) JPContactInformation *_Nullable shippingInfo;

/**
 *  Raw data of the received dictionary
 */
@property (nonatomic, strong) NSDictionary *_Nonnull rawData;

/**
 *  Create a JPResponse object from a dictionary
 *
 *  @param dictionary the dictionary
 *
 *  @return a JPResponse object
 */
- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

@end
