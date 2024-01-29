//
//  JPBasicAuthorization.h
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

#import "JPAuthorization.h"
#import <Foundation/Foundation.h>

/**
 * DEPRECATED: use JPSessionAuthorization instead.
 * Authorization type that uses token and secret combination to authorize Judo backend requests.
 */
__attribute__((deprecated("This authentication method is deprecated, please use payment session instead.")))
@interface JPBasicAuthorization : NSObject <JPAuthorization>

/**
 * Designated initializer that describes a basic authorization
 *
 * @param token - an NSString instance describing the token
 * @param secret - an NSString instance describing the secret
 *
 * @returns a configured JPBasicAuthorization instance
 */
- (instancetype)initWithToken:(NSString *)token
                    andSecret:(NSString *)secret;

/**
 * Designated initializer that describes a basic authorization
 *
 * @param token - an NSString instance describing the token
 * @param secret - an NSString instance describing the secret
 *
 * @returns a configured JPBasicAuthorization instance
 */
+ (instancetype)authorizationWithToken:(NSString *)token
                             andSecret:(NSString *)secret;

@end
