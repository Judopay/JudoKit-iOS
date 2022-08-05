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

#import "JPCardNetworkType.h"
#import <UIKit/UIKit.h>

@interface UIImage (Additions)

/**
 * Initializes an UIImage based on a icon name contained in the icons bundle
 *
 * @param iconName - a string describing the icon name in the icons bundle
 *
 * @return a configured UIImage instance
 */
+ (nullable UIImage *)_jp_imageWithIconName:(nonnull NSString *)iconName;

/**
 * Initializes an UIImage based on a resource name contained in the resources bundle
 *
 * @param resourceName - a string describing the resource name in the resources bundle
 *
 * @return a configured UIImage instance
 */
+ (nullable UIImage *)_jp_imageWithResourceName:(nonnull NSString *)resourceName;

/**
 * Initializes an UIImage based on a card network
 *
 * @param network - a value describing the Card Network
 *
 * @return a configured UIImage instance
 */
+ (nullable UIImage *)_jp_imageForCardNetwork:(JPCardNetworkType)network;

/**
 * Initializes an UIImage to be displayed on top of a card.
 * It returns the same images as the previous method, while providing white alternatives for dark logo's
 *
 * @param network - a value describing the Card Network
 *
 * @return a configured UIImage instance
 */
+ (nullable UIImage *)_jp_headerImageForCardNetwork:(JPCardNetworkType)network;

@end
