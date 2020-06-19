//
//  JPTransactionService.h
//  JudoKit-iOS
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

#import "JPTransactionType.h"
#import "JPTransactionViewModel.h"
#import "Typedefs.h"
#import <Foundation/Foundation.h>

extern NSString *_Nonnull const kPaymentEndpoint;
extern NSString *_Nonnull const kPreauthEndpoint;
extern NSString *_Nonnull const kRegisterCardEndpoint;
extern NSString *_Nonnull const kSaveCardEndpoint;

typedef NS_ENUM(NSUInteger, JPHTTPMethod) {
    JPHTTPMethodGET,
    JPHTTPMethodPOST,
};

@class JPConfiguration, JPTransaction;

@interface JPTransactionService : NSObject

/**
 * A boolean property that, if set to YES, toggles sandbox mode for the Judo transactions
 */
@property (nonatomic, assign) BOOL isSandboxed;

/**
 * Designated initializer that creates a configured instance of JPTransactionService based on a token and secret.
 *
 * @param token - a instance of NSString which describes the merchant's token.
 * @param secret - a instance of NSString which describes the merchant's secret.
 *
 * @returns - a configured instance of JPTransactionService
 */
- (nonnull instancetype)initWithToken:(nonnull NSString *)token
                            andSecret:(nonnull NSString *)secret;

/**
 * A method which returns a JPTransaction based on a provided configuration
 *
 * @param configuration - an instance of JPConfiguration which contains the required transaction parameters
 *
 * @returns - a configured instance of JPTransaction;
 */
- (nonnull JPTransaction *)transactionWithConfiguration:(nonnull JPConfiguration *)configuration andType:(JPTransactionType)type;

/**
 * A method for sending REST API requests
 *
 * @param transaction - mandatory JPTransaction object
 * @param completion - a completion block that returns an optional JPResponse or NSError
 */
- (void)sendWithTransaction:(nonnull JPTransaction *)transaction
              andCompletion:(nonnull JPCompletionBlock)completion;

@end
