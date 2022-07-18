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
    JPTokenRequest,
    JPRegisterCardRequest,
    JPSaveCardRequest,
    JPCheckCardRequest,
    JPConfiguration,
    JP3DSTransaction;

@interface JPCardTransactionDetails (Additions)

- (nonnull JPPaymentRequest *)_jp_toPaymentRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                     andTransaction:(nonnull JP3DSTransaction *)transaction;

- (nonnull JPTokenRequest *)_jp_toTokenRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                 andTransaction:(nonnull JP3DSTransaction *)transaction;

- (nonnull JPRegisterCardRequest *)_jp_toRegisterCardRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                               andTransaction:(nonnull JP3DSTransaction *)transaction;

- (nonnull JPSaveCardRequest *)_jp_toSaveCardRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                       andTransaction:(nonnull JP3DSTransaction *)transaction;

- (nonnull JPCheckCardRequest *)_jp_toCheckCardRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                         andTransaction:(nonnull JP3DSTransaction *)transaction;

@end
