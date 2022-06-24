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

@interface PayWithCardTokenViewController ()

@property (strong, nonatomic) IBOutlet UIButton *createCardTokenButton;

@property (strong, nonatomic) IBOutlet JPLoadingButton *payWithCardTokenButton;
@property (strong, nonatomic) IBOutlet JPLoadingButton *preAuthWithCardTokenButton;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) JPCardDetails *cardDetails;
@property (strong, nonatomic) JPCardTransactionService *transactionService;

@end

@implementation PayWithCardTokenViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Token and no UI payments";
    [self shouldEnableButtons:NO];
    [self setupButtons];
}

- (IBAction)addCardAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeTransactionWithType:JPTransactionTypeSaveCard
                              configuration:self.configuration
                                 completion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error showReceipt:false];
        
        weakSelf.cardDetails = response.cardDetails;
        
        if (weakSelf.cardDetails) {
            [weakSelf shouldEnableButtons:YES];
        }
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

- (IBAction)payWithCardToken:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;

    [self presentTextFieldAlertControllerWithTitle:@"Please provide the security code"
                                           message:@""
                               positiveButtonTitle:@"Ok"
                               negativeButtonTitle:@"Cancel"
                              textFieldPlaceholder:@"Security code"
                                     andCompletion:^(NSString *text) {
        if (!text || text.length == 0) {
            return;
        }
        
        [weakSelf.payWithCardTokenButton startLoading];
        
        weakSelf.configuration.reference = Settings.defaultSettings.reference;
        JPCardTransactionDetails *details = [JPCardTransactionDetails detailsWithConfiguration:weakSelf.configuration
                                                                                andCardDetails:weakSelf.cardDetails];
        details.secureCode = text;
        details.cardholderName = @"CHALLENGE";

        [weakSelf.transactionService invokeTokenPaymentWithDetails:details
                                                     andCompletion:^(JPResponse *response, JPError *error) {
            [weakSelf handleResponse:response error:error showReceipt:true];
            [weakSelf.payWithCardTokenButton stopLoading];
        }];
    }];
}

- (IBAction)preAuthWithCardToken:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;

    [self presentTextFieldAlertControllerWithTitle:@"Please provide the security code"
                                           message:@""
                               positiveButtonTitle:@"Ok"
                               negativeButtonTitle:@"Cancel"
                              textFieldPlaceholder:@"Security code"
                                     andCompletion:^(NSString *text) {
        if (!text || text.length == 0) {
            return;
        }
        
        [weakSelf.preAuthWithCardTokenButton startLoading];
        
        weakSelf.configuration.reference = Settings.defaultSettings.reference;
        JPCardTransactionDetails *details = [JPCardTransactionDetails detailsWithConfiguration:weakSelf.configuration
                                                                                andCardDetails:weakSelf.cardDetails];
        details.secureCode = text;
        details.cardholderName = @"CHALLENGE";

        [weakSelf.transactionService invokePreAuthTokenPaymentWithDetails:details
                                                            andCompletion:^(JPResponse *response, JPError *error) {
            [weakSelf handleResponse:response error:error showReceipt:true];
            [weakSelf.preAuthWithCardTokenButton stopLoading];
        }];
    }];
}

- (void)setupButtons {
    [self.preAuthWithCardTokenButton setBackgroundImage:UIColor.darkGrayColor.asImage forState:UIControlStateDisabled];
    [self.preAuthWithCardTokenButton setBackgroundImage:UIColor.blackColor.asImage forState:UIControlStateNormal];
    
    [self.payWithCardTokenButton setBackgroundImage:UIColor.darkGrayColor.asImage forState:UIControlStateDisabled];
    [self.payWithCardTokenButton setBackgroundImage:UIColor.blackColor.asImage forState:UIControlStateNormal];
}

- (void)shouldEnableButtons:(BOOL)shouldEnable {
    self.payWithCardTokenButton.enabled = shouldEnable;
    self.preAuthWithCardTokenButton.enabled = shouldEnable;
}

- (JPCardTransactionService *)transactionService {
    if (!_transactionService) {
        _transactionService = [[JPCardTransactionService alloc] initWithAuthorization:Settings.defaultSettings.authorization
                                                                          isSandboxed:Settings.defaultSettings.isSandboxed
                                                                     andConfiguration:self.configuration];
    }
    return  _transactionService;
}

@end
