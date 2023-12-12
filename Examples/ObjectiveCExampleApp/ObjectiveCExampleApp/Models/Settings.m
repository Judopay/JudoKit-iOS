#import "Settings.h"
#import <Judo3DS2_iOS/Judo3DS2_iOS.h>

static NSString *const kDefaultConsumerReference = @"my-unique-consumer-ref";
static NSString *const kDontSet = @"dontSet";

@interface Settings ()
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

@implementation Settings

+ (instancetype)defaultSettings {
    static Settings *defaultSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultSettings = [[self alloc] initWith:NSUserDefaults.standardUserDefaults];
    });
    return defaultSettings;
}

- (instancetype)initWith:(NSUserDefaults *)defaults {
    if (self = [super init]) {
        _defaults = defaults;
    }
    return self;
}

#pragma mark - API credentials section

- (BOOL)isSandboxed {
    return [self.defaults boolForKey:kSandboxedKey];
}

- (NSString *)judoId {
    return [self.defaults stringForKey:kJudoIdKey];
}

#pragma mark - Authorization

NSString *safeString(NSString *aString) {
    if (aString) {
        return aString;
    }
    return @"";
}

- (id<JPAuthorization>)authorization {

    if (self.isPaymentSessionAuthorizationOn) {
        NSString *token = safeString([self.defaults stringForKey:kSessionTokenKey]);
        NSString *paymentSession = safeString([self.defaults stringForKey:kPaymentSessionKey]);
        return [JPSessionAuthorization authorizationWithToken:token andPaymentSession:paymentSession];
    }

    NSString *token = @"";
    NSString *secret = @"";

    if (self.isTokenAndSecretAuthorizationOn) {
        token = safeString([self.defaults stringForKey:kTokenKey]);
        secret = safeString([self.defaults stringForKey:kSecretKey]);
    }

    return [JPBasicAuthorization authorizationWithToken:token andSecret:secret];
}

- (NSString *)token {
    return [self.defaults stringForKey:kTokenKey];
}

- (NSString *)secret {
    return [self.defaults stringForKey:kSecretKey];
}

- (void)setIsPaymentSessionAuthorizationOn:(BOOL)isOn {
    [self.defaults setBool:isOn forKey:kIsPaymentSessionOnKey];
}

- (void)setIsTokenAndSecretAuthorizationOn:(BOOL)isOn {
    [self.defaults setBool:isOn forKey:kIsTokenAndSecretOnKey];
}

- (BOOL)isTokenAndSecretAuthorizationOn {
    return [self.defaults boolForKey:kIsTokenAndSecretOnKey];
}

- (BOOL)isRecommendationFeatureOn {
    return [self.defaults boolForKey:kIsRecommendationOnKey];
}

- (BOOL)isPaymentSessionAuthorizationOn {
    return [self.defaults boolForKey:kIsPaymentSessionOnKey];
}

- (BOOL)isAddressOn {
    return [self.defaults boolForKey:kIsAddressOnKey];
}

- (BOOL)isPrimaryAccountDetailsOn {
    return [self.defaults boolForKey:kIsPrimaryAccountDetailsOnKey];
}

- (BOOL)isApplePayRecurringPaymentOn {
    return [self.defaults boolForKey:kIsRecurringPaymentOnKey];
}

#pragma mark - Reference section

- (JPReference *)reference {
    NSString *paymentReference = [self.defaults stringForKey:kPaymentReferenceKey];
    NSString *consumerReference = [self.defaults stringForKey:kConsumerReferenceKey];

    if (paymentReference.length == 0) {
        paymentReference = [JPReference generatePaymentReference];
    }

    if (consumerReference.length == 0) {
        consumerReference = kDefaultConsumerReference;
    }

    JPReference *reference = [[JPReference alloc] initWithConsumerReference:consumerReference paymentReference:paymentReference];
    reference.metaData = @{@"exampleMetaKey" : @"exampleMetaValue"};

    return reference;
}

#pragma mark - Amount section

- (JPAmount *)amount {
    NSString *amount = [self.defaults stringForKey:kAmountKey];
    NSString *currency = [self.defaults stringForKey:kCurrencyKey];
    return [[JPAmount alloc] initWithAmount:amount currency:currency];
}

#pragma mark - Apple Pay section

- (NSString *)applePayMerchantId {
    return [self.defaults stringForKey:kMerchantIdKey];
}

- (JPReturnedInfo)applePayReturnedContactInfo {
    JPReturnedInfo fields = JPReturnedInfoNone;

    if ([self.defaults boolForKey:kIsApplePayBillingContactInfoRequired]) {
        fields |= JPReturnedInfoBillingContacts;
    }

    if ([self.defaults boolForKey:kIsApplePayShippingContactInfoRequired]) {
        fields |= JPReturnedInfoShippingContacts;
    }

    return fields;
}

- (JPContactField)applePayBillingContactFields {
    JPContactField fields = JPContactFieldNone;

    if ([self.defaults boolForKey:kIsBillingContactFieldPostalAddressRequiredKey]) {
        fields |= JPContactFieldPostalAddress;
    }

    if ([self.defaults boolForKey:kIsBillingContactFieldPhoneRequiredKey]) {
        fields |= JPContactFieldPhone;
    }

    if ([self.defaults boolForKey:kIsBillingContactFieldEmailRequiredKey]) {
        fields |= JPContactFieldEmail;
    }

    if ([self.defaults boolForKey:kIsBillingContactFieldNameRequiredKey]) {
        fields |= JPContactFieldName;
    }

    return fields;
}

- (JPContactField)applePayShippingContactFields {
    JPContactField fields = JPContactFieldNone;

    if ([self.defaults boolForKey:kIsShippingContactFieldPostalAddressRequiredKey]) {
        fields |= JPContactFieldPostalAddress;
    }

    if ([self.defaults boolForKey:kIsShippingContactFieldPhoneRequiredKey]) {
        fields |= JPContactFieldPhone;
    }

    if ([self.defaults boolForKey:kIsShippingContactFieldEmailRequiredKey]) {
        fields |= JPContactFieldEmail;
    }

    if ([self.defaults boolForKey:kIsShippingContactFieldNameRequiredKey]) {
        fields |= JPContactFieldName;
    }

    return fields;
}

- (NSString *)applePayRecurringPaymentDescription {
    return [self.defaults stringForKey:kRecurringPaymentDescriptionKey];
}

- (NSString *)applePayRecurringPaymentBillingAgreement {
    return [self.defaults stringForKey:kRecurringPaymentBillingAgreementKey];
}

- (NSString *)applePayRecurringPaymentManagementUrl {
    return [self.defaults stringForKey:kRecurringPaymentManagementUrlKey];
}

- (NSCalendarUnit)applePayRecurringPaymentIntervalUnit {
    return (NSCalendarUnit)[self.defaults integerForKey:kRecurringPaymentIntervalUnitKey];
}

- (NSInteger)applePayRecurringPaymentIntervalCount {
    return [self.defaults integerForKey:kRecurringPaymentIntervalCountKey];
}

- (NSString *)applePayRecurringPaymentLabel {
    return [self.defaults stringForKey:kRecurringPaymentLabelKey];
}

- (NSDecimalNumber *)applePayRecurringPaymentAmount {
    return [NSDecimalNumber decimalNumberWithString:[self.defaults objectForKey:kRecurringPaymentAmountKey]];
}

- (NSDate *)applePayRecurringPaymentStartDate {
    return [self.defaults objectForKey:kRecurringPaymentStartDateKey];
}

- (NSDate *)applePayRecurringPaymentEndDate {
    return [self.defaults objectForKey:kRecurringPaymentEndDateKey];
}

#pragma mark - Supported card networks section

- (JPCardNetworkType)supportedCardNetworks {
    JPCardNetworkType networks = JPCardNetworkTypeUnknown;

    if ([self.defaults boolForKey:kVisaEnabledKey]) {
        networks |= JPCardNetworkTypeVisa;
    }

    if ([self.defaults boolForKey:kMasterCardEnabledKey]) {
        networks |= JPCardNetworkTypeMasterCard;
    }

    if ([self.defaults boolForKey:kMaestroEnabledKey]) {
        networks |= JPCardNetworkTypeMaestro;
    }

    if ([self.defaults boolForKey:kAMEXEnabledKey]) {
        networks |= JPCardNetworkTypeAMEX;
    }

    if ([self.defaults boolForKey:kChinaUnionPayEnabledKey]) {
        networks |= JPCardNetworkTypeChinaUnionPay;
    }

    if ([self.defaults boolForKey:kJCBEnabledKey]) {
        networks |= JPCardNetworkTypeJCB;
    }

    if ([self.defaults boolForKey:kDiscoverEnabledKey]) {
        networks |= JPCardNetworkTypeDiscover;
    }

    if ([self.defaults boolForKey:kDinersClubEnabledKey]) {
        networks |= JPCardNetworkTypeDinersClub;
    }

    return networks;
}

#pragma mark - Payment methods section

- (NSArray<JPPaymentMethod *> *)paymentMethods {
    NSMutableArray *methods = [NSMutableArray new];

    if ([self.defaults boolForKey:kCardPaymentMethodEnabledKey]) {
        [methods addObject:JPPaymentMethod.card];
    }

    if ([self.defaults boolForKey:kApplePayPaymentMethodEnabledKey]) {
        [methods addObject:JPPaymentMethod.applePay];
    }

    if ([self.defaults boolForKey:kiDEALPaymentMethodEnabledKey]) {
        [methods addObject:JPPaymentMethod.iDeal];
    }

    return methods;
}

#pragma mark - Others section keys

- (BOOL)isAVSEnabled {
    return [self.defaults boolForKey:kAVSEnabledKey];
}

- (BOOL)shouldPaymentMethodsDisplayAmount {
    return [self.defaults boolForKey:kShouldPaymentMethodsDisplayAmount];
}

- (BOOL)shouldPaymentButtonDisplayAmount {
    return [self.defaults boolForKey:kShouldPaymentButtonDisplayAmount];
}

- (BOOL)shouldPaymentMethodsVerifySecurityCode {
    return [self.defaults boolForKey:kShouldPaymentMethodsVerifySecurityCode];
}

- (BOOL)isInitialRecurringPaymentEnabled {
    return [self.defaults boolForKey:kIsInitialRecurringPaymentKey];
}

- (BOOL)isDelayedAuthorisationOn {
    return [self.defaults boolForKey:kIsDelayedAuthorisationOnKey];
}

- (BOOL)shouldAskForCSC {
    return [self.defaults boolForKey:kShouldAskForCSCKey];
}

- (BOOL)shouldAskForCardholderName {
    return [self.defaults boolForKey:kShouldAskForCardholderNameKey];
}

- (JPAddress *)address {
    if (Settings.defaultSettings.isAddressOn) {
        NSNumber *addressCountryCode = @([self.defaults stringForKey:kAddressCountryCodeKey].intValue);
        NSString *state = [self.defaults stringForKey:kAddressStateKey];

        return [[JPAddress alloc] initWithAddress1:[self.defaults stringForKey:kAddressLine1Key]
                                          address2:[self.defaults stringForKey:kAddressLine2Key]
                                          address3:[self.defaults stringForKey:kAddressLine3Key]
                                              town:[self.defaults stringForKey:kAddressTownKey]
                                          postCode:[self.defaults stringForKey:kAddressPostCodeKey]
                                       countryCode:addressCountryCode
                                             state:state.length > 0 ? state : nil];
    }
    return nil;
}

- (JPPrimaryAccountDetails *)primaryAccountDetails {
    if (Settings.defaultSettings.isPrimaryAccountDetailsOn) {
        JPPrimaryAccountDetails *accountDetails = [JPPrimaryAccountDetails new];
        accountDetails.accountNumber = [self.defaults stringForKey:kPrimaryAccountAccountNumberKey];
        accountDetails.name = [self.defaults stringForKey:kPrimaryAccountNameKey];
        accountDetails.dateOfBirth = [self.defaults stringForKey:kPrimaryAccountDateOfBirthKey];
        accountDetails.postCode = [self.defaults stringForKey:kPrimaryAccountPostCodeKey];
        return accountDetails;
    }
    return nil;
}

- (NSString *)emailAddress {
    if (Settings.defaultSettings.isAddressOn) {
        return [self.defaults stringForKey:kAddressEmailAddressKey];
    }
    return nil;
}

- (NSString *)mobileNumber {
    if (Settings.defaultSettings.isAddressOn) {
        return [self.defaults stringForKey:kAddressMobileNumberKey];
    }
    return nil;
}

- (NSString *)phoneCountryCode {
    if (Settings.defaultSettings.isAddressOn) {
        return [self.defaults stringForKey:kAddressPhoneCountryCodeKey];
    }
    return nil;
}

#pragma mark - 3DS v2.0

- (BOOL)shouldAskForBillingInformation {
    return [self.defaults boolForKey:kShouldAskForBillingInformationKey];
}

- (NSString *)challengeRequestIndicator {
    NSString *value = [self.defaults stringForKey:kChallengeRequestIndicatorKey];
    return ([value isEqualToString:kDontSet]) ? nil : value;
}

- (NSString *)scaExemption {
    NSString *value = [self.defaults stringForKey:kScaExemptionKey];
    return ([value isEqualToString:kDontSet]) ? nil : value;
}

- (NSNumber *)timeoutForKey:(NSString *)key {
    NSString *timeout = [self.defaults stringForKey:key];
    NSInteger timeoutInSeconds = [timeout intValue] * 60;
    return timeoutInSeconds == 0 ? @(600) : @(timeoutInSeconds);
}

- (int)threeDsTwoMaxTimeout {
    NSString *timeout = [self.defaults stringForKey:kThreeDsTwoMaxTimeoutKey];
    return timeout.intValue;
}

- (NSString *)threeDSTwoMessageVersion {
    return safeString([self.defaults stringForKey:kThreeDSTwoMessageVersionKey]);
}

- (JP3DSUICustomization *)threeDSUICustomization {
    if ([self.defaults boolForKey:kIsThreeDSUICustomisationEnabledKey]) {
        JP3DSUICustomization *customization = [JP3DSUICustomization new];

        JP3DSLabelCustomization *labelCustomization = [JP3DSLabelCustomization new];
        NSString *font = [self.defaults stringForKey:kThreeDSLabelTextFontNameKey];
        [labelCustomization setTextFontName:font];
        [labelCustomization setTextColor:[self.defaults stringForKey:kThreeDSLabelTextColorKey]];
        [labelCustomization setTextFontSize:[self.defaults stringForKey:kThreeDSLabelTextFontSizeKey].integerValue];
        [labelCustomization setHeadingTextFontName:[self.defaults stringForKey:kThreeDSLabelHeadingTextFontNameKey]];
        [labelCustomization setHeadingTextColor:[self.defaults stringForKey:kThreeDSLabelHeadingTextColorKey]];
        [labelCustomization setHeadingTextFontSize:[self.defaults stringForKey:kThreeDSLabelHeadingTextFontSizeKey].integerValue];
        [customization setLabelCustomization:labelCustomization];

        JP3DSToolbarCustomization *toolbarCustomization = [JP3DSToolbarCustomization new];
        [toolbarCustomization setTextFontName:[self.defaults stringForKey:kThreeDSToolbarTextFontNameKey]];
        [toolbarCustomization setTextColor:[self.defaults stringForKey:kThreeDSToolbarTextColorKey]];
        [toolbarCustomization setTextFontSize:[self.defaults stringForKey:kThreeDSToolbarTextFontSizeKey].integerValue];
        [toolbarCustomization setBackgroundColor:[self.defaults stringForKey:kThreeDSToolbarBackgroundColorKey]];
        [toolbarCustomization setHeaderText:[self.defaults stringForKey:kThreeDSToolbarHeaderTextKey]];
        [toolbarCustomization setButtonText:[self.defaults stringForKey:kThreeDSToolbarButtonTextKey]];
        [customization setToolbarCustomization:toolbarCustomization];

        JP3DSTextBoxCustomization *textBoxCustomization = [JP3DSTextBoxCustomization new];
        [textBoxCustomization setTextFontName:[self.defaults stringForKey:kThreeDSTextBoxTextFontNameKey]];
        [textBoxCustomization setTextColor:[self.defaults stringForKey:kThreeDSTextBoxTextColorKey]];
        [textBoxCustomization setTextFontSize:[self.defaults stringForKey:kThreeDSTextBoxTextFontSizeKey].integerValue];
        [textBoxCustomization setBorderWidth:[self.defaults stringForKey:kThreeDSTextBoxBorderWidthKey].integerValue];
        [textBoxCustomization setBorderColor:[self.defaults stringForKey:kThreeDSTextBoxBorderColorKey]];
        [textBoxCustomization setCornerRadius:[self.defaults stringForKey:kThreeDSTextBoxCornerRadiusKey].integerValue];
        [customization setTextBoxCustomization:textBoxCustomization];

        JP3DSButtonCustomization *submitCustomization = [JP3DSButtonCustomization new];
        [submitCustomization setTextFontName:[self.defaults stringForKey:kThreeDSSubmitButtonTextFontNameKey]];
        [submitCustomization setTextColor:[self.defaults stringForKey:kThreeDSSubmitButtonTextColorKey]];
        [submitCustomization setTextFontSize:[self.defaults stringForKey:kThreeDSSubmitButtonTextFontSizeKey].integerValue];
        [submitCustomization setBackgroundColor:[self.defaults stringForKey:kThreeDSSubmitButtonBackgroundColorKey]];
        [submitCustomization setCornerRadius:[self.defaults stringForKey:kThreeDSSubmitButtonCornerRadiusKey].integerValue];
        [customization setButtonCustomization:submitCustomization ofType:JP3DSButtonTypeSubmit];

        JP3DSButtonCustomization *nextCustomization = [JP3DSButtonCustomization new];
        [nextCustomization setTextFontName:[self.defaults stringForKey:kThreeDSNextButtonTextFontNameKey]];
        [nextCustomization setTextColor:[self.defaults stringForKey:kThreeDSNextButtonTextColorKey]];
        [nextCustomization setTextFontSize:[self.defaults stringForKey:kThreeDSNextButtonTextFontSizeKey].integerValue];
        [nextCustomization setBackgroundColor:[self.defaults stringForKey:kThreeDSNextButtonBackgroundColorKey]];
        [nextCustomization setCornerRadius:[self.defaults stringForKey:kThreeDSNextButtonCornerRadiusKey].integerValue];
        [customization setButtonCustomization:nextCustomization ofType:JP3DSButtonTypeNext];

        JP3DSButtonCustomization *cancelCustomization = [JP3DSButtonCustomization new];
        [cancelCustomization setTextFontName:[self.defaults stringForKey:kThreeDSCancelButtonTextFontNameKey]];
        [cancelCustomization setTextColor:[self.defaults stringForKey:kThreeDSCancelButtonTextColorKey]];
        [cancelCustomization setTextFontSize:[self.defaults stringForKey:kThreeDSCancelButtonTextFontSizeKey].integerValue];
        [cancelCustomization setBackgroundColor:[self.defaults stringForKey:kThreeDSCancelButtonBackgroundColorKey]];
        [cancelCustomization setCornerRadius:[self.defaults stringForKey:kThreeDSCancelButtonCornerRadiusKey].integerValue];
        [customization setButtonCustomization:cancelCustomization ofType:JP3DSButtonTypeCancel];

        JP3DSButtonCustomization *continueCustomization = [JP3DSButtonCustomization new];
        [continueCustomization setTextFontName:[self.defaults stringForKey:kThreeDSContinueButtonTextFontNameKey]];
        [continueCustomization setTextColor:[self.defaults stringForKey:kThreeDSContinueButtonTextColorKey]];
        [continueCustomization setTextFontSize:[self.defaults stringForKey:kThreeDSContinueButtonTextFontSizeKey].integerValue];
        [continueCustomization setBackgroundColor:[self.defaults stringForKey:kThreeDSContinueButtonBackgroundColorKey]];
        [continueCustomization setCornerRadius:[self.defaults stringForKey:kThreeDSContinueButtonCornerRadiusKey].integerValue];
        [customization setButtonCustomization:continueCustomization ofType:JP3DSButtonTypeContinue];

        JP3DSButtonCustomization *resendCustomization = [JP3DSButtonCustomization new];
        [resendCustomization setTextFontName:[self.defaults stringForKey:kThreeDSResendButtonTextFontNameKey]];
        [resendCustomization setTextColor:[self.defaults stringForKey:kThreeDSResendButtonTextColorKey]];
        [resendCustomization setTextFontSize:[self.defaults stringForKey:kThreeDSResendButtonTextFontSizeKey].integerValue];
        [resendCustomization setBackgroundColor:[self.defaults stringForKey:kThreeDSResendButtonBackgroundColorKey]];
        [resendCustomization setCornerRadius:[self.defaults stringForKey:kThreeDSResendButtonCornerRadiusKey].integerValue];
        [customization setButtonCustomization:resendCustomization ofType:JP3DSButtonTypeResend];

        return customization;
    }

    return nil;
}

#pragma mark - Recommendation Feature

- (NSString *)rsaKey {
    if (Settings.defaultSettings.isRecommendationFeatureOn) {
        return [self.defaults stringForKey:kRsaKey];
    }
    return nil;
}

- (NSString *)recommendationUrl {
    if (Settings.defaultSettings.isRecommendationFeatureOn) {
        return [self.defaults stringForKey:kRecommendationUrlKey];
    }
    return nil;
}

- (NSNumber *)recommendationTimeout {
    if (Settings.defaultSettings.isRecommendationFeatureOn) {
        return [self timeoutForKey:kRecommendationApiTimeoutKey];
    }
    return nil;
}

#pragma mark - Network Timeouts

- (NSNumber *)connectTimeout {
    return [self timeoutForKey:kConnectTimeoutKey];
}

- (NSNumber *)readTimeout {
    return [self timeoutForKey:kReadTimeoutKey];
}

- (NSNumber *)writeTimeout {
    return [self timeoutForKey:kWriteTimeoutKey];
}

- (void)updateAuthorizationWithPaymentSession:(NSString *)session
                                     andToken:(NSString *)token {
    [self.defaults setValue:session forKey:kPaymentSessionKey];
    [self.defaults setValue:token forKey:kSessionTokenKey];
}

@end
