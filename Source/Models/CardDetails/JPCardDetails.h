//
//  JPCardDetails.h
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

#import "JPCardNetworkType.h"
#import <Foundation/Foundation.h>

/**
 * The CardDetails object stores information that is returned from a successful payment or pre-auth.
 * This class also implements the `NSCoding` protocol to enable serialization for persistency.
 */
@interface JPCardDetails : NSObject

/**
 * The last four digits of the card used for this transaction
 */
@property (nonatomic, strong) NSString *_Nullable cardLastFour;

/**
 * Expiry date of the card used for this transaction formatted as a two digit month and year i.e. MM/YY
 */
@property (nonatomic, strong) NSString *_Nullable endDate;

/**
 * Can be used to charge future payments against this card
 */
@property (nonatomic, strong) NSString *_Nullable cardToken;

/**
 * The card network
 */
@property (nonatomic, assign) JPCardNetworkType cardNetwork;

/**
 * The raw card network
 */
@property (nonatomic, assign) NSNumber *_Nullable rawCardNetwork;

/**
 * The card number if available
 */
@property (nonatomic, strong) NSString *_Nullable cardNumber;

/**
 * The bank the card was issued from.
 *
 * Possible values are CREDIT INDUSTRIEL ET COMMERCIAL, BARCLAYS, BANK OF AMERICA
 */
@property (nonatomic, strong) NSString *_Nullable bank;

/**
 * The category of the card.
 *
 * Possible values are CORPORATE, CLASSIC, PLATINUM
 */
@property (nonatomic, strong) NSString *_Nullable cardCategory;

/**
 * The country the card was issued from in ISO 3166-1 alpha-2 format (2 chararacters)
 *
 * Possible values are UK, FR, DE, etc
 */
@property (nonatomic, strong) NSString *_Nullable cardCountry;

/**
 * The funding type of the card.
 *
 * Possible values are Debit, Credit, etc
 */
@property (nonatomic, strong) NSString *_Nullable cardFunding;

/**
 * The scheme of the card.
 *
 * Possible values are VISA, MASTERCARD, etc
 */
@property (nonatomic, strong) NSString *_Nullable cardScheme;

@property (nonatomic, strong) NSString *_Nullable cardHolderName;

/**
 * The ownership type of the card.
 *
 * Possible values are Personal or Commercial.
 */
@property (nonatomic, strong) NSString *_Nullable ownerType;

/**
 *  Designated initializer for Card Details
 *
 *  @param dictionary all parameters as a dictionary
 *
 *  @return a JPCardDetails object
 */
- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

/**
 * Desgignated
 */
- (nonnull instancetype)initWithCardNumber:(nonnull NSString *)cardNumber
                               expiryMonth:(NSUInteger)month
                                expiryYear:(NSUInteger)year;

/**
 *  Get a formatted string with the right whitespacing for a certain card type
 *
 *  @return a string with the last four digits with the right format
 */
- (nullable NSString *)formattedCardLastFour;

/**
 *  Get a formatted string with the right slash for a date
 *
 *  @return a string with the date as shown on the credit card with the right format
 */
- (nullable NSString *)formattedExpiryDate;

@end
