//
//  JudoKit.m
//  JudoKitObjC
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

#import "JudoKit.h"

#import "JPSession.h"
#import "JPPayment.h"

@interface JPSession ()

@property (nonatomic, strong, readwrite) NSString *authorizationHeader;

@end

@interface JudoKit ()

@property (nonatomic, strong, readwrite) JPSession *currentAPISession;

@end

@implementation JudoKit

- (instancetype)initWithToken:(NSString *)token secret:(NSString *)secret {
    return [self initWithToken:token secret:secret allowJailbrokenDevices:YES];
}

- (instancetype)initWithToken:(NSString *)token secret:(NSString *)secret allowJailbrokenDevices:(BOOL)jailbrokenDevicesAllowed {
    self = [super init];
    if (self) {
        NSString *plainString = [NSString stringWithFormat:@"%@:%@", token, secret];
        NSData *plainData = [plainString dataUsingEncoding:NSISOLatin1StringEncoding];
        NSString *base64String = [plainData base64EncodedStringWithOptions:0];
        
        self.currentAPISession = [JPSession new];
        
        [self.currentAPISession setAuthorizationHeader:[NSString stringWithFormat:@"Basic %@", base64String]];
    }
    return self;
}

- (JPPayment *)paymentWithJudoId:(NSString *)judoId {
    JPPayment *payment = [JPPayment new];
    payment.judoId = judoId;
    payment.currentAPISession = self.currentAPISession;
    return payment;
}

@end
