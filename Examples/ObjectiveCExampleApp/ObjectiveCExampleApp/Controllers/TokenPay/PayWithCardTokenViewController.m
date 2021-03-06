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

@property (strong, nonatomic) IBOutlet JPLoadingButton *payWithCardTokenButton;
@property (strong, nonatomic) IBOutlet JPLoadingButton *preAuthWithCardTokenButton;
@property (strong, nonatomic) IBOutlet UIButton *createCardTokenButton;

@property (strong, nonatomic) JP3DSService *threeDSecureService;
@property (strong, nonatomic) JPApiService *apiService;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) NSString *cardToken;

@end

@implementation PayWithCardTokenViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self shouldEnableButtons:NO];
    [self setupButtons];

    self.apiService = [[JPApiService alloc] initWithAuthorization:Settings.defaultSettings.authorization
                                                      isSandboxed:Settings.defaultSettings.isSandboxed];
}

- (IBAction)addCardAction:(UIButton *)sender {
    [self createCardTokenOperation];
}

- (void)createCardTokenOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeTransactionWithType:JPTransactionTypeSaveCard
                              configuration:self.configuration
                                 completion:^(JPResponse *response, JPError *error) {
                                     [weakSelf handleResponse:response error:error showReceipt:false];
                                 }];
}

- (void)handleResponse:(JPResponse *)response
                 error:(NSError *)error
           showReceipt:(BOOL)showReceipt {

    if (error.code == Judo3DSRequestError) {
        [self handle3DSecureTransactionFromError:error];
        return;
    }

    if (error || !response) {
        [self displayAlertWithError:error];
        return;
    }

    self.cardToken = response.cardDetails.cardToken;

    if (self.cardToken) {
        [self shouldEnableButtons:YES];
    }

    if (showReceipt) {
        [self presentResultViewControllerWithResponse:response];
    }
}

- (IBAction)payWithCardToken:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.payWithCardTokenButton startLoading];

    JPTokenRequest *request = [[JPTokenRequest alloc] initWithConfiguration:self.configuration andCardToken:self.cardToken];
    request.yourPaymentReference = [JPReference generatePaymentReference];

    [self.apiService invokeTokenPaymentWithRequest:request
                                     andCompletion:^(JPResponse *response, JPError *error) {
                                         [weakSelf handleResponse:response error:error showReceipt:true];
                                         [weakSelf.payWithCardTokenButton stopLoading];
                                     }];
}

- (IBAction)preAuthWithCardToken:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.preAuthWithCardTokenButton startLoading];

    JPTokenRequest *request = [[JPTokenRequest alloc] initWithConfiguration:self.configuration andCardToken:self.cardToken];
    request.yourPaymentReference = [JPReference generatePaymentReference];

    [self.apiService invokePreAuthTokenPaymentWithRequest:request
                                            andCompletion:^(JPResponse *response, JPError *error) {
                                                [weakSelf handleResponse:response error:error showReceipt:true];
                                                [weakSelf.preAuthWithCardTokenButton stopLoading];
                                            }];
}

- (void)handle3DSecureTransactionFromError:(NSError *)error {
    __weak typeof(self) weakSelf = self;
    JP3DSConfiguration *configuration = [JP3DSConfiguration configurationWithError:error];
    [self.threeDSecureService invoke3DSecureWithConfiguration:configuration
                                                   completion:^(JPResponse *response, JPError *transactionError) {
                                                       if (response) {
                                                           [weakSelf presentResultViewControllerWithResponse:response];
                                                           return;
                                                       }

                                                       [weakSelf displayAlertWithError:error];
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

- (JP3DSService *)threeDSecureService {
    if (!_threeDSecureService) {
        _threeDSecureService = [[JP3DSService alloc] initWithApiService:self.apiService];
    }
    return _threeDSecureService;
}

@end
