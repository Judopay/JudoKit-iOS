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
#import "JPCountry.h"
#import "JPInputType.h"
#import "JPLoadingButton.h"
#import "JPPresentationMode.h"
#import "JPState.h"
#import "JPTheme.h"
#import "JPTransactionButton.h"
#import "JPTransactionPresenter.h"
#import "NSString+Additions.h"
#import "UIViewController+Additions.h"

@interface JPTransactionViewController () <JPCardInputViewDelegate>
@end

@implementation JPTransactionViewController

#pragma mark - View Lifecycle

- (void)loadView {
    JPCardInputView *view = [JPCardInputView new];
    view.delegate = self;

    self.view = view;
}

- (JPCardInputView *)cardInputView {
    return (JPCardInputView *)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.presenter onViewDidLoad];
    [self _jp_registerKeyboardObservers];
}

- (void)dealloc {
    [self _jp_removeKeyboardObservers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.cardInputView endEditing:YES];
    [super viewWillDisappear:animated];
}

#pragma mark - View protocol methods

- (void)updateViewWithViewModel:(JPTransactionViewModel *)viewModel {
    [self.cardInputView configureWithViewModel:viewModel];
}

- (void)applyConfiguredTheme:(JPTheme *)theme {
    [self.cardInputView applyTheme:theme];
}

- (void)updateViewWithError:(NSError *)error {
    [self _jp_triggerNotificationFeedbackWithType:UINotificationFeedbackTypeError];
}

- (UIAlertController *)alertControllerWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"jp_scan_card_confirm"._jp_localized
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];

    [controller addAction:confirmAction];
    return controller;
}

- (void)displayCameraPermissionsAlert {
    UIAlertController *controller = [self alertControllerWithTitle:@"jp_scan_card_no_permission_title"._jp_localized
                                                        andMessage:@"jp_scan_card_no_permission_message"._jp_localized];

    UIAlertAction *goToSettingsAction = [UIAlertAction actionWithTitle:@"jp_scan_card_go_to_settings"._jp_localized
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
    UIAlertController *controller = [self alertControllerWithTitle:@"jp_scan_card_restricted_title"._jp_localized
                                                        andMessage:@"jp_scan_card_restricted_message"._jp_localized];

    [self presentViewController:controller animated:YES completion:nil];
}

- (void)displayCameraSimulatorAlert {
    UIAlertController *controller = [self alertControllerWithTitle:@"jp_scan_card_simulator_title"._jp_localized
                                                        andMessage:nil];

    [self presentViewController:controller animated:YES completion:nil];
}

- (void)moveFocusToInput:(JPInputType)type {
    [self.cardInputView moveFocusToInput:type];
}

#pragma mark - JPCardInputViewDelegate

- (void)cardInputView:(JPCardInputView *)inputView
        didChangeText:(NSString *)text
         forInputType:(JPInputType)type
        andEndEditing:(BOOL)endEditing {
    [self.presenter handleInputChange:text forType:type showError:endEditing];
}

- (void)cardInputView:(JPCardInputView *)inputView didPerformAction:(JPCardInputViewActionType)action {
    [inputView endEditing:YES];

    switch (action) {
        case JPCardInputViewActionTypeCancel:
            [self.presenter handleCancelButtonTap];
            break;

        case JPCardInputViewActionTypeScanCard:
            [self.presenter handleScanCardButtonTap];
            break;

        case JPCardInputViewActionTypeSubmit:
            [self.presenter handleSubmitButtonTap];
            break;

        default:
            break;
    }
}

#pragma mark - Keyboard handling logic

- (void)_jp_keyboardWillShow:(NSNotification *)notification {
    [self.cardInputView notifyKeyboardWillShow:YES withNotification:notification];
}

- (void)_jp_keyboardWillHide:(NSNotification *)notification {
    [self.cardInputView notifyKeyboardWillShow:NO withNotification:notification];
}

@end
