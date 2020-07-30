//
//  JPPBBAConfiguration.h
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

/**
 * A configuration file responsible for setting additional parameters
 * for PBBA method.
 */
@interface JPPBBAConfiguration : NSObject

/**
 * [Optional] The merchant mobile number
 */
@property (nonatomic, strong, nullable) NSString *mobileNumber;

/**
 * [Optional] The merchant email address
 */
@property (nonatomic, strong, nullable) NSString *emailAddress;

/**
 * [Optional] The merchant appears on statement
 */
@property (nonatomic, strong, nullable) NSString *appearsOnStatement;

/**
 * [Optional] DeeplinkURL from bank app
 */
@property (nonatomic, strong, nullable) NSURL *deeplinkURL;

/**
 * [Optional] The merchant deeplinkScheme from app
 */
@property (nonatomic, strong, nullable) NSString *deeplinkScheme;

- (nonnull instancetype)initWithDeeplinkScheme:(nonnull NSString *)deeplinkScheme
                                andDeeplinkURL:(nullable NSURL *)deeplinkURL;

+ (nonnull instancetype)configurationWithDeeplinkScheme:(nonnull NSString *)deeplinkScheme
                                         andDeeplinkURL:(nullable NSURL *)deeplinkURL;

/**
 * A method which check deeplink url in pbba configuration
 *
 * @returns - a bool value.
 */
- (BOOL)hasDeepLinkURL;

@end
