//
//  JP3DSConfiguration.h
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

#import "JP3DSConfiguration.h"
#import "JPResponse.h"

@implementation JP3DSConfiguration

+ (instancetype)configurationWithError:(NSError *)error {
    return [[JP3DSConfiguration alloc] initWithError:error];
}

- (instancetype)initWithError:(NSError *)error {
    if (self = [super init]) {
        NSDictionary *payload = error.userInfo;
        _mdValue = payload[@"md"];
        _paReqValue = payload[@"paReq"];
        _receiptId = payload[@"receiptId"];
        _acsURL = [NSURL URLWithString:payload[@"acsUrl"]];
    }
    return self;
}

+ (instancetype)configurationWithResponse:(JPResponse *)response {
    return [[JP3DSConfiguration alloc] initWithResponse:response];
}

- (instancetype)initWithResponse:(JPResponse *)response {
    if (self = [super init]) {
        _mdValue = response.rawData[@"md"];
        _paReqValue = response.rawData[@"paReq"];
        _receiptId = response.rawData[@"receiptId"];
        NSString *acsUrl = response.rawData[@"acsUrl"];
        if (acsUrl) {
            _acsURL = [NSURL URLWithString:acsUrl];
        }
    }
    return self;
}

@end
