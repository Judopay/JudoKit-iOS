//
//  JPSession.h
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

#import "Typedefs.h"
#import <Foundation/Foundation.h>

@class JPSessionConfiguration;

/**
 *  The Session class is a wrapper for all REST API calls
 */
@interface JPSession : NSObject

/**
 * A designated initializer that creates a JPSession instance with a provided authorization header
 *
 *
 * @returns a configured instance of JPSession
 */
+ (nonnull instancetype)sessionWithConfiguration:(nonnull JPSessionConfiguration *)configuration;

/**
 * A designated initializer that creates a JPSession instance with a provided authorization header
 *
 *
 * @returns a configured instance of JPSession
 */
- (nonnull instancetype)initWithConfiguration:(nonnull JPSessionConfiguration *)configuration;

/**
 *  POST Helper Method for accessing the judo REST API
 *
 *  @param endpoint       the endpoint
 *  @param parameters information that is set in the HTTP Body
 *  @param completion completion callback block with the results
 */
- (void)POST:(nonnull NSString *)endpoint
       parameters:(nullable NSDictionary *)parameters
    andCompletion:(nonnull JPCompletionBlock)completion;

/**
 *  PUT Helper Method for accessing the judo REST API - PUT should only be accessed for 3DS transactions to fulfill the transaction
 *
 *  @param endpoint       the endpoint
 *  @param parameters information that is set in the HTTP Body
 *  @param completion completion callback block with the results
 */
- (void)PUT:(nonnull NSString *)endpoint
       parameters:(nullable NSDictionary *)parameters
    andCompletion:(nonnull JPCompletionBlock)completion;

/**
 *  GET Helper Method for accessing the judo REST API
 *
 *  @param endpoint       the endpoint
 *  @param parameters information that is set in the HTTP Body
 *  @param completion completion callback block with the results
 */
- (void)GET:(nonnull NSString *)endpoint
       parameters:(nullable NSDictionary *)parameters
    andCompletion:(nonnull JPCompletionBlock)completion;

@end
