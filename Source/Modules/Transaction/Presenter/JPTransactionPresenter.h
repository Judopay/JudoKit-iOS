//
//  JPTransactionPresenter.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JPTransactionView;
@protocol JPTransactionRouter;
@protocol JPTransactionInteractor;
typedef NS_ENUM(NSUInteger, JPInputType);

@protocol JPTransactionPresenter

/**
 * A method that is called when the view initially loads to prepare the initial view model
 */
- (void)onViewDidLoad;

/**
 * A method that updates the view model whenever a input field value changes
 */
- (void)handleInputChange:(NSString *)input
                  forType:(JPInputType)type
                showError:(BOOL)showError;

/**
 * A method that handles the Pay Now button tap
 */
- (void)handleSubmitButtonTap;

/**
 * A method that handles Scan Card button tap
 */
- (void)handleScanCardButtonTap;

/**
 * A method that handles Cancel button tap
 */
- (void)handleCancelButtonTap;

/**
 * A method used to notify the JPTransactionPresenter that the card scan returned valid card details
 *
 * @param cardNumber - the detected card number
 * @param expiryDate - the detected card expiration date
 */
- (void)updateViewModelWithCardNumber:(NSString *)cardNumber
                        andExpiryDate:(nullable NSString *)expiryDate;

@end

@interface JPTransactionPresenterImpl : NSObject <JPTransactionPresenter>

/**
 * A weak reference to the view that adops the  JPTransactionView protocol
 */
@property (nonatomic, weak, nullable) id<JPTransactionView> view;

/**
 * A strong reference to the interactor that adops the  JPTransactionInteractor protocol
 */
@property (nonatomic, strong) id<JPTransactionInteractor> interactor;

/**
 * A strong reference to the router that adops the  JPTransactionRouter protocol
 */
@property (nonatomic, strong) id<JPTransactionRouter> router;

@end

NS_ASSUME_NONNULL_END
