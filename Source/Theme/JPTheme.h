//
//  JPTheme.h
//  JudoKitObjC
//
//  Copyright (c) 2016 Alternative Payments Ltd
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

@import UIKit;

/**
 *  A class which can be used to easily customize the SDKs view
 */
@interface JPTheme : NSObject

/**
 *  An array of accepted card networks
 */
@property (nonatomic, strong) NSArray *acceptedCardNetworks;

/**
 *  A tint color that is used to generate a theme for the judo payment form
 */
@property (nonatomic, strong) UIColor *tintColor;

/**
 *  Set the address verification service to true to prompt the user to input his country and post code information
 */
@property (nonatomic, assign) BOOL avsEnabled;

/**
 *  a boolean indicating whether a security message should be shown below the input
 */
@property (nonatomic, assign) BOOL showSecurityMessage;

#pragma mark - Buttons

/**
 *  the title for the payment button
 */
@property (nonatomic, strong) NSString *paymentButtonTitle;

/**
 *  the title for the button when registering a card
 */
@property (nonatomic, strong) NSString *registerCardButtonTitle;

/**
 *  the title for the back button of the navigation controller
 */
@property (nonatomic, strong) NSString *registerCardNavBarButtonTitle;

/**
 *  the title for the back button
 */
@property (nonatomic, strong) NSString *backButtonTitle;

#pragma mark - Titles

/**
 *  the title for a payment
 */
@property (nonatomic, strong) NSString *paymentTitle;

/**
 *  the title for a card registration
 */
@property (nonatomic, strong) NSString *registerCardTitle;

/**
 *  the title for a refund
 */
@property (nonatomic, strong) NSString *refundTitle;

/**
 *  the title for an authentication
 */
@property (nonatomic, strong) NSString *authenticationTitle;

#pragma mark - Loading

/**
 *  when a register card transaction is currently running
 */
@property (nonatomic, strong) NSString *loadingIndicatorRegisterCardTitle;

/**
 *  the title of the loading indicator during a transaction
 */
@property (nonatomic, strong) NSString *loadingIndicatorProcessingTitle;

/**
 *  the title of the loading indicator during a redirect to a 3DS webview
 */
@property (nonatomic, strong) NSString *redirecting3DSTitle;

/**
 *  the title of the loading indicator during the verification of the transaction
 */
@property (nonatomic, strong) NSString *verifying3DSPaymentTitle;

/**
 *  the title of the loading indicator during the verification of the card registration
 */
@property (nonatomic, strong) NSString *verifying3DSRegisterCardTitle;

#pragma mark - Input fields

/**
 *  the height of the input fields
 */
@property (nonatomic, assign) CGFloat inputFieldHeight;

#pragma mark - Security Message

/**
 *  the message that is shown below the input fields the ensure safety when entering card information
 */
@property (nonatomic, strong) NSString *securityMessageString;

/**
 *  the text size of the security message
 */
@property (nonatomic, assign) CGFloat securityMessageTextSize;

#pragma mark - Colors

/**
 *  Dark gray color
 *
 *  @return A UIColor object
 */
- (UIColor *)judoDarkGrayColor;

/**
 *  Dark gray color
 *
 *  @return A UIColor object
 */
- (UIColor *)judoInputFieldTextColor;

/**
 *  Light gray color
 *
 *  @return A UIColor object
 */
- (UIColor *)judoLightGrayColor;

/**
 *  Light gray color
 *
 *  @return A UIColor object
 */
- (UIColor *)judoInputFieldBorderColor;

/**
 *  Gray color
 *
 *  @return A UIColor object
 */
- (UIColor *)judoContentViewBackgroundColor;

/**
 *  Button color
 *
 *  @return A UIColor object
 */
- (UIColor *)judoButtonColor;

/**
 *  Button title color
 *
 *  @return A UIColor object
 */
- (UIColor *)judoButtonTitleColor;

/**
 *  Background color of the loadingView
 *
 *  @return A UIColor object
 */
- (UIColor *)judoLoadingBackgroundColor;

/**
 *  Red color
 *
 *  @return A UIColor object
 */
- (UIColor *)judoRedColor;

/**
 *  Loading block color
 *
 *  @return A UIColor object
 */
- (UIColor *)judoLoadingBlockViewColor;

/**
 *  Input field background color
 *
 *  @return A UIColor object
 */
- (UIColor *)judoInputFieldBackgroundColor;

@end
