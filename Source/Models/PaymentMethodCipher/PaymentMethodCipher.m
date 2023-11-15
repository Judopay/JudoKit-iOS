//
//  PaymentMethodCipher.m
//  JudoKit_iOS
//
//  Copyright (c) 2023 Alternative Payments Ltd
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

#import "PaymentMethodCipher.h"

@implementation PaymentMethodCipher

- (instancetype)initWithAesKeyCipherText:(NSString *)aesKeyCipherText
                                  algorithm:(NSString *)algorithm
                             cardCipherText:(NSString *)cardCipherText
                                   keyIndex:(NSString *)keyIndex
                               keySignature:(NSString *)keySignature
                                 methodType:(NSString *)methodType
    recommendationFeatureProviderSDKVersion:(NSString *)recommendationFeatureProviderSDKVersion {

    if (self = [super init]) {
        self.aesKeyCipherText = aesKeyCipherText;
        self.algorithm = algorithm;
        self.cardCipherText = cardCipherText;
        self.keyIndex = keyIndex;
        self.keySignature = keySignature;
        self.methodType = methodType;
        self.ravelinSDKVersion = recommendationFeatureProviderSDKVersion;
    }

    return self;
}

@end
