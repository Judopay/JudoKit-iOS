//
//  MainViewController.m
//  CarthageExampleApp
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

#import <CoreLocation/CoreLocation.h>
#import <JudoKit_iOS/JudoKit_iOS.h>
#import "ExampleAppCredentials.h"
#import "MainViewController.h"

static NSString * const kConsumerReference = @"judoPay-sample-app-objc";

@interface MainViewController ()

@property (nonatomic, strong) JPReference *reference;
@property (nonatomic, strong) JudoKit *judoKit;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MainViewController

// MARK: View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestLocationPermissions];
    [self setupJudoSDK];
}

// MARK: Setup methods

- (void)setupJudoSDK {
    self.judoKit = [[JudoKit alloc] initWithAuthorization:[[JPBasicAuthorization alloc] initWithToken:token andSecret:secret]];
    self.judoKit.isSandboxed = YES;
}

- (void)requestLocationPermissions {
    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
}

// MARK: SDK Features

- (IBAction)paymentOperation:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeTransactionWithType:JPTransactionTypePayment
                                     configuration:self.configuration
                                        completion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error];
    }];
}

// MARK: Helper methods

- (void)handleResponse:(JPResponse *)response error:(NSError *)error {
    if (error) {
        [self presentErrorWithMessage: error.localizedDescription];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Response: %@", response);
    }];
}

- (void)presentErrorWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// MARK: Lazy properties

- (JPConfiguration *)configuration {
    JPReference *reference = [JPReference consumerReference:kConsumerReference];
    reference.metaData = @{@"exampleMetaKey": @"exampleMetaValue"};

    JPAmount *amount = [[JPAmount alloc] initWithAmount:@"1.5" currency:@"GBP"];
    JPConfiguration *configuration = [[JPConfiguration alloc] initWithJudoID:judoId
                                                                      amount:amount
                                                                   reference:reference];
    return configuration;
}

@end

