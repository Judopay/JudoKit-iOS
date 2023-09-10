//
//  RecommendationConfiguration.h
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
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHx3ANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <Foundation/Foundation.h>

//@class JPAmount, JPReference;

// Todo: Adjust comments.

@interface RecommendationConfiguration : NSObject

/**
 * The Judo ID required for most JudoKit transactions
 */
@property (nonatomic, strong, nonnull) NSString *rsaKey;

/**
 * The Judo ID required for most JudoKit transactions
 */
@property (nonatomic, strong, nonnull) NSString *recommendationURL;

/**
 * The Judo ID required for most JudoKit transactions
 */
@property (nonatomic, assign, nullable) int *recommendationTimeout;

/**
 * Designated initializer that sets the required parameters for most Judo transations.
 *  - Compatible with Payment, PreAuth, Register Card, Check Card, Save Card transactions.
 *  - Compatible with Apple Pay transactions.
 *  - Compatible with Judo Payment Method Selection screen.
 *
 *  @param judoId - the Judo ID of the merchant.
 *  @param amount - the JPAmount instance, contaning the amount and the currency of the transaction.
 *  @param reference - the JPReference instance, containing the consumer/payment references.
 *
 *  @returns a configured instance of JPConfiguration
 */
- (nonnull instancetype)initWithRsaKey:(nonnull NSString *)rsaKey
                   andRecommendationURL:(nonnull NSString *)recommendationURL;

+ (nonnull instancetype)configurationWithRsaKey:(nonnull NSString *)rsaKey
                   andRecommendationURL:(nonnull NSString *)recommendationURL;

@end
