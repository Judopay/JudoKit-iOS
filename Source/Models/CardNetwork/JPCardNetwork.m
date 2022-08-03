//
//  JPCardNetwork.m
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

#import "JPCardNetwork.h"
#import "JPConstants.h"
#import "NSString+Additions.h"

@implementation JPCardNetwork

+ (NSDictionary<NSNumber *, NSString *> *)networkNames {
    static NSDictionary *_networkNames;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkNames = @{
            @(JPCardNetworkTypeUnknown) : @"unknown_card_network"._jp_localized,
            @(JPCardNetworkTypeVisa) : @"Visa",
            @(JPCardNetworkTypeMasterCard) : @"Mastercard",
            @(JPCardNetworkTypeChinaUnionPay) : @"China UnionPay",
            @(JPCardNetworkTypeAMEX) : @"American Express",
            @(JPCardNetworkTypeJCB) : @"JCB",
            @(JPCardNetworkTypeMaestro) : @"Maestro",
            @(JPCardNetworkTypeDiscover) : @"Discover",
            @(JPCardNetworkTypeDinersClub) : @"Diners Club",
        };
    });

    return _networkNames;
}

+ (BOOL)doesCardNumber:(NSString *)cardNumber matchRegex:(NSString *)regex {
    NSRegularExpression *ukRegex = [NSRegularExpression regularExpressionWithPattern:regex
                                                                             options:NSRegularExpressionAnchorsMatchLines
                                                                               error:nil];
    return [ukRegex numberOfMatchesInString:cardNumber
                                    options:NSMatchingWithoutAnchoringBounds
                                      range:NSMakeRange(0, cardNumber.length)] > 0;
}

+ (JPCardNetworkType)cardNetworkForCardNumber:(NSString *)cardNumber {
    if ([self doesCardNumber:cardNumber matchRegex:kRegexVisa]) {
        return JPCardNetworkTypeVisa;
    }

    if ([self doesCardNumber:cardNumber matchRegex:kRegexMasterCard]) {
        return JPCardNetworkTypeMasterCard;
    }

    if ([self doesCardNumber:cardNumber matchRegex:kRegexMaestro]) {
        return JPCardNetworkTypeMaestro;
    }

    if ([self doesCardNumber:cardNumber matchRegex:kRegexAmex]) {
        return JPCardNetworkTypeAMEX;
    }

    if ([self doesCardNumber:cardNumber matchRegex:kRegexDiscover]) {
        return JPCardNetworkTypeDiscover;
    }

    if ([self doesCardNumber:cardNumber matchRegex:kRegexDinersClub]) {
        return JPCardNetworkTypeDinersClub;
    }

    if ([self doesCardNumber:cardNumber matchRegex:kRegexJCB]) {
        return JPCardNetworkTypeJCB;
    }

    if ([self doesCardNumber:cardNumber matchRegex:kRegexUnionPay]) {
        return JPCardNetworkTypeChinaUnionPay;
    }

    return JPCardNetworkTypeUnknown;
}

+ (NSString *)cardPatternForType:(JPCardNetworkType)networkType {
    switch (networkType) {
        case JPCardNetworkTypeVisa:
            return kVISAPattern;
        case JPCardNetworkTypeAMEX:
            return kAMEXPattern;
        case JPCardNetworkTypeDinersClub:
            return kDinersClubPattern;
        default:
            return [self defaultNumberPattern];
    }
}

+ (NSString *)defaultNumberPattern {
    return kDefaultPattern;
}

+ (NSString *)nameOfCardNetwork:(JPCardNetworkType)network {
    NSDictionary *names = [JPCardNetwork networkNames];
    NSNumber *key = @(network);
    if ([names.allKeys containsObject:key]) {
        return names[key];
    }
    return names[@(JPCardNetworkTypeUnknown)];
}

+ (NSUInteger)secureCodeLengthForNetworkType:(JPCardNetworkType)networkType {
    switch (networkType) {
        case JPCardNetworkTypeAMEX:
            return kSecurityCodeLengthAmex;
        default:
            return kSecurityCodeLengthDefault;
    }
}

+ (NSString *)secureCodePlaceholderForNetworkType:(JPCardNetworkType)networkType {
    switch (networkType) {
        case JPCardNetworkTypeAMEX:
            return kSecurityCodePlaceholderhAmex;
        case JPCardNetworkTypeVisa:
            return kSecurityCodePlaceholderhVisa;
        case JPCardNetworkTypeMasterCard:
            return kSecurityCodePlaceholderhMasterCard;
        case JPCardNetworkTypeChinaUnionPay:
            return kSecurityCodePlaceholderhChinaUnionPay;
        case JPCardNetworkTypeJCB:
            return kSecurityCodePlaceholderhJCB;
        default:
            return kSecurityCodePlaceholderDefault;
    }
}

@end
