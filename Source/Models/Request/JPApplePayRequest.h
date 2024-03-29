//
//  JPApplePayPaymentRequest.h
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

@class PKPayment, PKPaymentMethod, PKPaymentToken, PKContact;

NS_ASSUME_NONNULL_BEGIN

@interface JPApplePayPaymentMethod : NSObject

/**
 * A string describing the instrument that's suitable for display
 */
@property (nonatomic, copy, readonly, nullable) NSString *displayName;

/**
 * The payment network that backs the instrument. Suitable for display.
 */
@property (nonatomic, copy, readonly, nullable) NSString *network;

/**
 * The underlying instrument type (credit, debit, etc)
 */
@property (nonatomic, copy, readonly, nullable) NSString *type;

/**
 * Designated initializer that creates a JPApplePayPaymentMethod instance based on a PKPaymentMethod
 *
 * @param paymentMethod - a reference to the PKPaymentMethod obtained once the Apple Pay authorization finishes
 *
 * @return a configured instance of JPApplePayPaymentMethod
 */
- (nonnull instancetype)initWithPaymentMethod:(PKPaymentMethod *)paymentMethod;

@end

@interface JPApplePayPaymentToken : NSObject

/**
 * Describes the properties of the underlying payment instrument selected to fund the payment
 */
@property (nonatomic, strong, nullable) JPApplePayPaymentMethod *paymentMethod;

/**
 * A refrerence to the payment data used to complete the Apple Pay transaction
 */
@property (nonatomic, strong, nullable) NSDictionary *paymentData;

/**
 * Designated initializer that creates a JPApplePayPaymentToken instance based on a PKPaymentToken
 *
 * @param token - a reference to the PKPaymentToken obtained once the Apple Pay authorization finishes
 *
 * @return a configured instance of JPApplePayPaymentToken
 */
- (nonnull instancetype)initWithPaymentToken:(nonnull PKPaymentToken *)token;

@end

@interface JPApplePayBillingContact : NSObject

@property (nonatomic, strong, nullable) NSString *street;
@property (nonatomic, strong, nullable) NSString *subLocality;
@property (nonatomic, strong, nullable) NSString *city;
@property (nonatomic, strong, nullable) NSString *subAdministrativeArea;
@property (nonatomic, strong, nullable) NSString *state;
@property (nonatomic, strong, nullable) NSString *postalCode;
@property (nonatomic, strong, nullable) NSString *country;
@property (nonatomic, strong, nullable) NSString *isoCountryCode;

@property (nonatomic, strong, nullable) NSString *namePrefix;
@property (nonatomic, strong, nullable) NSString *givenName;
@property (nonatomic, strong, nullable) NSString *middleName;
@property (nonatomic, strong, nullable) NSString *familyName;
@property (nonatomic, strong, nullable) NSString *nameSuffix;
@property (nonatomic, strong, nullable) NSString *nickname;

- (nonnull instancetype)initWithContact:(PKContact *_Nonnull)contact;

@end

@interface JPApplePayPayment : NSObject

/**
 * A reference to the JPApplePayPaymentToken instance containing information about the Apple Pay token
 */
@property (nonatomic, strong, nonnull) JPApplePayPaymentToken *token;

@property (nonatomic, strong, nullable) JPApplePayBillingContact *billingContact;

/**
 * Designated initializer based on a provided PKPayment instance
 *
 * @param payment - an instance of PKPayment that describes the Apple Pay transaction
 *
 * @returns a configured JPApplePayPayment instance
 */
- (nonnull instancetype)initWithPayment:(nonnull PKPayment *)payment;

@end

@interface JPApplePayRequest : JPRequest

/**
 * A reference to the JPApplePayPayment instance describing the Apple Pay transaction
 */
@property (nonatomic, strong, nullable) JPApplePayPayment *pkPayment;

/**
 * Designated initializer based on a provided JPConfiguration instance
 *
 * @param configuration - an instance of JPConfiguration that contains the merchant configuration
 * @param payment - an instance of PKPayment that describes the Apple Pay transaction
 *
 * @returns a configured JPApplePayRequest instance
 */
- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration
                                   andPayment:(nonnull PKPayment *)payment;

@end

NS_ASSUME_NONNULL_END
