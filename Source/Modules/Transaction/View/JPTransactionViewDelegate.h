//
//  JPTransactionViewDelegate.h
//  JudoKit_iOS
//
//  Copyright (c) 2020 Alternative Payments Ltd
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

NS_ASSUME_NONNULL_BEGIN

@class JPApiService, JPConfiguration, JPCardTransactionDetails;
typedef NS_ENUM(NSUInteger, JPTransactionType);

#pragma mark - JPTransactionViewDelegate

@protocol JPTransactionViewDelegate
/**
 * A method that is called once the Add Card flow completes
 */
- (void)didFinishAddingCard;

/**
 * A method that is called once the Ask for CSC and/or Cardholder Name flow completes
 */
- (void)didInputSecurityCode:(NSString *)csc andCardholderName:(NSString *)cardholderName;

/**
 * A method that is called when the user cancels the flow
 */
- (void)didCancel;

@end

#pragma mark - JPTransactionViewDelegateTokenPaymentImpl

@interface JPTransactionViewDelegateTokenPaymentImpl : NSObject

/**
 * A designated initializer that creates a JPTransactionViewDelegateTokenPaymentImpl object
 *
 * @param apiService - the service responsible for Judo backend calls
 * @param type - a TransactionType that describes the type of the transaction.
 * @param configuration - an instance of JPConfiguration used to configure the transaction.
 * @param details - an instance of JPStoredCardDetails to make the token payment with.
 * @param completion - a completion block with an optional JPResponse object or an NSError.
 * @returns a configured instance of JPTransactionViewDelegateTokenPaymentImpl
 */
- (nonnull instancetype)initWithAPIService:(nonnull JPApiService *)apiService
                                      type:(JPTransactionType)type
                             configuration:(nonnull JPConfiguration *)configuration
                                   details:(nonnull JPCardTransactionDetails *)details
                                completion:(nullable JPCompletionBlock)completion;

/**
 * Sends a token payment or pre-auth transaction based on the tokenised card details
 */
- (void)executeTokenPaymentTransaction;

@end

@interface JPTransactionViewDelegateTokenPaymentImpl (TransactionDelegate) <JPTransactionViewDelegate>
@end

NS_ASSUME_NONNULL_END
