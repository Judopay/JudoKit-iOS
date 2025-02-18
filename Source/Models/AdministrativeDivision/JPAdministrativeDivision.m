//
//  JPAdministrativeDivision.m
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

#import "JPAdministrativeDivision.h"
#import "JPConstants.h"

@implementation JPAdministrativeDivision

+ (nullable JPAdministrativeDivision *)forAdministrativeDivisionName:(nonnull NSString *)name andCountryCode:(nonnull NSString *)countryCode {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    if ([countryCode isEqualToString:kAlpha2CodeUSA]) {
        return [JPAdministrativeDivisionsList.american.divisions filteredArrayUsingPredicate:predicate].firstObject;
    } else if ([countryCode isEqualToString:kAlpha2CodeCanada]) {
        return [JPAdministrativeDivisionsList.canadian.divisions filteredArrayUsingPredicate:predicate].firstObject;
    } else if ([countryCode isEqualToString:kAlpha2CodeIndia]) {
        return [JPAdministrativeDivisionsList.indian.divisions filteredArrayUsingPredicate:predicate].firstObject;
    } else if ([countryCode isEqualToString:kAlpha2CodeChina]) {
        return [JPAdministrativeDivisionsList.chinese.divisions filteredArrayUsingPredicate:predicate].firstObject;
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

@implementation JPAdministrativeDivisionsList

+ (instancetype)american {
    return [[JPAdministrativeDivisionsList alloc] initWith:@[
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

+ (instancetype)canadian {
    return [[JPAdministrativeDivisionsList alloc] initWith:@[
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

+ (instancetype)indian {
    return [[JPAdministrativeDivisionsList alloc] initWith:@[
        @{@"isoCode" : @"AN", @"name" : @"Andaman and Nicobar Islands"},
        @{@"isoCode" : @"AP", @"name" : @"Andhra Pradesh"},
        @{@"isoCode" : @"AR", @"name" : @"Arunachal Pradesh"},
        @{@"isoCode" : @"AS", @"name" : @"Assam"},
        @{@"isoCode" : @"BR", @"name" : @"Bihar"},
        @{@"isoCode" : @"CH", @"name" : @"Chandigarh"},
        @{@"isoCode" : @"CG", @"name" : @"Chhattisgarh"},
        @{@"isoCode" : @"DL", @"name" : @"Delhi"},
        @{@"isoCode" : @"DH", @"name" : @"Dadra and Nagar Haveli and Daman and Diu"},
        @{@"isoCode" : @"GA", @"name" : @"Goa"},
        @{@"isoCode" : @"GJ", @"name" : @"Gujarat"},
        @{@"isoCode" : @"HR", @"name" : @"Haryana"},
        @{@"isoCode" : @"HP", @"name" : @"Himachal Pradesh"},
        @{@"isoCode" : @"JK", @"name" : @"Jammu and Kashmīr"},
        @{@"isoCode" : @"JH", @"name" : @"Jharkhand"},
        @{@"isoCode" : @"KA", @"name" : @"Karnataka"},
        @{@"isoCode" : @"KL", @"name" : @"Kerala"},
        @{@"isoCode" : @"LA", @"name" : @"Ladakh"},
        @{@"isoCode" : @"LD", @"name" : @"Lakshadweep"},
        @{@"isoCode" : @"MP", @"name" : @"Madhya Pradesh"},
        @{@"isoCode" : @"MH", @"name" : @"Maharashtra"},
        @{@"isoCode" : @"MN", @"name" : @"Manipur"},
        @{@"isoCode" : @"ML", @"name" : @"Meghalaya"},
        @{@"isoCode" : @"MZ", @"name" : @"Mizoram"},
        @{@"isoCode" : @"NL", @"name" : @"Nāgāland"},
        @{@"isoCode" : @"OD", @"name" : @"Odisha"},
        @{@"isoCode" : @"PY", @"name" : @"Puducherry"},
        @{@"isoCode" : @"PB", @"name" : @"Punjab"},
        @{@"isoCode" : @"RJ", @"name" : @"Rajasthan"},
        @{@"isoCode" : @"SK", @"name" : @"Sikkim"},
        @{@"isoCode" : @"TN", @"name" : @"Tamil Nadu"},
        @{@"isoCode" : @"TS", @"name" : @"Telangana"},
        @{@"isoCode" : @"TR", @"name" : @"Tripura"},
        @{@"isoCode" : @"UP", @"name" : @"Uttar Pradesh"},
        @{@"isoCode" : @"UK", @"name" : @"Uttarakhand"},
        @{@"isoCode" : @"WB", @"name" : @"West Bengal"}
    ]];
}

+ (instancetype)chinese {
    return [[JPAdministrativeDivisionsList alloc] initWith:@[
        @{@"isoCode" : @"AH", @"name" : @"Anhui Sheng"},
        @{@"isoCode" : @"MO", @"name" : @"Aomen Tebiexingzhengqu"},
        @{@"isoCode" : @"BJ", @"name" : @"Beijing Shi"},
        @{@"isoCode" : @"CQ", @"name" : @"Chongqing Shi"},
        @{@"isoCode" : @"FJ", @"name" : @"Fujian Sheng"},
        @{@"isoCode" : @"GS", @"name" : @"Gansu Sheng"},
        @{@"isoCode" : @"GD", @"name" : @"Guangdong Sheng"},
        @{@"isoCode" : @"GX", @"name" : @"Guangxi Zhuangzu Zizhiqu"},
        @{@"isoCode" : @"GZ", @"name" : @"Guizhou Sheng"},
        @{@"isoCode" : @"HI", @"name" : @"Hainan Sheng"},
        @{@"isoCode" : @"HE", @"name" : @"Hebei Sheng"},
        @{@"isoCode" : @"HL", @"name" : @"Heilongjiang Sheng"},
        @{@"isoCode" : @"HA", @"name" : @"Henan Sheng"},
        @{@"isoCode" : @"HK", @"name" : @"Hong Kong SAR"},
        @{@"isoCode" : @"HB", @"name" : @"Hubei Sheng"},
        @{@"isoCode" : @"HN", @"name" : @"Hunan Sheng"},
        @{@"isoCode" : @"JS", @"name" : @"Jiangsu Sheng"},
        @{@"isoCode" : @"JX", @"name" : @"Jiangxi Sheng"},
        @{@"isoCode" : @"JL", @"name" : @"Jilin Sheng"},
        @{@"isoCode" : @"LN", @"name" : @"Liaoning Sheng"},
        @{@"isoCode" : @"MO", @"name" : @"Macao SAR"},
        @{@"isoCode" : @"MO", @"name" : @"Macau SAR"},
        @{@"isoCode" : @"NM", @"name" : @"Nei Mongol Zizhiqu"},
        @{@"isoCode" : @"NX", @"name" : @"Ningxia Huizu Zizhiqu"},
        @{@"isoCode" : @"QH", @"name" : @"Qinghai Sheng"},
        @{@"isoCode" : @"SN", @"name" : @"Shaanxi Sheng"},
        @{@"isoCode" : @"SD", @"name" : @"Shandong Sheng"},
        @{@"isoCode" : @"SH", @"name" : @"Shanghai Shi"},
        @{@"isoCode" : @"SX", @"name" : @"Shanxi Sheng"},
        @{@"isoCode" : @"SC", @"name" : @"Sichuan Sheng"},
        @{@"isoCode" : @"TW", @"name" : @"Taiwan Sheng"},
        @{@"isoCode" : @"TJ", @"name" : @"Tianjin Shi"},
        @{@"isoCode" : @"HK", @"name" : @"Xianggang Tebiexingzhengqu"},
        @{@"isoCode" : @"XJ", @"name" : @"Xinjiang Uygur Zizhiqu"},
        @{@"isoCode" : @"XZ", @"name" : @"Xizang Zizhiqu"},
        @{@"isoCode" : @"YN", @"name" : @"Yunnan Sheng"},
        @{@"isoCode" : @"ZJ", @"name" : @"Zhejiang Sheng"},
    ]];
}

- (instancetype)initWith:(NSArray *)array {
    if (!array) {
        return nil;
    }
    if (self = [super init]) {
        NSMutableArray *administrativeDivisions = [NSMutableArray new];
        for (NSDictionary *divisionsDics in array) {
            if (divisionsDics) {
                JPAdministrativeDivision *administrativeDivision = [[JPAdministrativeDivision alloc] initWithDictionary:divisionsDics];
                if (administrativeDivision) {
                    [administrativeDivisions addObject:administrativeDivision];
                }
            }
        }
        self.divisions = administrativeDivisions;
    }
    return self;
}

@end
