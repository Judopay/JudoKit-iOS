//
//  JPTransactionViewController.m
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

#import "JPTransactionViewController.h"
#import "JPCardDetailsMode.h"
#import "JPCardInputField.h"
#import "JPCardInputView.h"
#import "JPCardNumberField.h"
#import "JPCountry.h"
#import "JPInputType.h"
#import "JPLoadingButton.h"
#import "JPTheme.h"
#import "JPTransactionButton.h"
#import "JPTransactionPresenter.h"
#import "NSString+Additions.h"
#import "UIViewController+Additions.h"

@interface JPTransactionViewController ()
@property (nonatomic, strong) JPCardInputView *addCardView;
@property (nonatomic, strong) NSArray *countries;
@end

@implementation JPTransactionViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addCardView = [JPCardInputView new];
    self.view = self.addCardView;
    [self.presenter prepareInitialViewModel];
    [self _jp_registerKeyboardObservers];
    [self addGestureRecognizers];
    if (@available(iOS 13.0, *)) {
        self.addCardView.scanCardButton.hidden = NO;
    } else {
        self.addCardView.scanCardButton.hidden = YES;
    }
}

- (void)dealloc {
    [self _jp_removeKeyboardObservers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.addCardView endEditing:YES];
    [super viewWillDisappear:animated];
}

#pragma mark - User actions

- (void)onBackgroundViewTap {
    [self.addCardView endEditing:YES];
}

- (void)onCancelButtonTap {
    [self.delegate didCancel];
    [self.presenter handleCancelButtonTap];
}

- (void)onAddCardButtonTap {
    [self.addCardView.addCardButton startLoading];
    [self.addCardView enableUserInterface:NO];
    [self.presenter handleTransactionButtonTap];
}

- (void)onContinueButtonTap {
    [self.presenter handleContinueButtonTap];
}

- (void)onBackButtonTap {
    [self.presenter handleBackButtonTap];
}

- (void)onPayWithSecurityCodeButtonTap {
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:true
                             completion:^{
                                 [weakSelf.delegate didInputSecurityCode:weakSelf.addCardView.secureCodeTextField.text];
                             }];
}

- (void)onScanCardButtonTap {
    [self.addCardView endEditing:YES];
    [self.presenter handleScanCardButtonTap];
}

#pragma mark - View protocol methods

- (void)updateViewWithViewModel:(JPTransactionViewModel *)viewModel
            shouldUpdateTargets:(BOOL)shouldUpdateTargets {
    if (viewModel.mode == JPCardDetailsModeAVS || viewModel.mode == JPCardDetailsModeThreeDS2BillingDetails) {
        self.addCardView.countryPickerView.delegate = self;
        self.addCardView.countryPickerView.dataSource = self;
        self.countries = viewModel.pickerCountries;
    }
    shouldUpdateTargets ? [self updateTargets:viewModel] : NULL;
    [self.addCardView configureWithViewModel:viewModel];
}

- (void)applyConfiguredTheme:(nonnull JPTheme *)theme {
    [self.addCardView applyTheme:theme];
}

- (void)updateViewWithError:(NSError *)error {
    [self.addCardView enableUserInterface:YES];
    [self.addCardView.addCardButton stopLoading];
    [self _jp_displayAlertWithError:error];
    [self _jp_triggerNotificationFeedbackWithType:UINotificationFeedbackTypeError];
}

- (void)didFinishAddingCard {
    [self.delegate didFinishAddingCard];
}

- (UIAlertController *)alertControllerWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"scan_card_confirm"._jp_localized
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];

    [controller addAction:confirmAction];
    return controller;
}

- (void)displayCameraPermissionsAlert {
    UIAlertController *controller = [self alertControllerWithTitle:@"scan_card_no_permission_title"._jp_localized
                                                        andMessage:@"scan_card_no_permission_message"._jp_localized];

    UIAlertAction *goToSettingsAction = [UIAlertAction actionWithTitle:@"scan_card_go_to_settings"._jp_localized
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *_Nonnull action) {
                                                                   [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                                                                                    options:@{}
                                                                                          completionHandler:nil];
                                                               }];

    [controller addAction:goToSettingsAction];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)displayCameraRestrictionAlert {
    UIAlertController *controller = [self alertControllerWithTitle:@"scan_card_restricted_title"._jp_localized
                                                        andMessage:@"scan_card_restricted_message"._jp_localized];

    [self presentViewController:controller animated:YES completion:nil];
}

- (void)displayCameraSimulatorAlert {
    UIAlertController *controller = [self alertControllerWithTitle:@"scan_card_simulator_title"._jp_localized
                                                        andMessage:nil];

    [self presentViewController:controller animated:YES completion:nil];
}

- (void)changeFocusToSecurityCodeField {
    [self.addCardView.secureCodeTextField becomeFirstResponder];
}

#pragma mark - Layout setup

- (void)updateTargets:(JPTransactionViewModel *)viewModel {
    [self _jp_connectButton:self.addCardView.cancelButton withSelector:@selector(onCancelButtonTap)];
    [self _jp_connectButton:self.addCardView.scanCardButton withSelector:@selector(onScanCardButtonTap)];
    switch (viewModel.mode) {
        case JPCardDetailsModeDefault:
        case JPCardDetailsModeAVS:
            [self _jp_connectButton:self.addCardView.addCardButton withSelector:@selector(onAddCardButtonTap)];
            break;
        case JPCardDetailsModeThreeDS2:
            [self _jp_connectButton:self.addCardView.addCardButton withSelector:@selector(onContinueButtonTap)];
            break;
        case JPCardDetailsModeThreeDS2BillingDetails:
            [self _jp_connectButton:self.addCardView.addCardButton withSelector:@selector(onAddCardButtonTap)];
            [self _jp_connectButton:self.addCardView.backButton withSelector:@selector(onBackButtonTap)];
            break;
        case JPCardDetailsModeSecurityCode:
            [self _jp_connectButton:self.addCardView.addCardButton withSelector:@selector(onPayWithSecurityCodeButtonTap)];
        default:
            break;
    }

    self.addCardView.cardNumberTextField.delegate = self;
    self.addCardView.cardHolderTextField.delegate = self;
    self.addCardView.cardHolderPhoneTextField.delegate = self;
    self.addCardView.cardHolderCityTextField.delegate = self;
    self.addCardView.cardHolderAddressLine1TextField.delegate = self;
    self.addCardView.cardHolderAddressLine2TextField.delegate = self;
    self.addCardView.cardHolderAddressLine3TextField.delegate = self;
    self.addCardView.cardHolderPhoneCodeTextField.delegate = self;
    self.addCardView.cardHolderEmailTextField.delegate = self;
    self.addCardView.cardExpiryTextField.delegate = self;
    self.addCardView.secureCodeTextField.delegate = self;
    self.addCardView.countryTextField.delegate = self;
    self.addCardView.postcodeTextField.delegate = self;
}

- (void)addGestureRecognizers {
    [self _jp_addTapGestureForView:self.addCardView.backgroundView withSelector:@selector(onBackgroundViewTap)];
}

#pragma mark - Keyboard handling logic

- (void)_jp_keyboardWillShow:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.addCardView.bottomSliderConstraint.constant = -keyboardSize.height;
    [self.view layoutIfNeeded];

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve
                     animations:^{
                         [weakSelf.addCardView adjustTopSpace];
                         [weakSelf.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){}];
}

- (void)_jp_keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    self.addCardView.bottomSliderConstraint.constant = 0;
    [self.view layoutIfNeeded];

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve
                     animations:^{
                         [weakSelf.addCardView adjustTopSpace];
                         [weakSelf.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){}];
}

@end

#pragma mark - Country UIPickerView delegate

@implementation JPTransactionViewController (CountryPickerDelegate)

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.countries.count;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    JPCountry *country = self.countries[row];
    [self.presenter handleInputChange:country.name forType:JPInputTypeCardCountry showError:YES];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    JPCountry *country = self.countries[row];
    return country.name;
}

@end

#pragma mark - Card number delegate

@implementation JPTransactionViewController (InputFieldDelegate)

- (BOOL)inputField:(JPInputField *)inputField shouldChangeText:(NSString *)text {
    BOOL showError = inputField.type != JPInputTypeCardholderEmail && inputField.type != JPInputTypeCardholderPhone;

    [self.presenter handleInputChange:text
                              forType:inputField.type
                            showError:showError];
    return NO;
}

- (void)inputField:(JPInputField *)inputField didEndEditing:(NSString *)text {
    [self.presenter handleInputChange:text
                              forType:inputField.type
                            showError:inputField.type == JPInputTypeCardholderEmail];
}

- (void)inputFieldDidBeginEditing:(JPInputField *)inputField {
    //    UIScrollView *scrollView = self.addCardView.scrollView;
    //    CGRect visibleScrollRect = UIEdgeInsetsInsetRect(scrollView.bounds, scrollView.contentInset);
    //    CGRect fieldFrame = inputField.frame;
    //
    //    if (!CGRectContainsRect(visibleScrollRect, fieldFrame)) {
    //        [scrollView scrollRectToVisible:CGRectInset(fieldFrame, 0, 80) animated:YES];
    //    }
}

@end
