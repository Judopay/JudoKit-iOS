//
//  Functions.m
//  JudoKit_iOS
//
//  Copyright (c) 2019 Alternative Payments Ltd
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

#import <arpa/inet.h>
#import <ifaddrs.h>

#import "Functions.h"
#import "JudoKit.h"
#import "NSString+Additions.h"
#import <sys/utsname.h>

static NSString *const kUserAgentProductName = @"JudoKit-iOS";
static NSString *const kUserAgentSubProductNameReactNative = @"JudoKit-ReactNative";

@implementation JPQueryStringPair

- (instancetype)initWithField:(NSString *)field value:(NSString *)value {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.field = field;
    self.value = value;

    return self;
}

- (NSString *)URLEncodedValue {
    if (!self.value || [self.value isEqual:NSNull.null]) {
        return RFC3986PercentEscapedStringFromString([self.field description]);
    } else {
        return [NSString stringWithFormat:@"%@=%@", RFC3986PercentEscapedStringFromString([self.field description]), RFC3986PercentEscapedStringFromString([self.value description])];
    }
}

@end

NSString *RFC3986PercentEscapedStringFromString(NSString *string) {
    static NSString *const kCharactersGeneralDelimitersToEncode = @":#[]@";
    static NSString *const kCharactersSubDelimitersToEncode = @"!$&'()*+,;=";

    NSMutableCharacterSet *allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kCharactersGeneralDelimitersToEncode stringByAppendingString:kCharactersSubDelimitersToEncode]];

    static NSUInteger const batchSize = 50;

    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;

    while (index < string.length) {
        NSUInteger length = MIN(string.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);

        range = [string rangeOfComposedCharacterSequencesForRange:range];

        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        if (encoded) {
            [escaped appendString:encoded];
        }

        index += range.length;
    }

    return escaped;
}

NSString *queryParameters(NSArray<JPQueryStringPair *> *parameters) {
    NSMutableArray<NSString *> *components = [NSMutableArray new];

    for (JPQueryStringPair *parameter in parameters) {
        [components addObject:[parameter URLEncodedValue]];
    }

    return [components componentsJoinedByString:@"&"];
}

double getWidthAspectRatio(void) {
    return UIScreen.mainScreen.bounds.size.width / 414;
}

NSString *getUserAgent(JPSubProductInfo *subProductInfo) {
    UIDevice *device = UIDevice.currentDevice;
    NSBundle *mainBundle = NSBundle.mainBundle;

    NSMutableArray<NSString *> *userAgentParts = [NSMutableArray new];

    // Base user agent
    [userAgentParts addObject:[NSString stringWithFormat:@"%@/%@", kUserAgentProductName, JudoKitVersion]];

    if (subProductInfo.subProductType == JPSubProductTypeReactNative) {
        [userAgentParts addObject:[NSString stringWithFormat:@"(%@/%@)", kUserAgentSubProductNameReactNative, subProductInfo.version]];
    }

    // Operating system
    [userAgentParts addObject:[NSString stringWithFormat:@"%@/%@", device.systemName, device.systemVersion]];

    NSString *appName = [mainBundle objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *appVersion = [mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

    if (appName && appVersion) {
        // App Name and version
        NSString *appNameMinusSpaces = [appName _jp_stringByRemovingWhitespaces];
        [userAgentParts addObject:[NSString stringWithFormat:@"%@/%@", appNameMinusSpaces, appVersion]];
    }

    // Model
    NSString *model;
    struct utsname systemInfo;
    uname(&systemInfo);
    char machine = systemInfo.machine;

    if (machine) {
        model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    }

    if (!model) {
        model = device.model;
    }

    [userAgentParts addObject:model];

    return [userAgentParts componentsJoinedByString:@" "];
}

NSString *getIPAddress(void) {
    NSString *address;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;

    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);

    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {

            BOOL isValidFamily = temp_addr->ifa_addr->sa_family == AF_INET;
            BOOL isValidName = [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"];

            if (isValidFamily && isValidName) {
                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
            }

            temp_addr = temp_addr->ifa_next;
        }
    }

    freeifaddrs(interfaces);
    return address ? address : @"";
}

NSString *generateBasicAuthHeader(NSString *token, NSString *secret) {
    NSString *formattedString = [NSString stringWithFormat:@"%@:%@", token, secret];
    NSData *encodedStringData = [formattedString dataUsingEncoding:NSISOLatin1StringEncoding];
    NSString *base64String = [encodedStringData base64EncodedStringWithOptions:0];
    return [NSString stringWithFormat:@"Basic %@", base64String];
}

NSString *getSafeStringRepresentation(id object) {
    if (!object || [object isKindOfClass:NSString.class]) {
        return object;
    }

    if ([object isKindOfClass:NSNumber.class]) {
        return [object stringValue];
    }

    return [NSString stringWithFormat:@"%@", object];
}
