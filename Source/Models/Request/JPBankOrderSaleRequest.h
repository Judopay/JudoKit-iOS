//
//  JPBankOrderSaleRequest.h
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

#import <Foundation/Foundation.h>

@class JPConfiguration;

@interface JPBankOrderSaleRequest : NSObject

/**
 * A reference to the amount value
 */
@property (nonatomic, strong, nullable) NSNumber *amount;

/**
 * A reference to the judo ID
 */
@property (nonatomic, strong, nullable) NSString *judoId;

/**
 * A reference to the bank identifier code
 */
@property (nonatomic, strong, nullable) NSString *bic;

/**
 * A reference to the currency
 */
@property (nonatomic, strong, nullable) NSString *currency;

/**
 * A reference to the country
 */
@property (nonatomic, strong, nullable) NSString *country;

/**
 * A reference to the payment method
 */
@property (nonatomic, strong, nullable) NSString *paymentMethod;

/**
 * A reference to the user's email address
 */
@property (nonatomic, strong, nullable) NSString *emailAddress;

/**
 * A reference to the user's mobile number
 */
@property (nonatomic, strong, nullable) NSString *mobileNumber;

/**
 * A reference to the account holder's name
 */
@property (nonatomic, strong, nullable) NSString *accountHolderName;

/**
 * A reference to the "appears on statement" name
 */
@property (nonatomic, strong, nullable) NSString *appearsOnStatement;

/**
 * A reference to the merchant's redirect URL
 */
@property (nonatomic, strong, nullable) NSString *merchantRedirectUrl;

/**
 * A reference to the merchant's payment reference
 */
@property (nonatomic, strong, nullable) NSString *merchantPaymentReference;

/**
 * A reference to the merchant's consumer reference
 */
@property (nonatomic, strong, nullable) NSString *merchantConsumerReference;

/**
 * A reference to the payment metadata
 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *paymentMetadata;

/**
 * Designated initializer based on a provided configuration object
 *
 * @param configuration - an instance of JPConfiguration that describes the merchant's configuration
 *
 * @returns a configured JPBankOrderSaleRequest instance
 */
- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration;

/**
 * Designated iDEAL initializer based on a provided configuration object and the bank identifier code
 *
 * @param configuration - an instance of JPConfiguration that describes the merchant's configuration
 * @param bic - the bank identifier code used to identify one of the iDEAL banks
 *
 * @returns a configured JPBankOrderSaleRequest instance
 */
+ (nonnull instancetype)idealRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                               andBIC:(nonnull NSString *)bic;

/**
 * Designated PBBA initializer based on a provided configuration object
 *
 * @param configuration - an instance of JPConfiguration that describes the merchant's configuration
 *
 * @returns a configured JPBankOrderSaleRequest instance
 */
+ (nonnull instancetype)pbbaRequestWithConfiguration:(nonnull JPConfiguration *)configuration;

@end
