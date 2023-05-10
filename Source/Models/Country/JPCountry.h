//
//  JPCountry.h
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

#import "JPBillingCountry.h"
#import <Foundation/Foundation.h>

@interface JPCountry : NSObject

@property (nonatomic, nullable, copy) NSString *alpha2Code;
@property (nonatomic, nullable, copy) NSString *name;
@property (nonatomic, nullable, copy) NSString *dialCode;
@property (nonatomic, nullable, copy) NSString *numericCode;
@property (nonatomic, nullable, copy) NSString *phoneNumberFormat;

+ (nullable NSNumber *)isoCodeForCountry:(nonnull NSString *)countryName;

+ (nullable NSNumber *)dialCodeForCountry:(nonnull NSString *)countryName;

+ (nullable JPCountry *)forCountryName:(nonnull NSString *)countryName;

- (nullable instancetype)initWithDictionary:(nullable NSDictionary *)dict;

- (BOOL)isUSA;

- (BOOL)isCanada;

- (BOOL)hasStates;

- (JPBillingCountry)toBillingCountry;

@end

@interface JPCountryList : NSObject

@property (nonatomic, nullable, copy) NSArray<JPCountry *> *countries;

- (nullable instancetype)initWithDictionary:(nullable NSDictionary *)dict;

+ (nullable instancetype)defaultCountryList;

@end
