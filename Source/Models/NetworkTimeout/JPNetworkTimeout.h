//
//  JPNetworkTimeout.h
//  JudoKit_iOS
//
//  Copyright (c) 2022 Alternative Payments Ltd
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
 * Class for setting custom network timeout values.
 * Values must be specified in seconds.
 */
@interface JPNetworkTimeout : NSObject

/**
 * The connect timeout.
 * Defaults to 5 seconds.
 */
@property (nonatomic, assign) NSTimeInterval connectTimeout;

/**
 * The read timeout.
 * Defaults to 180 seconds.
 */
@property (nonatomic, assign) NSTimeInterval readTimeout;

/**
 * The write timeout.
 * defaults to 30 seconds.
 */
@property (nonatomic, assign) NSTimeInterval writeTimeout;

- (instancetype)init;

- (instancetype)initWithConnectTimeout:(NSTimeInterval)connectTimeout
                        andReadTimeout:(NSTimeInterval)readTimeout
                       andWriteTimeout:(NSTimeInterval)writeTimeout;

@end
