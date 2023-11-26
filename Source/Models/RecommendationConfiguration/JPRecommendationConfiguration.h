//
//  JPRecommendationConfiguration.h
//  JudoKit_iOS
//
//  Copyright (c) 2023 Alternative Payments Ltd
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

@interface JPRecommendationConfiguration : NSObject

@property (nonatomic, strong, nonnull) NSURL *URL;
@property (nonatomic, strong, nonnull) NSString *RSAPublicKey;
@property (nonatomic, assign, nullable) NSNumber *timeout;

/**
 * Designated initializer that sets the required parameters for Recommendation Feature calls.
 *
 *  @returns a configured instance of JPRecommendationConfiguration
 */
- (nonnull instancetype)initWithURL:(nonnull NSURL *)URL
                       RSAPublicKey:(nonnull NSString *)key
                         andTimeout:(nullable NSNumber *)timeout;

- (nonnull instancetype)initWithURL:(nonnull NSURL *)URL
                    andRSAPublicKey:(nonnull NSString *)key;

+ (nonnull instancetype)configurationWithURL:(nonnull NSURL *)URL
                                RSAPublicKey:(nonnull NSString *)key
                                  andTimeout:(nullable NSNumber *)timeout;

+ (nonnull instancetype)configurationWithURL:(nonnull NSURL *)URL
                             andRSAPublicKey:(nonnull NSString *)key;

@end
