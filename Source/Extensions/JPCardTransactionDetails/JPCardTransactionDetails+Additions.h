//
//  JPCardTransactionDetails+Additions.h
//  JudoKit_iOS
//
//  Copyright (c) 2022 Alternative Payments Ltd
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

#import "JPCardTransactionDetails.h"

@class JPPaymentRequest,
    JPPreAuthRequest,
    JPTokenRequest,
    JPPreAuthTokenRequest,
    JPRegisterCardRequest,
    JPSaveCardRequest,
    JPCheckCardRequest,
    JPConfiguration,
    JP3DSTransaction,
    JPCardTransactionDetailsOverrides;

@interface JPCardTransactionDetails (Additions)

- (nonnull JPPaymentRequest *)toPaymentRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                 andTransaction:(nonnull JP3DSTransaction *)transaction;

- (nonnull JPPreAuthRequest *)toPreAuthPaymentRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                        andTransaction:(nonnull JP3DSTransaction *)transaction;

- (nonnull JPPreAuthTokenRequest *)toPreAuthTokenRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                           andTransaction:(nonnull JP3DSTransaction *)transaction;

- (nonnull JPTokenRequest *)toTokenRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                             andTransaction:(nonnull JP3DSTransaction *)transaction;

/**
 * DEPRECATED: use Check Card feature instead.
 */
- (nonnull JPRegisterCardRequest *)toRegisterCardRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                           andTransaction:(nonnull JP3DSTransaction *)transaction
    __deprecated_msg("Register Card functionality has been deprecated and will be removed in a future version. Please use Check Card feature instead.");

- (nonnull JPSaveCardRequest *)toSaveCardRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                   andTransaction:(nonnull JP3DSTransaction *)transaction;

- (nonnull JPCheckCardRequest *)toCheckCardRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                     andTransaction:(nonnull JP3DSTransaction *)transaction;

- (nonnull JPPaymentRequest *)toPaymentRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                      overrides:(nullable JPCardTransactionDetailsOverrides *)overrides
                                                 andTransaction:(nonnull JP3DSTransaction *)transaction;

- (nonnull JPPreAuthRequest *)toPreAuthPaymentRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                             overrides:(nullable JPCardTransactionDetailsOverrides *)overrides
                                                        andTransaction:(nonnull JP3DSTransaction *)transaction;

- (nonnull JPTokenRequest *)toTokenRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                  overrides:(nullable JPCardTransactionDetailsOverrides *)overrides
                                             andTransaction:(nonnull JP3DSTransaction *)transaction;

- (nonnull JPPreAuthTokenRequest *)toPreAuthTokenRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                                overrides:(nullable JPCardTransactionDetailsOverrides *)overrides
                                                           andTransaction:(nonnull JP3DSTransaction *)transaction;

/**
 * DEPRECATED: use Check Card feature instead.
 */
- (nonnull JPRegisterCardRequest *)toRegisterCardRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                                overrides:(nullable JPCardTransactionDetailsOverrides *)overrides
                                                           andTransaction:(nonnull JP3DSTransaction *)transaction
    __deprecated_msg("Register Card functionality has been deprecated and will be removed in a future version. Please use Check Card feature instead.");

- (nonnull JPCheckCardRequest *)toCheckCardRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                          overrides:(nullable JPCardTransactionDetailsOverrides *)overrides
                                                     andTransaction:(nonnull JP3DSTransaction *)transaction;

- (nonnull NSString *)directoryServerIdInSandboxEnv:(BOOL)isSandboxed
                             usingFabrick3DSService:(BOOL)isUsingFabrick3DSService;

@end
