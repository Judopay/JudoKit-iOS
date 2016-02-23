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
#import "JPConsumer.h"

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
        if (cardDetailsDictionary) {
            self.cardDetails = [[JPCardDetails alloc] initWithDictionary:cardDetailsDictionary];
        }
        self.consumer = [[JPConsumer alloc] initWithDictionary:dictionary[@"consumer"]];
        self.rawData = dictionary;
    }
    return self;
}

- (TransactionResult)transactionResultForString:(NSString *)resultString {
    if ([resultString isEqualToString:@"Success"]) {
        return TransactionResultSuccess;
    } else if ([resultString isEqualToString:@"Declined"]) {
        return TransactionResultDeclined;
    }
    return TransactionResultError;
}

- (TransactionType)transactionTypeForString:(NSString *)typeString {
    if ([typeString isEqualToString:@"Payment"]) {
        return TransactionTypePayment;
    } else if ([typeString isEqualToString:@"PreAuth"]) {
        return TransactionTypePreAuth;
    } else if ([typeString isEqualToString:@"RegisterCard"]) {
        return TransactionTypeRegisterCard;
    }
    return TransactionTypeRefund;
}



@end
