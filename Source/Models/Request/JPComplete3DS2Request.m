//
//  JPComplete3DS2Request.m
//  JudoKit_iOS
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

#import "JPComplete3DS2Request.h"

@implementation JPComplete3DS2Request

- (instancetype)initWithVersion:(NSString *)version andSecureCode:(NSString *)code {
    return [self initWithVersion:version secureCode:code andThreeDSSDKChallengeStatus:nil];
}

- (instancetype)initWithVersion:(NSString *)version
                      secureCode:(NSString *)code
    andThreeDSSDKChallengeStatus:(NSString *)threeDSSDKChallengeStatus {
    if (self = [super init]) {
        _version = version;
        _cv2 = code;
        _threeDSSDKChallengeStatus = threeDSSDKChallengeStatus;
    }
    return self;
}

@end
