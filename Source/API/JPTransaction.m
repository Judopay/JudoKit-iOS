//
//  JPTransaction.m
//  JudoKitObjC
//
//  Created by ben.riazy on 12/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import "JPTransaction.h"

#import "JPAmount.h"
#import "JPReference.h"
#import "JPCard.h"
#import "JPPaymentToken.h"

@interface JPReference ()

@property (nonatomic, strong, readwrite) NSString *paymentReference;
@property (nonatomic, strong, readwrite) NSString *consumerReference;

@end

@interface JPTransaction ()

@property (nonatomic, strong) NSString *currentTransactionReference;

@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation JPTransaction

- (instancetype)init {
    self = [super init];
    if (self) {
        self.parameters = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - getters and setters

- (NSString *)judoID {
    return self.parameters[@"judoId"];
}

- (void)setJudoID:(NSString *)judoID {
    self.parameters[@"judoId"] = judoID;
}

- (JPAmount *)amount {
    if (self.parameters[@"amount"] && self.parameters[@"currency"]) {
        NSString *amount = self.parameters[@"amount"];
        NSString *currency = self.parameters[@"currency"];
        return [JPAmount amount:amount currency:currency];
    }
    return nil;
}

- (void)setAmount:(JPAmount *)amount {
    self.parameters[@"amount"] = amount.amount;
    self.parameters[@"currency"] = amount.currency;
}

- (JPReference *)reference {
    if (self.parameters[@"yourConsumerReference"] && self.parameters[@"yourPaymentReference"]) {
        JPReference *reference = [JPReference new];
        reference.consumerReference = self.parameters[@"yourConsumerReference"];
        reference.paymentReference = self.parameters[@"yourPaymentReference"];
        reference.metaData = self.parameters[@"yourPaymentMetaData"];
        return reference;
    }
    return nil;
}

- (void)setReference:(JPReference *)reference {
    self.parameters[@"yourConsumerReference"] = reference.consumerReference;
    self.parameters[@"yourPaymentReference"] = reference.paymentReference;
    self.parameters[@"yourPaymentMetaData"] = reference.metaData;
}

- (JPCard *)card {
    if (self.parameters[@""]) {
        JPCard *card = [JPCard new];
        card.cardNumber = self.parameters[@"cardNumber"];
        card.expiryDate = self.parameters[@"expiryDate"];
        card.secureCode = self.parameters[@"cv2"];
        
        card.startDate = self.parameters[@"startDate"];
        card.issueNumber = self.parameters[@"issueNumber"];
        
        card.cardAddress = self.parameters[@"cardAddress"];
        
        return card;
    }
    return nil;
}

- (void)setCard:(JPCard *)card {
    if (card.cardNumber) {
        self.parameters[@"cardNumber"] = card.cardNumber;
    }
    if (card.expiryDate) {
        self.parameters[@"expiryDate"] = card.expiryDate;
    }
    if (card.secureCode) {
        self.parameters[@"cv2"] = card.secureCode;
    }
    
    if (card.startDate) {
        self.parameters[@"startDate"] = card.startDate;
    }
    if (card.issueNumber) {
        self.parameters[@"issueNumber"] = card.issueNumber;
    }
    
    if (card.cardAddress) {
        self.parameters[@"cardAddress"] = card.cardAddress;
    }
}

@end
