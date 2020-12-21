//
//  JPUITestConfiguration.h
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
#import "JPUITestData.h"

@interface JPUITestConfiguration : NSObject

/**
 * The non-3DS basic authentication token
 */
@property (nonatomic, strong, nullable) NSString *token;

/**
 * The non-3DS basic authentication secret
 */
@property (nonatomic, strong, nullable) NSString *secret;

/**
 * The 3DS basic authentication token
 */
@property (nonatomic, strong, nullable) NSString *threeDSToken;

/**
 * The 3DS basic authentication secret
 */
@property (nonatomic, strong, nullable) NSString *threeDSSecret;

/**
 * The Judo ID value
 */
@property (nonatomic, strong, nullable) NSString *judoID;

/**
 * A boolean value for the sandbox mode toggle
 */
@property (nonatomic, assign) BOOL isSandboxed;

/**
 * An array of NSString values, representing the tags of the scenarios to be included.
 * Once tags are included, only the scenarios matching the tags specified will be executed
 */
@property (nonatomic, strong, nullable) NSArray <NSString *> *testsToInclude;

/**
 * An array of NSString values, representing the tags of the scenarios to be skipped
 */
@property (nonatomic, strong, nullable) NSArray <NSString *> *testsToSkip;

/**
 * An array of JPUITestCard objects, representing the card details for a specific network
 */
@property (nonatomic, strong, nullable) NSArray <JPUITestCard *> *defaultCards;

/**
 * An array of JPUITestData objects, which contain card details for specific tags.
 * If specified, these card details override the default card details for the selected tags
 */
@property (nonatomic, strong, nullable) NSArray <JPUITestData *> *testData;

/**
 * Default initializer that looks for the test input data JSON in its default location.
 *
 * @returns a configured instance of JPUITestConfiguration
 */
+ (nonnull instancetype)defaultConfiguration;

/**
 * A convenience initializer allowing you to specify the relative path of the test input data JSON
 * The file must be in the ObjectiveCExampleAppUITests bundle for this to work.
 *
 * @returns a configured instance of JPUITestConfiguration
 */
- (nonnull instancetype)initWithRelativePath:(nonnull NSString *)relativePath;

/**
 * Method for fetching a test data field based on an identifier and type.
 * Fields associated with a tag have priority and will override default field values,
 *
 * @param tag - the test scenario tag, that may hold specific test data
 * @param identifier - the identifier used in the JSON file, matching a specific field
 * @param type - the type of the field, used to identify a specific entry in the test data
 *
 * @returns an optional NSString, representing the field value, if it exists
 */
- (nonnull NSString *)fetchFieldForTag:(nonnull NSString *)tag
                            identifier:(nonnull NSString *)identifier
                               andType:(nonnull NSString *)type;

@end
