//
//  JudoPayViewController.m
//  JudoKitObjC
//
//  Copyright (c) 2016 Alternative Payments Ltd
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

#import "JudoPayViewController.h"
#import "JPTransaction.h"
#import "JudoPayView.h"
#import "JPSession.h"
#import "JP3DSWebView.h"
#import "JPPaymentToken.h"
#import "CardInputField.h"
#import "DateInputField.h"
#import "SecurityCodeInputField.h"
#import "PostCodeInputField.h"
#import "BillingCountryInputField.h"
#import "IssueNumberInputField.h"
#import "NSError+Judo.h"
#import "JudoKit.h"
#import "JPTheme.h"
#import "LoadingView.h"
#import "FloatingTextField.h"

#import "NSString+Card.h"
#import "UIColor+Judo.h"

#import "JPCard.h"
#import "JPAddress.h"

@import CoreLocation;
@import JudoShield;

@interface JudoPayViewController () <UIWebViewDelegate>

@property (nonatomic, strong, readwrite) JPAmount *amount;
@property (nonatomic, strong, readwrite) NSString *judoId;
@property (nonatomic, strong, readwrite) JPReference *reference;
@property (nonatomic, strong, readwrite) JPPaymentToken *paymentToken;

@property (nonatomic, strong) JudoShield *judoShield;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, strong) JPTransaction *pending3DSTransaction;
@property (nonatomic, strong) NSString *pending3DSReceiptId;
@property (nonatomic, strong) JudoCompletionBlock completionBlock;

@property (nonatomic, strong) JudoPayView *view;

@end

@implementation JudoPayViewController

@synthesize view;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.judoKitSession.apiSession.uiClientMode = YES;
    
    self.title = self.view.transactionTitle;
    
    self.view.threeDSWebView.delegate = self;
    
    self.view.theme = self.theme;
    
    // Button Actions
    
    NSString *payButtonTitle = self.view.transactionType == TransactionTypeRegisterCard ? self.theme.registerCardButtonTitle : self.theme.paymentButtonTitle;
    
    [self.view.paymentButton addTarget:self action:@selector(payButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.view.paymentNavBarButton = [[UIBarButtonItem alloc] initWithTitle:payButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(payButtonAction:)];
    self.view.paymentNavBarButton.enabled = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.theme.backButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonAction:)];
    self.navigationItem.rightBarButtonItem = self.view.paymentNavBarButton;
    
    self.navigationController.navigationBar.tintColor = self.theme.judoDarkGrayColor;
    
    if ([self.theme.tintColor colorMode]) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:self.theme.judoDarkGrayColor};
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view paymentEnabled:NO];
    
    [self.view layoutIfNeeded];
    
    if (self.view.cardDetails == nil && self.view.cardInputField.textField.text) {
        [self.view.cardInputField textFieldDidChangeValue:self.view.cardInputField.textField];
        [self.view.expiryDateInputField textFieldDidChangeValue:self.view.cardInputField.textField];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.judoShield locationWithCompletion:^(CLLocationCoordinate2D coordinate, NSError * _Nullable error) {
        if (error) {
            // silently fail
        } else if (CLLocationCoordinate2DIsValid(coordinate)) {
            self.currentLocation = coordinate;
        }
    }];
    
    if (self.view.cardInputField.textField.text.length) {
        [self.view.securityCodeInputField.textField becomeFirstResponder];
    } else {
        [self.view.cardInputField.textField becomeFirstResponder];
    }
}

- (void)payButtonAction:(id)sender {
    if (!self.reference || !self.amount || !self.judoId) {
        if (self.completionBlock) {
            self.completionBlock(nil, [NSError judoParameterError]);
        }
        return; // BAIL
    }
    
    [self.view.securityCodeInputField.textField resignFirstResponder];
    [self.view.postCodeInputField.textField resignFirstResponder];
    
    [self.view.loadingView startAnimating];
    
    JPTransaction *transaction = [self.judoKitSession transactionForType:self.type judoId:self.judoId amount:self.amount reference:self.reference];
    
    if (self.paymentToken) {
        self.paymentToken.secureCode = self.view.securityCodeInputField.textField.text;
        [transaction setPaymentToken:self.paymentToken];
    } else {
        JPAddress *address = nil;
        if (self.theme.avsEnabled) {
            if (self.view.postCodeInputField.textField.text) {
                address = [JPAddress new];
                address.postCode = self.view.postCodeInputField.textField.text;
                address.billingCountry = self.view.billingCountryInputField.textField.text;
            }
        }
        
        NSString *issueNumber = nil;
        NSString *startDate = nil;
        
        if (self.view.cardInputField.cardNetwork == CardNetworkMaestro) {
            issueNumber = self.view.issueNumberInputField.textField.text;
            startDate = self.view.startDateInputField.textField.text;
        }
        
        JPCard *card = [[JPCard alloc] initWithCardNumber:[self.view.cardInputField.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""]
                                               expiryDate:self.view.expiryDateInputField.textField.text
                                               secureCode:self.view.securityCodeInputField.textField.text];
        
        card.cardAddress = address;
        
        card.issueNumber = issueNumber;
        card.startDate = startDate;
        
        [transaction setCard:card];
    }
    
    if (CLLocationCoordinate2DIsValid(self.currentLocation)) {
        [transaction setLocation:self.currentLocation];
    }
    
    if (self.judoShield.deviceSignal) {
        [transaction setDeviceSignal:self.judoShield.deviceSignal];
    }
    
    self.pending3DSTransaction = transaction;
    
    [transaction sendWithCompletion:^(JPResponse * response, NSError * error) {
        if (error) {
            if (error.domain == JudoErrorDomain && error.code == JudoError3DSRequest) {
                if (!error.userInfo) {
                    if (self.completionBlock) {
                        self.completionBlock(nil, [NSError judoResponseParseError]);
                        return; // BAIL
                    }
                }
                
                NSError *load3DSerror = nil;
                
                self.pending3DSReceiptId = [self.view.threeDSWebView load3DSWithPayload:error.userInfo error:&load3DSerror];
                
                if (load3DSerror && self.completionBlock) {
                    self.completionBlock(nil, load3DSerror);
                    [self.view.loadingView stopAnimating];
                    return; // BAIL
                }
                
                
                
                self.view.loadingView.actionLabel.text = self.theme.redirecting3DSTitle;
                self.title = self.theme.authenticationTitle;
                [self.view paymentEnabled:NO];
                
            }
        } else if (response) {
            if (self.completionBlock) {
                self.completionBlock(response, nil);
                [self.view.loadingView stopAnimating];
            }
        }
    }];
    
}

- (void)doneButtonAction:(id)sender {
    if (self.completionBlock) {
        self.completionBlock(nil, [NSError judoUserDidCancelError]);
    }
}

#pragma mark - UIWebView Delegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlString = request.URL.absoluteString;
    
    if ([urlString rangeOfString:@"Parse3DS"].location != NSNotFound) {
        NSString *bodyString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        if (!bodyString) {
            if (self.completionBlock) {
                self.completionBlock(nil, [NSError judo3DSRequestFailedErrorWithUnderlyingError:nil]);
            }
            return NO;
        }
        
        NSMutableDictionary *results = [NSMutableDictionary dictionary];
        
        NSArray *pairs = [bodyString componentsSeparatedByString:@"&"];
        
        for (NSString *pair in pairs) {
            if ([pair rangeOfString:@"="].location != NSNotFound) {
                NSArray *components = [pair componentsSeparatedByString:@"="];
                NSString *value = components[1];
                NSString *escapedVal = [value stringByRemovingPercentEncoding];
                
                results[components[0]] = escapedVal;
            }
        }
        
        if (self.pending3DSReceiptId) {
            if (self.view.transactionType == TransactionTypeRegisterCard) {
                self.view.loadingView.actionLabel.text = self.theme.verifying3DSRegisterCardTitle;
            } else {
                self.view.loadingView.actionLabel.text = self.theme.verifying3DSPaymentTitle;
            }
            [self.view.loadingView startAnimating];
            self.title = self.theme.authenticationTitle;
            [self.pending3DSTransaction threeDSecureWithParameters:results completion:^(JPResponse * response, NSError * error) {
                [self.view.loadingView stopAnimating];
                if (self.completionBlock) {
                    if (error) {
                        self.completionBlock(nil, error);
                    } else if (response) {
                        self.completionBlock(response, nil);
                    } else {
                        self.completionBlock(nil, [NSError judo3DSRequestFailedErrorWithUnderlyingError:nil]);
                    }
                }
            }];
        } else {
            if (self.completionBlock) {
                self.completionBlock(nil, [NSError judo3DSRequestFailedErrorWithUnderlyingError:nil]);
            }
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.threeDSWebView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.view.threeDSWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        }];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat alphaVal = 1.0f;
    if ([webView.request.URL.absoluteString isEqualToString:@"about:blank"]) {
        alphaVal = 0.0f;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.view.threeDSWebView.alpha = alphaVal;
        [self.view.loadingView stopAnimating];
    }];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIView animateWithDuration:0.5 animations:^{
        self.view.threeDSWebView.alpha = 0.0f;
        [self.view.loadingView stopAnimating];
    }];
    if (self.completionBlock) {
        self.completionBlock(nil, [NSError judo3DSRequestFailedErrorWithUnderlyingError:error]);
    }
}

@end
