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
static NSString *const kIsAddressOnKey = @"is_address_enabled";
static NSString *const kIsPrimaryAccountDetailsOnKey = @"is_primary_account_details_enabled";

static NSString *const kAddressLine1Key = @"address_line_1";
static NSString *const kAddressLine2Key = @"address_line_2";
static NSString *const kAddressLine3Key = @"address_line_3";
static NSString *const kAddressTownKey = @"address_town";
static NSString *const kAddressPostCodeKey = @"address_post_code";
static NSString *const kAddressCountryCodeKey = @"address_country_code";
static NSString *const kAddressStateKey = @"address_state";
static NSString *const kAddressPhoneCountryCodeKey = @"address_phone_country_code";
static NSString *const kAddressMobileNumberKey = @"address_mobile_number";
static NSString *const kAddressEmailAddressKey = @"address_email_address";

static NSString *const kPrimaryAccountNameKey = @"primary_account_name";
static NSString *const kPrimaryAccountAccountNumberKey = @"primary_account_account_number";
static NSString *const kPrimaryAccountDateOfBirthKey = @"primary_account_date_of_birth";
static NSString *const kPrimaryAccountPostCodeKey = @"primary_account_post_code";

#pragma mark - Recommendation Feature section keys
static NSString *const kIsRecommendationOnKey = @"is_recommendation_enabled";
static NSString *const kRsaKey = @"rsa_key";
static NSString *const kRecommendationUrlKey = @"recommendation_url";
static NSString *const kRecommendationApiTimeoutKey = @"recommendation_api_timeout";

#pragma mark - 3DS 2.0 section keys

static NSString *const kShouldAskForBillingInformationKey = @"should_ask_for_billing_information";
static NSString *const kChallengeRequestIndicatorKey = @"challenge_request_indicator";
static NSString *const kScaExemptionKey = @"sca_exemption";
static NSString *const kThreeDsTwoMaxTimeoutKey = @"three_ds_two_max_timeout";
static NSString *const kConnectTimeoutKey = @"connect_timeout";
static NSString *const kReadTimeoutKey = @"read_timeout";
static NSString *const kWriteTimeoutKey = @"write_timeout";
static NSString *const kThreeDSTwoMessageVersionKey = @"three_ds_two_message_version";

static NSString *const kIsThreeDSUICustomisationEnabledKey = @"three_ds_is_ui_customisation_enabled";

static NSString *const kThreeDSToolbarTextFontNameKey = @"three_ds_toolbar_text_font_name";
static NSString *const kThreeDSToolbarTextColorKey = @"three_ds_toolbar_text_color";
static NSString *const kThreeDSToolbarTextFontSizeKey = @"three_ds_toolbar_text_font_size";
static NSString *const kThreeDSToolbarBackgroundColorKey = @"three_ds_toolbar_background_color";
static NSString *const kThreeDSToolbarHeaderTextKey = @"three_ds_toolbar_header_text";
static NSString *const kThreeDSToolbarButtonTextKey = @"three_ds_toolbar_button_text";

static NSString *const kThreeDSLabelTextFontNameKey = @"three_ds_label_text_font_name";
static NSString *const kThreeDSLabelTextColorKey = @"three_ds_label_text_color";
static NSString *const kThreeDSLabelTextFontSizeKey = @"three_ds_label_text_font_size";
static NSString *const kThreeDSLabelHeadingTextFontNameKey = @"three_ds_label_heading_text_font_name";
static NSString *const kThreeDSLabelHeadingTextColorKey = @"three_ds_label_heading_text_color";
static NSString *const kThreeDSLabelHeadingTextFontSizeKey = @"three_ds_label_heading_text_font_size";

static NSString *const kThreeDSTextBoxTextFontNameKey = @"three_ds_text_box_text_font_name";
static NSString *const kThreeDSTextBoxTextColorKey = @"three_ds_text_box_text_color";
static NSString *const kThreeDSTextBoxTextFontSizeKey = @"three_ds_text_box_text_font_size";
static NSString *const kThreeDSTextBoxBorderWidthKey = @"three_ds_text_box_border_width";
static NSString *const kThreeDSTextBoxBorderColorKey = @"three_ds_text_box_border_color";
static NSString *const kThreeDSTextBoxCornerRadiusKey = @"three_ds_text_box_corner_radius";

static NSString *const kThreeDSSubmitButtonTextFontNameKey = @"three_ds_submit_button_text_font_name";
static NSString *const kThreeDSSubmitButtonTextColorKey = @"three_ds_submit_button_text_color";
static NSString *const kThreeDSSubmitButtonTextFontSizeKey = @"three_ds_submit_button_text_font_size";
static NSString *const kThreeDSSubmitButtonBackgroundColorKey = @"three_ds_submit_button_background_color";
static NSString *const kThreeDSSubmitButtonCornerRadiusKey = @"three_ds_submit_button_corner_radius";

static NSString *const kThreeDSNextButtonTextFontNameKey = @"three_ds_next_button_text_font_name";
static NSString *const kThreeDSNextButtonTextColorKey = @"three_ds_next_button_text_color";
static NSString *const kThreeDSNextButtonTextFontSizeKey = @"three_ds_next_button_text_font_size";
static NSString *const kThreeDSNextButtonBackgroundColorKey = @"three_ds_next_button_background_color";
static NSString *const kThreeDSNextButtonCornerRadiusKey = @"three_ds_next_button_corner_radius";

static NSString *const kThreeDSContinueButtonTextFontNameKey = @"three_ds_continue_button_text_font_name";
static NSString *const kThreeDSContinueButtonTextColorKey = @"three_ds_continue_button_text_color";
static NSString *const kThreeDSContinueButtonTextFontSizeKey = @"three_ds_continue_button_text_font_size";
static NSString *const kThreeDSContinueButtonBackgroundColorKey = @"three_ds_continue_button_background_color";
static NSString *const kThreeDSContinueButtonCornerRadiusKey = @"three_ds_continue_button_corner_radius";

static NSString *const kThreeDSCancelButtonTextFontNameKey = @"three_ds_cancel_button_text_font_name";
static NSString *const kThreeDSCancelButtonTextColorKey = @"three_ds_cancel_button_text_color";
static NSString *const kThreeDSCancelButtonTextFontSizeKey = @"three_ds_cancel_button_text_font_size";
static NSString *const kThreeDSCancelButtonBackgroundColorKey = @"three_ds_cancel_button_background_color";
static NSString *const kThreeDSCancelButtonCornerRadiusKey = @"three_ds_cancel_button_corner_radius";

static NSString *const kThreeDSResendButtonTextFontNameKey = @"three_ds_resend_button_text_font_name";
static NSString *const kThreeDSResendButtonTextColorKey = @"three_ds_resend_button_text_color";
static NSString *const kThreeDSResendButtonTextFontSizeKey = @"three_ds_resend_button_text_font_size";
static NSString *const kThreeDSResendButtonBackgroundColorKey = @"three_ds_resend_button_background_color";
static NSString *const kThreeDSResendButtonCornerRadiusKey = @"three_ds_resend_button_corner_radius";

#pragma mark - Reference section keys

static NSString *const kPaymentReferenceKey = @"payment_reference";
static NSString *const kConsumerReferenceKey = @"consumer_reference";

#pragma mark - Amount section keys

static NSString *const kAmountKey = @"amount";
static NSString *const kCurrencyKey = @"currency";

#pragma mark - Apple Pay section keys

static NSString *const kMerchantIdKey = @"apple_pay_merchant_id";

static NSString *const kIsApplePayBillingContactInfoRequired = @"is_apple_pay_billing_contact_info_required";
static NSString *const kIsApplePayShippingContactInfoRequired = @"is_apple_pay_shipping_contact_info_required";

static NSString *const kIsBillingContactFieldPostalAddressRequiredKey = @"is_billing_contact_field_postal_address_required";
static NSString *const kIsBillingContactFieldPhoneRequiredKey = @"is_billing_contact_field_phone_required";
static NSString *const kIsBillingContactFieldEmailRequiredKey = @"is_billing_contact_field_email_required";
static NSString *const kIsBillingContactFieldNameRequiredKey = @"is_billing_contact_field_name_required";

static NSString *const kIsShippingContactFieldPostalAddressRequiredKey = @"is_shipping_contact_field_postal_address_required";
static NSString *const kIsShippingContactFieldPhoneRequiredKey = @"is_shipping_contact_field_phone_required";
static NSString *const kIsShippingContactFieldEmailRequiredKey = @"is_shipping_contact_field_email_required";
static NSString *const kIsShippingContactFieldNameRequiredKey = @"is_shipping_contact_field_name_required";

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
static NSString *const kIsDelayedAuthorisationOnKey = @"is_delayed_authorisation_on";
static NSString *const kShouldAskForCSCKey = @"should_ask_for_csc";
static NSString *const kShouldAskForCardholderNameKey = @"should_ask_for_cardholder_name";

@class JP3DSUICustomization;

@interface Settings : NSObject

+ (instancetype)defaultSettings;

- (instancetype)initWith:(NSUserDefaults *)defaults;

#pragma mark - API credentials section

- (BOOL)isSandboxed;

- (NSString *)judoId;

#pragma mark - Authorization

- (id<JPAuthorization>)authorization;

@property (nonatomic, assign) BOOL isTokenAndSecretAuthorizationOn;
@property (nonatomic, assign) BOOL isRecommendationFeatureOn;
@property (nonatomic, assign) BOOL isPaymentSessionAuthorizationOn;

#pragma mark - Payment reference section

- (JPReference *)reference;

#pragma mark - Amount section

- (JPAmount *)amount;

#pragma mark - Apple Pay section

- (NSString *)applePayMerchantId;

- (JPReturnedInfo)applePayReturnedContactInfo;
- (JPContactField)applePayBillingContactFields;
- (JPContactField)applePayShippingContactFields;

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
- (BOOL)isRecommendationFeatureOn;
- (BOOL)isAddressOn;
- (BOOL)isPrimaryAccountDetailsOn;
- (BOOL)isDelayedAuthorisationOn;
- (BOOL)shouldAskForCSC;
- (BOOL)shouldAskForCardholderName;

#pragma mark - Card Address

- (JPAddress *)address;

- (JPPrimaryAccountDetails *)primaryAccountDetails;

- (nullable NSString *)emailAddress;
- (nullable NSString *)phoneCountryCode;
- (nullable NSString *)mobileNumber;

#pragma mark - 3DS v2.0

- (BOOL)shouldAskForBillingInformation;
- (nullable NSString *)challengeRequestIndicator;
- (nullable NSString *)scaExemption;
- (int)threeDsTwoMaxTimeout;
- (nullable NSString *)threeDSTwoMessageVersion;
- (nullable JP3DSUICustomization *)threeDSUICustomization;
- (nonnull NSNumber *)connectTimeout;
- (nonnull NSNumber *)readTimeout;
- (nonnull NSNumber *)writeTimeout;

#pragma mark - Recommendation Feature
- (NSString *)rsaKey;
- (NSString *)recommendationUrl;
- (NSNumber *)recommendationTimeout;

@end

NS_ASSUME_NONNULL_END
