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
#import "UIViewController+Additions.h"
#import "Settings.h"

@interface NoUICardPayViewController ()
@property (strong, nonatomic) IBOutlet JPLoadingButton *payWithCardButton;
@property (strong, nonatomic) IBOutlet JPLoadingButton *preAuthWithCardButton;

@property (strong, nonatomic) JP3DSService *threeDSecureService;
@property (strong, nonatomic) JPApiService *apiService;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation NoUICardPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"No UI payments";

    [self.preAuthWithCardButton setBackgroundImage:UIColor.blackColor.asImage forState:UIControlStateNormal];
    [self.payWithCardButton setBackgroundImage:UIColor.blackColor.asImage forState:UIControlStateNormal];

    self.apiService = [[JPApiService alloc] initWithAuthorization:Settings.defaultSettings.authorization
                                                      isSandboxed:Settings.defaultSettings.isSandboxed];

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

    [self presentResultViewControllerWithResponse:response];
}

- (JPPaymentRequest *)paymentRequest {
    JPCard *card = [[JPCard alloc] initWithCardNumber:@"4000 0000 0000 0002"
                                       cardholderName:@"Name Here"
                                           expiryDate:@"12/25"
                                           secureCode:@"452"];
    
    JPPaymentRequest *request = [[JPPaymentRequest alloc] initWithConfiguration:self.configuration andCardDetails:card];
    request.yourPaymentReference = [JPReference generatePaymentReference];
    return request;
}

- (IBAction)payWithCardToken:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.payWithCardButton startLoading];
    
    [self.apiService invokePaymentWithRequest:self.paymentRequest
                                     andCompletion:^(JPResponse *response, JPError *error) {
                                         [weakSelf handleResponse:response error:error showReceipt:true];
                                         [weakSelf.payWithCardButton stopLoading];
                                     }];
}

- (IBAction)preAuthWithCardToken:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.preAuthWithCardButton startLoading];

    [self.apiService invokePreAuthPaymentWithRequest:self.paymentRequest
                                       andCompletion:^(JPResponse *response, JPError *error) {
                                                [weakSelf handleResponse:response error:error showReceipt:true];
                                                [weakSelf.preAuthWithCardButton stopLoading];
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

- (JP3DSService *)threeDSecureService {
    if (!_threeDSecureService) {
        _threeDSecureService = [[JP3DSService alloc] initWithApiService:self.apiService];
    }
    return _threeDSecureService;
}

@end
