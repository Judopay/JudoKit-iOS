//
//  NSBundle+Additions.h
//  JudoKit-iOS
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

#import <Foundation/Foundation.h>

/**
 * An NSBundle extension that offers additional convenience initializers
 */
@interface NSBundle (Additions)

/**
 * An initializer that points to the JudoKit framework
 */
+ (nonnull instancetype)frameworkBundle;

/**
 * An initializer that points to the icons bundle inside the JudoKit framework
 */
+ (nullable instancetype)iconsBundle;

/**
 * An initializer that points to the strings bundle inside the JudoKit framework
 */
+ (nonnull instancetype)stringsBundle;

/**
 * An initializer that points to the resources bundle inside the JudoKit framework
 */
+ (nullable instancetype)resourcesBundle;

/**
 * A getter that returns the URL Scheme from the app's Info.plist, used for app redirect calls.
 * Transactions such as Pay by Bank App require a valid URL Scheme to be enabled.
 *
 * @returns a nullable NSString instance containing the URL Scheme name
 */
+ (nullable NSString *)appURLScheme;

@end
