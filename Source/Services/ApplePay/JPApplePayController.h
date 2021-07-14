//
//  JPApplePayController.h
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

#import "JPApplePayTypedefs.h"
#import <UIKit/UIKit.h>

@class JPConfiguration;

@class JPConfiguration, JPApplePayController;

@interface JPApplePayController : NSObject <PKPaymentAuthorizationViewControllerDelegate>

/**
 * Designated initalizer that creates a configured instance of JPApplePayController for making Apple Pay transactions.
 *
 * @param configuration - an instance of JPConfiguration used to configure the Apple Pay flow.
 *
 * @returns - a configured instance of JPApplePayController.
 */
- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration;

/**
 * A method that returns a configured Apple Pay UIViewController instance that can be presented to complete
 * Apple Pay transactions.
 *
 * @param authorizationBlock - a block that is called when Apple Pay authorizes the payment.
 * @param didFinishBlock - a completion block called after the PKPaymentAuthorizationViewController did finish.
 *
 * @returns a fully configured UIViewController instance
 */
- (nullable UIViewController *)applePayViewControllerWithAuthorizationBlock:(JPApplePayAuthorizationBlock _Nonnull)authorizationBlock
                                                             didFinishBlock:(JPApplePayDidFinishBlock _Nonnull)didFinishBlock;

@end
