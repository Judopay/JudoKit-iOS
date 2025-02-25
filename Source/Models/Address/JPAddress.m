//
//  JPAddress.m
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

#import "JPAddress.h"
#import "NSObject+Additions.h"

@implementation JPAddress

static NSString *const kAddress1Key = @"address1";
static NSString *const kAddress2Key = @"address2";
static NSString *const kAddress3Key = @"address3";
static NSString *const kTownKey = @"town";
static NSString *const kPostCodeKey = @"postCode";
static NSString *const kCountryCodeKey = @"countryCode";
static NSString *const kStateKey = @"state";

@dynamic state;

- (instancetype)initWithAddress1:(NSString *)address1
                        address2:(NSString *)address2
                        address3:(NSString *)address3
                            town:(NSString *)town
                        postCode:(NSString *)postCode
                     countryCode:(NSNumber *)countryCode
          administrativeDivision:(NSString *)administrativeDivision {

    if (self = [super init]) {
        self.address1 = address1;
        self.address2 = address2;
        self.address3 = address3;
        self.town = town;
        self.postCode = postCode;
        self.countryCode = countryCode;
        self.administrativeDivision = administrativeDivision;
    }
    return self;
}

- (instancetype)initWithAddress1:(NSString *)address1
                        address2:(NSString *)address2
                        address3:(NSString *)address3
                            town:(NSString *)town
                        postCode:(NSString *)postCode
                     countryCode:(NSNumber *)countryCode
                           state:(NSString *)state {

    return [self initWithAddress1:address1
                         address2:address2
                         address3:address3
                             town:town
                         postCode:postCode
                      countryCode:countryCode
           administrativeDivision:state];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if (dictionary[kAddress1Key]) {
            self.address1 = dictionary[kAddress1Key];
        }

        if (dictionary[kAddress2Key]) {
            self.address2 = dictionary[kAddress2Key];
        }

        if (dictionary[kAddress3Key]) {
            self.address3 = dictionary[kAddress3Key];
        }

        if (dictionary[kTownKey]) {
            self.town = dictionary[kTownKey];
        }

        if (dictionary[kPostCodeKey]) {
            self.postCode = dictionary[kPostCodeKey];
        }

        if (dictionary[kCountryCodeKey]) {
            self.countryCode = dictionary[kCountryCodeKey];
        }

        if (dictionary[kStateKey]) {
            self.administrativeDivision = dictionary[kStateKey];
        }
    }
    return self;
}

#pragma mark - JPDictionaryConvertible

- (NSDictionary *)_jp_toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];

    if (self.address1) {
        dictionary[kAddress1Key] = self.address1;
    }

    if (self.address2) {
        dictionary[kAddress2Key] = self.address2;
    }

    if (self.address3) {
        dictionary[kAddress3Key] = self.address3;
    }

    if (self.town) {
        dictionary[kTownKey] = self.town;
    }

    if (self.postCode) {
        dictionary[kPostCodeKey] = self.postCode;
    }

    if (self.countryCode) {
        dictionary[kCountryCodeKey] = self.countryCode;
    }

    if (self.administrativeDivision) {
        dictionary[kStateKey] = self.administrativeDivision;
    }

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
