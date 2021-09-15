#import "Settings.h"

static NSString *const kDefaultConsumerReference = @"my-unique-consumer-ref";

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

- (void)setIsPaymentSessionAuthorizationOn:(BOOL)isOn {
    [self.defaults setBool:isOn forKey:kIsPaymentSessionOnKey];
}

- (void)setIsTokenAndSecretAuthorizationOn:(BOOL)isOn {
    [self.defaults setBool:isOn forKey:kIsTokenAndSecretOnKey];
}

- (BOOL)isTokenAndSecretAuthorizationOn {
    return [self.defaults boolForKey:kIsTokenAndSecretOnKey];
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
    reference.metaData = @{@"exampleMetaKey" : @{@"exampleSubMetaKey" : @"exampleSubMetaValue"}};

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

    if ([self.defaults boolForKey:kPbbaPaymentMethodEnabledKey]) {
        [methods addObject:JPPaymentMethod.pbba];
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

- (JPAddress *)address {
    if (Settings.defaultSettings.isAddressOn) {
        return [[JPAddress alloc] initWithLine1:[self.defaults stringForKey:kAddressLine1Key]
                                          line2:[self.defaults stringForKey:kAddressLine2Key]
                                          line3:[self.defaults stringForKey:kAddressLine3Key]
                                           town:[self.defaults stringForKey:kAddressTownKey]
                                    countryCode:[self.defaults stringForKey:kAddressBillingCountryKey]
                                       postCode:[self.defaults stringForKey:kAddressPostCodeKey]];
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

@end
