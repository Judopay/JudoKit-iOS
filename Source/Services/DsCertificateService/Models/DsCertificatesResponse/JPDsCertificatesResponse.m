//
//  JPDsCertificatesResponse.m
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

#import "JPDsCertificatesResponse.h"

@implementation JPDsCertificatesResponse

+ (nullable instancetype)responseFromDictionary:(NSDictionary *)dict {
    if (![dict isKindOfClass:NSDictionary.class]) {
        return nil;
    }

    JPDsCertificatesResponse *response = [JPDsCertificatesResponse new];
    response.schemaVersion = dict[@"schemaVersion"] ?: @"";
    response.publishedAt = dict[@"publishedAt"];

    NSArray *rawEntries = dict[@"entries"];
    NSMutableArray<JPDsCertificateEntry *> *entries = [NSMutableArray array];
    for (NSDictionary *entryDict in rawEntries) {
        JPDsCertificateEntry *entry = [JPDsCertificateEntry entryFromDictionary:entryDict];
        if (entry) {
            [entries addObject:entry];
        }
    }
    response.entries = [entries copy];

    return response;
}

- (BOOL)hasCompatibleSchemaVersion {
    NSArray<NSString *> *parts = [self.schemaVersion componentsSeparatedByString:@"."];
    if (parts.count == 0) {
        return NO;
    }
    return [parts.firstObject integerValue] == 1;
}

@end
