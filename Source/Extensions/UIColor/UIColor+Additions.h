//
//  UIColor+Additions.h
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

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

/**
 * A method which converts the color into an UIImage instance
 */
- (nonnull UIImage *)_jp_asImage;

/**
 * A method which returns an UIImage based on a HEX value
 */
+ (UIColor *_Nonnull)_jp_colorFromHex:(int)hex;

/**
 * The black color value (0x262626) used in the application
 */
+ (UIColor *_Nonnull)_jp_blackColor;

/**
 * The dark gray color value (0x999999) used in the application
 */
+ (UIColor *_Nonnull)_jp_darkGrayColor;

/**
 * The gray color value (0xE5E5E5) used in the application
 */
+ (UIColor *_Nonnull)_jp_grayColor;

/**
 * The graphite gray color value (0x8C8C8C) used in the application
 */
+ (UIColor *_Nonnull)_jp_graphiteGrayColor;

/**
 * The light gray color value (0xF6F6F6) used in the application
 */
+ (UIColor *_Nonnull)_jp_lightGrayColor;

/**
 * The red color value (0xE21900) used in the application
 */
+ (UIColor *_Nonnull)_jp_redColor;

/**
 * The white color value (0xFFFFFF) used in the application
 */
+ (UIColor *_Nonnull)_jp_whiteColor;

@end
