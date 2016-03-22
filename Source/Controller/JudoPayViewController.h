//
//  JudoPayViewController.h
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

#import <UIKit/UIKit.h>
#import "JPTransactionData.h"

@class JudoKit, JPTheme, JPAmount, JPReference, JPPaymentToken, JudoPayView, JPResponse;

@interface JudoPayViewController : UIViewController

@property (nonatomic, strong) JudoKit * _Nullable judoKitSession;

@property (nonatomic, strong) JPTheme * _Nullable theme;

@property (nonatomic, assign) TransactionType type;

@property (nonatomic, strong, readonly) JPAmount * _Nonnull amount;
@property (nonatomic, strong, readonly) NSString * _Nonnull judoId;
@property (nonatomic, strong, readonly) JPReference * _Nonnull reference;

@property (nonatomic, strong) JPPaymentToken * _Nullable paymentToken;

- (nonnull instancetype)initWithJudoId:(nonnull NSString *)judoId amount:(nullable JPAmount *)amount reference:(nonnull JPReference *)reference transaction:(TransactionType)type currentSession:(nonnull JudoKit *)session cardDetails:(nullable JPCardDetails *)cardDetails completion:(nonnull void(^)(JPResponse * _Nullable, NSError * _Nullable))completion;

@end
