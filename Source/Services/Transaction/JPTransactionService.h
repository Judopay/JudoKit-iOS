//
//  JPTransactionService.h
//  JudoKitObjC
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

#import <Foundation/Foundation.h>

#import "JPConfiguration.h"
#import "JPReceipt.h"
#import "JPSession.h"
#import "JPTransaction.h"

@interface JPTransactionService : NSObject

/**
 * A boolean property that, if set to YES, toggles sandbox mode for the Judo transactions
 */
@property (nonatomic, assign) BOOL isSandboxed;

/**
 * A property which describes the transaction type
 */
@property (nonatomic, assign) TransactionType transactionType;

/**
 * Designated initializer that creates a configured instance of JPTransactionService based on a token and secret.
 *
 * @param token - a instance of NSString which describes the merchant's token.
 * @param secret - a instance of NSString which describes the merchant's secret.
 *
 * @returns - a configured instance of JPTransactionService
 */
- (instancetype)initWithToken:(NSString *)token
                    andSecret:(NSString *)secret;

/**
 * A method which returns a JPTransaction based on a provided configuration
 *
 * @param configuration - an instance of JPConfiguration which contains the required transaction parameters
 *
 * @returns - a configured instance of JPTransaction;
 */
- (JPTransaction *)transactionWithConfiguration:(JPConfiguration *)configuration;

/**
 * A method which returns a list of transactions based on a specified type.
 *
 * @param type - the type of the transaction.
 * @param pagination - an instance of JPPagination which offers pagination details
 * @param completion - a completion block with an optinal JPResponse or NSError
 */
- (void)listTransactionsOfType:(TransactionType)type
                     paginated:(JPPagination *)pagination
                    completion:(JudoCompletionBlock)completion;

/**
 * A method which returns a instance of JPReceipt based on a specified receipt ID.
 *
 * @param receiptId - an instance of NSString that serves as the receipt ID of a transaction.
 *
 * @returns - a configured instance of JPReceipt.
 */
- (JPReceipt *)receiptForReceiptId:(NSString *)receiptId;

@end
