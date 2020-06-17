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
#import "DetailViewController.h"
#import "UIColor+Additions.h"

@import JudoKit_iOS;

@interface PayWithCardTokenViewController ()
@property (strong, nonatomic) IBOutlet JPLoadingButton *payWithCardTokenButton;
@property (strong, nonatomic) IBOutlet JPLoadingButton *preAuthWithCardTokenButton;
@property (strong, nonatomic) IBOutlet UIButton *createCardTokenButton;
@property (nonatomic, strong) JPTransactionService *transactionService;
@property (strong, nonatomic) JPTransaction *transaction;
@property (nonatomic, strong) UIActivityIndicatorView *_Nullable activityIndicatorView;
@end

@implementation PayWithCardTokenViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self disableButtons];
    [self setupButtons];
    Settings *settings = [[Settings alloc] initWith:NSUserDefaults.standardUserDefaults];
    self.transactionService = [[JPTransactionService alloc] initWithToken:settings.token
                                                                andSecret:settings.secret];
    self.transactionService.isSandboxed = settings.isSandboxed;
    self.transaction = [self.transactionService transactionWithConfiguration:self.configuration];
}

- (IBAction)addCardAction:(UIButton *)sender {
    [self createCardTokenOperation];
}

- (void)createCardTokenOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeTransactionWithType:JPTransactionTypeRegisterCard
                              configuration:self.configuration
                                 completion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error showReceipt:false];
    }];
}

- (void)handleResponse:(JPResponse *)response error:(NSError *)error showReceipt:(BOOL)showReceipt {
    if (error || !response) {
        [self displayAlertWithError: error];
        return;
    }
    
    JPTransactionData *transactionData = response.items.firstObject;
    
    self.transaction.cardToken = transactionData.cardDetails.cardToken;
    if (transactionData.cardDetails.cardToken) {
        [self enableButtons];
    }
    
    if (showReceipt) {
        [self presentDetailsViewControllerWithTransactionData:transactionData];
    }
}

- (void)presentDetailsViewControllerWithTransactionData:(JPTransactionData *)transactionData {
    DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    viewController.transactionData = transactionData;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)payWithCardToken:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.payWithCardTokenButton startLoading];
    [self.transactionService payWithTransaction:self.transaction andCompletion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error showReceipt:true];
        [self.payWithCardTokenButton stopLoading];
    }];
}

- (IBAction)preAuthWithCardToken:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.preAuthWithCardTokenButton startLoading];
    [self.transactionService preAuthWithTransaction:self.transaction andCompletion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error showReceipt:true];
        [self.preAuthWithCardTokenButton stopLoading];
    }];
}

- (void)setupButtons {
    [self.preAuthWithCardTokenButton setBackgroundImage:UIColor.darkGrayColor.asImage forState:UIControlStateDisabled];
    [self.payWithCardTokenButton setBackgroundImage:UIColor.darkGrayColor.asImage forState:UIControlStateDisabled];
    [self.payWithCardTokenButton setBackgroundImage:UIColor.blackColor.asImage forState:UIControlStateNormal];
    [self.preAuthWithCardTokenButton setBackgroundImage:UIColor.blackColor.asImage forState:UIControlStateNormal];
}

- (void)disableButtons {
    self.payWithCardTokenButton.enabled = NO;
    self.preAuthWithCardTokenButton.enabled = NO;
}

- (void)enableButtons {
    self.payWithCardTokenButton.enabled = YES;
    self.preAuthWithCardTokenButton.enabled = YES;
}

@end
