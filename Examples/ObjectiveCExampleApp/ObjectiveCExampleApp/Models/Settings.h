#import <Foundation/Foundation.h>
@import JudoKit_iOS;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API credentials section keys

static NSString *const kSandboxedKey = @"is_sandboxed";
static NSString *const kJudoIdKey = @"judo_id";

#pragma mark - Authorization section keys

static NSString *const kIsTokenAndSecretOnKey = @"is_token_and_secret_on";
static NSString *const kIsPaymentSessionOnKey = @"is_payment_session_on";

static NSString *const kTokenKey = @"token";
static NSString *const kSecretKey = @"secret";

static NSString *const kSessionTokenKey = @"session_token";
static NSString *const kPaymentSessionKey = @"payment_session";

#pragma mark - Reference section keys
static NSString *const kPaymentReferenceKey = @"payment_reference";
static NSString *const kConsumerReferenceKey = @"consumer_reference";

#pragma mark - Amount section keys

static NSString *const kAmountKey = @"amount";
static NSString *const kCurrencyKey = @"currency";

#pragma mark - Apple Pay section keys

static NSString *const kMerchantIdKey = @"apple_pay_merchant_id";

#pragma mark - Supported card networks section keys

static NSString *const kVisaEnabledKey = @"is_card_network_visa_enabled";
static NSString *const kMasterCardEnabledKey = @"is_card_network_master_card_enabled";
static NSString *const kMaestroEnabledKey = @"is_card_network_maestro_enabled";
static NSString *const kAMEXEnabledKey = @"is_card_network_amex_enabled";
static NSString *const kChinaUnionPayEnabledKey = @"is_card_network_china_union_pay_enabled";
static NSString *const kJCBEnabledKey = @"is_card_network_jcb_enabled";
static NSString *const kDiscoverEnabledKey = @"is_card_network_discover_enabled";
static NSString *const kDinersClubEnabledKey = @"is_card_network_diners_club_enabled";
static NSString *const kPbbaPaymentMethodEnabledKey = @"is_payment_method_pbba_enabled";

#pragma mark - Payment methods section keys

static NSString *const kCardPaymentMethodEnabledKey = @"is_payment_method_card_enabled";
static NSString *const kiDEALPaymentMethodEnabledKey = @"is_payment_method_ideal_enabled";
static NSString *const kApplePayPaymentMethodEnabledKey = @"is_payment_method_apple_pay_enabled";

#pragma mark - Others section keys

static NSString *const kAVSEnabledKey = @"is_avs_enabled";
static NSString *const kShouldPaymentMethodsDisplayAmount = @"should_payment_methods_display_amount";
static NSString *const kShouldPaymentButtonDisplayAmount = @"should_payment_button_display_amount";
static NSString *const kShouldPaymentMethodsVerifySecurityCode = @"should_ask_security_code";
static NSString *const kIsInitialRecurringPaymentKey = @"is_initial_recurring_payment";

#pragma mark - Address section keys

static NSString *const kCardAddress1 = @"card_address_1";
static NSString *const kCardAddress2 = @"card_address_2";
static NSString *const kCardAddressTown = @"card_address_town";
static NSString *const kCardAddressPostCode = @"card_address_post_code";
static NSString *const kCardAddressCountryCode = @"card_address_country_code";
static NSString *const kCardHolderEmailAddress = @"card_holder_email_address";
static NSString *const kCardHolderMobileNumber = @"card_holder_mobile_number";

@interface Settings : NSObject

+ (instancetype)defaultSettings;

- (instancetype)initWith:(NSUserDefaults *)defaults;

#pragma mark - API credentials section

- (BOOL)isSandboxed;

- (NSString *)judoId;

#pragma mark - Authorization

- (id<JPAuthorization>)authorization;

@property (nonatomic, assign) BOOL isTokenAndSecretAuthorizationOn;
@property (nonatomic, assign) BOOL isPaymentSessionAuthorizationOn;

#pragma mark - Payment reference section

- (JPReference *)reference;

#pragma mark - Amount section

- (JPAmount *)amount;

#pragma mark - Apple Pay section

- (NSString *)applePayMerchantId;

#pragma mark - Supported card networks section

- (JPCardNetworkType)supportedCardNetworks;

#pragma mark - Payment methods section

- (NSArray<JPPaymentMethod *> *)paymentMethods;

#pragma mark - Others section keys

- (BOOL)isAVSEnabled;
- (BOOL)shouldPaymentMethodsDisplayAmount;
- (BOOL)shouldPaymentButtonDisplayAmount;
- (BOOL)shouldPaymentMethodsVerifySecurityCode;
- (BOOL)isInitialRecurringPaymentEnabled;

#pragma mark - Card Address

- (nullable JPAddress *)cardAddress;

#pragma mark - Card Holder Contacts

- (nullable NSString *)emailAddress;

- (nullable NSString *)mobileNumber;

@end

NS_ASSUME_NONNULL_END
