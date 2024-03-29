//
//  JPSessionConfiguration.h
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

@protocol JPAuthorization;

@class JPSubProductInfo;

@interface JPSessionConfiguration : NSObject

/**
 * A reference to one of the JPAuthorization instances (basic or session authorization)
 */
@property (nonatomic, strong, nonnull) id<JPAuthorization> authorization;

/**
 * A reference to the Judo base URL
 */
@property (nonatomic, readonly, nullable) NSURL *apiBaseURL;

/**
 * A parameter describing if the session is pointing to the sandbox environment
 */
@property (nonatomic, assign) BOOL isSandboxed;

@property (nonatomic, strong, nullable) JPSubProductInfo *subProductInfo;

/**
 * Designated initializer the generates a session configuration based on the authorization type
 *
 * @param authorization - one of the JPAuthorization instances (basic or session authorization)
 *
 * @returns a configured JPSessionConfiguration instance
 */
- (nonnull instancetype)initWithAuthorization:(nonnull id<JPAuthorization>)authorization;

/**
 * Designated initializer the generates a session configuration based on the authorization type
 *
 * @param authorization - one of the JPAuthorization instances (basic or session authorization)
 *
 * @returns a configured JPSessionConfiguration instance
 */
+ (nonnull instancetype)configurationWithAuthorization:(nonnull id<JPAuthorization>)authorization;

@end
