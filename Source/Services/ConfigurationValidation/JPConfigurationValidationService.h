//
//  JPConfigurationValidationService.h
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

#import "JPTransactionType.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JPValidationError) {
    JPValidationErrorMissingParameter,
    JPValidationErrorInvalidParameter
};

@class JPError, JPConfiguration;

@protocol JPConfigurationValidationService

/**
 * A method that validates the configuration and returns an optional JPError if the configuration fails
 *
 * @param configuration - an instance of JPConfiguration that contains all the payment configuration properties
 * @param transactionType - the transaction type used to apply the correct validation rules
 *
 * @returns an optional instance of JPError containing the validation error details
 */
- (JPError *)validateConfiguration:(JPConfiguration *)configuration
                forTransactionType:(JPTransactionType)transactionType;

/**
 * A method that validates the Apple Pay configuration and returns an optional JPError if the configuration fails
 *
 * @param configuration - an instance of JPConfiguration that contains all the payment configuration properties
 *
 * @returns an optional instance of JPError containing the validation error details
 */
- (JPError *)validateApplePayConfiguration:(JPConfiguration *)configuration;

@end

/**
 * A class that implements the JPConfigurationValidationService protocol
 */
@interface JPConfigurationValidationServiceImp : NSObject <JPConfigurationValidationService>

@end
