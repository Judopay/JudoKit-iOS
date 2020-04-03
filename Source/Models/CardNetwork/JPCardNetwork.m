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
+ (instancetype)networkWith:(CardNetwork)type
             numberPrefixes:(NSString *)prefixes {
    return [JPCardNetwork networkWith:type
                       numberPrefixes:prefixes
                        numberPattern:[self defaultNumberPattern]];
}

+ (instancetype)networkWith:(CardNetwork)type
             numberPrefixes:(NSString *)prefixes
              numberPattern:(NSString *)pattern {
    JPCardNetwork *network = [JPCardNetwork new];
    network.network = type;
    network.numberPrefixes = [prefixes componentsSeparatedByString:@","];
    network.numberPattern = pattern;
    return network;
}

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

+ (NSArray<JPCardNetwork *> *)supportedNetworks {
    static NSArray *_networks;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networks = @[
            [JPCardNetwork networkWith:CardNetworkVisa
                        numberPrefixes:kVisaPrefixes],

            [JPCardNetwork networkWith:CardNetworkChinaUnionPay
                        numberPrefixes:kChinaUnionPayPrefixes],

            [JPCardNetwork networkWith:CardNetworkAMEX
                        numberPrefixes:kAMEXPrefixes
                         numberPattern:kAMEXPattern],

            [JPCardNetwork networkWith:CardNetworkMaestro
                        numberPrefixes:kMaestroPrefixes],

            [JPCardNetwork networkWith:CardNetworkDinersClub
                        numberPrefixes:kDinersClubPrefixes
                         numberPattern:kDinersClubPattern],

            [JPCardNetwork networkWith:CardNetworkJCB
                        numberPrefixes:kJCBPrefixes],

            [JPCardNetwork networkWith:CardNetworkMasterCard
                        numberPrefixes:kMasterCardPrefixes],

            [JPCardNetwork networkWith:CardNetworkDiscover
                        numberPrefixes:kDiscoverPrefixes],
        ];
    });

    return _networks;
}

+ (CardNetwork)cardNetworkForCardNumber:(NSString *)cardNumber {
    __block CardNetwork network = CardNetworkUnknown;
    NSArray<JPCardNetwork *> *networks = [JPCardNetwork supportedNetworks];

    [networks enumerateObjectsUsingBlock:^(JPCardNetwork *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj.numberPrefixes containsPrefix:cardNumber]) {
            *stop = YES;
            network = obj.network;
            return;
        }
    }];

    return network;
}

+ (JPCardNetwork *)cardNetworkWithType:(CardNetwork)networkType {
    __block JPCardNetwork *network = nil;
    NSArray<JPCardNetwork *> *networks = [JPCardNetwork supportedNetworks];

    [networks enumerateObjectsUsingBlock:^(JPCardNetwork *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.network == networkType) {
            *stop = YES;
            network = obj;
            return;
        }
    }];

    return network;
}

+ (NSString *)defaultNumberPattern {
    return kVISAPattern;
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