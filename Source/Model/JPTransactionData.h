//
//  JPTransactionData.h
//  JudoKitObjC
//
//  Created by Hamon Riazy on 19/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JPAmount, JPCardDetails, JPConsumer;


typedef NS_ENUM(NSUInteger, TransactionType) {
    TransactionTypePayment,
    TransactionTypePreAuth,
    TransactionTypeRefund,
    TransactionTypeRegisterCard
};


typedef NS_ENUM(NSUInteger, TransactionResult) {
    TransactionResultSuccess,
    TransactionResultDeclined,
    TransactionResultError
};


@interface JPTransactionData : NSObject

@property (nonatomic, strong) NSString * __nonnull receiptId;
/// Your original reference for this payment
@property (nonatomic, strong) NSString * __nonnull yourPaymentReference;
/// The type of Transaction, either "Payment" or "Refund"
@property (nonatomic, assign) TransactionType type;
/// Date and time of the Transaction including time zone offset
@property (nonatomic, strong) NSDate * __nonnull createdAt;
/// The result of this transactions, this will either be "Success" or "Declined"
@property (nonatomic, assign) TransactionResult result;
/// A message detailing the result.
@property (nonatomic, strong) NSString * __nullable String;
/// The number (e.g. "123-456" or "654321") identifying the Merchant to whom payment has been made
@property (nonatomic, strong) NSString * __nonnull judoId;
/// The trading name of the Merchant to whom payment has been made
@property (nonatomic, strong) NSString * __nonnull merchantName;
/// How the Merchant will appear on the Consumers statement
@property (nonatomic, strong) NSString * __nonnull appearsOnStatementAs;
/// If present this will show the total value of refunds made against the original payment
@property (nonatomic, strong) JPAmount * __nullable refunds;
/// This is the original value of this transaction before refunds
@property (nonatomic, strong) JPAmount * __nullable originalAmount;
/// This will show the remaining balance of the transaction after refunds. You cannot refund more than the original payment
@property (nonatomic, strong) JPAmount * __nullable netAmount;
/// This is the value of this transaction (if refunds available it is the amount after refunds)
@property (nonatomic, strong) JPAmount * __nonnull amount;
/// Information about the card used in this transaction
@property (nonatomic, strong) JPCardDetails * __nullable cardDetails;
/// Details of the Consumer for use in repeat payments
@property (nonatomic, strong) JPConsumer * __nonnull consumer;
/// Raw data of the received dictionary
@property (nonatomic, strong) NSDictionary * __nonnull rawData;

@end
