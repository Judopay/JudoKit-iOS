//
//  JPAddress.h
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

#import <Foundation/Foundation.h>

/**
 *  The Address object stores information around the address that is related to a card
 */
@interface JPAddress : NSObject

/**
 *  Line one of the address
 */
@property (nonatomic, strong, nullable) NSString *address1;

/**
 *  Line two of the address
 */
@property (nonatomic, strong, nullable) NSString *address2;

/**
 *  Line three of the address
 */
@property (nonatomic, strong, nullable) NSString *address3;

/**
 *  Town of the address
 */
@property (nonatomic, strong, nullable) NSString *town;

/**
 *  Post code of the address
 */
@property (nonatomic, strong, nullable) NSString *postCode;

/**
 * Sets country code of the address.
 */
@property (nonatomic, strong, nullable) NSNumber *countryCode;

/**
 * Sets state code of the address.
 */
@property (nonatomic, strong, nullable) NSString *state;

/**
 *  Designated Initializer
 *
 *  @param address1 - the primary card address line
 *  @param address2 - an optional secondary address line
 *  @param address3 - an optional third address line
 *  @param town - a string that represents the town name
 *  @param postCode the postal code of the card
 *  @param countryCode - the country code of the address
 *  @param state - the state code of the address
 *
 *  @return a JPAddress object
 */
- (nonnull instancetype)initWithAddress1:(nullable NSString *)address1
                                address2:(nullable NSString *)address2
                                address3:(nullable NSString *)address3
                                    town:(nullable NSString *)town
                                postCode:(nullable NSString *)postCode
                             countryCode:(nullable NSNumber *)countryCode
                                   state:(nullable NSString *)state;

/**
 *  Initializer
 *
 *  @param dictionary a dictionary containing all the values
 *
 *  @return a JPAddress object
 */
- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

@end
