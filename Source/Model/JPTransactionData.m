//
//  JPTransactionData.m
//  JudoKitObjC
//
//  Created by Hamon Riazy on 19/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import "JPTransactionData.h"
#import "JPAmount.h"
#import "JPCardDetails.h"

@implementation JPTransactionData

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.receiptId = dictionary[@"receiptId"];
        self.paymentReference = dictionary[@"yourPaymentReference"];
        self.type = [self transactionTypeForString:dictionary[@"type"]];
        self.createdAt = dictionary[@"createdAt"];
        self.result = [self transactionResultForString:dictionary[@"result"]];
        self.message = dictionary[@"message"];
        self.judoId = dictionary[@"judoId"];
        self.merchantName = dictionary[@"merchantName"];
        self.appearsOnStatementAs = dictionary[@"appearsOnStatementAs"];
        NSString *currency = dictionary[@"currency"];
        if (dictionary[@"refunds"]) {
            self.refunds = [[JPAmount alloc] initWithAmount:dictionary[@"refunds"] currency:currency];
        }
        self.originalAmount = dictionary[@"originalAmount"];
        
        self.netAmount = dictionary[@"netAmount"];
        NSString *amount = dictionary[@"amount"];
        self.amount = [[JPAmount alloc] initWithAmount:amount currency:currency];
        NSDictionary *cardDetailsDictionary = dictionary[@"cardDetails"];
        self.cardDetails = [[JPCardDetails alloc] init];
        // TODO:
        self.consumer = dictionary[@"consumer"];
        self.rawData = dictionary;
    }
    return self;
}

- (TransactionResult)transactionResultForString:(NSString *)resultString {
    return TransactionResultDeclined;
}

- (TransactionType)transactionTypeForString:(NSString *)typeString {
    return TransactionTypePayment;
}

/*
 
 guard let receiptID = dict["receiptId"] as? String,
 let yourPaymentReference = dict["yourPaymentReference"] as? String,
 let typeString = dict["type"] as? String,
 let type = TransactionType(rawValue: typeString),
 let createdAtString = dict["createdAt"] as? String,
 let createdAt = ISO8601DateFormatter.dateFromString(createdAtString),
 let resultString = dict["result"] as? String,
 let result = TransactionResult(rawValue: resultString),
 let judoID = dict["judoId"] as? NSNumber,
 let merchantName = dict["merchantName"] as? String,
 let appearsOnStatementAs = dict["appearsOnStatementAs"] as? String,
 let currency = dict["currency"] as? String,
 let amountString = dict["amount"] as? String,
 let cardDetailsDict = dict["cardDetails"] as? JSONDictionary,
 let consumerDict = dict["consumer"] as? JSONDictionary else {
 self.receiptID = ""
 self.yourPaymentReference = ""
 self.type = TransactionType.Payment
 self.createdAt = NSDate()
 self.result = TransactionResult.Error
 self.message = ""
 self.judoID = ""
 self.merchantName = ""
 self.appearsOnStatementAs = ""
 self.refunds = Amount(amountString: "1", currency: "XOR")
 self.originalAmount = Amount(amountString: "1", currency: "XOR")
 self.netAmount = Amount(amountString: "1", currency: "XOR")
 self.amount = Amount(amountString: "1", currency: "XOR")
 self.cardDetails = CardDetails(nil)
 self.consumer = Consumer(consumerToken: "", consumerReference: "")
 self.rawData = [String : AnyObject]()
 super.init()
 throw JudoError(.ResponseParseError)
 }
 
 self.receiptID = receiptID
 self.yourPaymentReference = yourPaymentReference
 self.type = type
 self.createdAt = createdAt
 self.result = result
 self.message = dict["message"] as? String
 self.judoID = String(judoID.integerValue)
 self.merchantName = merchantName
 self.appearsOnStatementAs = appearsOnStatementAs
 
 if let refunds = dict["refunds"] as? String {
 self.refunds = Amount(amountString: refunds, currency: currency)
 } else {
 self.refunds = nil
 }
 
 if let originalAmount = dict["originalAmount"] as? String {
 self.originalAmount = Amount(amountString: originalAmount, currency: currency)
 } else {
 self.originalAmount = nil
 }
 
 if let netAmount = dict["netAmount"] as? String {
 self.netAmount = Amount(amountString: netAmount, currency: currency)
 } else {
 self.netAmount = nil
 }
 
 self.amount = Amount(amountString: amountString, currency: currency)
 
 self.cardDetails = CardDetails(cardDetailsDict)
 self.consumer = Consumer(consumerDict)
 self.rawData = dict
 
 */

@end
