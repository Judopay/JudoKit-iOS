//
//  JPApiService.h
//  JudoKit_iOS
//
//  Copyright (c) 2019 Alternative Payments Ltd
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

#import "Typedefs.h"
#import <Foundation/Foundation.h>

@protocol Authorization;

@class JPPaymentRequest,
JPTokenRequest,
JPBankOrderSaleRequest,
JPApplePayRequest,
JPCheckCardRequest,
JPSaveCardRequest,
JPRegisterCardRequest,
JP3DSecureAuthenticationResult;

@interface JPApiService : NSObject

- (nonnull instancetype)initWithAuthorization:(nonnull id <Authorization>)authorization isSandboxed:(BOOL)sandboxed;

- (void)invokePaymentWithRequest:(nonnull JPPaymentRequest *)request andCompletion:(nullable JPCompletionBlock)completion;

- (void)invokePreAuthPaymentWithRequest:(nonnull JPPaymentRequest *)request andCompletion:(nullable JPCompletionBlock)completion;

- (void)invokeTokenPaymentWithRequest:(nonnull JPTokenRequest *)request andCompletion:(nullable JPCompletionBlock)completion;

- (void)invokePreAuthTokenPaymentWithRequest:(nonnull JPTokenRequest *)request andCompletion:(nullable JPCompletionBlock)completion;

- (void)invokeComplete3dSecureWithReceiptId:(nonnull NSString *)receiptId
                       authenticationResult:(nonnull JP3DSecureAuthenticationResult *)result
                              andCompletion:(nullable JPCompletionBlock)completion;

- (void)invokeRegisterCardWithRequest:(nonnull JPRegisterCardRequest *)request andCompletion:(nullable JPCompletionBlock)completion;

- (void)invokeSaveCardWithRequest:(nonnull JPSaveCardRequest *)request andCompletion:(nullable JPCompletionBlock)completion;

- (void)invokeCheckCardWithRequest:(nonnull JPCheckCardRequest *)request andCompletion:(nullable JPCompletionBlock)completion;

- (void)invokeApplePayPaymentWithRequest:(nonnull JPApplePayRequest *)request andCompletion:(nullable JPCompletionBlock)completion;

- (void)invokePreAuthApplePayPaymentWithRequest:(nonnull JPApplePayRequest *)request andCompletion:(nullable JPCompletionBlock)completion;

- (void)invokeBankSaleWithRequest:(nonnull JPBankOrderSaleRequest *)request andCompletion:(nullable JPCompletionBlock)completion;

- (void)invokeOrderStatusWithOrderId:(nonnull NSString *)orderId andCompletion:(nullable JPCompletionBlock)completion;

@end
