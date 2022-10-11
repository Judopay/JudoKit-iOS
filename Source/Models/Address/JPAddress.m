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

@implementation JPAddress

- (instancetype)initWithAddress1:(nullable NSString *)address1
                        address2:(nullable NSString *)address2
                        address3:(nullable NSString *)address3
                            town:(nullable NSString *)town
                        postCode:(nullable NSString *)postCode
                     countryCode:(nullable NSNumber *)countryCode
                           state:(nullable NSString *)state {

    if (self = [super init]) {
        self.address1 = address1;
        self.address2 = address2;
        self.address3 = address3;
        self.town = town;
        self.postCode = postCode;
        self.countryCode = countryCode;
        self.state = state;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if (dictionary[@"address1"]) {
            self.address1 = dictionary[@"address1"];
        }

        if (dictionary[@"address2"]) {
            self.address2 = dictionary[@"address2"];
        }

        if (dictionary[@"address3"]) {
            self.address3 = dictionary[@"address3"];
        }

        if (dictionary[@"town"]) {
            self.town = dictionary[@"town"];
        }

        if (dictionary[@"postCode"]) {
            self.postCode = dictionary[@"postCode"];
        }

        if (dictionary[@"countryCode"]) {
            self.countryCode = dictionary[@"countryCode"];
        }

        if (dictionary[@"state"]) {
            self.state = dictionary[@"state"];
        }
    }
    return self;
}

@end
