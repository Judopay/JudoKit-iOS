//
//  JPUITestData.h
//  ObjectiveCExampleAppUITests
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
#import "JPUITestCard.h"
#import "JPUITestAddress.h"

@interface JPUITestData : NSObject

/**
 * An array of NSString values representing the tags for which the custom card details will apply.
 */
@property (nonatomic, strong, nullable) NSArray <NSString *> *tags;

/**
 * An array of JPUITestCard objects containing the card details for specific test scenarios
 */
@property (nonatomic, strong, nullable) NSArray <JPUITestCard *> *cards;

/**
 * An array of JPUITestAddress objects containing the AVS details for a specific test scenario
 */
@property (nonatomic, strong, nullable) NSArray <JPUITestAddress *> *avs;

/**
 * Designated initializer that creates a JPUITestData object by parsing a JSON dictionary
 *
 * @returns a configured instance of JPUITestData
 */
- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

/**
 * Method used to fetch card details for a specified card type, matching the provided tag
 *
 * @param tag - the tag of the test scenario, used to fetch specific card details, if they are present
 * @param cardType - the card type used to find the correct card details
 *
 * @returns an optional JPUITestCard if it exists, containing the card details
 */
- (nullable JPUITestCard *)fetchCardForTag:(nonnull NSString *)tag
                               andCardType:(nonnull NSString *)cardType;

/**
 * Method used to fetch the post code for a specified country, matching the provided tag
 *
 * @param tag - the tag of the test scenario, used to fetch specific card details, if they are present
 * @param country - the country associated with a specific post code
 *
 * @returns an optional NSString, representing the post code, if it exists
 */
- (nullable NSString *)fetchPostCodeForTag:(nonnull NSString *)tag
                                andCountry:(nonnull NSString *)country;
@end
