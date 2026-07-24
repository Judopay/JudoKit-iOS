//
//  JPDeviceDetails.m
//  JudoKit_iOS
//
//  Copyright (c) 2026 Alternative Payments Ltd
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

#import "JPDeviceDetails.h"

@implementation JPDeviceDetails

- (instancetype)initWithKDeviceId:(NSString *)kDeviceId
                        vDeviceId:(NSString *)vDeviceId
                      countryCode:(NSString *)countryCode
                    cultureLocale:(NSString *)cultureLocale
                               os:(NSString *)os {
    if (self = [super init]) {
        _kDeviceId = kDeviceId;
        _vDeviceId = vDeviceId;
        _countryCode = countryCode;
        _cultureLocale = cultureLocale;
        _os = os;
    }
    return self;
}

#pragma mark - JPDictionaryConvertible

- (NSDictionary *)_jp_toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if (self.kDeviceId)
        dict[@"kDeviceId"] = self.kDeviceId;
    if (self.vDeviceId)
        dict[@"vDeviceId"] = self.vDeviceId;
    if (self.countryCode)
        dict[@"countryCode"] = self.countryCode;
    if (self.cultureLocale)
        dict[@"cultureLocale"] = self.cultureLocale;
    if (self.os)
        dict[@"os"] = self.os;
    return dict;
}

@end
