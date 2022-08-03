//
//  UIImage+Additions.h
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
//

#import "NSBundle+Additions.h"
#import "UIImage+Additions.h"

@implementation UIImage (Additions)

+ (UIImage *)_jp_imageWithIconName:(NSString *)iconName {
    return [UIImage imageNamed:iconName inBundle:NSBundle._jp_iconsBundle compatibleWithTraitCollection:nil];
}

+ (UIImage *)_jp_imageWithResourceName:(NSString *)resourceName {
    return [UIImage imageNamed:resourceName inBundle:NSBundle._jp_resourcesBundle compatibleWithTraitCollection:nil];
}

+ (UIImage *)_jp_headerImageForCardNetwork:(JPCardNetworkType)network {
    if (network == JPCardNetworkTypeVisa) {
        return [UIImage _jp_imageWithIconName:@"card-visa-white"];
    }
    return [UIImage _jp_imageForCardNetwork:network];
}

+ (UIImage *)_jp_imageForCardNetwork:(JPCardNetworkType)network {
    switch (network) {
        case JPCardNetworkTypeAMEX:
            return [UIImage _jp_imageWithIconName:@"card-amex"];
        case JPCardNetworkTypeDinersClub:
            return [UIImage _jp_imageWithIconName:@"card-diners"];
        case JPCardNetworkTypeDiscover:
            return [UIImage _jp_imageWithIconName:@"card-discover"];
        case JPCardNetworkTypeJCB:
            return [UIImage _jp_imageWithIconName:@"card-jcb"];
        case JPCardNetworkTypeMaestro:
            return [UIImage _jp_imageWithIconName:@"card-maestro"];
        case JPCardNetworkTypeMasterCard:
            return [UIImage _jp_imageWithIconName:@"card-mastercard"];
        case JPCardNetworkTypeChinaUnionPay:
            return [UIImage _jp_imageWithIconName:@"card-unionpay"];
        case JPCardNetworkTypeVisa:
            return [UIImage _jp_imageWithIconName:@"card-visa"];
        default:
            return nil;
    }
}

@end
