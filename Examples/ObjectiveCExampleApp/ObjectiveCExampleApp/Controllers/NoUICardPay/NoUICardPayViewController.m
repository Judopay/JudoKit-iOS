//
//  NoUICardPayViewController.m
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

#import "NoUICardPayViewController.h"
#import "Settings.h"
#import "UIViewController+Additions.h"

@import JudoKit_iOS;

@interface NoUICardPayViewController ()
@property (strong, nonatomic) IBOutlet JPLoadingButton *payWithCardButton;
@property (strong, nonatomic) IBOutlet JPLoadingButton *preAuthWithCardButton;

@property (strong, nonatomic) JPCardTransactionService *transactionService;
@end

@implementation NoUICardPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"No UI payments";

    [self.preAuthWithCardButton setBackgroundImage:UIColor.blackColor._jp_asImage forState:UIControlStateNormal];
    [self.payWithCardButton setBackgroundImage:UIColor.blackColor._jp_asImage forState:UIControlStateNormal];
}

- (IBAction)payWithCardToken:(UIButton *)sender {
    self.configuration.reference = Settings.defaultSettings.reference;
    [self.payWithCardButton startLoading];

    __weak typeof(self) weakSelf = self;
    [self.transactionService invokePaymentWithDetails:self.cardTransactionDetails
                                        andCompletion:^(JPResponse *response, JPError *error) {
                                            [weakSelf.payWithCardButton stopLoading];
                                            [weakSelf handleResponse:response error:error showReceipt:true];
                                        }];
}

- (IBAction)preAuthWithCardToken:(UIButton *)sender {
    self.configuration.reference = Settings.defaultSettings.reference;
    [self.preAuthWithCardButton startLoading];

    __weak typeof(self) weakSelf = self;
    [self.transactionService invokePreAuthPaymentWithDetails:self.cardTransactionDetails
                                               andCompletion:^(JPResponse *response, JPError *error) {
                                                   [weakSelf.preAuthWithCardButton stopLoading];
                                                   [weakSelf handleResponse:response error:error showReceipt:true];
                                               }];
}

- (JPCardTransactionDetails *)cardTransactionDetails {
    JPCardTransactionDetails *details = [JPCardTransactionDetails new];
    details.cardNumber = @"4976350000006891";
    details.cardholderName = @"CHALLENGE";
    details.expiryDate = @"12/25";
    details.securityCode = @"341";
    details.emailAddress = @"federico.onco@gmail.com";
    details.mobileNumber = @"7866868430";
    details.phoneCountryCode = @"44";
    details.billingAddress = [[JPAddress alloc] initWithAddress1:@"Holbeck Row"
                                                        address2:nil
                                                        address3:nil
                                                            town:@"London"
                                                        postCode:@"se151qa"
                                                     countryCode:@826
                                                           state:nil];

    return details;
}

- (void)handleResponse:(JPResponse *)response
                 error:(NSError *)error
           showReceipt:(BOOL)showReceipt {
    if (error || !response) {
        [self displayAlertWithError:error];
        return;
    }

    [self presentResultViewControllerWithResponse:response];
}

- (JPCardTransactionService *)transactionService {
    if (!_transactionService) {
        _transactionService = [[JPCardTransactionService alloc] initWithAuthorization:Settings.defaultSettings.authorization
                                                                          isSandboxed:Settings.defaultSettings.isSandboxed
                                                                     andConfiguration:self.configuration];
    }
    return _transactionService;
}

@end
