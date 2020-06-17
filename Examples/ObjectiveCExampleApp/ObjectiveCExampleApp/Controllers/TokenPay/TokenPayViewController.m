//
//  TokenPayViewController.m
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

#import "TokenPayViewController.h"
#import "Settings.h"
#import "DetailViewController.h"

@import JudoKit_iOS;

@interface TokenPayViewController ()
@property (strong, nonatomic) IBOutlet UIButton *cardPay;
@property (strong, nonatomic) IBOutlet UIButton *preAuthCardPay;
@property (strong, nonatomic) IBOutlet UIButton *addCardButton;
@property (nonatomic, strong) JPTransactionService *transactionService;
@property (strong, nonatomic) Settings *settings;
@property (strong, nonatomic) JPTransaction *transaction;
@end

@implementation TokenPayViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDisableButtons];
    [self setupButtons];
    self.transactionService = [[JPTransactionService alloc] initWithToken:self.settings.token
                                                                andSecret:self.settings.secret];
    self.transactionService.isSandboxed = self.settings.isSandboxed;
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
    if (error) {
        [self displayAlertWithError: error];
        return;
    }
    
    if (!response) {
        return;
    }
    
    JPTransactionData *transactionData = response.items.firstObject;
    
    self.transaction.cardToken = transactionData.cardDetails.cardToken;
    if (transactionData.cardDetails.cardToken) {
        [self setEnableButtons];
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

- (IBAction)payCard:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.transactionService payWithTransaction:self.transaction andCompletion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error showReceipt:true];
    }];
}

- (IBAction)preAuthPay:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.transactionService preAuthWithTransaction:self.transaction andCompletion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error showReceipt:true];
    }];
}

- (Settings *)settings {
    if (!_settings) {
        _settings = [[Settings alloc] initWith:NSUserDefaults.standardUserDefaults];
    }
    return _settings;
}

- (void)setupButtons {
    self.cardPay.layer.cornerRadius = 4.0F;
    self.preAuthCardPay.layer.cornerRadius = 4.0F;
    self.addCardButton.layer.cornerRadius = 4.0F;
}

- (void)setDisableButtons {
    [self.cardPay setEnabled:NO];
    [self.preAuthCardPay setEnabled:NO];
    self.cardPay.alpha = 0.5;
    self.preAuthCardPay.alpha = 0.5;
}

- (void)setEnableButtons {
    [self.cardPay setEnabled:YES];
    [self.preAuthCardPay setEnabled:YES];
    self.cardPay.alpha = 1.0;
    self.preAuthCardPay.alpha = 1.0;
}

@end
