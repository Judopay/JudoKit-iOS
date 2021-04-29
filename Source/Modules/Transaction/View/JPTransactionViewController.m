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
#import "JPCardInputField.h"
#import "JPCardInputView.h"
#import "JPCardNumberField.h"
#import "JPLoadingButton.h"
#import "JPTheme.h"
#import "JPTransactionButton.h"
#import "JPTransactionPresenter.h"
#import "NSString+Additions.h"
#import "UIViewController+Additions.h"

@interface JPTransactionViewController ()
@property (nonatomic, strong) JPCardInputView *addCardView;
@property (nonatomic, strong) NSArray *countryNames;
@end

@implementation JPTransactionViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addCardView = [JPCardInputView new];
    self.view = self.addCardView;
    [self.presenter prepareInitialViewModel];
    [self registerKeyboardObservers];
    [self addGestureRecognizers];
    if (@available(iOS 13.0, *)) {
        self.addCardView.scanCardButton.hidden = NO;
    } else {
        self.addCardView.scanCardButton.hidden = YES;
    }

}

- (void)dealloc {
    [self removeKeyboardObservers];
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
    if (viewModel.mode == JPCardDetailsModeAVS) {
        self.addCardView.countryPickerView.delegate = self;
        self.addCardView.countryPickerView.dataSource = self;
        self.countryNames = viewModel.countryPickerViewModel.pickerTitles;
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
    [self displayAlertWithError:error];
    [self triggerNotificationFeedbackWithType:UINotificationFeedbackTypeError];
}

- (void)didFinishAddingCard {
    [self.delegate didFinishAddingCard];
}

- (UIAlertController *)alertControllerWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"scan_card_confirm".localized
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];

    [controller addAction:confirmAction];
    return controller;
}

- (void)displayCameraPermissionsAlert {
    UIAlertController *controller = [self alertControllerWithTitle:@"scan_card_no_permission_title".localized
                                                        andMessage:@"scan_card_no_permission_message".localized];

    UIAlertAction *goToSettingsAction = [UIAlertAction actionWithTitle:@"scan_card_go_to_settings".localized
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
    UIAlertController *controller = [self alertControllerWithTitle:@"scan_card_restricted_title".localized
                                                        andMessage:@"scan_card_restricted_message".localized];

    [self presentViewController:controller animated:YES completion:nil];
}

- (void)displayCameraSimulatorAlert {
    UIAlertController *controller = [self alertControllerWithTitle:@"scan_card_simulator_title".localized
                                                        andMessage:nil];

    [self presentViewController:controller animated:YES completion:nil];
}

- (void)changeFocusToSecurityCodeField {
    [self.addCardView.secureCodeTextField becomeFirstResponder];
}

#pragma mark - Layout setup

- (void)updateTargets:(JPTransactionViewModel *)viewModel {
    [self connectButton:self.addCardView.cancelButton withSelector:@selector(onCancelButtonTap)];
    [self connectButton:self.addCardView.scanCardButton withSelector:@selector(onScanCardButtonTap)];
    switch (viewModel.mode) {
        case JPCardDetailsModeDefault:
        case JPCardDetailsModeAVS:
            [self connectButton:self.addCardView.addCardButton withSelector:@selector(onAddCardButtonTap)];
            break;
        case JPCardDetailsMode3DS2:
            [self connectButton:self.addCardView.addCardButton withSelector:@selector(onContinueButtonTap)];
            break;
        case JPCardDetailsMode3DS2BillingDetails:
            [self connectButton:self.addCardView.addCardButton withSelector:@selector(onContinueButtonTap)];
            [self connectButton:self.addCardView.backButton withSelector:@selector(onBackButtonTap)];
            break;
        case JPCardDetailsModeSecurityCode:
            [self connectButton:self.addCardView.addCardButton withSelector:@selector(onPayWithSecurityCodeButtonTap)];
        default:
            break;
    }

    self.addCardView.cardNumberTextField.delegate = self;
    self.addCardView.cardHolderTextField.delegate = self;
    self.addCardView.cardHolderCountryTextField.delegate = self;
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
    [self addTapGestureForView:self.addCardView.backgroundView withSelector:@selector(onBackgroundViewTap)];
}

#pragma mark - Keyboard handling logic

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.addCardView.bottomSliderConstraint.constant = -keyboardSize.height;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve
                     animations:^{
        [weakSelf.addCardView adjustTopSpace];
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    self.addCardView.bottomSliderConstraint.constant = 0;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve
                     animations:^{
        [weakSelf.addCardView adjustTopSpace];
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

@end

#pragma mark - Country UIPickerView delegate

@implementation JPTransactionViewController (CountryPickerDelegate)

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.countryNames.count;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    [self.presenter handleInputChange:self.countryNames[row]
                              forType:JPInputTypeCardCountry];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    return self.countryNames[row];
}

@end

#pragma mark - Card number delegate

@implementation JPTransactionViewController (InputFieldDelegate)

- (BOOL)inputField:(JPInputField *)inputField shouldChangeText:(NSString *)text {
    [self.presenter handleInputChange:text forType:inputField.type];
    return NO;
}

@end
