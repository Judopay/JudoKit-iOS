//
//  PayWithCardTokenViewController.m
//  ObjectiveCExampleApp
//
//  Copyright (c) 2020 Alternative Payments Ltd
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

#import "PayWithCardTokenViewController.h"
#import "Settings.h"
#import "UIViewController+Additions.h"

@import JudoKit_iOS;

@interface PayWithCardTokenViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *createCardTokenButton;

@property (strong, nonatomic) IBOutlet JPLoadingButton *payWithCardTokenButton;
@property (strong, nonatomic) IBOutlet JPLoadingButton *preAuthWithCardTokenButton;

@property (weak, nonatomic) IBOutlet UITextField *cardNetworkTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardTokenTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardSecurityCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardholderNameTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewBottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *delayLabel;
@property (weak, nonatomic) IBOutlet UIStepper *delayStepper;

@end

@implementation PayWithCardTokenViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Token payments";
    [self shouldEnableButtons:NO];
    [self _jp_registerKeyboardObservers];
    
    [self onDelayStepperValueChanged:self.delayStepper];
}

- (void)dealloc {
    [self _jp_removeKeyboardObservers];
}

#pragma mark - Keyboard handling logic

- (void)_jp_keyboardWillShow:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.scrollviewBottomConstraint.constant = keyboardSize.height;
    [self.view layoutIfNeeded];

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve
                     animations:^{
                         [weakSelf.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){}];
}

- (void)_jp_keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    self.scrollviewBottomConstraint.constant = 0;
    [self.view layoutIfNeeded];

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve
                     animations:^{
                         [weakSelf.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){}];
}

- (IBAction)textFieldDidChange:(id)sender {
    BOOL shouldEnableButtons =
        self.cardNetworkTextField.text.length > 0 && self.cardTokenTextField.text.length > 0 && self.cardholderNameTextField.text.length > 0;

    [self shouldEnableButtons:shouldEnableButtons];
}

- (IBAction)addCardAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeTransactionWithType:JPTransactionTypeSaveCard
                              configuration:self.configuration
                                 completion:^(JPResponse *response, JPError *error) {
                                     [weakSelf handleResponse:response error:error showReceipt:false];
                                     [weakSelf fillInFieldsFromResponse:response];
                                 }];
}

- (void)handleResponse:(JPResponse *)response error:(NSError *)error showReceipt:(BOOL)showReceipt {
    if (error || !response) {
        [self displayAlertWithError:error];
        return;
    }

    if (showReceipt) {
        [self presentResultViewControllerWithResponse:response];
    }
}

- (void)fillInFieldsFromResponse:(JPResponse *)response {
    JPCardDetails *cardDetails = response.cardDetails;

    if (cardDetails) {
        self.cardNetworkTextField.text = [NSString stringWithFormat:@"%@", cardDetails.rawCardNetwork];
        self.cardTokenTextField.text = cardDetails.cardToken;
        self.cardholderNameTextField.text = cardDetails.cardHolderName;
        [self textFieldDidChange:nil];
    }
}

- (IBAction)onDelayStepperValueChanged:(UIStepper *)sender {
    self.delayLabel.text = [NSString stringWithFormat:@"Simulate delay: %d sec.", (int)sender.value];
}

- (dispatch_time_t)delayDispatchTime {
    double delayInSeconds = self.delayStepper.value;
    return dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
}

- (IBAction)payWithCardToken:(UIButton *)sender {
    [self.payWithCardTokenButton startLoading];

    __weak typeof(self) weakSelf = self;
            
    dispatch_after(self.delayDispatchTime, dispatch_get_main_queue(), ^{
        [self.judoKit invokeTokenTransactionWithType:JPTransactionTypePayment
                                       configuration:self.configuration
                                             details:[self cardTransactionDetails]
                                          completion:^(JPResponse *response, JPError *error) {
                                              [weakSelf handleResponse:response error:error showReceipt:true];
                                              [weakSelf.payWithCardTokenButton stopLoading];
                                          }];
    });
}

- (IBAction)preAuthWithCardToken:(UIButton *)sender {
    [self.preAuthWithCardTokenButton startLoading];

    __weak typeof(self) weakSelf = self;

    dispatch_after(self.delayDispatchTime, dispatch_get_main_queue(), ^{
        [weakSelf.judoKit invokeTokenTransactionWithType:JPTransactionTypePreAuth
                                       configuration:self.configuration
                                             details:[self cardTransactionDetails]
                                          completion:^(JPResponse *response, JPError *error) {
                                              [weakSelf handleResponse:response error:error showReceipt:true];
                                              [weakSelf.preAuthWithCardTokenButton stopLoading];
                                          }];
    });
}

- (JPCardTransactionDetails *)cardTransactionDetails {
    self.configuration.reference = Settings.defaultSettings.reference;

    JPCardTransactionDetails *details = [JPCardTransactionDetails detailsWithConfiguration:self.configuration];

    NSString *secureCode = nil;

    if (self.cardSecurityCodeTextField.text.length > 0) {
        secureCode = self.cardSecurityCodeTextField.text;
    }

    details.cardToken = self.cardTokenTextField.text;
    details.cardType = @(self.cardNetworkTextField.text.integerValue)._jp_toCardNetworkType;
    details.securityCode = secureCode;
    details.cardholderName = self.cardholderNameTextField.text;

    return details;
}

- (void)shouldEnableButtons:(BOOL)shouldEnable {
    self.payWithCardTokenButton.enabled = shouldEnable;
    self.preAuthWithCardTokenButton.enabled = shouldEnable;
}

@end
