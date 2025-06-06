//
//  JPTransactionInteractor.h
//  JudoKit_iOS
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

#import "Typedefs.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JPCard, JPConfiguration, JPCardValidationService, JPTransactionViewModel, JPValidationResult, JPError, JPResponse, JPAddress, JPCardTransactionService, JPTheme, JPCountry, JPCardTransactionDetails;

typedef NS_ENUM(NSUInteger, JPPresentationMode);
typedef NS_ENUM(NSUInteger, JPTransactionType);
typedef NS_OPTIONS(NSUInteger, JPCardNetworkType);

@protocol JPTransactionInteractor

/**
 * A method that returns JPPresentationMode
 */
- (JPPresentationMode)presentationMode;

/**
 * A method that returns JPTheme from UI Configuration
 */
- (JPTheme *)getConfiguredTheme;

/**
 * A method that returns the current transaction type
 */
- (JPTransactionType)transactionType;

/**
 * A method that returns the current cardNetwork type
 */
- (JPCardNetworkType)cardNetworkType;

- (nullable JPCardTransactionDetails *)getConfiguredCardTransactionDetails;

/**
 * A method that handles the camera permission for the Scan Card functionality
 *
 * @param completion - the AVAuthorizationStatus which returns the camera permission status
 */
- (void)handleCameraPermissionsWithCompletion:(void (^)(AVAuthorizationStatus))completion;

/**
 * A method which returns the countries which the user can select in the country picker
 */
- (NSArray<JPCountry *> *)getFilteredCountriesBySearchString:(nullable NSString *)searchString;

/**
 * A method for returning merchant-set card address details
 */
- (JPAddress *)getConfiguredCardAddress;

/**
 * A method for returning the transaction response / error to the merchant
 *
 * @param response - the JPResponse returned from the transaction
 * @param error - the JPError returned from the transaction
 */
- (void)completeTransactionWithResponse:(nullable JPResponse *)response
                                  error:(nullable JPError *)error;

/**
 * A method that stores the errors returned from the Judo API to be sent back to the merchant once the user cancels the payment.
 *
 * @param error - an instance of NSError that describes the error
 */
- (void)storeError:(NSError *)error;

/**
 * A method for resetting the card validation results
 */
- (void)resetCardValidationResults;

/**
 * A method for validating the card number
 *
 * @param input - the input card number string
 *
 * @returns a JPValidationResult with the validation status details
 */
- (JPValidationResult *)validateCardNumberInput:(NSString *)input;

/**
 * A method for validating the cardholder name
 *
 * @param input - the input cardholder name string
 *
 * @returns a JPValidationResult with the validation status details
 */
- (JPValidationResult *)validateCardholderNameInput:(NSString *)input;

/**
 * A method for validating the expiry date
 *
 * @param input - the input expiry date string
 *
 * @returns a JPValidationResult with the validation status details
 */
- (JPValidationResult *)validateExpiryDateInput:(NSString *)input;

/**
 * A method for validating the secure code
 *
 * @param input - the input secure code string
 *
 * @returns a JPValidationResult with the validation status details
 */
- (JPValidationResult *)validateSecureCodeInput:(NSString *)input trimIfTooLong:(BOOL)trim;

/**
 * A method for validating the country
 *
 * @param input - the input country string
 *
 * @returns a JPValidationResult with the validation status details
 */
- (JPValidationResult *)validateCountryInput:(NSString *)input;

/**
 * A method for validating the post code number
 *
 * @param input - the input post code number string
 *
 * @returns a JPValidationResult with the validation status details
 */
- (JPValidationResult *)validatePostalCodeInput:(NSString *)input;

- (JPValidationResult *)validateBillingEmailInput:(NSString *)input;
- (JPValidationResult *)validateBillingCountryInput:(NSString *)input;
- (JPValidationResult *)validateBillingAdministrativeDivisionInput:(NSString *)input;
- (JPValidationResult *)validateBillingPhoneCodeInput:(NSString *)input;
- (JPValidationResult *)validateBillingPhoneInput:(NSString *)input;
- (JPValidationResult *)validateBillingAddressLineInput:(NSString *)input;
- (JPValidationResult *)validateBillingCity:(NSString *)input;
- (JPValidationResult *)validateBillingPostalCodeInput:(NSString *)input;

- (void)sendTransactionWithDetails:(JPCardTransactionDetails *)details
                 completionHandler:(JPCompletionBlock)completionHandler;

- (void)sendTokenTransactionWithDetails:(JPCardTransactionDetails *)details
                      completionHandler:(JPCompletionBlock)completionHandler;

/**
 * A method for generating pay button title
 */
- (NSString *)generatePayButtonTitle;

- (JPConfiguration *)configuration;

@end

@interface JPTransactionInteractorImpl : NSObject <JPTransactionInteractor>

/**
 * Designated initializer which creates a configured JPTransactionInteractorImpl instance
 *
 * @param cardValidationService - the service which is used to validate card details
 * @param transactionService - the service which sends requests to the Judo backend and handles 3DS checks
 * @param type - the transaction type
 * @param mode - the card details mode
 * @param configuration - the JPConfiguration object used for customizing the payment flow
 * @param details - the card details
 * @param completion - the completion block with an optional JPResponse / NSError
 */
- (instancetype)initWithCardValidationService:(JPCardValidationService *)cardValidationService
                           transactionService:(JPCardTransactionService *)transactionService
                              transactionType:(JPTransactionType)type
                             presentationMode:(JPPresentationMode)mode
                                configuration:(JPConfiguration *)configuration
                           transactionDetails:(nullable JPCardTransactionDetails *)details
                                   completion:(JPCompletionBlock)completion;
@end

NS_ASSUME_NONNULL_END
