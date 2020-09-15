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

//------------------------------------------------------
// MARK: - Initializers
//------------------------------------------------------

+ (instancetype)resultWithTitle:(NSString *)title
                       andItems:(NSArray<ResultItem *> *)items {
    Result *result = [Result new];
    result.title = title;
    result.items = items;
    return result;
}

+ (instancetype)resultWithTitle:(NSString *)title
                  andDictionary:(NSDictionary *)dictionary {
    NSMutableArray *items = [NSMutableArray new];
    for (NSString *key in dictionary.allKeys) {
        id value = [dictionary valueForKey:key];
        NSString *stringValue = [self formattedRepresentationOfObject:value];
        ResultItem *item = [ResultItem resultItemWithTitle:key value:stringValue];

        if ([value isKindOfClass:NSDictionary.class]) {
            item.subResult = [Result resultWithTitle:key andDictionary:value];
        }

        if ([value isKindOfClass:NSArray.class]) {
            item.subResult = [Result resultWithTitle:key andArray:value];
        }

        [items addObject:item];
    }
    return [self resultWithTitle:title andItems:items];
}

+ (instancetype)resultWithTitle:(NSString *)title
                       andArray:(NSArray *)array {
    NSMutableArray *items = [NSMutableArray new];
    for (int index = 0; index < array.count; index++) {
        NSString *stringValue = [self formattedRepresentationOfObject:array[index]];
        ResultItem *item = [ResultItem resultItemWithTitle:stringValue value:@""];

        if ([array[index] isKindOfClass:NSDictionary.class]) {
            item.subResult = [Result resultWithTitle:stringValue andDictionary:array[index]];
        }

        if ([array[index] isKindOfClass:NSArray.class]) {
            item.subResult = [Result resultWithTitle:stringValue andArray:array[index]];
        }

        if (![array[index] isKindOfClass:NSString.class] &&
            ![array[index] isKindOfClass:NSNumber.class] &&
            ![array[index] isKindOfClass:NSArray.class] &&
            ![array[index] isKindOfClass:NSDictionary.class]) {
            item.subResult = [Result resultFromObject:array[index]];
        }

        [items addObject:item];
    }
    return [self resultWithTitle:title andItems:items];
}

+ (instancetype)resultFromObject:(id)objectToBuildFrom {

    // Get the class type of an instance
    Class myClass = [objectToBuildFrom class];

    // Get the class name
    NSString *title = NSStringFromClass(myClass);

    // Store the number of class properties
    unsigned int numberOfProperties = 0;

    // Copy the class properties and store them into an array
    objc_property_t *propertyArray = class_copyPropertyList(myClass, &numberOfProperties);

    // Create a mutable array based on the number of properties
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:numberOfProperties];

    // Iterate through each property
    for (NSUInteger i = 0; i < numberOfProperties; i++) {

        // Obtain the property name
        objc_property_t property = propertyArray[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];

        // Obtain the property value
        id myValue = [objectToBuildFrom valueForKey:name];

        // Obtain the string representation of the property value
        NSString *stringValue = [self formattedRepresentationOfObject:myValue];

        // Create a ResultItem and add it to the mutable array
        if (myValue) {
            ResultItem *item = [ResultItem resultItemWithTitle:name value:stringValue];

            if (![myValue isKindOfClass:NSString.class] &&
                ![myValue isKindOfClass:NSNumber.class] &&
                ![myValue isKindOfClass:NSArray.class] &&
                ![myValue isKindOfClass:NSDictionary.class]) {
                item.subResult = [Result resultFromObject:myValue];
            }

            if ([myValue isKindOfClass:NSDictionary.class]) {
                item.subResult = [Result resultWithTitle:name andDictionary:myValue];
            }

            if ([myValue isKindOfClass:NSArray.class]) {
                item.subResult = [Result resultWithTitle:name andArray:myValue];
            }

            [items addObject:item];
        }
    }

    // Free up memory
    free(propertyArray);

    // Return the Result instance
    return [Result resultWithTitle:title andItems:items];
}

//------------------------------------------------------
// MARK: - Helpers
//------------------------------------------------------

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
        return [NSString stringWithFormat:@"Contains %lu additional properties.", myArray.count];
    }

    if ([myObject isKindOfClass:NSDictionary.class]) {
        NSDictionary *myDictionary = (NSDictionary *)myObject;
        if (myDictionary.allKeys.count == 0) {
            return @"Empty dictionary";
        }
        return [NSString stringWithFormat:@"Contains %lu additional properties.", myDictionary.allKeys.count];
    }

    if ([myObject isKindOfClass:NSObject.class]) {
        Class myClass = [myObject class];
        NSString *title = NSStringFromClass(myClass);
        return title;
    }

    return @"";
}

@end
