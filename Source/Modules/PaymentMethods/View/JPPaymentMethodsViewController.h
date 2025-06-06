//
//  JPPaymentMethodsViewController.h
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

#import "JPApplePayController.h"
#import "JPPaymentMethodsCardListHeaderCellDelegate.h"
#import "JPSectionViewDelegate.h"
#import <UIKit/UIKit.h>

@protocol JPPaymentMethodsPresenter;
@class JPPaymentMethodsViewModel, JPConfiguration;

#pragma mark - JPPaymentMethodsView

@protocol JPPaymentMethodsView

/**
 * A method that configures the view based on a passed view model
 *
 * @param viewModel - a view model detailing the layout details
 * @param shouldAnimate - if set to NO, will prompt the table view to reloadData instead of animating insertions/deletions
 */
- (void)configureWithViewModel:(nonnull JPPaymentMethodsViewModel *)viewModel
           shouldAnimateChange:(BOOL)shouldAnimate;

/**
 * Convenience method for displaying alert controllers based on a specified error with an optional title
 *
 * @param title - an optional NSString that defines the title of the alert
 * @param error - an NSError instance describing the current error
 */
- (void)_jp_displayAlertWithTitle:(nullable NSString *)title
                         andError:(nonnull NSError *)error;

/**
 * A method that is used to present the Apple Pay sheet while providing a block for handling authorization responses.
 *
 * @param authorizationBlock - a block used to capture the Apple Pay authorization PKPayment object
 * @param didFinishBlock - a completion block called after the PKPaymentAuthorizationViewController did finish.
 */
- (void)presentApplePayWithAuthorizationBlock:(nonnull JPApplePayAuthorizationBlock)authorizationBlock
                               didFinishBlock:(nonnull JPApplePayDidFinishBlock)didFinishBlock;

- (void)setIsPaymentInProgress:(BOOL)isCardPaymentInProgress;
- (void)endEditingCardListIfNeeded;

@end

#pragma mark - JPPaymentMethodsViewController

@interface JPPaymentMethodsViewController : UIViewController <JPPaymentMethodsView>

/**
 * A reference to the JPConfiguration instance responsible for customizing the user interface and setting Apple Pay
 */
@property (nonatomic, strong) JPConfiguration *_Nullable configuration;

/**
 * A strong reference to a presenter object that adopts the JPTransactionPresenter protocol
 */
@property (nonatomic, strong) id<JPPaymentMethodsPresenter> _Nonnull presenter;

@end

/**
 * A JPPaymentMethodsViewController extension for implementing the table view data source methods
 */
@interface JPPaymentMethodsViewController (TableViewDataSource) <UITableViewDataSource>
@end

/**
 * A JPPaymentMethodsViewController extension for implementing the table view delegate methods
 */
@interface JPPaymentMethodsViewController (TableViewDelegate) <UITableViewDelegate>
@end

/**
 * A JPPaymentMethodsViewController extension that adopts the Header View delegate methods
 */
@interface JPPaymentMethodsViewController (EditCardsDelegate) <JPPaymentMethodsCardListHeaderCellDelegate>
@end

/**
 * A JPPaymentMethodsViewController extension that adopts the JPSectionView delegate methods
 */
@interface JPPaymentMethodsViewController (JPSectionViewDelegate) <JPSectionViewDelegate>
@end
