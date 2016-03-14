//
//  JudoPayView.h
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

#import <UIKit/UIKit.h>

#import "JPTransactionData.h"

@class JP3DSWebView, JPTheme, LoadingView;

@class CardInputField, IssueNumberInputField, DateInputField, SecurityCodeInputField, PostCodeInputField, BillingCountryInputField;

@interface JudoPayView : UIView

@property (nonatomic, strong, readonly) UIScrollView *contentView;

@property (nonatomic, strong, readonly) JP3DSWebView *threeDSWebView;

@property (nonatomic, strong, readonly) LoadingView *loadingView;

@property (nonatomic, strong) JPCardDetails *cardDetails;

@property (nonatomic, strong) JPTheme *theme;

@property (nonatomic, strong, readonly) CardInputField *cardInputField;
@property (nonatomic, strong, readonly) DateInputField *expiryDateInputField;
@property (nonatomic, strong, readonly) SecurityCodeInputField *securityCodeInputField;
@property (nonatomic, strong, readonly) DateInputField *startDateInputField;
@property (nonatomic, strong, readonly) IssueNumberInputField *issueNumberInputField;
@property (nonatomic, strong, readonly) PostCodeInputField *postCodeInputField;
@property (nonatomic, strong, readonly) BillingCountryInputField *billingCountryInputField;

@property (nonatomic, strong, readonly) NSString *transactionTitle;
@property (nonatomic, assign, readonly) TransactionType transactionType;

@property (nonatomic, strong, readonly) UIButton *paymentButton;
@property (nonatomic, strong) UIBarButtonItem *paymentNavBarButton;

- (void)paymentEnabled:(BOOL)enabled;

@end
