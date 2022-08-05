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

@class JPLoadingButton, JPInputField, JPCardNumberField, JPCardInputField, JPTransactionButton, JPTheme, JPTransactionViewModel;

@interface JPCardInputView : UIView

@property (nonatomic, strong) UIScrollView *_Nullable scrollView;
/**
 * The dimmed, semi-transparent background view that fades in when the add card slider appears
 */
@property (nonatomic, strong) UIView *_Nullable backgroundView;

/**
 * The cancel button that, when pressed, dismisses the Add Card view controller
 */
@property (nonatomic, strong) UIButton *_Nullable cancelButton;

/**
 * The add address line button that, when pressed, adds a new address line
 */
@property (nonatomic, strong) UIButton *_Nullable addAddressLineButton;

/**
 * A button that, when pressed, invokes the card scanning functionality
 */
@property (nonatomic, strong) UIButton *_Nullable scanCardButton;

/**
 * The input field for adding the card number
 */
@property (nonatomic, strong) JPCardNumberField *_Nullable cardNumberTextField;

/**
 * The input field for adding the cardholder name
 */
@property (nonatomic, strong) JPCardInputField *_Nullable cardHolderTextField;

/**
 * The input field for adding the cardholder email
 */
@property (nonatomic, strong) JPCardInputField *_Nullable cardHolderEmailTextField;

/**
 * The input field for adding the cardholder phone code
 */
@property (nonatomic, strong) JPCardInputField *_Nullable cardHolderPhoneCodeTextField;

/**
 * The input field for adding the cardholder adress line 1
 */
@property (nonatomic, strong) JPCardInputField *_Nullable cardHolderAddressLine1TextField;

/**
 * The input field for adding the cardholder adress line 2
 */
@property (nonatomic, strong) JPCardInputField *_Nullable cardHolderAddressLine2TextField;

/**
 * The input field for adding the cardholder adress line 3
 */
@property (nonatomic, strong) JPCardInputField *_Nullable cardHolderAddressLine3TextField;

/**
 * The input field for adding the cardholder phone number
 */
@property (nonatomic, strong) JPCardInputField *_Nullable cardHolderPhoneTextField;

/**
 * The input field for adding the cardholder city name
 */
@property (nonatomic, strong) JPCardInputField *_Nullable cardHolderCityTextField;

/**
 * The input field for adding the card expiration date
 */
@property (nonatomic, strong) JPCardInputField *_Nullable cardExpiryTextField;

/**
 * The input field for adding the card secure code
 */
@property (nonatomic, strong) JPCardInputField *_Nullable secureCodeTextField;

/**
 * The input field for selecting the country
 */
@property (nonatomic, strong) JPCardInputField *_Nullable countryTextField;

/**
 * The picker view associated to the country input field;
 */
@property (nonatomic, strong) UIPickerView *_Nullable countryPickerView;

/**
 * The input field for adding the postal code
 */
@property (nonatomic, strong) JPCardInputField *_Nullable postcodeTextField;

/**
 * The Add Card button that, when tapped, displays a loading spinner
 */
@property (nonatomic, strong) JPTransactionButton *_Nullable addCardButton;

/**
 * The Back button that, when tapped, displays card details view
 */
@property (nonatomic, strong) JPTransactionButton *_Nullable backButton;

/**
 * The Add Card view's bottom constraint that is used to move the view when the keyboard animates
 */
@property (nonatomic, strong) NSLayoutConstraint *_Nullable bottomSliderConstraint;

/**
 * A method used to apply a theme to the view
 *
 * @param theme - the JPTheme object used to configure the user interface
 */
- (void)applyTheme:(JPTheme *_Nullable)theme;

/**
 * A method that configures the view based on a view model
 *
 * @param viewModel - an instance of JPTransactionViewModel used for view customization
 */
- (void)configureWithViewModel:(JPTransactionViewModel *_Nullable)viewModel;

/**
 * A method that specifies if the user inteface should be enabled
 *
 * @param shouldEnable - set to YES if the interface is enabled and no if otherwise
 */
- (void)enableUserInterface:(BOOL)shouldEnable;

/**
 * A method that adjusts view top space
 *
 */
- (void)adjustTopSpace;

@end
