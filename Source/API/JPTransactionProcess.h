//
//  JPTransactionProcess.h
//  JudoKitObjC
//
//  Created by ben.riazy on 16/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JPAmount;

@interface JPTransactionProcess : NSObject

- (instancetype)initWithReceiptId:(NSString *)receiptId amount:(JPAmount *)amount paymentReference:(NSString *)paymentRef;

@end
