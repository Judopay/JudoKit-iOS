//
//  RavelinCardEncryptionService.m
//  JudoKit_iOS
//
//  Copyright (c) 2022 Alternative Payments Ltd
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
#import "RavelinCardEncryptionService.h"
#import "JPCardTransactionTypedefs.h"

@implementation RavelinCardEncryptionService

- (instancetype)init {
    self = [super init];
    if (self) {
        // Perform any setup or initialization here for the no-argument constructor
    }
    return self;
}

- (BOOL)isCardEncryptionRequiredWithType:(JPCardTransactionType)type
            isRavelinEncryptionEnabled:(BOOL)isRavelinEncryptionEnabled {
    return isRavelinEncryptionEnabled && (
        type == JPCardTransactionTypePayment ||
        type == JPCardTransactionTypeCheck ||
        type == JPCardTransactionTypePreAuth
    );
}

- (BOOL)performCardEncryptionWithCardNumber:(NSString *)cardNumber {
    
//    RVNEncryption *ravelin = [RVNEncryption sharedInstance];
//    self.ravelinEncrypt.rsaKey = @"----|----";
    
    return true;
}

//- (EncryptedCard *)performCardEncryptionWithCardNumber:(NSString *)cardNumber
//                                      cardHolderName:(NSString *)cardHolderName
//                                     expirationDate:(NSString *)expirationDate
//                                              rsaKey:(NSString *)rsaKey {
//    NSString *expiryMonth = [expirationDate substringWithRange:NSMakeRange(0, 2)];
//    NSString *expiryYear = [expirationDate substringWithRange:NSMakeRange(3, 2)];
//
//    CardDetails *cardDetails = [[CardDetails alloc] initWithCardNumber:cardNumber
//                                                           expiryMonth:expiryMonth
//                                                            expiryYear:expiryYear
//                                                       cardHolderName:cardHolderName];
//
//    return [[RavelinEncrypt new] encryptCard:cardDetails rsaKey:rsaKey];
//}


@end
