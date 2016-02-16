//
//  JPTransactionProcess.m
//  JudoKitObjC
//
//  Created by ben.riazy on 16/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import "JPTransactionProcess.h"

#import "JPAmount.h"

#import "JPSession.h"

@interface JPTransactionProcess ()

@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation JPTransactionProcess

- (instancetype)initWithReceiptId:(NSString *)receiptId amount:(JPAmount *)amount paymentReference:(NSString *)paymentRef {
    self = [super init];
    if (self) {
        self.parameters = [NSMutableDictionary dictionary];
        self.parameters[@"receiptId"] = receiptId;
        self.parameters[@"amount"] = amount.amount;
        self.parameters[@"currency"] = amount.currency;
        self.parameters[@"yourPaymentReference"] = paymentRef;
    }
    return self;
}

- (void)sendWithCompletion:(void(^)(JPResponse *, NSError *))completion {
    [[JPSession sharedSession] POST:self.transactionProcessingPath parameters:self.parameters completion:completion];
}

#pragma mark - getters

- (NSString *)receiptId {
    return self.parameters[@"receiptId"];
}

- (JPAmount *)amount {
    return [JPAmount amount:self.parameters[@"amount"] currency:self.parameters[@"currency"]];
}

- (NSString *)paymentReference {
    return self.parameters[@"yourPaymentReference"];
}

- (NSString *)transactionProcessingPath {
    return @"/";
}

@end
