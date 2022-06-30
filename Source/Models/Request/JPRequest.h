//
//  JPRequest.h
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

@class JPPrimaryAccountDetails, JPAddress, JPConfiguration, JPCard, JPThreeDSecureTwo;

@interface JPRequest : NSObject

/**
 * A reference to the amount value
 */
@property (nonatomic, strong, nullable) NSString *amount;

/**
 * A reference to the amount currency
 */
@property (nonatomic, strong, nullable) NSString *currency;

/**
 * A reference to the Judo ID
 */
@property (nonatomic, strong, nullable) NSString *judoId;

/**
 * A reference to the card number
 */
@property (nonatomic, strong, nullable) NSString *cardNumber;

/**
 * A reference to the card secure code
 */
@property (nonatomic, strong, nullable) NSString *cv2; // TODO: <- Change to secureCode

/**
 * A reference to the card expiry date
 */
@property (nonatomic, strong, nullable) NSString *expiryDate;

/**
 * A reference to the card start date (Maestro)
 */
@property (nonatomic, strong, nullable) NSString *startDate;

/**
 * A reference to the card issue number (Maestro)
 */
@property (nonatomic, strong, nullable) NSString *issueNumber;

/**
 * A reference to the user's email address
 */
@property (nonatomic, strong, nullable) NSString *emailAddress;

/**
 * A reference to the user's mobile number
 */
@property (nonatomic, strong, nullable) NSString *mobileNumber;

/**
 * A reference to the card address
 */
@property (nonatomic, strong, nullable) JPAddress *cardAddress;

/**
 * A reference to the  payment reference
 */
@property (nonatomic, strong, nullable) NSString *yourPaymentReference;

/**
 * A reference to the  consumer reference
 */
@property (nonatomic, strong, nullable) NSString *yourConsumerReference;

/**
 * A reference to the  payment metadata
 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *yourPaymentMetaData;

/**
 * A reference to the primary account details
 */
@property (nonatomic, strong, nullable) JPPrimaryAccountDetails *primaryAccountDetails;

@property (nonatomic, strong, nullable) NSString *phoneCountryCode;
@property (nonatomic, strong, nullable) JPThreeDSecureTwo *threeDSecure;
@property (nonatomic, strong, nullable) NSString *cardHolderName;

/**
 * Designated initializer that creates a JPRequest based on the configurations provided
 *
 * @param configuration - an instance of JPConfiguration that contains the configuration information
 *
 * @returns a configured JPRequest instance
 */
- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration;

/**
 * Designated initializer that creates a JPRequest based on the configurations and card details provided
 *
 * @param configuration - an instance of JPConfiguration that contains the configuration information
 * @param card - an instance of JPCard that contains the card information
 *
 * @returns a configured JPRequest instance
 */
- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration
                               andCardDetails:(nonnull JPCard *)card;

@end
