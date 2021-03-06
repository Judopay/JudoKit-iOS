//
//  Result.h
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

@class ResultItem;

@interface Result : NSObject

/**
 * Stores the title of a Judo response property
 */
@property (nonatomic, strong) NSString *title;

/**
 * An array of ResultItem instances that store the value/values of a Judo response property
 */
@property (nonatomic, strong) NSArray<ResultItem *> *items;

/**
 * Designated initializer that creates a Result instance, by manually providing a title and result items
 *
 * @param title - the title of the Judo response property
 * @param items - an array of ResultItem instances that store the value/values of a Judo response property
 *
 * @returns a configured instance of Result
 */
+ (instancetype)resultWithTitle:(NSString *)title
                       andItems:(NSArray<ResultItem *> *)items;

/**
 * Convenience initializer that creates a Result instance based on a dynamic object
 *
 * @param objectToBuildFrom - an instance of an object that is used to generate the Result
 *
 * @returns a configured instance of Result
 */
+ (instancetype)resultFromObject:(id)objectToBuildFrom;

@end
