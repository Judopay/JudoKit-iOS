//
//  JP3DSConfiguration.h
//  JudoKitObjC
//
//  Copyright (c) 2020 Alternative Payments Ltd
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

@interface JP3DSConfiguration : NSObject

/**
 * The PaReq value obtained from the NSError's payload
 */
@property (nonatomic, strong, readonly) NSString *_Nonnull paReqValue;

/**
 * The MD value obtained from the NSError's payload
 */
@property (nonatomic, strong, readonly) NSString *_Nonnull mdValue;

/**
 * The Receipt ID obtained from the NSError's payload
 */
@property (nonatomic, strong, readonly) NSString *_Nonnull receiptId;

/**
 * The ACS URL obtained from the NSError's payload
 */
@property (nonatomic, strong, readonly) NSURL *_Nonnull acsURL;

/**
 * Designated initializer that creates a configured instance of JP3DSConfiguration based on a 3D Secure NSError
 *
 * @param error - an instance of a 3D Secure NSError
 * @returns - a configured instance of JP3DSConfiguration
 */
+ (nonnull instancetype)configurationWithError:(nonnull NSError *)error;

/**
 * Designated initializer that creates a configured instance of JP3DSConfiguration based on a 3D Secure NSError
 *
 * @param error - an instance of a 3D Secure NSError
 * @returns - a configured instance of JP3DSConfiguration
 */
- (nonnull instancetype)initWithError:(nonnull NSError *)error;

@end
