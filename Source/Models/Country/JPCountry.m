//
//  JPCountry.m
//  JudoKit_iOS
//
//  Copyright (c) 2016 Alternative Payments Ltd
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

#import "JPCountry.h"
#import "JPConstants.h"
#import "NSBundle+Additions.h"
#import "NSString+Additions.h"

@implementation JPCountryList

+ (instancetype)defaultCountryList {
    NSString *str = [NSBundle._jp_frameworkBundle pathForResource:@"countries-list" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:str];

    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        JPCountryList *list = [[JPCountryList alloc] initWithDictionary:dict];
        return list;
    }

    return nil;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    if (self = [super init]) {
        NSArray *countriesDictionaries = dict[@"countries"];
        NSMutableArray *countries = [NSMutableArray new];
        for (NSDictionary *countryDict in countriesDictionaries) {
            if (countryDict) {
                JPCountry *country = [[JPCountry alloc] initWithDictionary:countryDict];
                if (country) {
                    [countries addObject:country];
                }
            }
        }
        self.countries = countries;
    }
    return self;
}

@end

@implementation JPCountry

+ (NSNumber *)isoCodeForCountry:(NSString *)countryName {
    JPCountry *country = [JPCountry forCountryName:countryName];

    if (!country) {
        return nil;
    }

    return @([country.numericCode intValue]);
}

+ (NSNumber *)dialCodeForCountry:(NSString *)countryName {
    JPCountry *country = [JPCountry forCountryName:countryName];

    if (!country) {
        return nil;
    }

    return @([country.dialCode intValue]);
}

+ (nullable JPCountry *)forCountryName:(nonnull NSString *)countryName {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", countryName];
    return [JPCountryList.defaultCountryList.countries filteredArrayUsingPredicate:predicate].firstObject;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    if (self = [super init]) {
        self.alpha2Code = dict[@"alpha2Code"];
        self.name = dict[@"name"];
        self.dialCode = dict[@"dialCode"];
        self.numericCode = dict[@"numericCode"];
        self.phoneNumberFormat = dict[@"phoneNumberFormat"];
    }
    return self;
}

- (BOOL)isUSA {
    return [self.alpha2Code isEqualToString:kAlpha2CodeUSA];
}

- (BOOL)isCanada {
    return [self.alpha2Code isEqualToString:kAlpha2CodeCanada];
}

- (BOOL)isIndia {
    return [self.alpha2Code isEqualToString:kAlpha2CodeIndia];
}

- (BOOL)isChina {
    return [self.alpha2Code isEqualToString:kAlpha2CodeChina];
}

- (BOOL)hasStates {
    return self.isUSA || self.isCanada || self.isIndia || self.isChina;
}

- (JPBillingCountry)toBillingCountry {
    if ([self.alpha2Code isEqualToString:kAlpha2CodeUSA]) {
        return JPBillingCountryUSA;
    } else if ([self.alpha2Code isEqualToString:kAlpha2CodeUK]) {
        return JPBillingCountryUK;
    } else if ([self.alpha2Code isEqualToString:kAlpha2CodeCanada]) {
        return JPBillingCountryCanada;
    } else {
        return JPBillingCountryOther;
    }
}

@end
