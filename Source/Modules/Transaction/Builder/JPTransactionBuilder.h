//
//  JPTransactionBuilder.h
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

#import "JPCardNetworkType.h"
#import "JPPresentationMode.h"
#import "JPTransactionType.h"
#import "Typedefs.h"
#import <Foundation/Foundation.h>

@class JPApiService, JPConfiguration, JPTransactionViewController, JPCardTransactionDetails, RavelinCardEncryptionService;

@protocol JPTransactionBuilder

+ (JPTransactionViewController *)buildModuleWithApiService:(JPApiService *)apiService
                                         encryptionService:(RavelinCardEncryptionService *)encryptionService
                                             configuration:(JPConfiguration *)configuration
                                           transactionType:(JPTransactionType)type
                                          presentationMode:(JPPresentationMode)mode
                                                completion:(JPCompletionBlock)completion;

+ (JPTransactionViewController *)buildModuleWithApiService:(JPApiService *)apiService
                                         encryptionService:(RavelinCardEncryptionService *)encryptionService
                                             configuration:(JPConfiguration *)configuration
                                           transactionType:(JPTransactionType)type
                                          presentationMode:(JPPresentationMode)mode
                                        transactionDetails:(JPCardTransactionDetails *)details
                                                completion:(JPCompletionBlock)completion;

@end

@interface JPTransactionBuilderImpl : NSObject <JPTransactionBuilder>

@end
