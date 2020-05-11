//
//  JPClientDetails.h
//  JudoKit-iOS
//
//  Copyright (c) 2019 Alternative Payments Ltd
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

#import "JPDictionaryConvertible.h"
#import <Foundation/Foundation.h>

@interface JPClientDetails : NSObject <JPDictionaryConvertible>

/**
 * An NSSting property describing the key of a JPClientDetails instance
 */
@property (nonatomic, strong, readonly) NSString *_Nullable key;

/**
 * An NSSting property describing the value of a JPClientDetails instance
 */
@property (nonatomic, strong, readonly) NSString *_Nullable value;

/**
 * Designated initializer based on a key and a value NSString object
 *
 * @param key - an instance of NSString describing the key
 * @param value - an instance of NSString describing the value
 *
 * @returns a configured instance of JPClientDetails
 */
- (nonnull instancetype)initWithKey:(nonnull NSString *)key
                              value:(nonnull NSString *)value;

/**
 * Designated initializer based on a NSDictionary object
 *
 * @param dictionary - an instance of NSDictionary describing JPClientDetails instance
 *
 * @returns a configured instance of JPClientDetails
 */
+ (nonnull instancetype)detailsWithDictionary:(nonnull NSDictionary *)dictionary;

@end
