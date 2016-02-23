//
//  JudoKit.m
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

#import "JudoKit.h"

#import "JPSession.h"
#import "JPPayment.h"
#import "JPPreAuth.h"
#import "JPRefund.h"
#import "JPReceipt.h"
#import "JPReference.h"
#import "JPRegisterCard.h"
#import "JPVoid.h"
#import "JPCollection.h"

@interface JPSession ()

@property (nonatomic, strong, readwrite) NSString *authorizationHeader;

@end

@interface JudoKit ()

@property (nonatomic, strong, readwrite) JPSession *apiSession;

@end

@implementation JudoKit

- (instancetype)initWithToken:(NSString *)token secret:(NSString *)secret {
    return [self initWithToken:token secret:secret allowJailbrokenDevices:YES];
}

- (instancetype)initWithToken:(NSString *)token secret:(NSString *)secret allowJailbrokenDevices:(BOOL)jailbrokenDevicesAllowed {
    self = [super init];
    if (self) {
        NSString *plainString = [NSString stringWithFormat:@"%@:%@", token, secret];
        NSData *plainData = [plainString dataUsingEncoding:NSISOLatin1StringEncoding];
        NSString *base64String = [plainData base64EncodedStringWithOptions:0];
        
        self.apiSession = [JPSession new];
        
        [self.apiSession setAuthorizationHeader:[NSString stringWithFormat:@"Basic %@", base64String]];
    }
    return self;
}

- (JPTransaction *)transactionForType:(Class)type judoId:(NSString *)judoId amount:(JPAmount *)amount consumerReference:(NSString *)consumerReference {
    JPTransaction *transaction = [type new];
    transaction.judoId = judoId;
    transaction.amount = amount;
    transaction.reference = [[JPReference alloc] initWithConsumerReference:consumerReference];
    transaction.apiSession = self.apiSession;
    return transaction;
}

- (JPPayment *)paymentWithJudoId:(NSString *)judoId amount:(JPAmount *)amount consumerReference:(NSString *)consumerReference {
    return (JPPayment *)[self transactionForType:[JPPayment class] judoId:judoId amount:amount consumerReference:consumerReference];
}

- (JPPreAuth *)preAuthWithJudoId:(NSString *)judoId amount:(JPAmount *)amount consumerReference:(NSString *)consumerReference {
    return (JPPreAuth *)[self transactionForType:[JPPreAuth class] judoId:judoId amount:amount consumerReference:consumerReference];
}

- (JPRegisterCard *)registerCardWithJudoId:(NSString *)judoId amount:(JPAmount *)amount consumerReference:(NSString *)consumerReference {
    return (JPRegisterCard *)[self transactionForType:[JPRegisterCard class] judoId:judoId amount:amount consumerReference:consumerReference];
}

- (JPTransactionProcess *)transactionProcessForType:(Class)type receiptId:(NSString *)receiptId amount:(JPAmount *)amount paymentReference:(NSString *)paymentReference {
    JPTransactionProcess *transactionProc = [[type alloc] initWithReceiptId:receiptId amount:amount paymentReference:paymentReference];
    transactionProc.apiSession = self.apiSession;
    return transactionProc;
}

- (JPCollection *)collectionWithReceiptId:(NSString *)receiptId amount:(JPAmount *)amount paymentReference:(NSString *)paymentReference {
    return (JPCollection *)[self transactionProcessForType:[JPCollection class] receiptId:receiptId amount:amount paymentReference:paymentReference];
}

- (JPVoid *)voidWithReceiptId:(NSString *)receiptId amount:(JPAmount *)amount paymentReference:(NSString *)paymentReference {
    return (JPVoid *)[self transactionProcessForType:[JPVoid class] receiptId:receiptId amount:amount paymentReference:paymentReference];
}

- (JPRefund *)refundWithReceiptId:(NSString *)receiptId amount:(JPAmount *)amount paymentReference:(NSString *)paymentReference {
    return (JPRefund *)[self transactionProcessForType:[JPRefund class] receiptId:receiptId amount:amount paymentReference:paymentReference];
}

- (JPReceipt *)receipt:(NSString *)receiptId {
    JPReceipt *receipt = [[JPReceipt alloc] initWithReceiptId:receiptId];
    receipt.apiSession = self.apiSession;
    return receipt;
}


- (void)list:(Class)type paginated:(JPPagination *)pagination completion:(JudoCompletionBlock)completion {
    JPTransaction *transaction = [type new];
    transaction.apiSession = self.apiSession;
    [transaction listWithPagination:pagination completion:completion];
}

@end
