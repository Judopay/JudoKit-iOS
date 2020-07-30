//
//  JPTokenRequest.h
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

#import "JPRequest.h"
#import <Foundation/Foundation.h>

@class JPConfiguration;

@interface JPTokenRequest : JPRequest

/**
 * A reference to the card expiry date
 */
@property (nonatomic, strong, nullable) NSString *endDate;

/**
 * A reference to the card last four digits
 */
@property (nonatomic, strong, nullable) NSString *cardLastFour;

/**
 * A reference to the card token
 */
@property (nonatomic, strong, nullable) NSString *cardToken;

/**
 * A reference to the card type
 */
@property (nonatomic, strong, nullable) NSNumber *cardType;

/**
 * Designated initializer based on the provided configuration and card token
 *
 * @param configuration - an instance of JPConfiguration that describe the merchant configuration values
 * @param cardToken - the card token obtained from a Save Card transaction
 *
 * @return a configured JPTokenRequest instance
 */
- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration
                                 andCardToken:(nonnull NSString *)cardToken;

@end
