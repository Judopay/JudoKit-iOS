//
//  JPSessionConfiguration.m
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

#import "JPSessionConfiguration.h"
#import "JPAuthorization.h"

static NSString *const kJudoBaseURL = @"https://api.judopay.com/";
static NSString *const kJudoSandboxBaseURL = @"https://api-sandbox.judopay.com/";

@implementation JPSessionConfiguration

#pragma mark - Initializers

- (instancetype)initWithAuthorization:(id<JPAuthorization>)authorization {
    self = [super init];
    if (self) {
        self.authorization = authorization;
        self.isSandboxed = NO;
    }

    return self;
}

+ (instancetype)configurationWithAuthorization:(id<JPAuthorization>)authorization {
    return [[JPSessionConfiguration alloc] initWithAuthorization:authorization];
}

#pragma mark - Getters

- (NSURL *)apiBaseURL {
    NSString *url = kJudoBaseURL;

    if (self.isSandboxed) {
        url = kJudoSandboxBaseURL;
    }

    return [NSURL URLWithString:url];
}

@end
