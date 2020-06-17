//
//  JPBrowser.h
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

#import "JPDictionaryConvertible.h"
#import <UIKit/UIKit.h>

@interface JPBrowser : NSObject <JPDictionaryConvertible>

/**
 * An instance of NSString describing the accepted header
 */
@property (nonatomic, strong, readonly) NSString *_Nullable acceptHeader;

/**
 * An instance of NSTimeZone describing the time zone
 */
@property (nonatomic, strong, readonly) NSTimeZone *_Nullable timeZone;

/**
 * An instance of NSString describing the user agent
 */
@property (nonatomic, strong, readonly) NSString *_Nullable userAgent;

/**
 * An instance of NSString describing the language
 */
@property (nonatomic, strong, readonly) NSString *_Nullable language;

/**
 * An instance of NSString describing if the browser has Java enabled
 */
@property (nonatomic, strong, readonly) NSString *_Nullable javaEnabled;

/**
 * An instance of NSString describing if the browser has Javascript enabled
 */
@property (nonatomic, strong, readonly) NSString *_Nullable javascriptEnabled;

/**
 * An instance of NSString describing the color depth of the device
 */
@property (nonatomic, strong, readonly) NSString *_Nullable colorDepth;

/**
 * An instance of CGSize describing the screen size of the device
 */
@property (nonatomic, readonly) CGSize screenSize;

@end
