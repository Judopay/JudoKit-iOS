//
//  ResultItem.h
//  ObjectiveCExampleApp
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

@class Result;

@interface ResultItem : NSObject

/**
 * The title of a result property
 */
@property (nonatomic, strong) NSString *title;

/**
 * The value of a result property represented as a NSString
 */
@property (nonatomic, strong) NSString *value;

/**
 * An optional Result used to storing nested properties
 */
@property (nonatomic, strong) Result *subResult;

/**
 * Designated initializer that creates an instance of ResultItem based on a title and value
 *
 * @param title - the title of the result property
 * @param value - the value of the result property
 */
+ (instancetype)resultItemWithTitle:(NSString *)title
                              value:(NSString *)value;

@end
