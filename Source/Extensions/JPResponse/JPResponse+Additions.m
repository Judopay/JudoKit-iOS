//
//  JPResponse+Additions.m
//  JudoKit_iOS
//
//  Copyright © 2016 Alternative Payments Ltd. All rights reserved.
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

#import "JPCReqParameters.h"
#import "JPResponse+Additions.h"
#import "NSString+Additions.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const k3DSTwoMessage = @"Issuer ACS has responded with a Challenge URL";

@implementation JPResponse (Additions)

- (BOOL)isThreeDSecureOneRequired {
    NSString *acsUrl = self.rawData[@"acsUrl"];
    NSString *md = self.rawData[@"md"];
    NSString *paReq = self.rawData[@"paReq"];
    return acsUrl.isNotNullOrEmpty && md.isNotNullOrEmpty && paReq.isNotNullOrEmpty;
}

- (BOOL)isThreeDSecureTwoRequired {
    return self.message.length > 0 && [self.message.lowercaseString isEqualToString:k3DSTwoMessage.lowercaseString];
}

- (JPCReqParameters *)cReqParameters {
    NSString *cReq = self.rawData[@"cReq"];
    return [[JPCReqParameters alloc] initWithString:cReq];
}

@end

NS_ASSUME_NONNULL_END
