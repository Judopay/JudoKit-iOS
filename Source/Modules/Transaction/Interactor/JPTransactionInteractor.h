//
//  JPTransactionInteractor.h
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

#import "JPSession.h"
#import "JPTransaction.h"
#import "JPValidationResult.h"

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@class JPCard, JPConfiguration, JPCardValidationService, JPTransactionService;
@class JPTransactionViewModel;

@protocol JPTransactionInteractor

/**
 *  A method for checking if AVS is enabled
 *
 *  @return YES if the merchant has set AVS as enabled and NO if otherwise
 */
- (BOOL)isAVSEnabled;


- (TransactionType)transactionType;


- (void)handleCameraPermissionsWithCompletion:(void (^)(AVAuthorizationStatus))completion;

- (NSArray<NSString *> *)getSelectableCountryNames;

- (JPValidationResult *)validateCardNumberInput:(NSString *)input;
- (JPValidationResult *)validateCardholderNameInput:(NSString *)input;
- (JPValidationResult *)validateExpiryDateInput:(NSString *)input;
- (JPValidationResult *)validateSecureCodeInput:(NSString *)input;
- (JPValidationResult *)validateCountryInput:(NSString *)input;
- (JPValidationResult *)validatePostalCodeInput:(NSString *)input;

- (void)sendTransactionWithCard:(JPCard *)card
              completionHandler:(JudoCompletionBlock)completionHandler;

- (void)updateKeychainWithCardModel:(JPTransactionViewModel *)viewModel
                           andToken:(NSString *)token;

@end

@interface JPTransactionInteractorImpl : NSObject <JPTransactionInteractor>

- (instancetype)initWithCardValidationService:(JPCardValidationService *)cardValidationService
                           transactionService:(JPTransactionService *)transactionService
                                configuration:(JPConfiguration *)configuration
                                   completion:(JudoCompletionBlock)completion;
@end
