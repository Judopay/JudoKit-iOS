//
//  UIColor+Additions.m
//  JudoKit_iOS
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

#import "UIColor+Additions.h"

@implementation UIColor (Judo)

- (UIImage *)_jp_asImage {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIColor *)_jp_colorFromHex:(int)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0x00FF00) >> 8)) / 255.0
                            blue:((float)((hex & 0x0000FF) >> 0)) / 255.0
                           alpha:1.0];
}

+ (UIColor *)_jp_blackColor {
    return [UIColor _jp_colorFromHex:0x262626];
}

+ (UIColor *)_jp_darkGrayColor {
    return [UIColor _jp_colorFromHex:0x999999];
}

+ (UIColor *)_jp_grayColor {
    return [UIColor _jp_colorFromHex:0xE5E5E5];
}

+ (UIColor *)_jp_graphiteGrayColor {
    return [UIColor _jp_colorFromHex:0x8C8C8C];
}

+ (UIColor *)_jp_lightGrayColor {
    return [UIColor _jp_colorFromHex:0xF6F6F6];
}

+ (UIColor *)_jp_redColor {
    return [UIColor _jp_colorFromHex:0xE21900];
}

+ (UIColor *)_jp_whiteColor {
    return [UIColor _jp_colorFromHex:0xFFFFFF];
}

@end
