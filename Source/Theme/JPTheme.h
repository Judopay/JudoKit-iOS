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

@interface JPTheme : NSObject

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) BOOL avsEnabled;
@property (nonatomic, assign) BOOL showSecurityMessage;

#pragma mark - Buttons

@property (nonatomic, strong) NSString *paymentButtonTitle;
@property (nonatomic, strong) NSString *registerCardButtonTitle;
@property (nonatomic, strong) NSString *registerCardNavBarButtonTitle;
@property (nonatomic, strong) NSString *backButtonTitle;

#pragma mark - Titles

@property (nonatomic, strong) NSString *paymentTitle;
@property (nonatomic, strong) NSString *registerCardTitle;
@property (nonatomic, strong) NSString *refundTitle;
@property (nonatomic, strong) NSString *authenticationTitle;

#pragma mark - Loading

@property (nonatomic, strong) NSString *loadingIndicatorRegisterCardTitle;
@property (nonatomic, strong) NSString *loadingIndicatorProcessingTitle;
@property (nonatomic, strong) NSString *redirecting3DSTitle;
@property (nonatomic, strong) NSString *verifying3DSPaymentTitle;
@property (nonatomic, strong) NSString *verifying3DSRegisterCardTitle;

#pragma mark - Input fields

@property (nonatomic, assign) CGFloat inputFieldHeight;

#pragma mark - Security Message

@property (nonatomic, strong) NSString *securityMessageString;

@property (nonatomic, assign) CGFloat securityMessageTextSize;

#pragma mark - Colors

- (UIColor *)inverseColor;

- (CGFloat)greyScale;

- (BOOL)colorMode;

- (UIColor *)judoDarkGrayColor;
- (UIColor *)judoInputFieldTextColor;
- (UIColor *)judoLightGrayColor;
- (UIColor *)judoInputFieldBorderColor;
- (UIColor *)judoContentViewBackgroundColor;
- (UIColor *)judoButtonColor;
- (UIColor *)judoButtonTitleColor;
- (UIColor *)judoLoadingBackgroundColor;
- (UIColor *)judoRedColor;
- (UIColor *)judoLoadingBlockViewColor;
- (UIColor *)judoInputFieldBackgroundColor;

@end
