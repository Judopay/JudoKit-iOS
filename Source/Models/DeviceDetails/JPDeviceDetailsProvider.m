//
//  JPDeviceDetailsProvider.m
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

#import "JPDeviceDetailsProvider.h"
#import "JPDeviceDetails.h"

static NSString *const kVDeviceIdKey = @"Judo-vDeviceId";

@interface JPDeviceDetailsProvider ()
@property (nonatomic, strong) UIDevice *device;
@property (nonatomic, strong) NSLocale *locale;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, copy) NSString *cachedKDeviceId;
@property (nonatomic, copy) NSString *cachedVDeviceId;
@end

@implementation JPDeviceDetailsProvider

- (instancetype)init {
    return [self initWithDevice:UIDevice.currentDevice
                         locale:NSLocale.currentLocale
                   userDefaults:NSUserDefaults.standardUserDefaults];
}

- (instancetype)initWithDevice:(UIDevice *)device
                        locale:(NSLocale *)locale
                  userDefaults:(NSUserDefaults *)userDefaults {
    if (self = [super init]) {
        _device = device;
        _locale = locale;
        _userDefaults = userDefaults;
    }
    return self;
}

- (JPDeviceDetails *)deviceDetails {
    return [[JPDeviceDetails alloc] initWithKDeviceId:self.kDeviceId
                                            vDeviceId:self.vDeviceId
                                          countryCode:self.countryCode
                                        cultureLocale:self.cultureLocale
                                                   os:self.os];
}

#pragma mark - Private

- (NSString *)kDeviceId {
    if (!_cachedKDeviceId) {
        @try {
            _cachedKDeviceId = self.device.identifierForVendor.UUIDString;
        } @catch (NSException *ignored) {}
    }
    return _cachedKDeviceId;
}

- (NSString *)vDeviceId {
    if (!_cachedVDeviceId) {
        @try {
            NSString *stored = [self.userDefaults stringForKey:kVDeviceIdKey];
            if (!stored) {
                stored = [[NSUUID UUID] UUIDString];
                [self.userDefaults setObject:stored forKey:kVDeviceIdKey];
            }
            _cachedVDeviceId = stored;
        } @catch (NSException *ignored) {}
    }
    return _cachedVDeviceId;
}

- (NSString *)countryCode {
    @try {
        return self.locale.countryCode;
    } @catch (NSException *ignored) {
        return nil;
    }
}

- (NSString *)cultureLocale {
    @try {
        NSString *language = self.locale.languageCode;
        NSString *country = self.locale.countryCode;
        if (language && country) {
            return [NSString stringWithFormat:@"%@_%@", language, country];
        }
        return nil;
    } @catch (NSException *ignored) {
        return nil;
    }
}

- (NSString *)os {
    return [NSString stringWithFormat:@"%@ %@", self.device.systemName, self.device.systemVersion];
}

@end
