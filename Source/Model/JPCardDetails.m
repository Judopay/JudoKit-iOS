//
//  JPCardDetails.m
//  JudoKitObjC
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

#import "JPCardDetails.h"

@implementation JPCardDetails

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
        self.cardLastFour = dictionary[@"cardLastfour"];
        self.endDate = dictionary[@"endDate"];
        self.cardToken = dictionary[@"cardToken"];
        self.cardNumber = dictionary[@"cardNumber"];
        self.cardNetwork = ((NSNumber *)dictionary[@"cardType"]).integerValue;
	}
	return self;
}

- (nullable NSString *)formattedCardLastFour {
    if (!self.cardLastFour) {
        return nil;
    }
    
    switch (self.cardNetwork) {
        case CardNetworkAMEX:
            return [NSString stringWithFormat:@"**** ****** *%@", self.cardLastFour];
            break;
        case CardNetworkUnknown:
            return [NSString stringWithFormat:@"**** %@", self.cardLastFour];
            break;
        default:
            return [NSString stringWithFormat:@"**** **** **** %@", self.cardLastFour];
            break;
    }
    
}

- (nullable NSString *)formattedExpiryDate {
    if (!self.endDate) {
        return nil;
    }
    
    if (self.endDate.length == 4) {
        NSString *prefix = [self.endDate substringToIndex:2];
        NSString *suffix = [self.endDate substringFromIndex:2];
        return [NSString stringWithFormat:@"%@/%@", prefix, suffix];
    }
    return self.endDate;
}

+ (nonnull NSString *)titleForCardNetwork:(CardNetwork)network {
    switch (network) {
        case CardNetworkUnknown:
            return @"Unknown Card Network";
        case CardNetworkVisa:
            return @"Visa Card Network";
        case CardNetworkMasterCard:
            return @"MasterCard Network";
        case CardNetworkVisaElectron:
            return @"Visa Electron Network";
        case CardNetworkSwitch:
            return @"Switch Network";
        case CardNetworkSolo:
            return @"Solo Network";
        case CardNetworkLaser:
            return @"Laser Network";
        case CardNetworkChinaUnionPay:
            return @"China UnionPay Network";
        case CardNetworkAMEX:
            return @"American Express Card Network";
        case CardNetworkJCB:
            return @"JCB Network";
        case CardNetworkMaestro:
            return @"Maestro Card Network";
        case CardNetworkVisaDebit:
            return @"Visa Debit Card Network";
        case CardNetworkMasterCardDebit:
            return @"MasterCard Network";
        case CardNetworkVisaPurchasing:
            return @"Visa Purchasing Network";
        case CardNetworkDiscover:
            return @"Discover Network";
        case CardNetworkCarnet:
            return @"Carnet Network";
        case CardNetworkCarteBancaire:
            return @"Carte Bancaire Network";
        case CardNetworkDinersClub:
            return @"Diners Club Network";
        case CardNetworkElo:
            return @"Elo Network";
        case CardNetworkFarmersCard:
            return @"Farmers Card Network";
        case CardNetworkSoriana:
            return @"Soriana Network";
        case CardNetworkPrivateLabelCard:
            return @"Private Label Card Network";
        case CardNetworkQCard:
            return @"Q Card Network";
        case CardNetworkStyle:
            return @"Style Network";
        case CardNetworkTrueRewards:
            return @"True Rewards Network";
        case CardNetworkUATP:
            return @"UATP Network";
        case CardNetworkBankCard:
            return @"Bank Card Network";
        case CardNetworkBanamex_Costco:
            return @"Banamex Costco Network";
        case CardNetworkInterPayment:
            return @"InterPayment Network";
        case CardNetworkInstaPayment:
            return @"InstaPayment Network";
        case CardNetworkDankort:
            return @"Dankort Network";
    }
}

@end
