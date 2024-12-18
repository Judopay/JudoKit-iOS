//
//  MainViewController.m
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

@import TTGSnackbar;
#import <CoreLocation/CoreLocation.h>
#import <InAppSettingsKit/IASKAppSettingsViewController.h>
#import <InAppSettingsKit/IASKSettingsReader.h>
@import JudoKit_iOS;

#import "ApplePayViewController.h"
#import "DemoFeature.h"
#import "ExampleAppStorage.h"
#import "IASKAppSettingsViewController+Additions.h"
#import "MainViewController.h"
#import "NoUICardPayViewController.h"
#import "PayWithCardTokenViewController.h"
#import "Settings.h"
#import "UIViewController+Additions.h"
#import "MainViewController+Additions.h"

static NSString *const kTokenPaymentsScreenSegue = @"tokenPayments";
static NSString *const kApplePayScreenSegue = @"showApplePayScreen";
static NSString *const kNoUIPaymentsScreenSegue = @"noUIPayments";

@interface MainViewController ()

@property (nonatomic, strong) JudoKit *judoKit;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray<NSString *> *settingsToObserve;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *networkInspectorButton;
@property (nonatomic, assign) BOOL shouldUpdateKitAuth;
@property (nonatomic, strong) NSURL *deepLinkURL;
@property (nonatomic, strong) IASKAppSettingsViewController *settingsViewController;
@end

@implementation MainViewController

// MARK: View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup accessibility identifiers
    self.view.accessibilityIdentifier = @"Main View";
    self.settingsButton.accessibilityIdentifier = @"Settings Button";
    self.networkInspectorButton.accessibilityIdentifier = @"Network requests inspector button";
    self.networkInspectorButton.action = @selector(presentNetworkRequestsInspector);
    self.networkInspectorButton.target = self;
        
    self.shouldUpdateKitAuth = YES;
    [self requestLocationPermissions];
    
    self.judoKit = [[JudoKit alloc] initWithAuthorization:Settings.defaultSettings.authorization];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.shouldUpdateKitAuth) {
        self.shouldUpdateKitAuth = NO;
        [self updateKitAuth];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(settingDidChanged:)
                                               name:kIASKAppSettingChanged
                                             object:nil];
    
    for (NSString *key in self.settingsToObserve) {
        [Settings.defaultSettings.defaults addObserver:self
                                            forKeyPath:key
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    }
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    
    // Remove KVO observers when it's no longer needed
    for (NSString *key in self.settingsToObserve) {
        [Settings.defaultSettings.defaults removeObserver:self forKeyPath:key];
    }
}

- (void)settingDidChanged:(NSNotification *)notification {
    if (![notification.name isEqualToString:kIASKAppSettingChanged]) {
        return;
    }
    
    NSSet *changes = [NSSet setWithArray:notification.userInfo.allKeys];
        
    // As settingsViewController belongs to type "IASKAppSettingsViewController, it gets nested (e.g. Apple Pay Settings),
    // and therefore it is important to call this updating method on the main (parent) Settings ViewController, not necessarily
    // the one that sends this notification (as it's possibly the nested one). Main Settings VS propagades these changes
    // down to its children.
    if ([_settingsViewController respondsToSelector:@selector(didChangedSettingsWithKeys:)]) {
        [_settingsViewController didChangedSettingsWithKeys:changes.allObjects];
    }
}

// Observe changes to UserDefaults keys - to update judokit.auth in case if changes are made
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
    if ([object isKindOfClass:NSUserDefaults.class] && [self.settingsToObserve containsObject:keyPath]) {
        self.shouldUpdateKitAuth = YES;
    }
}

// MARK: Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:IASKAppSettingsViewController.class]) {
        _settingsViewController = segue.destinationViewController;
        _settingsViewController.neverShowPrivacySettings = YES;
        _settingsViewController.delegate = self;
        [_settingsViewController updateHiddenKeys];
    }
    if ([segue.destinationViewController isKindOfClass:PayWithCardTokenViewController.class]) {
        PayWithCardTokenViewController *controller = segue.destinationViewController;
        controller.judoKit = self.judoKit;
        controller.configuration = self.configuration;
    }
    if ([segue.destinationViewController isKindOfClass:NoUICardPayViewController.class]) {
        NoUICardPayViewController *controller = segue.destinationViewController;
        controller.configuration = self.configuration;
    }
}

// MARK: Setup methods

- (void)updateKitAuth {
    self.judoKit.isSandboxed = Settings.defaultSettings.isSandboxed;
    self.judoKit.authorization = Settings.defaultSettings.authorization;
}

- (void)requestLocationPermissions {
    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
}

// MARK: SDK Features

- (void)paymentOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeTransactionWithType:JPTransactionTypePayment
                              configuration:self.configuration
                                 completion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error];
    }];
}

- (void)preAuthOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeTransactionWithType:JPTransactionTypePreAuth
                              configuration:self.configuration
                                 completion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error];
    }];
}

- (void)createCardTokenOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeTransactionWithType:JPTransactionTypeRegisterCard
                              configuration:self.configuration
                                 completion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error];
    }];
}

- (void)checkCardOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeTransactionWithType:JPTransactionTypeCheckCard
                              configuration:self.configuration
                                 completion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error];
    }];
}

- (void)saveCardOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeTransactionWithType:JPTransactionTypeSaveCard
                              configuration:self.configuration
                                 completion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error];
    }];
}

- (void)applePayPaymentOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeApplePayWithMode:JPTransactionModePayment
                           configuration:self.configuration
                              completion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error];
    }];
}

- (void)applePayPreAuthOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeApplePayWithMode:JPTransactionModePreAuth
                           configuration:self.configuration
                              completion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error];
    }];
}

- (void)paymentMethodOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokePaymentMethodScreenWithMode:JPTransactionModePayment
                                      configuration:self.configuration
                                         completion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error];
    }];
}

- (void)preAuthMethodOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokePaymentMethodScreenWithMode:JPTransactionModePreAuth
                                      configuration:self.configuration
                                         completion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error];
    }];
}

- (void)tokenPaymentsMethodOperation {
    [self performSegueWithIdentifier:kTokenPaymentsScreenSegue sender:nil];
}

- (void)noUIPaymentsMethodOperation {
    [self performSegueWithIdentifier:kNoUIPaymentsScreenSegue sender:nil];
}

- (void)applePayOperation {
    [self performSegueWithIdentifier:kApplePayScreenSegue sender:nil];
}

- (void)serverToServerMethodOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokePaymentMethodScreenWithMode:JPTransactionModeServerToServer
                                      configuration:self.configuration
                                         completion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error];
    }];
}

- (void)presentTextFieldAlertControllerWithCompletion:()completion {
}

- (void)transactionDetailsMethodOperation {
    __weak typeof(self) weakSelf = self;
    [self presentTextFieldAlertControllerWithTitle:@"Get transaction"
                                           message:@"For receipt Id:"
                               positiveButtonTitle:@"Search"
                               negativeButtonTitle:@"Cancel"
                              textFieldPlaceholder:@"Receipt ID"
                                     andCompletion:^(NSString *text) {
        if (!text || text.length == 0) {
            return;
        }
        
        [weakSelf.judoKit fetchTransactionWithReceiptId:text
                                             completion:^(JPResponse *response, JPError *error) {
            [weakSelf handleResponse:response error:error];
        }];
    }];
}

// MARK: Helper methods

- (void)displaySnackBarWith:(NSString *)text {
    TTGSnackbar *bar = [[TTGSnackbar alloc] initWithMessage:text
                                                   duration:TTGSnackbarDurationMiddle];
    bar.shouldDismissOnSwipe = YES;
    [TTGSnackbarManager.shared showSnackbar:bar];
}

- (void)handleResponse:(JPResponse *)response error:(NSError *)error {
    if (error) {
        [self displaySnackBarWith:error.localizedDescription];
        return;
    }
    
    if (!response) {
        return;
    }
    
    [self presentResultViewControllerWithResponse:response];
}

// MARK: Lazy properties

- (JPConfiguration *)configuration {
    JPConfiguration *configuration = [[JPConfiguration alloc] initWithJudoID:Settings.defaultSettings.judoId
                                                                      amount:Settings.defaultSettings.amount
                                                                   reference:Settings.defaultSettings.reference];
    configuration.paymentMethods = Settings.defaultSettings.paymentMethods;
    configuration.uiConfiguration.isAVSEnabled = Settings.defaultSettings.isAVSEnabled;
    configuration.uiConfiguration.shouldPaymentMethodsDisplayAmount = Settings.defaultSettings.shouldPaymentMethodsDisplayAmount;
    configuration.uiConfiguration.shouldPaymentButtonDisplayAmount = Settings.defaultSettings.shouldPaymentButtonDisplayAmount;
    configuration.uiConfiguration.shouldPaymentMethodsVerifySecurityCode = Settings.defaultSettings.shouldPaymentMethodsVerifySecurityCode;
    configuration.uiConfiguration.shouldAskForBillingInformation = Settings.defaultSettings.shouldAskForBillingInformation;
    configuration.uiConfiguration.shouldAskForCSC = Settings.defaultSettings.shouldAskForCSC;
    configuration.uiConfiguration.shouldAskForCardholderName = Settings.defaultSettings.shouldAskForCardholderName;
    
    @try {
        configuration.uiConfiguration.threeDSUICustomization = Settings.defaultSettings.threeDSUICustomization;
    } @catch (NSException *exception) {
        [self displaySnackBarWith:[NSString stringWithFormat:@"Setting 3DS SDK UI configuration failed with reason: %@", exception.reason]];
    }
    
    configuration.supportedCardNetworks = Settings.defaultSettings.supportedCardNetworks;
    configuration.applePayConfiguration = self.applePayConfiguration;
    
    configuration.isInitialRecurringPayment = Settings.defaultSettings.isInitialRecurringPaymentEnabled;
    configuration.cardAddress = Settings.defaultSettings.address;
    configuration.primaryAccountDetails = Settings.defaultSettings.primaryAccountDetails;
    configuration.isDelayedAuthorisation = Settings.defaultSettings.isDelayedAuthorisationOn;
    configuration.isAllowIncrement = Settings.defaultSettings.isAllowIncrementOn;
    
    configuration.emailAddress = Settings.defaultSettings.emailAddress;
    configuration.phoneCountryCode = Settings.defaultSettings.phoneCountryCode;
    configuration.mobileNumber = Settings.defaultSettings.mobileNumber;
    configuration.scaExemption = Settings.defaultSettings.scaExemption;
    configuration.challengeRequestIndicator = Settings.defaultSettings.challengeRequestIndicator;
    configuration.threeDSTwoMaxTimeout = Settings.defaultSettings.threeDsTwoMaxTimeout;
    configuration.extras = @{
        @"shouldUseFabrickDsId": @(Settings.defaultSettings.isUsingFabrick3DSService)
    };
    
    NSString *messageVersion = Settings.defaultSettings.threeDSTwoMessageVersion;
    
    if (messageVersion.length > 0) {
        configuration.threeDSTwoMessageVersion = messageVersion;
    }
    
    if (Settings.defaultSettings.isRecommendationFeatureOn) {
        NSString *rsaKey = Settings.defaultSettings.rsaKey;
        NSURL *URL = [NSURL URLWithString:Settings.defaultSettings.recommendationUrl];
        NSNumber *timeout = Settings.defaultSettings.recommendationTimeout;
        BOOL isRecommendationHaltTransactionOn = Settings.defaultSettings.isRecommendationHaltTransactionOn;
        configuration.recommendationConfiguration = [[JPRecommendationConfiguration alloc] initWithURL:URL
                                                                                          RSAPublicKey:rsaKey
                                                                                               timeout:timeout
                                                                    andHaltTransactionInCaseOfAnyError:isRecommendationHaltTransactionOn];
    }
    
    return configuration;
}

- (JPApplePayConfiguration *)applePayConfiguration {
    
    NSDecimalNumber *itemOnePrice = [NSDecimalNumber decimalNumberWithString:@"0.01"];
    NSDecimalNumber *itemTwoPrice = [NSDecimalNumber decimalNumberWithString:@"0.02"];
    NSDecimalNumber *totalPrice = [NSDecimalNumber decimalNumberWithString:@"0.03"];
    
    NSArray *items = @[ [JPPaymentSummaryItem itemWithLabel:@"Item 1" amount:itemOnePrice],
                        [JPPaymentSummaryItem itemWithLabel:@"Item 2"
                                                     amount:itemTwoPrice],
                        [JPPaymentSummaryItem itemWithLabel:@"Tim Apple"
                                                     amount:totalPrice] ];
    
    JPApplePayConfiguration *configuration = [[JPApplePayConfiguration alloc] initWithMerchantId:Settings.defaultSettings.applePayMerchantId
                                                                                        currency:Settings.defaultSettings.amount.currency
                                                                                     countryCode:@"GB"
                                                                             paymentSummaryItems:items];
    
    configuration.requiredShippingContactFields = Settings.defaultSettings.applePayShippingContactFields;
    configuration.requiredBillingContactFields = Settings.defaultSettings.applePayBillingContactFields;
    configuration.returnedContactInfo = Settings.defaultSettings.applePayReturnedContactInfo;
    configuration.supportedCardNetworks = Settings.defaultSettings.supportedCardNetworks;
    configuration.shippingMethods = @[ [[JPPaymentShippingMethod alloc] initWithIdentifier:@"method"
                                                                                    detail:@"details"
                                                                                     label:@"label"
                                                                                    amount:totalPrice
                                                                                      type:JPPaymentSummaryItemTypeFinal] ];
    if (Settings.defaultSettings.isApplePayRecurringPaymentOn) {

        NSURL *managementURL = [NSURL URLWithString:Settings.defaultSettings.applePayRecurringPaymentManagementUrl];
        
        if (@available(iOS 16.0, *)) {
            JPRecurringPaymentSummaryItem *regularBilling = [JPRecurringPaymentSummaryItem itemWithLabel:Settings.defaultSettings.applePayRecurringPaymentLabel
                                                                                                  amount:Settings.defaultSettings.applePayRecurringPaymentAmount
                                                                                            intervalUnit:Settings.defaultSettings.applePayRecurringPaymentIntervalUnit
                                                                                           intervalCount:Settings.defaultSettings.applePayRecurringPaymentIntervalCount
                                                                                               startDate:Settings.defaultSettings.applePayRecurringPaymentStartDate
                                                                                              andEndDate:Settings.defaultSettings.applePayRecurringPaymentEndDate];
            
            JPRecurringPaymentRequest *request = [JPRecurringPaymentRequest requestWithPaymentDescription:Settings.defaultSettings.applePayRecurringPaymentDescription
                                                                                           regularBilling:regularBilling
                                                                                         andManagementURL:managementURL];
            request.billingAgreement = Settings.defaultSettings.applePayRecurringPaymentBillingAgreement;
            configuration.recurringPaymentRequest = request;
        }
    }
    return configuration;
}

- (NSArray<NSString *> *)settingsToObserve {
    if (!_settingsToObserve) {
        _settingsToObserve = @[ kSandboxedKey,
                                kTokenKey, kSecretKey,
                                kPaymentSessionKey,
                                kSessionTokenKey,
                                kIsTokenAndSecretOnKey, kIsPaymentSessionOnKey ];
    }
    return _settingsToObserve;
}

@end

@implementation MainViewController (TableViewDelegates)

// MARK: UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return DemoFeature.defaultFeatures.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Features";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"To view test card details:\nSign in to judo and go to Developer/Tools.";
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DemoFeature *option = DemoFeature.defaultFeatures[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:option.cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = option.title;
    cell.detailTextLabel.text = option.details;
    cell.accessibilityLabel = option.title;
    return cell;
}

// MARK: UITableViewDelegate

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DemoFeature *feature = DemoFeature.defaultFeatures[indexPath.row];
    
    BOOL isApplePayRelatedFeature = feature.type == DemoFeatureTypeApplePayPayment || feature.type == DemoFeatureTypeApplePayPreAuth || feature.type == DemoFeatureTypeApplePayStandalone;
    
    JPConfiguration *configuration = self.configuration;
    if (isApplePayRelatedFeature && ![JudoKit isApplePayAvailableWithConfiguration:configuration]) {
        [self displayAlertWithTitle:@"Error" andMessage:@"ApplePay is not available for given configuration."];
        return;
    }
    
    switch (feature.type) {
        case DemoFeatureTypePayment:
            [self paymentOperation];
            break;
            
        case DemoFeatureTypePreAuth:
            [self preAuthOperation];
            break;
            
        case DemoFeatureTypeCreateCardToken:
            [self createCardTokenOperation];
            break;
            
        case DemoFeatureTypeSaveCard:
            [self saveCardOperation];
            break;
            
        case DemoFeatureTypeCheckCard:
            [self checkCardOperation];
            break;
            
        case DemoFeatureTypeApplePayPayment:
            [self applePayPaymentOperation];
            break;
            
        case DemoFeatureTypeApplePayPreAuth:
            [self applePayPreAuthOperation];
            break;
            
        case DemoFeatureTypeApplePayStandalone:
            [self applePayOperation];
            break;
            
        case DemoFeatureTypePaymentMethods:
            [[ExampleAppStorage sharedInstance] persistLastUsedFeature:DemoFeatureTypePaymentMethods];
            [self paymentMethodOperation];
            break;
            
        case DemoFeatureTypePreAuthMethods:
            [self preAuthMethodOperation];
            break;
            
        case DemoFeatureTypeServerToServer:
            [self serverToServerMethodOperation];
            break;
            
        case DemoFeatureTokenPayments:
            [self tokenPaymentsMethodOperation];
            break;
            
        case DemoFeatureNoUIPayments:
            [self noUIPaymentsMethodOperation];
            break;
            
        case DemoFeatureGetTransactionDetails:
            [self transactionDetailsMethodOperation];
            break;
    }
}

@end
