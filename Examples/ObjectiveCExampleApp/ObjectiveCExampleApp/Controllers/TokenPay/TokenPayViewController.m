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

@import JudoKit_iOS;

@interface TokenPayViewController ()
@property (strong, nonatomic) IBOutlet UIButton *cardPay;
@property (strong, nonatomic) IBOutlet UIButton *preAuthCardPay;
@end

@implementation TokenPayViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.cardPay setEnabled:NO];
    [self.preAuthCardPay setEnabled:NO];
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

    if (transactionData.cardDetails) {
        if (transactionData.cardDetails.cardToken) {
            [self.cardPay setEnabled:YES];
            [self.preAuthCardPay setEnabled:YES];
        }
    }
}

@end
