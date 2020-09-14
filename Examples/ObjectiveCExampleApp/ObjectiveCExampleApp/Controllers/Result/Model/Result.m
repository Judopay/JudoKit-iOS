//
//  Result.m
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

#import "Result.h"
#import "ResultItem.h"
#import <objc/runtime.h>

@implementation Result

+ (instancetype)resultWithTitle:(NSString *)title andItems:(NSArray<ResultItem *> *)items {
    Result *result = [Result new];
    result.title = title;
    result.items = items;
    return result;
}

+ (instancetype)resultFromObject:(id)objectToBuildFrom {
    Class myClass = [objectToBuildFrom class];
    NSString *title = NSStringFromClass(myClass);
    
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList(myClass, &numberOfProperties);
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:numberOfProperties];

    for (NSUInteger i = 0; i < numberOfProperties; i++) {
        objc_property_t property = propertyArray[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        id myValue = [objectToBuildFrom valueForKey:name];

        ResultItem *item = [ResultItem resultItemWithTitle:name value:[self formattedRepresentationOfObject:myValue]];
        [items addObject: item];
        
        const char* myType = @encode(typeof(myValue));
        switch (myType[0]) {
            case '@':
                
                break;
                
            default:
                break;
        }
    }
    
    free(propertyArray);

    return [Result resultWithTitle:title andItems:items];
}

+ (NSString *)formattedRepresentationOfObject:(id)myObject {
    if (!myObject || [myObject isKindOfClass:NSNull.class]) {
        return @"null";
    }
    
    if ([myObject isKindOfClass:NSString.class]) {
        return myObject;
    }
    
    if ([myObject isKindOfClass:NSNumber.class]) {
        return [NSNumberFormatter localizedStringFromNumber:myObject numberStyle:NSNumberFormatterNoStyle];
    }
    
    if ([myObject isKindOfClass:NSArray.class]) {
        NSArray *myArray = (NSArray *)myObject;
        if (myArray.count == 0) {
            return @"Empty array";
        }
        return [NSString stringWithFormat:@"Contains %lu instances of %@\nTap to see more", myArray.count, NSStringFromClass([myArray.firstObject class])];
    }
    
    return @"";
}

@end
