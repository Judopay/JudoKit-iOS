//
//  JudoKit.h
//  JudoKit_iOS
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

#import "JPSubProductInfo.h"
#import "JPTransactionMode.h"
#import "JPTransactionType.h"
#import "Typedefs.h"
#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>
#import <RavelinEncrypt/RavelinEncrypt.h>

@class JPCardTransactionDetails, JPConfiguration, JPPaymentMethod, JPSession;
@protocol JPAuthorization;

static NSString *__nonnull const JudoKitName = @"JudoKit_iOS";
static NSString *__nonnull const JudoKitVersion = @"3.2.5";

@interface JudoKit : NSObject

/**
 * A property that toggles sandbox mode on the Judo SDK.
 */

@property (nonatomic, assign) BOOL isSandboxed;
@property (nonatomic, strong, nullable) JPSubProductInfo *subProductInfo;
@property (nonatomic, strong, nonnull) id<JPAuthorization> authorization;

/**
 * Designated initializer that returns a configured JudoKit instance.
 *
 * @param jailbrokenDevicesAllowed - a boolean value that, if set to YES, will allow jailbroken devices to use the Judo SDK.
 *
 * @returns - a configured instance of JudoKit
 */

- (nullable instancetype)initWithAuthorization:(nonnull id<JPAuthorization>)authorization
                        allowJailbrokenDevices:(BOOL)jailbrokenDevicesAllowed;

/**
 * Convenience initializer that returns a configured JudoKit instance that allows jailbroken devices.
 *
 * @returns - a configured instance of JudoKit.
 */

- (nullable instancetype)initWithAuthorization:(nonnull id<JPAuthorization>)authorization;

/**
 * A method which invokes the Judo transaction interface which allows users to enter their card details and make a transaction.
 *
 * @param type - an instance of TransactionType that describes the type of the transaction.
 * @param configuration - an instance of JPConfiguration used to configure the transaction.
 * @param completion - a completion block with an optional JPResponse object or an NSError.
 */

- (void)invokeTransactionWithType:(JPTransactionType)type
                    configuration:(nonnull JPConfiguration *)configuration
                       completion:(nullable JPCompletionBlock)completion;

/**
 * A method which optionally invokes the Judo transaction interface which allows users to enter their CSC or cardholder name and make a transaction.
 *
 * @param type - a TransactionType that describes the type of the transaction.
 * @param configuration - an instance of JPConfiguration used to configure the transaction.
 * @param details - an instance of JPCardTransactionDetails to make the token payment with.
 * @param completion - a completion block with an optional JPResponse object or an NSError.
 */
- (void)invokeTokenTransactionWithType:(JPTransactionType)type
                         configuration:(nonnull JPConfiguration *)configuration
                               details:(nonnull JPCardTransactionDetails *)details
                            completion:(nullable JPCompletionBlock)completion;

/**
 * A method which returns a configured Judo transaction UIViewController that can be presented to allow
 * users to enter their card details and make a transaction
 *
 * @param type - an instance of TransactionType that describes the type of the transaction.
 * @param configuration - an instance of JPConfiguration used to configure the transaction.
 * @param completion - a completion block with an optional JPResponse object or an NSError.
 *
 * @returns a fully configured UIViewController instance
 */

- (nullable UIViewController *)transactionViewControllerWithType:(JPTransactionType)type
                                                   configuration:(nonnull JPConfiguration *)configuration
                                                      completion:(nullable JPCompletionBlock)completion;

/**
 * A method used to determine if ApplePay is available on the device
 *
 * @returns true - if canMakePayments and canMakePaymentsUsingNetworks, false otherwise
 */
+ (BOOL)isApplePayAvailableWithConfiguration:(nonnull JPConfiguration *)configuration;

/**
 * A method which invokes the Apple Pay sleeve which allows users to make Apple Pay transactions.
 *
 * @param mode - an instance of TransactionMode that specifies either a Payment or a Pre Auth transaction.
 * @param configuration - an instance of JPConfiguration used to configure the transaction.
 * @param completion - a completion block with an optional JPResponse object or an NSError.
 */

- (void)invokeApplePayWithMode:(JPTransactionMode)mode
                 configuration:(nonnull JPConfiguration *)configuration
                    completion:(nullable JPCompletionBlock)completion;

/**
 * A method which invokes the Judo Payment Method Selection screen which allows users to pick between multiple payment methods to complete their transaction.
 *
 * @param mode - an instance of TransactionMode that specifies either a Payment or a Pre Auth transaction.
 * @param configuration - an instance of JPConfiguration used to configure the transaction.
 * @param completion - a completion block with an optional JPResponse object or an NSError.
 *
 * @returns a fully configured UIViewController instance
 */

- (nullable UIViewController *)applePayViewControllerWithMode:(JPTransactionMode)mode
                                                configuration:(nonnull JPConfiguration *)configuration
                                                   completion:(nullable JPCompletionBlock)completion;

/**
 * A method which invokes the Judo Payment Method Selection screen which allows users to pick between multiple payment
 * methods to complete their transaction.
 *
 * @param mode - an instance of TransactionMode that specifies either a Payment or a Pre Auth transaction.
 * @param configuration - an instance of JPConfiguration used to configure the transaction.
 * @param completion - a completion block with an optional JPResponse object or an NSError.
 */

- (void)invokePaymentMethodScreenWithMode:(JPTransactionMode)mode
                            configuration:(nonnull JPConfiguration *)configuration
                               completion:(nullable JPCompletionBlock)completion;

/**
 * A method which returns a configured Judo Payment Method Selection UIViewController which allows users to pick between
 * multiple payment methods to complete their transaction.
 *
 * @param mode - an instance of TransactionMode that specifies either a Payment or a Pre Auth transaction.
 * @param configuration - an instance of JPConfiguration used to configure the transaction.
 * @param completion - a completion block with an optional JPResponse object or an NSError.
 *
 * @returns a fully configured UIViewController instance
 */

- (nullable UIViewController *)paymentMethodViewControllerWithMode:(JPTransactionMode)mode
                                                     configuration:(nonnull JPConfiguration *)configuration
                                                        completion:(nullable JPCompletionBlock)completion;

/**
 * A method used to fetch the details of a transaction based on a provided receipt ID
 *
 * @param receiptId - a string which contains the receipt ID of a transaction.
 * @param completion - a completion block with an optional JPResponse object or an NSError.
 */

- (void)fetchTransactionWithReceiptId:(nonnull NSString *)receiptId
                           completion:(nullable JPCompletionBlock)completion;

@end
