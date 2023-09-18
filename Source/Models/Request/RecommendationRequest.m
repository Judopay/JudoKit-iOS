//
//  RecommendationRequest.m
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

#import "RecommendationRequest.h"
#import "RecommendationConfiguration.h"
#import "PaymentMethodCipher.h"

static NSString *const kAesKeyCiphertext = @"aesKeyCiphertext";
static NSString *const kAlgorithm = @"algorithm";
static NSString *const kCardCiphertext = @"cardCiphertext";
static NSString *const kKeyIndex = @"keyIndex";
static NSString *const kKeySignature = @"keySignature";
static NSString *const kMethodType = @"methodType";
static NSString *const kRecommendationFeatureProviderSDKVersion = @"ravelinSDKVersion";

@implementation RecommendationRequest

- (nonnull instancetype)initWithEncryptedCardDetails:(nonnull NSDictionary *)encryptedCardDetails {
    if (self = [super init]) {
        
        NSString *aesKeyCiphertext = encryptedCardDetails[kAesKeyCiphertext];
        NSString *algorithm = encryptedCardDetails[kAlgorithm];
        NSString *cardCiphertext = encryptedCardDetails[kCardCiphertext];
        NSString *keyIndex = encryptedCardDetails[kKeyIndex];
        // Todo: What about this keySignature property?
        NSString *keySignature = @"key-signature";
        NSString *methodType = encryptedCardDetails[kMethodType];
        NSString *recommendationFeatureProviderSDKVersion = encryptedCardDetails[kRecommendationFeatureProviderSDKVersion];
        
        PaymentMethodCipher * paymentMethodCipher = [[PaymentMethodCipher alloc] initWithAesKeyCipherText:aesKeyCiphertext
                                                                                                algorithm:algorithm
                                                                                           cardCipherText:cardCiphertext
                                                                                                 keyIndex:keyIndex
                                                                                             keySignature:keySignature
                                                                                               methodType:methodType
                                                                  recommendationFeatureProviderSDKVersion:recommendationFeatureProviderSDKVersion];
        RecommendationPaymentMethod * recommendationPaymentMethod = [[RecommendationPaymentMethod alloc] initWithPaymentMethodCipher:paymentMethodCipher];
        _paymentMethod = recommendationPaymentMethod;
    }
    return self;
}

@end
