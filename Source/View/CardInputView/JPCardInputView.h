//
//  JPCardInputView.h
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

#import "JPTransactionViewModel.h"
#import <UIKit/UIKit.h>

@class JPLoadingButton, JPInputField, JPCardNumberField, JPCardInputField, JPTransactionButton, JPTheme, JPTransactionViewModel, JPCardInputView;

typedef enum JPCardInputViewActionType : NSUInteger {
    JPCardInputViewActionTypeUnknown,
    JPCardInputViewActionTypeCancel,
    JPCardInputViewActionTypeScanCard,
    JPCardInputViewActionTypeSubmit
} JPCardInputViewActionType;

@protocol JPCardInputViewDelegate <NSObject>

@required
- (void)cardInputView:(nonnull JPCardInputView *)inputView didChangeText:(nullable NSString *)text forInputType:(JPInputType)type andEndEditing:(BOOL)endEditing;
- (void)cardInputView:(nonnull JPCardInputView *)inputView didPerformAction:(JPCardInputViewActionType)action;

@end

@interface JPCardInputView : UIView

@property (nonatomic, strong, nullable) id<JPCardInputViewDelegate> delegate;

/**
 * A method used to apply a theme to the view
 *
 * @param theme - the JPTheme object used to configure the user interface
 */
- (void)applyTheme:(nullable JPTheme *)theme;

/**
 * A method that configures the view based on a view model
 *
 * @param viewModel - an instance of JPTransactionViewModel used for view customization
 */
- (void)configureWithViewModel:(nullable JPTransactionViewModel *)viewModel;

- (void)notifyKeyboardWillShow:(BOOL)willShow withNotification:(nonnull NSNotification *)notification;

- (void)moveFocusToInput:(JPInputType)type;

@end
