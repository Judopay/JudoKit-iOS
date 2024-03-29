//
//  JPTransactionViewController.h
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

#import "JPInputFieldDelegate.h"
#import "JPInputType.h"
#import "JPTransactionViewModel.h"
#import <UIKit/UIKit.h>

@protocol JPTransactionPresenter;
@class JPTheme, JPTransactionViewModel;

#pragma mark - JPTransactionView

@protocol JPTransactionView

/**
 * A method that updates the view based on the provided view model
 */
- (void)updateViewWithViewModel:(nonnull JPTransactionViewModel *)viewModel;

/**
 * A method that sets the view theme
 */
- (void)applyConfiguredTheme:(nonnull JPTheme *)theme;

/**
 * A method that updates the view with an error
 */
- (void)updateViewWithError:(nonnull NSError *)error;

/**
 * A method that triggers an UIAlertViewController with the option of navigating to Settings
 */
- (void)displayCameraPermissionsAlert;

/**
 * A method that triggers an UIAlertViewController with the restricted camera message
 */
- (void)displayCameraRestrictionAlert;

/**
 * A method that triggers an UIAlertViewController with the camera denied message due to simulator usage
 */
- (void)displayCameraSimulatorAlert;

- (void)moveFocusToInput:(JPInputType)type;

@end

#pragma mark - JPTransactionViewController

@interface JPTransactionViewController : UIViewController <JPTransactionView>

/**
 * A strong reference to a presenter object that adopts the JPTransactionPresenter protocol
 */
@property (nonatomic, strong) id<JPTransactionPresenter> _Nonnull presenter;

@end
