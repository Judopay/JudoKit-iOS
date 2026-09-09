//
//  JPDsCertificateEntry.m
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

#import "JPDsCertificateEntry.h"

static NSDate *_Nullable jp_parseISO8601Date(NSString *string) {
    NSISO8601DateFormatter *formatter = [[NSISO8601DateFormatter alloc] init];
    formatter.formatOptions = NSISO8601DateFormatWithInternetDateTime | NSISO8601DateFormatWithFractionalSeconds;
    NSDate *date = [formatter dateFromString:string];
    if (!date) {
        formatter.formatOptions = NSISO8601DateFormatWithInternetDateTime;
        date = [formatter dateFromString:string];
    }
    return date;
}

@implementation JPDsCertificateEntry

+ (nullable instancetype)entryFromDictionary:(NSDictionary *)dict {
    if (![dict isKindOfClass:NSDictionary.class]) {
        return nil;
    }

    JPDsCertificateEntry *entry = [JPDsCertificateEntry new];
    entry.dsId = dict[@"dsId"];
    entry.dsName = dict[@"dsName"];
    entry.dsCertificate = dict[@"dsCertificate"];
    entry.rootCertificates = dict[@"rootCertificates"] ?: @[];
    entry.keyId = dict[@"keyId"];
    entry.validUntil = dict[@"validUntil"];

    if (!entry.dsId || !entry.dsCertificate || !entry.keyId) {
        return nil;
    }

    return entry;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"dsId"] = self.dsId ?: NSNull.null;
    dict[@"dsName"] = self.dsName ?: NSNull.null;
    dict[@"dsCertificate"] = self.dsCertificate ?: NSNull.null;
    dict[@"rootCertificates"] = self.rootCertificates ?: @[];
    dict[@"keyId"] = self.keyId ?: NSNull.null;
    if (self.validUntil) {
        dict[@"validUntil"] = self.validUntil;
    }
    return [dict copy];
}

- (BOOL)isNotExpiredForDate:(NSDate *)date {
    if (!self.validUntil) {
        return YES;
    }
    NSDate *expiry = jp_parseISO8601Date(self.validUntil);
    if (!expiry) {
        return YES;
    }
    return [expiry compare:date] == NSOrderedDescending;
}

- (BOOL)isNearExpiryForDate:(NSDate *)date threshold:(NSTimeInterval)threshold {
    if (!self.validUntil) {
        return NO;
    }
    NSDate *expiry = jp_parseISO8601Date(self.validUntil);
    if (!expiry) {
        return NO;
    }
    NSTimeInterval timeUntilExpiry = [expiry timeIntervalSinceDate:date];
    return timeUntilExpiry < threshold;
}

@end
