//
//  JPCardNetwork.m
//  JudoKitObjC
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
#import "NSArray+Additions.h"

@implementation JPCardNetwork

+ (NSDictionary<NSNumber *, NSString *> *)networkNames {
    static NSDictionary *_networkNames;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkNames = @{
            @(CardNetworkUnknown) : @"Unknown Card Network",
            @(CardNetworkVisa) : @"Visa",
            @(CardNetworkMasterCard) : @"Mastercard",
            @(CardNetworkChinaUnionPay) : @"China UnionPay",
            @(CardNetworkAMEX) : @"AmEx",
            @(CardNetworkJCB) : @"JCB",
            @(CardNetworkMaestro) : @"Maestro",
            @(CardNetworkDiscover) : @"Discover",
            @(CardNetworkDinersClub) : @"Diners Club",
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

+ (CardNetwork)cardNetworkForCardNumber:(NSString *)cardNumber {
    if ([self doesCardNumber:cardNumber matchRegex:kRegexVisa]) {
        return CardNetworkVisa;
    }

    if ([self doesCardNumber:cardNumber matchRegex:kRegexMasterCard]) {
        return CardNetworkMasterCard;
    }

    if ([self doesCardNumber:cardNumber matchRegex:kRegexMaestro]) {
        return CardNetworkMaestro;
    }

    if ([self doesCardNumber:cardNumber matchRegex:kRegexAmex]) {
        return CardNetworkAMEX;
    }

    if ([self doesCardNumber:cardNumber matchRegex:kRegexDiscover]) {
        return CardNetworkDiscover;
    }

    if ([self doesCardNumber:cardNumber matchRegex:kRegexDinersClub]) {
        return CardNetworkDinersClub;
    }

    if ([self doesCardNumber:cardNumber matchRegex:kRegexJCB]) {
        return CardNetworkJCB;
    }

    if ([self doesCardNumber:cardNumber matchRegex:kRegexUnionPay]) {
        return CardNetworkChinaUnionPay;
    }

    return CardNetworkUnknown;
}

+ (NSString *)cardPatternForType:(CardNetwork)networkType {
    switch (networkType) {
        case CardNetworkVisa:
            return kVISAPattern;
        case CardNetworkAMEX:
            return kAMEXPattern;
        case CardNetworkDinersClub:
            return kDinersClubPattern;
        default:
            return [self defaultNumberPattern];
    }
}

+ (NSString *)defaultNumberPattern {
    return kDefaultPattern;
}

+ (NSString *)nameOfCardNetwork:(CardNetwork)network {
    NSDictionary *names = [JPCardNetwork networkNames];
    NSNumber *key = @(network);
    if ([names.allKeys containsObject:key]) {
        return names[key];
    }
    return names[@(CardNetworkUnknown)];
}

+ (NSUInteger)secureCodeLengthForNetworkType:(CardNetwork)networkType {
    switch (networkType) {
        case CardNetworkAMEX:
            return kSecurityCodeLengthAmex;
        default:
            return kSecurityCodeLengthDefault;
    }
}

+ (NSString *)secureCodePlaceholderForNetworkType:(CardNetwork)networkType {
    switch (networkType) {
        case CardNetworkAMEX:
            return kSecurityCodePlaceholderhAmex;
        case CardNetworkVisa:
            return kSecurityCodePlaceholderhVisa;
        case CardNetworkMasterCard:
            return kSecurityCodePlaceholderhMasterCard;
        case CardNetworkChinaUnionPay:
            return kSecurityCodePlaceholderhChinaUnionPay;
        case CardNetworkJCB:
            return kSecurityCodePlaceholderhJCB;
        default:
            return kSecurityCodePlaceholderDefault;
    }
}

@end
