//
//  NSArray+Additions.m
//  JudoKit_iOS
//
//  Copyright © 2016 Alternative Payments Ltd. All rights reserved.
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

#import "NSArray+Additions.h"
#import "NSObject+Additions.h"

@implementation NSArray (Additions)

- (NSArray *)toArrayOfDictionaries {
    NSMutableArray *dictArray = [NSMutableArray new];

    for (NSObject *item in self) {
        if ([item isKindOfClass:NSArray.class]) {
            NSArray *array = (NSArray *)item;
            if (array.count > 0) {
                [dictArray addObject:[array toArrayOfDictionaries]];
            }
        } else {
            [dictArray addObject:[item toDictionary]];
        }
    }

    return [NSArray arrayWithArray:dictArray];
}

@end
