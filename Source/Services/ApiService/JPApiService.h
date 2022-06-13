//
//  JPApiService.h
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
#import <Foundation/Foundation.h>

@protocol JPAuthorization;

@class JPPaymentRequest,
    JPRequest,
    JPTokenRequest,
    JPBankOrderSaleRequest,
    JPApplePayRequest,
    JPCheckCardRequest,
    JPSaveCardRequest,
    JPRegisterCardRequest,
    JPComplete3DS2Request,
    JP3DSecureAuthenticationResult;

@interface JPApiService : NSObject

/**
 * A reference to one of the JPAuthorization instances which defines either a basic or a session authorization
 */
@property (nonatomic, strong, nonnull) id<JPAuthorization> authorization;

/**
 * A boolean property that defines if the Judo SDK should point to the sandbox environment
 */
@property (nonatomic, assign) BOOL isSandboxed;

/**
 * Designated initializer that creates an instance of JPApiSession based on the authorization type provided
 *
 * @param authorization - can be either a JPBasicAuthorization or a JPSessionAuthorization instance
 * @param sandboxed - boolean that specifies if the requests should go to the sandbox environment
 *
 * @returns a configured instance of JPApiSession
 */
- (nonnull instancetype)initWithAuthorization:(nonnull id<JPAuthorization>)authorization
                                  isSandboxed:(BOOL)sandboxed;

/**
 * A method that invokes a payment transaction
 *
 * @param request - an instance of JPPaymentRequest describing the payment request
 * @param completion - the completion block that contains the optional JPResponse or JPError
 */
- (void)invokePaymentWithRequest:(nonnull JPPaymentRequest *)request
                   andCompletion:(nullable JPCompletionBlock)completion;

/**
 * A method that invokes a pre-auth transaction
 *
 * @param request - an instance of JPPaymentRequest describing the pre-auth request
 * @param completion - the completion block that contains the optional JPResponse or JPError
 */
- (void)invokePreAuthPaymentWithRequest:(nonnull JPPaymentRequest *)request
                          andCompletion:(nullable JPCompletionBlock)completion;

/**
 * A method that invokes a token payment transaction
 *
 * @param request - an instance of JPTokenRequest describing the token payment request
 * @param completion - the completion block that contains the optional JPResponse or JPError
 */
- (void)invokeTokenPaymentWithRequest:(nonnull JPTokenRequest *)request
                        andCompletion:(nullable JPCompletionBlock)completion;

/**
 * A method that invokes a token pre-auth transaction
 *
 * @param request - an instance of JPTokenRequest describing the token pre-auth request
 * @param completion - the completion block that contains the optional JPResponse or JPError
 */
- (void)invokePreAuthTokenPaymentWithRequest:(nonnull JPTokenRequest *)request
                               andCompletion:(nullable JPCompletionBlock)completion;

/**
 * A method that invokes a register card transaction
 *
 * @param request - an instance of JPRegisterCardRequest describing the register card request
 * @param completion - the completion block that contains the optional JPResponse or JPError
 */
- (void)invokeRegisterCardWithRequest:(nonnull JPRegisterCardRequest *)request
                        andCompletion:(nullable JPCompletionBlock)completion;

/**
 * A method that invokes a save card transaction
 *
 * @param request - an instance of JPSaveCardRequest describing the save card request
 * @param completion - the completion block that contains the optional JPResponse or JPError
 */
- (void)invokeSaveCardWithRequest:(nonnull JPSaveCardRequest *)request
                    andCompletion:(nullable JPCompletionBlock)completion;

/**
 * A method that invokes a check card transaction
 *
 * @param request - an instance of JPCheckCardRequest describing the check card request
 * @param completion - the completion block that contains the optional JPResponse or JPError
 */
- (void)invokeCheckCardWithRequest:(nonnull JPCheckCardRequest *)request
                     andCompletion:(nullable JPCompletionBlock)completion;

/**
 * A method that invokes an Apple Pay payment transaction
 *
 * @param request - an instance of JPApplePayRequest describing the Apple Pay request
 * @param completion - the completion block that contains the optional JPResponse or JPError
 */
- (void)invokeApplePayPaymentWithRequest:(nonnull JPApplePayRequest *)request
                           andCompletion:(nullable JPCompletionBlock)completion;

/**
 * A method that invokes an Apple Pay pre-auth transaction
 *
 * @param request - an instance of JPApplePayRequest describing the Apple Pay request
 * @param completion - the completion block that contains the optional JPResponse or JPError
 */
- (void)invokePreAuthApplePayPaymentWithRequest:(nonnull JPApplePayRequest *)request
                                  andCompletion:(nullable JPCompletionBlock)completion;

/**
 * A method that invokes a Bank transaction, used for completing transactions via Bank apps (iDEAL, PayByBankApp)
 *
 * @param request - an instance of JPBankOrderSaleRequest describing the Bank request
 * @param completion - the completion block that contains the optional JPResponse or JPError
 */
- (void)invokeBankSaleWithRequest:(nonnull JPBankOrderSaleRequest *)request
                    andCompletion:(nullable JPCompletionBlock)completion;

/**
 * A method that invokes a Bank order status, to check the transaction status completed via a Bank app
 *
 * @param orderId - a NSString instance identifying the order
 * @param completion - the completion block that contains the optional JPResponse or JPError
 */
- (void)invokeOrderStatusWithOrderId:(nonnull NSString *)orderId
                       andCompletion:(nullable JPCompletionBlock)completion;

/**
 * A method that is called for 3D Secure transactions, after the user authenticates the transaction
 *
 * @param receiptId - the receipt ID obtained from the ACS page
 * @param result - an instance of JP3DSecureAuthenticationResult that describes the authentication result
 * @param completion - the completion block that contains the optional JPResponse or JPError
 */
- (void)invokeComplete3dSecureWithReceiptId:(nonnull NSString *)receiptId
                       authenticationResult:(nonnull JP3DSecureAuthenticationResult *)result
                              andCompletion:(nullable JPCompletionBlock)completion;

- (void)invokeComplete3dSecureTwoWithReceiptId:(nonnull NSString *)receiptId
                                       request:(nonnull JPComplete3DS2Request *)request
                                 andCompletion:(nullable JPCompletionBlock)completion;
/**
 * A method used to fetch the details of a transaction based on a provided receipt ID
 *
 * @param receiptId - a string which contains the receipt ID of a transaction.
 * @param completion - a completion block with an optional JPResponse object or an NSError.
 */
- (void)fetchTransactionWithReceiptId:(nonnull NSString *)receiptId
                           completion:(nullable JPCompletionBlock)completion;
@end
