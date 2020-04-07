//
//  JPConfigurationValidationService.m
//  JudoKitObjC
//
//  Copyright (c) 2019 Alternative Payments Ltd
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

#import "JPConfigurationValidationService.h"

typedef NS_ENUM(NSUInteger, ValidationError) {
    IllegalArgumentError,  // empty is null parameter
    IllegalStateError   // invalid parameter
};

@implementation JPConfigurationValidationServiceImp

- (instancetype)init {
    self = [super init];
    if (self) {
        _validAllCurrencies = @[@"USD", @"CAD", @"EUR", @"GBP"];
    }
    return self;
}

- (BOOL)isTransactionNotValideWithConfiguration:(JPConfiguration *)configuration
                                  completion:(JudoCompletionBlock)completion {
    NSError *error;
    [self checkForValidCurency:configuration.amount.currency error: &error];
    [self checkIfAmountIsnumber:configuration.amount.amount error: &error];
    [self checkForJudoId:configuration error:&error];
    [self checkIfConsumerReferenceIsValid:configuration error:&error];
    
    if (error) { completion(nil, error); }
    
    return error ? true : false;
}

- (BOOL)isAppleTransactionNotValideWithConfiguration:(JPConfiguration *)configuration
                                       completion:(JudoCompletionBlock)completion {
    NSError *error;
    
    [self checkForValidCurency:configuration.applePayConfiguration.currency error:&error];
    [self checkForEmptyMerchantId:configuration.applePayConfiguration.merchantId error:&error];
    [self checkForValidCountryCode:configuration.applePayConfiguration.countryCode error:&error];
    [self checkApplePaymentItems:configuration error:&error];
    [self checkForShippingMethods:configuration error:&error];
    [self checkForAppleConfig:configuration error:&error];
    
    if (error) { completion(nil, error); }
    
    return error ? true : false;
}

- (void)checkApplePaymentItems:(JPConfiguration *)configuration error:(NSError **)error {
    if ([configuration.applePayConfiguration.paymentSummaryItems count] == 0) {
        *error = [NSError errorWithDomain:kJudoErrorDomain
                                   code:IllegalArgumentError
                               userInfo:@{NSLocalizedDescriptionKey : @"Payment items couldn't be empty"}];
    }
}

- (void)checkForShippingMethods:(JPConfiguration *)configuration error:(NSError **)error {
    if ((configuration.applePayConfiguration.requiredShippingContactFields != ContactFieldNone) &&
       ([configuration.applePayConfiguration.shippingMethods count] == 0)) {
        *error = [NSError errorWithDomain:kJudoErrorDomain
                                   code:IllegalArgumentError
                               userInfo:@{NSLocalizedDescriptionKey : @"Specify shipinng methonds"}];
    }
}

- (void)checkForJudoId:(JPConfiguration *)configuration error:(NSError **)error {
    if (![configuration.judoId length]) {
        *error = [NSError errorWithDomain:kJudoErrorDomain
                                    code:IllegalArgumentError
                                userInfo:@{NSLocalizedDescriptionKey : @"JudoId cannot be null or empty"}];
    }
}

- (void)checkForValidCurency:(NSString *)curency error:(NSError **)error {
    if ([curency length] == 0) {
        *error = [NSError errorWithDomain:kJudoErrorDomain
                                    code:IllegalArgumentError
                                userInfo:@{NSLocalizedDescriptionKey : @"Currency cannot be empty"}];
    } else if (![_validAllCurrencies containsObject:curency]) {
        *error = [NSError errorWithDomain:kJudoErrorDomain
                                    code:IllegalStateError
                                userInfo:@{NSLocalizedDescriptionKey : @"Unsuported Currency"}];
    }
}

- (void)checkForEmptyMerchantId:(NSString *)merchantId error:(NSError **)error {
        if ([merchantId length] == 0) {
        *error = [NSError errorWithDomain:kJudoErrorDomain
                                    code:IllegalArgumentError
                                userInfo:@{NSLocalizedDescriptionKey : @"Merchant Id cannot be empty"}];
    }
}

- (void)checkForValidCountryCode:(NSString *)countryCode error:(NSError **)error {
    if ([countryCode length] != 2) {
        *error = [NSError errorWithDomain:kJudoErrorDomain
                                    code:IllegalStateError
                                userInfo:@{NSLocalizedDescriptionKey : @"Country Code is invalid"}];
    }
}

- (void)checkForAppleConfig:(JPConfiguration *)configuration error:(NSError **)error {
    if (!configuration.applePayConfiguration) {
       *error = [NSError errorWithDomain:kJudoErrorDomain
                                    code:IllegalArgumentError
                                userInfo:@{NSLocalizedDescriptionKey : @"Apple Configuration is empty"}];
    }
}

- (void)checkIfAmountIsnumber:(NSString *)amount error:(NSError **)error {
    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
    formater.numberStyle = NSNumberFormatterDecimalStyle;
    if (![formater numberFromString: amount]) {
        *error = [NSError errorWithDomain:kJudoErrorDomain
                                    code:IllegalStateError
                                userInfo:@{NSLocalizedDescriptionKey : @"Amount should be a number"}];
    }
}

- (void)checkIfConsumerReferenceIsValid:(JPConfiguration *)configuration error:(NSError **)error {
    if ([configuration.reference.consumerReference length] > kMaximumLenghtForConsumerReference) {
        *error = [NSError errorWithDomain:kJudoErrorDomain
                                    code:IllegalStateError
                                userInfo:@{NSLocalizedDescriptionKey : @"Consumer Reference is invalied"}];
    }
}

@end
