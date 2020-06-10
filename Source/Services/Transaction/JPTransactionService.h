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
 * A property which describes the transaction type
 */
@property (nonatomic, assign) JPTransactionType transactionType;

/**
 * A property which describes the transaction UI mode
 */
@property (nonatomic, assign) JPCardDetailsMode mode;

/**
 * A property that will return one of the pre-defined card network types (only for card number)
 */
@property (nonatomic, assign) JPCardNetworkType cardNetwork;

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
- (nonnull JPTransaction *)transactionWithConfiguration:(nonnull JPConfiguration *)configuration;

/**
 * A method for sending REST API requests to a provided URL with optional parameters
 *
 * @param endpoint - the destination URL endpoint for REST requests
 * @param httpMethod - an NS_ENUM value that describes the HTTP method
 * @param parameters - optional NSDictionary that should be send with the request
 * @param completion - a completion block that returns an optional JPResponse or NSError
 */
- (void)sendRequestWithEndpoint:(nonnull NSString *)endpoint
                     httpMethod:(JPHTTPMethod)httpMethod
                     parameters:(nullable NSDictionary *)parameters
                     completion:(nullable JPCompletionBlock)completion;

@end
