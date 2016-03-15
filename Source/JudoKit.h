//
//  JudoKit.h
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

#import "JPTransactionData.h"

@class JPSession;

@class JPPayment, JPPreAuth, JPRegisterCard, JPTransaction;
@class JPCollection, JPVoid, JPRefund;
@class JPReceipt;

@class JPCardDetails;
@class JPPaymentToken;

@class JPTheme;

@class JPAmount;
@class JPReference;
@class JPPagination;
@class JPResponse;

@interface JudoKit : NSObject

@property (nonatomic, strong, readonly) JPSession * __nonnull apiSession;

@property (nonatomic, strong) JPTheme * __nonnull theme;

- (nonnull instancetype)initWithToken:(nonnull NSString *)token secret:(nonnull NSString *)secret allowJailbrokenDevices:(BOOL)jailbrokenDevicesAllowed;

- (nonnull instancetype)initWithToken:(nonnull NSString *)token secret:(nonnull NSString *)secret;

- (void)invokePayment:(nonnull NSString *)judoId amount:(nonnull JPAmount *)amount consumerReference:(nonnull NSString *)reference cardDetails:(nullable JPCardDetails *)cardDetails completion:(nonnull void(^)(JPResponse * _Nullable, NSError * _Nullable))completion;

- (void)invokePreAuth:(nonnull NSString *)judoId amount:(nonnull JPAmount *)amount consumerReference:(nonnull NSString *)reference cardDetails:(nullable JPCardDetails *)cardDetails completion:(nonnull void(^)(JPResponse * _Nullable, NSError * _Nullable))completion;

- (void)invokeRegisterCard:(nonnull NSString *)judoId amount:(nonnull JPAmount *)amount consumerReference:(nonnull NSString *)reference cardDetails:(nullable JPCardDetails *)cardDetails completion:(nonnull void(^)(JPResponse * _Nullable, NSError * _Nullable))completion;

- (void)invokeTokenPayment:(nonnull NSString *)judoId amount:(nonnull JPAmount *)amount consumerReference:(nonnull NSString *)reference cardDetails:(nullable JPCardDetails *)cardDetails paymentToken:(nonnull JPPaymentToken *)paymentToken completion:(nonnull void(^)(JPResponse * _Nullable, NSError * _Nullable))completion;

- (void)invokeTokenPreAuth:(nonnull NSString *)judoId amount:(nonnull JPAmount *)amount consumerReference:(nonnull NSString *)reference cardDetails:(nullable JPCardDetails *)cardDetails paymentToken:(nonnull JPPaymentToken *)paymentToken completion:(nonnull void(^)(JPResponse * _Nullable, NSError * _Nullable))completion;

- (nonnull JPPayment *)paymentWithJudoId:(nonnull NSString *)judoId amount:(nonnull JPAmount *)amount reference:(nonnull JPReference *)reference;

- (nonnull JPPreAuth *)preAuthWithJudoId:(nonnull NSString *)judoId amount:(nonnull JPAmount *)amount reference:(nonnull JPReference *)reference;

- (nonnull JPRegisterCard *)registerCardWithJudoId:(nonnull NSString *)judoId amount:(nullable JPAmount *)amount reference:(nonnull JPReference *)reference;

- (nonnull JPCollection *)collectionWithReceiptId:(nonnull NSString *)receiptId amount:(nonnull JPAmount *)amount;

- (nonnull JPVoid *)voidWithReceiptId:(nonnull NSString *)receiptId amount:(nonnull JPAmount *)amount;

- (nonnull JPRefund *)refundWithReceiptId:(nonnull NSString *)receiptId amount:(nonnull JPAmount *)amount;

- (nonnull JPReceipt *)receipt:(nullable NSString *)receiptId;

- (void)list:(nonnull Class)type paginated:(nullable JPPagination *)pagination completion:(nonnull void(^)(JPResponse * _Nullable, NSError * _Nullable))completion;

- (nonnull JPTransaction *)transactionForTypeClass:(nonnull Class)type judoId:(nonnull NSString *)judoId amount:(nonnull JPAmount *)amount reference:(nonnull JPReference *)reference;

- (nonnull JPTransaction *)transactionForType:(TransactionType)type judoId:(nonnull NSString *)judoId amount:(nonnull JPAmount *)amount reference:(nonnull JPReference *)reference;

@end
