//
//  JPInputField.h
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
#import "JPCardDetails.h"
#import "BillingCountry.h"

@class JPTheme;

@class FloatingTextField, CardLogoView;

@class IssueNumberInputField, CardInputField, DateInputField, BillingCountryInputField, PostCodeInputField, JPInputField;

@protocol JudoPayInputDelegate <NSObject>

- (void)cardInput:(CardInputField *)input didFailWithError:(NSError *)error;

- (void)cardInput:(CardInputField *)input didFindValidNumber:(NSString *)cardNumberString;

- (void)cardInput:(CardInputField *)input didDetectNetwork:(CardNetwork)network;

- (void)dateInput:(DateInputField *)input didFailWithError:(NSError *)error;

- (void)dateInput:(DateInputField *)input didFindValidDate:(NSString *)date;

- (void)issueNumberInputDidEnterCode:(IssueNumberInputField *)input withIssueNumber:(NSString *)issueNumber;

- (void)billingCountryInput:(BillingCountryInputField *)input didSelect:(BillingCountry)billingCountry;

- (void)postCodeInputField:(PostCodeInputField *)input didFailWithError:(NSError *)error;

- (void)judoPayInput:(JPInputField *)input didValidate:(BOOL)valid;

- (void)judoPayInputDidChangeText:(JPInputField *)input;

@end

@interface JPInputField : UIView <UITextFieldDelegate>

@property (nonatomic, strong) FloatingTextField *textField;

@property (nonatomic, strong) JPTheme *theme;

@property (nonatomic, weak) id<JudoPayInputDelegate> delegate;

@property (nonatomic, strong, readonly) NSAttributedString *placeholder;
@property (nonatomic, assign, readonly) BOOL containsLogo;
@property (nonatomic, strong, readonly) CardLogoView *logoView;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, assign, readonly) CGFloat titleWidth;
@property (nonatomic, strong, readonly) NSString *hintLabelText;

@property (nonatomic, assign, readonly) BOOL isValid;

- (instancetype)initWithTheme:(JPTheme *)theme;

- (void)errorAnimation:(BOOL)showRedBlock;

- (void)updateCardLogo;

- (void)dismissError;

- (void)setActive:(BOOL)isActive;

- (void)didChangeInputText;

- (void)textFieldDidChangeValue:(UITextField *)textField;

@end
