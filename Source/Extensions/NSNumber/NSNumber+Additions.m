//
//  NSNumber+Additions.m
//  JudoKit_iOS
//
//  Copyright (c) 2019-2022 Alternative Payments Ltd
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

#import "NSNumber+Additions.h"

@implementation NSNumber (Additions)

- (JPCardNetworkType)toCardNetworkType {
    switch (self.unsignedIntegerValue) {
        case 1:
        case 3:  // VISA ELECTRON
        case 11: // VISA DEBIT
        case 13: // VISA PURCHASING
            return JPCardNetworkTypeVisa;

        case 2:
        case 12: // MASTERCARD DEBIT
            return JPCardNetworkTypeMasterCard;

        case 7:
            return JPCardNetworkTypeChinaUnionPay;

        case 8:
            return JPCardNetworkTypeAMEX;

        case 9:
            return JPCardNetworkTypeJCB;

        case 10:
            return JPCardNetworkTypeMaestro;

        case 14:
            return JPCardNetworkTypeDiscover;

        case 17:
            return JPCardNetworkTypeDinersClub;

        default:
            return JPCardNetworkTypeUnknown;
    }
}

@end
