//
//  JPTransactionData.h
//  JudoKitObjC
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

#import <Foundation/Foundation.h>

@class JPAmount, JPCardDetails, JPConsumer, JPPaymentToken;


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

@property (nonatomic, strong) NSString * _Nonnull receiptId;
/// Your original reference for this payment
@property (nonatomic, strong) NSString * _Nonnull paymentReference;
/// The type of Transaction, either "Payment" or "Refund"
@property (nonatomic, assign) TransactionType type;
/// Date and time of the Transaction including time zone offset
@property (nonatomic, strong) NSString * _Nonnull createdAt;
/// The result of this transactions, this will either be "Success" or "Declined"
@property (nonatomic, assign) TransactionResult result;
/// A message detailing the result.
@property (nonatomic, strong) NSString * _Nullable message;
/// The number (e.g. "123-456" or "654321") identifying the Merchant to whom payment has been made
@property (nonatomic, strong) NSString * _Nonnull judoId;
/// The trading name of the Merchant to whom payment has been made
@property (nonatomic, strong) NSString * _Nonnull merchantName;
/// How the Merchant will appear on the Consumers statement
@property (nonatomic, strong) NSString * _Nonnull appearsOnStatementAs;
/// If present this will show the total value of refunds made against the original payment
@property (nonatomic, strong) JPAmount * _Nullable refunds;
/// This is the original value of this transaction before refunds
@property (nonatomic, strong) JPAmount * _Nullable originalAmount;
/// This will show the remaining balance of the transaction after refunds. You cannot refund more than the original payment
@property (nonatomic, strong) JPAmount * _Nullable netAmount;
/// This is the value of this transaction (if refunds available it is the amount after refunds)
@property (nonatomic, strong) JPAmount * _Nonnull amount;
/// Information about the card used in this transaction
@property (nonatomic, strong) JPCardDetails * _Nullable cardDetails;
/// Details of the Consumer for use in repeat payments
@property (nonatomic, strong) JPConsumer * _Nonnull consumer;
/// Raw data of the received dictionary
@property (nonatomic, strong) NSDictionary * _Nonnull rawData;

@property (nonatomic, strong, readonly) JPPaymentToken * _Nonnull paymentToken;

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

@end
