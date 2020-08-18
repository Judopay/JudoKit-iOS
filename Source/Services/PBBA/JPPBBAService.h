//
//  JPPBBAService.h
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

#import "JPTransactionStatusView.h"
#import "Typedefs.h"
#import <Foundation/Foundation.h>
#import <ZappMerchantLib/PBBAAppUtils.h>

@class JPConfiguration, JPApiService;

@interface JPPBBAService : NSObject

/**
 * Creates an instance of an JPPBBAService object
 *
 * @param configuration - an instance of JPConfiguration used to configure the PBBA
 * @param apiService - an instance of JPApiService responsible for Judo backend calls
 */
- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration
                                   apiService:(nonnull JPApiService *)apiService;

/**
 * A method used to determine if there are any PBBA supported bank apps installed on the device
 *
 * @returns true - if a bank app has been found, false otherwise
 */
+ (bool)isBankingAppAvailable;

/**
 * Method used for returning a redirect URL based on the PBBA
 *
 * @param completion  A completion block that either returns the redirect URL string or returns an error
 */
- (void)openPBBAMerchantApp:(nonnull JPCompletionBlock)completion;

/**
 * Method used for start polling
 *
 * @param completion  A completion block that either returns the redirect URL string or returns an error
 */
- (void)pollingOrderStatus:(nonnull JPCompletionBlock)completion;

/**
 * A method to display a progress indicator based on a provided transaction status
 *
 * @param status - the transaction status to be displayed
 */
- (void)showStatusViewWith:(JPTransactionStatus)status;

@end
