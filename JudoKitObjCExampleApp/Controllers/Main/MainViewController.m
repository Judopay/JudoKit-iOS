//
//  MainViewController.m
//  JudoKitObjCExample
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

#import <CoreLocation/CoreLocation.h>

#import "MainViewController.h"
#import "DetailViewController.h"
#import "ExampleAppCredentials.h"
#import "JPApplePayConfiguration.h"
#import "SettingsViewController.h"
#import "HalfHeightPresentationController.h"

#import "DemoFeature.h"
#import "Settings.h"

#import "JudoKitObjC.h"

static NSString * const kCellIdentifier = @"com.judo.judopaysample.tableviewcellidentifier";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, SettingsViewControllerDelegate, UIViewControllerTransitioningDelegate> {
    UIAlertController *_alertController;
}

@property (nonatomic, strong) JPCardDetails *cardDetails;
@property (nonatomic, strong) JPPaymentToken *payToken;
@property (nonatomic, strong) JudoKit *judoKitSession;

@property (nonatomic, nonnull, strong) NSString *reference;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSArray <DemoFeature *> *features;
@property (strong, nonatomic) Settings *settings;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    // initialize the SDK by setting it up with a token and a secret
    self.judoKitSession = [[JudoKit alloc] initWithToken:token secret:secret];
    
    // setting the SDK to Sandbox Mode - once this is set, the SDK wil stay in Sandbox mode until the process is killed
    self.judoKitSession.isSandboxed = YES;

    self.reference = @"judoPay-sample-app-objc";
    
    self.settings = [Settings defaultSettings];
    self.features = [DemoFeature defaultFeatures];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_alertController) {
        [self presentViewController:_alertController animated:YES completion:nil];
        _alertController = nil;
    }
}

#pragma mark - Actions

- (void)setSettings:(Settings *)settings {
    _settings = settings;
    //TODO: Handle this as a property
    self.configuration.uiConfiguration.isAVSEnabled = settings.isAVSEnabled;
}

- (void)settingsViewController:(SettingsViewController *)viewController didUpdateSettings:(Settings *)settings {
    self.settings = settings;
}

- (IBAction)settingsButtonHandler:(id)sender {
    
    SettingsViewController *svc = [[SettingsViewController alloc] initWithSettings:self.settings];
    svc.delegate = self;
    svc.modalPresentationStyle = UIModalPresentationCustom;
    svc.transitioningDelegate = self;
    [self presentViewController:svc animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.features.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    DemoFeature *option = self.features[indexPath.row];
    cell.textLabel.text = option.title;
    cell.detailTextLabel.text = option.details;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DemoFeature *feature = self.features[indexPath.row];
        
    switch (feature.type) {
            
        case DemoFeatureTypePayment:
            [self invokeTransactionWithType:TransactionTypePayment];
            break;
            
        case DemoFeatureTypePreAuth:
            [self invokeTransactionWithType:TransactionTypePreAuth];
            break;
            
        case DemoFeatureTypeCreateCardToken:
            [self invokeTransactionWithType:TransactionTypeRegisterCard];
            break;

        case DemoFeatureTypeSaveCard:
            [self invokeTransactionWithType:TransactionTypeSaveCard];
            break;
            
        case DemoFeatureTypeCheckCard:
            [self invokeTransactionWithType:TransactionTypeCheckCard];
            break;

        case DemoFeatureTypeApplePayPayment:
            [self invokeApplePayWithMode:TransactionModePayment];
            break;

        case DemoFeatureTypeApplePayPreAuth:
            [self invokeApplePayWithMode:TransactionModePreAuth];
            break;

        case DemoFeatureTypePaymentMethods:
            [self invokePaymentMethodScreenWithMode:TransactionModePayment];
            break;
            
        case DemoFeatureTypePreAuthMethods:
            [self invokePaymentMethodScreenWithMode:TransactionModePreAuth];
            break;

        default:
            break;
    }
}

- (void)invokeTransactionWithType:(TransactionType)type {
    [self.judoKitSession invokeTransactionWithType:type
                                     configuration:self.configuration
                                        completion:^(JPResponse *response, NSError *error) {
        //TODO: Handle response / error
    }];
}

- (void)invokeApplePayWithMode:(TransactionMode)mode {
    [self.judoKitSession invokeApplePayWithMode:mode
                                  configuration:self.configuration.applePayConfiguration
                                     completion:^(JPResponse *response, NSError *error) {
        //TODO: Handle response / error
    }];
}

- (void)invokePaymentMethodScreenWithMode:(TransactionMode)mode {
    [self.judoKitSession invokePaymentMethodScreenWithMode:mode
                                             configuration:self.configuration
                                                completion:^(JPResponse *response, NSError *error) {
            //TODO: Handle response / error
    }];
}

#pragma mark - Operations

- (void)presentErrorWithMessage:(NSString *)message {
    self->_alertController = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [self->_alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:self->_alertController animated:YES completion:nil];
}

#pragma mark - Lazy Loading
- (JPApplePayConfiguration *)applePayConfigurationWithType:(TransactionType)transactionType {
    
    NSArray *items = @[
                       [[PaymentSummaryItem alloc] initWithLabel:@"Item 1"
                                                          amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]],
                       [[PaymentSummaryItem alloc] initWithLabel:@"Item 2"
                                                          amount:[NSDecimalNumber decimalNumberWithString:@"0.02"]],
                       [[PaymentSummaryItem alloc] initWithLabel:@"Tim Apple"
                                                          amount:[NSDecimalNumber decimalNumberWithString:@"0.03"]]
                       ];
    
    JPApplePayConfiguration *configuration = [[JPApplePayConfiguration alloc] initWithMerchantId:merchantId
                                                                                        currency:self.settings.currency
                                                                                     countryCode:@"GB"
                                                                             paymentSummaryItems:items];
    
    configuration.requiredShippingContactFields = ContactFieldAll;
    configuration.requiredBillingContactFields = ContactFieldAll;
    configuration.returnedContactInfo = ReturnedInfoAll;
    
    return configuration;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source {
    return [[HalfHeightPresentationController alloc] initWithPresentedViewController:presented
                                                            presentingViewController:presenting];
}

- (JPConfiguration *)configuration {
    
    // REQUIRED PARAMETERS
    JPAmount *amount = [[JPAmount alloc] initWithAmount:@"0.01" currency:self.settings.currency];
    JPReference *reference = [JPReference consumerReference:self.reference];
    
    // INITIALIZATION
    JPConfiguration *configuration;
    configuration = [[JPConfiguration alloc] initWithJudoID:judoId
                                                     amount:amount
                                                  reference:reference];
    
    // OPTIONAL PARAMETERS
    configuration.paymentMethods = @[JPPaymentMethod.card, JPPaymentMethod.iDeal, JPPaymentMethod.applePay];
    configuration.supportedCardNetworks = CardNetworkVisa;
    
    
    JPPrimaryAccountDetails *primaryAccountDetails = [JPPrimaryAccountDetails new];
    primaryAccountDetails.name = @"Example Name";
    primaryAccountDetails.accountNumber = @"Example Account Number";
    primaryAccountDetails.dateOfBirth = @"Example Date";
    primaryAccountDetails.postCode = @"Example Post Code";
    
    configuration.primaryAccountDetails = primaryAccountDetails;
    
    // UI Specific Configuration
    configuration.uiConfiguration.isAVSEnabled = NO;
    
    // APPLE PAY SPECIFIC STUFF
    configuration.applePayConfiguration = [self applePayConfigurationWithType:TransactionTypePayment];
    configuration.applePayConfiguration.supportedCardNetworks = CardNetworkChinaUnionPay;
    configuration.applePayConfiguration.shippingType = ShippingTypeShipping;
    configuration.applePayConfiguration.shippingMethods = @[];
    configuration.applePayConfiguration.requiredBillingContactFields = ContactFieldAll;
    configuration.applePayConfiguration.requiredShippingContactFields = ContactFieldAll;
    configuration.applePayConfiguration.returnedContactInfo = ReturnedInfoAll;
    
    return configuration;
}

@end
