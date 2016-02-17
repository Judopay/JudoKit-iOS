//
//  JPTransactionProcess.h
//  JudoKitObjC
//
//  Created by ben.riazy on 16/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JPAmount;
@class JPResponse;
@class JPSession;

@interface JPTransactionProcess : NSObject

@property (nonatomic, strong, readonly) NSString *receiptId;
@property (nonatomic, strong, readonly) JPAmount *amount;
@property (nonatomic, strong, readonly) NSString *paymentReference;

@property (nonatomic, strong, readonly) NSString *transactionProcessingPath;

@property (nonatomic, strong) JPSession *currentAPISession;

- (instancetype)initWithReceiptId:(NSString *)receiptId amount:(JPAmount *)amount paymentReference:(NSString *)paymentRef;

- (void)sendWithCompletion:(void(^)(JPResponse *, NSError *))completion;

@end
