//
//  RecommendationCardEncryptionService.m
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

#import <Foundation/Foundation.h>
#import <RavelinEncrypt/RavelinEncrypt.h>
#import "RecommendationCardEncryptionService.h"
#import "JPCardTransactionTypedefs.h"

@implementation RecommendationCardEncryptionService

- (instancetype)init {
    self = [super init];
    if (self) {}
    return self;
}

- (BOOL)isCardEncryptionRequiredWithType:(JPCardTransactionType)type
            isRecommendationFeatureEnabled:(BOOL)isRecommendationFeatureEnabled {
    return isRecommendationFeatureEnabled && (
        type == JPCardTransactionTypePayment ||
        type == JPCardTransactionTypeCheck ||
        type == JPCardTransactionTypePreAuth
    );
}

- (NSDictionary *)performCardEncryptionWithCardNumber:(NSString *)cardNumber
                                      cardHolderName:(NSString *)cardHolderName
                                     expirationDate:(NSString *)expirationDate
                                              rsaKey:(NSString *)rsaKey {
    NSString *expiryMonth = [expirationDate substringWithRange:NSMakeRange(0, 2)];
    NSString *expiryYear = [expirationDate substringWithRange:NSMakeRange(3, 2)];
    
    RVNEncryption *ravelin = [RVNEncryption sharedInstance];
    ravelin.rsaKey = rsaKey;
    
    NSError *error;
    NSDictionary *encryptionPayload = [[RVNEncryption sharedInstance] encrypt:cardNumber month:expiryMonth year:expiryYear nameOnCard:cardHolderName error:&error];
    if(!error) {
        NSLog(@"Ravelin encryption payload: %@",encryptionPayload);
        return encryptionPayload;
    } else {
        NSLog(@"Ravelin encryption error %@", error.localizedDescription);
        return nil;
    }
}

@end
