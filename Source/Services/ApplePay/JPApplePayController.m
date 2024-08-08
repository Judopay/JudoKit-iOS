//
//  JPApplePayController.h
//  JudoKit_iOS
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

#import "JPApplePayController.h"
#import "JPApplePayConfiguration.h"
#import "JPApplePayWrappers.h"
#import <PassKit/PassKit.h>

@interface JPApplePayController ()

@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, strong) JPApplePayAuthorizationBlock authorizationBlock;
@property (nonatomic, strong) JPApplePayDidFinishBlock didFinishBlock;
@property (nonatomic, assign) BOOL isPaymentAuthorized;

@end

@implementation JPApplePayController

#pragma mark - Initializers

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration {
    if (self = [super init]) {
        _configuration = configuration;
    }
    return self;
}

#pragma mark - Public methods

- (UIViewController *)applePayViewControllerWithAuthorizationBlock:(JPApplePayAuthorizationBlock)authorizationBlock
                                                    didFinishBlock:(JPApplePayDidFinishBlock)didFinishBlock {
    self.authorizationBlock = authorizationBlock;
    self.didFinishBlock = didFinishBlock;

    PKPaymentAuthorizationViewController *controller;
    controller = [JPApplePayWrappers pkPaymentControllerForConfiguration:self.configuration];
    controller.delegate = self;

    return controller;
}

#pragma mark - PKPaymentAuthorizationViewController delegate methods

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                   handler:(void (^)(PKPaymentAuthorizationResult *_Nonnull))completion {
    self.isPaymentAuthorized = YES;
    self.authorizationBlock(payment, completion);
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    __weak typeof(self) weakSelf = self;

    [controller dismissViewControllerAnimated:YES
                                   completion:^{
                                       __strong typeof(self) strongSelf = weakSelf;

                                       strongSelf.didFinishBlock(strongSelf.isPaymentAuthorized);
                                   }];
}

@end
