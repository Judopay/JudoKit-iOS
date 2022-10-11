//
//  JPState.m
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

#import "JPState.h"
#import "JPConstants.h"

@implementation JPState

+ (nullable JPState *)forStateName:(nonnull NSString *)stateName andCountryCode:(nonnull NSString *)countryCode {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", stateName];
    if ([countryCode isEqualToString:kAlpha2CodeUSA]) {
        return [JPStateList.usStateList.states filteredArrayUsingPredicate:predicate].firstObject;
    } else if ([countryCode isEqualToString:kAlpha2CodeCanada]) {
        return [JPStateList.caStateList.states filteredArrayUsingPredicate:predicate].firstObject;
    }
    return nil;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    if (self = [super init]) {
        _alpha2Code = dict[@"isoCode"];
        _name = dict[@"name"];
    }
    return self;
}

@end

@implementation JPStateList

+ (instancetype)usStateList {
    return [[JPStateList alloc] initWith:@[
        @{@"isoCode" : @"AK", @"name" : @"Alaska"},
        @{@"isoCode" : @"AZ", @"name" : @"Arizona"},
        @{@"isoCode" : @"AR", @"name" : @"Arkansas"},
        @{@"isoCode" : @"CA", @"name" : @"California"},
        @{@"isoCode" : @"CO", @"name" : @"Colorado"},
        @{@"isoCode" : @"CT", @"name" : @"Connecticut"},
        @{@"isoCode" : @"DE", @"name" : @"Delaware"},
        @{@"isoCode" : @"AL", @"name" : @"Alabama"},
        @{@"isoCode" : @"DC", @"name" : @"District Of Columbia"},
        @{@"isoCode" : @"FL", @"name" : @"Florida"},
        @{@"isoCode" : @"GA", @"name" : @"Georgia"},
        @{@"isoCode" : @"HI", @"name" : @"Hawaii"},
        @{@"isoCode" : @"ID", @"name" : @"Idaho"},
        @{@"isoCode" : @"IL", @"name" : @"Illinois"},
        @{@"isoCode" : @"IN", @"name" : @"Indiana"},
        @{@"isoCode" : @"IA", @"name" : @"Iowa"},
        @{@"isoCode" : @"KS", @"name" : @"Kansas"},
        @{@"isoCode" : @"KY", @"name" : @"Kentucky"},
        @{@"isoCode" : @"LA", @"name" : @"Louisiana"},
        @{@"isoCode" : @"ME", @"name" : @"Maine"},
        @{@"isoCode" : @"MD", @"name" : @"Maryland"},
        @{@"isoCode" : @"MA", @"name" : @"Massachusetts"},
        @{@"isoCode" : @"MI", @"name" : @"Michigan"},
        @{@"isoCode" : @"MN", @"name" : @"Minnesota"},
        @{@"isoCode" : @"MS", @"name" : @"Mississippi"},
        @{@"isoCode" : @"MO", @"name" : @"Missouri"},
        @{@"isoCode" : @"MT", @"name" : @"Montana"},
        @{@"isoCode" : @"NE", @"name" : @"Nebraska"},
        @{@"isoCode" : @"NV", @"name" : @"Nevada"},
        @{@"isoCode" : @"NH", @"name" : @"New Hampshire"},
        @{@"isoCode" : @"NJ", @"name" : @"New Jersey"},
        @{@"isoCode" : @"NM", @"name" : @"New Mexico"},
        @{@"isoCode" : @"NY", @"name" : @"New York"},
        @{@"isoCode" : @"NC", @"name" : @"North Carolina"},
        @{@"isoCode" : @"ND", @"name" : @"North Dakota"},
        @{@"isoCode" : @"OH", @"name" : @"Ohio"},
        @{@"isoCode" : @"OK", @"name" : @"Oklahoma"},
        @{@"isoCode" : @"OR", @"name" : @"Oregon"},
        @{@"isoCode" : @"PA", @"name" : @"Pennsylvania"},
        @{@"isoCode" : @"RI", @"name" : @"Rhode Island"},
        @{@"isoCode" : @"SC", @"name" : @"South Carolina"},
        @{@"isoCode" : @"SD", @"name" : @"South Dakota"},
        @{@"isoCode" : @"TN", @"name" : @"Tennessee"},
        @{@"isoCode" : @"TX", @"name" : @"Texas"},
        @{@"isoCode" : @"UT", @"name" : @"Utah"},
        @{@"isoCode" : @"VT", @"name" : @"Vermont"},
        @{@"isoCode" : @"VA", @"name" : @"Virginia"},
        @{@"isoCode" : @"WA", @"name" : @"Washington"},
        @{@"isoCode" : @"WV", @"name" : @"West Virginia"},
        @{@"isoCode" : @"WI", @"name" : @"Wisconsin"},
        @{@"isoCode" : @"WY", @"name" : @"Wyoming"}
    ]];
}

+ (instancetype)caStateList {
    return [[JPStateList alloc] initWith:@[
        @{@"isoCode" : @"AB", @"name" : @"Alberta"},
        @{@"isoCode" : @"BC", @"name" : @"British Columbia"},
        @{@"isoCode" : @"MB", @"name" : @"Manitoba"},
        @{@"isoCode" : @"NB", @"name" : @"New Brunswick"},
        @{@"isoCode" : @"NL", @"name" : @"Newfoundland and Labrador"},
        @{@"isoCode" : @"NS", @"name" : @"Nova Scotia"},
        @{@"isoCode" : @"NT", @"name" : @"Northwest Territories"},
        @{@"isoCode" : @"NU", @"name" : @"Nunavut"},
        @{@"isoCode" : @"ON", @"name" : @"Ontario"},
        @{@"isoCode" : @"PE", @"name" : @"Prince Edward Island"},
        @{@"isoCode" : @"QC", @"name" : @"Quebec"},
        @{@"isoCode" : @"SK", @"name" : @"Saskatchewan"},
        @{@"isoCode" : @"YT", @"name" : @"Yukon"}
    ]];
}

- (instancetype)initWith:(NSArray *)array {
    if (!array) {
        return nil;
    }
    if (self = [super init]) {
        NSMutableArray *states = [NSMutableArray new];
        for (NSDictionary *stateDict in array) {
            if (stateDict) {
                JPState *state = [[JPState alloc] initWithDictionary:stateDict];
                if (state) {
                    [states addObject:state];
                }
            }
        }
        self.states = states;
    }
    return self;
}

@end
