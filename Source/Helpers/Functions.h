//
//  Functions.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JPSubProductInfo;

@interface JPQueryStringPair : NSObject

@property (readwrite, nonatomic, strong, nonnull) NSString *field;
@property (readwrite, nonatomic, strong, nullable) NSString *value;

- (instancetype)initWithField:(NSString *)field value:(NSString *)value;
- (NSString *)URLEncodedValue;

@end

NSString *RFC3986PercentEscapedStringFromString(NSString *string);
NSString *queryParameters(NSArray<JPQueryStringPair *> *parameters);

/**
 * A method which returns the width aspect ratio (compared to an iPhone XR)
 */
double getWidthAspectRatio(void);

/**
 * A method which returns general information about the platform and operating system the app runs on
 */
NSString *getUserAgent(JPSubProductInfo *_Nullable subProductInfo);

/**
 * A method which returns the IP address of the device
 */
NSString *getIPAddress(void);

NSString *generateBasicAuthHeader(NSString *token, NSString *secret);

NSString *getSafeStringRepresentation(id object);

NS_ASSUME_NONNULL_END
