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
#import "JudoKit.h"

@import CoreLocation;
@import JudoShield;

@interface JudoPayViewController ()

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
    
    self.title = self.view.transactionType.title();
    
    self.view.threeDSecureWebView.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
