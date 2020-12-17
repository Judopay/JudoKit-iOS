//
//  JPUITestCard.m
//  ObjectiveCExampleAppUITests
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

#import "JPUITestCard.h"

@implementation JPUITestCard

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.cardType = dictionary[@"cardType"];
        self.cardNumber = dictionary[@"cardNumber"];
        self.cardholderName = dictionary[@"cardHolder"];
        self.expiryDate = dictionary[@"expiryDate"];
        self.securityCode = dictionary[@"securityCode"];
        self.secureCodeErrorMessage = dictionary[@"secureCodeErrorMessage"];
    }
    return self;
}

- (NSString *)valueForField:(NSString *)field {
    
    NSDictionary *valueDict = @{
        @"CARD NUMBER": self.cardNumber ? self.cardNumber : [NSNull null],
        @"CARDHOLDER NAME": self.cardholderName ? self.cardholderName : [NSNull null],
        @"EXPIRY DATE": self.expiryDate ? self.expiryDate : [NSNull null],
        @"SECURE CODE": self.securityCode ? self.securityCode : [NSNull null],
        @"SECURE CODE ERROR MESSAGE": self.secureCodeErrorMessage ? self.secureCodeErrorMessage : [NSNull null]
    };
    
    NSObject *value = [valueDict objectForKey:field];
    return (value != [NSNull null]) ? (NSString *)value : nil;
}

@end
