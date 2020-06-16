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

@import JudoKit_iOS;

@interface TokenPayViewController ()
@property (strong, nonatomic) IBOutlet UIButton *cardPay;
@property (strong, nonatomic) IBOutlet UIButton *preAuthCardPay;
@property (nonatomic, strong) JPTransactionService *transactionService;
@property (strong, nonatomic) Settings *settings;
@property (strong, nonatomic) JPTransaction *transaction;
@end

@implementation TokenPayViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.cardPay setEnabled:NO];
    [self.preAuthCardPay setEnabled:NO];
    
    self.transactionService = [[JPTransactionService alloc] initWithToken:self.settings.token
                                                                andSecret:self.settings.secret];
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
        [weakSelf handleResponse:response error:error];
    }];
}

- (void)handleResponse:(JPResponse *)response error:(NSError *)error {
    if (error) {
        [self displayAlertWithError: error];
        return;
    }

    if (!response) {
        return;
    }
    
    JPTransactionData *transactionData = response.items.firstObject;
    self.transaction.cardToken = transactionData.cardDetails.cardToken;
    if (self.transaction.cardToken) {
        [self.cardPay setEnabled:YES];
        [self.preAuthCardPay setEnabled:YES];
    }
}

- (IBAction)payCard:(UIButton *)sender {
    if (self.transaction.cardToken) {
        __weak typeof(self) weakSelf = self;
        [self.transactionService payWithCardWithTransaction:self.transaction completion:^(JPResponse *response, JPError *error) {
            [weakSelf handleResponse:response error:error];
        }];
    }
}

- (IBAction)preAuthPay:(UIButton *)sender {
    if (self.transaction.cardToken) {
        __weak typeof(self) weakSelf = self;
        [self.transactionService preAuthpayWithCardTransaction:self.transaction completion:^(JPResponse *response, JPError *error) {
            [weakSelf handleResponse:response error:error];
        }];
    }
}

- (Settings *)settings {
    if (!_settings) {
        _settings = [[Settings alloc] initWith:NSUserDefaults.standardUserDefaults];
    }
    return _settings;
}

@end
