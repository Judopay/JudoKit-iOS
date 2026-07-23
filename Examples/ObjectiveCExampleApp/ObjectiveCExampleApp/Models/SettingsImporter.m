//
//  SettingsImporter.m
//  ObjectiveCExampleApp
//
//  Copyright (c) 2026 Alternative Payments Ltd
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

#import "SettingsImporter.h"
#import "Settings.h"

// JSON-dialect keys shared with the Android example app; they do not map 1:1
// onto stored settings keys and are translated on import/export.
static NSString *const kPaymentSessionEnabledJsonKey = @"is_payment_session_enabled";
static NSString *const kSupportedNetworksJsonKey = @"supported_networks";
static NSString *const kPaymentMethodsJsonKey = @"payment_methods";

@implementation SettingsImporter

+ (BOOL)importSettings:(NSString *)json
            intoDefaults:(NSUserDefaults *)defaults
                   error:(NSError **)error {
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        if (error) {
            *error = [NSError errorWithDomain:@"SettingsImporter"
                                         code:1
                                     userInfo:@{ NSLocalizedDescriptionKey: @"The provided text is not valid UTF-8." }];
        }
        return NO;
    }

    NSError *parseError = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    if (parseError) {
        if (error) {
            *error = parseError;
        }
        return NO;
    }

    if (![object isKindOfClass:NSDictionary.class]) {
        if (error) {
            *error = [NSError errorWithDomain:@"SettingsImporter"
                                         code:2
                                     userInfo:@{ NSLocalizedDescriptionKey: @"Expected a JSON object at the root." }];
        }
        return NO;
    }

    NSDictionary *root = (NSDictionary *)object;
    [root enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if ([value isKindOfClass:NSDictionary.class]) {
            [(NSDictionary *)value enumerateKeysAndObjectsUsingBlock:^(id childKey, id childValue, BOOL *innerStop) {
                [self applyLeaf:childValue forKey:childKey intoDefaults:defaults];
            }];
        } else {
            [self applyLeaf:value forKey:key intoDefaults:defaults];
        }
    }];

    return YES;
}

+ (NSDictionary<NSString *, NSString *> *)cardNetworkKeysByValue {
    return @{
        @"VISA": kVisaEnabledKey,
        @"MASTERCARD": kMasterCardEnabledKey,
        @"MAESTRO": kMaestroEnabledKey,
        @"AMEX": kAMEXEnabledKey,
        @"CHINA_UNION_PAY": kChinaUnionPayEnabledKey,
        @"JCB": kJCBEnabledKey,
        @"DISCOVER": kDiscoverEnabledKey,
        @"DINERS_CLUB": kDinersClubEnabledKey
    };
}

+ (NSDictionary<NSString *, NSString *> *)challengeRequestIndicatorImportValues {
    return @{
        @"DON_T_SET": @"dontSet",
        @"NO_PREFERENCE": @"noPreference",
        @"NO_CHALLENGE": @"noChallenge",
        @"CHALLENGE_PREFERRED": @"challengePreferred",
        @"CHALLENGE_AS_MANDATE": @"challengeAsMandate"
    };
}

+ (NSDictionary<NSString *, NSString *> *)scaExemptionImportValues {
    return @{
        @"DON_T_SET": @"dontSet",
        @"LOW_VALUE": @"lowValue",
        @"SECURE_CORPORATE": @"secureCorporate",
        @"TRUSTED_BENEFICIARY": @"trustedBeneficiary",
        @"TRANSACTION_RISK_ANALYSIS": @"transactionRiskAnalysis"
    };
}

+ (NSString *)storedValueForKey:(NSString *)key value:(NSString *)value {
    if ([key isEqualToString:kChallengeRequestIndicatorKey]) {
        return [self challengeRequestIndicatorImportValues][value] ?: value;
    }
    if ([key isEqualToString:kScaExemptionKey]) {
        return [self scaExemptionImportValues][value] ?: value;
    }
    return value;
}

+ (void)applyLeaf:(id)value forKey:(NSString *)rawKey intoDefaults:(NSUserDefaults *)defaults {
    if ([rawKey isEqualToString:kPaymentSessionEnabledJsonKey]) {
        if (value == (id)kCFBooleanTrue || value == (id)kCFBooleanFalse) {
            BOOL isOn = [value boolValue];
            [defaults setBool:isOn forKey:kIsPaymentSessionOnKey];
            [defaults setBool:!isOn forKey:kIsTokenAndSecretOnKey];
        }
        return;
    }

    if ([rawKey isEqualToString:kSupportedNetworksJsonKey] && [value isKindOfClass:NSArray.class]) {
        [self applyCardNetworks:value intoDefaults:defaults];
        return;
    }

    if ([rawKey isEqualToString:kPaymentMethodsJsonKey] && [value isKindOfClass:NSArray.class]) {
        [self applyPaymentMethods:value intoDefaults:defaults];
        return;
    }

    if ([value isKindOfClass:NSArray.class]) {
        NSMutableArray<NSString *> *strings = [NSMutableArray new];
        for (id element in (NSArray *)value) {
            if (element == NSNull.null) {
                continue;
            }
            [strings addObject:[NSString stringWithFormat:@"%@", element]];
        }
        [defaults setObject:strings forKey:rawKey];
    } else if (value == (id)kCFBooleanTrue || value == (id)kCFBooleanFalse) {
        [defaults setBool:[value boolValue] forKey:rawKey];
    } else if ([value isKindOfClass:NSNumber.class]) {
        [defaults setObject:[(NSNumber *)value stringValue] forKey:rawKey];
    } else if ([value isKindOfClass:NSString.class]) {
        NSString *storedValue = [self storedValueForKey:rawKey value:(NSString *)value];
        [defaults setObject:storedValue forKey:rawKey];
    }
}

+ (void)applyCardNetworks:(NSArray *)values intoDefaults:(NSUserDefaults *)defaults {
    NSMutableSet<NSString *> *selected = [NSMutableSet new];
    for (id element in values) {
        [selected addObject:[[NSString stringWithFormat:@"%@", element] uppercaseString]];
    }
    [[self cardNetworkKeysByValue] enumerateKeysAndObjectsUsingBlock:^(NSString *value, NSString *key, BOOL *stop) {
        [defaults setBool:[selected containsObject:value] forKey:key];
    }];
}

+ (void)applyPaymentMethods:(NSArray *)values intoDefaults:(NSUserDefaults *)defaults {
    NSMutableSet<NSString *> *selected = [NSMutableSet new];
    for (id element in values) {
        [selected addObject:[[NSString stringWithFormat:@"%@", element] uppercaseString]];
    }
    [defaults setBool:[selected containsObject:@"CARD"] forKey:kCardPaymentMethodEnabledKey];
    [defaults setBool:([selected containsObject:@"APPLE_PAY"] || [selected containsObject:@"GOOGLE_PAY"])
               forKey:kApplePayPaymentMethodEnabledKey];
}

#pragma mark - Export

// Section layout mirrors SettingsImporter.SECTIONS in the Android example app
// so both platforms produce the same JSON structure for shared fixtures.
+ (NSArray<NSArray *> *)sections {
    return @[
        @[ @"api", @[
            kSandboxedKey,
            kIsUsingFabrick3DSServiceKey,
            kJudoIdKey,
            kTokenKey,
            kSecretKey,
            kPaymentSessionEnabledJsonKey,
            kPaymentSessionKey,
            kSessionTokenKey,
            kPaymentReferenceKey,
            kConsumerReferenceKey
        ] ],
        @[ @"recommendation", @[
            kIsRecommendationOnKey,
            kRecommendationUrlKey,
            kRsaKey,
            kRecommendationTimeoutKey,
            kIsRecommendationHaltTransactionOnKey
        ] ],
        @[ @"three_ds", @[
            kShouldAskForBillingInformationKey,
            kChallengeRequestIndicatorKey,
            kScaExemptionKey,
            kThreeDsTwoMaxTimeoutKey,
            kConnectTimeoutKey,
            kReadTimeoutKey,
            kWriteTimeoutKey,
            kThreeDSTwoMessageVersionKey
        ] ],
        @[ @"three_ds_ui_customisation", @[
            kIsThreeDSUICustomisationEnabledKey,
            kThreeDSToolbarTextFontNameKey,
            kThreeDSToolbarTextColorKey,
            kThreeDSToolbarTextFontSizeKey,
            kThreeDSToolbarBackgroundColorKey,
            kThreeDSToolbarHeaderTextKey,
            kThreeDSToolbarButtonTextKey,
            kThreeDSLabelTextFontNameKey,
            kThreeDSLabelTextColorKey,
            kThreeDSLabelTextFontSizeKey,
            kThreeDSLabelHeadingTextFontNameKey,
            kThreeDSLabelHeadingTextColorKey,
            kThreeDSLabelHeadingTextFontSizeKey,
            kThreeDSTextBoxTextFontNameKey,
            kThreeDSTextBoxTextColorKey,
            kThreeDSTextBoxTextFontSizeKey,
            kThreeDSTextBoxBorderWidthKey,
            kThreeDSTextBoxBorderColorKey,
            kThreeDSTextBoxCornerRadiusKey,
            kThreeDSSubmitButtonTextFontNameKey,
            kThreeDSSubmitButtonTextColorKey,
            kThreeDSSubmitButtonTextFontSizeKey,
            kThreeDSSubmitButtonBackgroundColorKey,
            kThreeDSSubmitButtonCornerRadiusKey,
            kThreeDSNextButtonTextFontNameKey,
            kThreeDSNextButtonTextColorKey,
            kThreeDSNextButtonTextFontSizeKey,
            kThreeDSNextButtonBackgroundColorKey,
            kThreeDSNextButtonCornerRadiusKey,
            kThreeDSContinueButtonTextFontNameKey,
            kThreeDSContinueButtonTextColorKey,
            kThreeDSContinueButtonTextFontSizeKey,
            kThreeDSContinueButtonBackgroundColorKey,
            kThreeDSContinueButtonCornerRadiusKey,
            kThreeDSCancelButtonTextFontNameKey,
            kThreeDSCancelButtonTextColorKey,
            kThreeDSCancelButtonTextFontSizeKey,
            kThreeDSCancelButtonBackgroundColorKey,
            kThreeDSCancelButtonCornerRadiusKey,
            kThreeDSResendButtonTextFontNameKey,
            kThreeDSResendButtonTextColorKey,
            kThreeDSResendButtonTextFontSizeKey,
            kThreeDSResendButtonBackgroundColorKey,
            kThreeDSResendButtonCornerRadiusKey
        ] ],
        @[ @"amount", @[
            kAmountKey,
            kCurrencyKey
        ] ],
        @[ @"address", @[
            kIsAddressOnKey,
            kAddressLine1Key,
            kAddressLine2Key,
            kAddressLine3Key,
            kAddressTownKey,
            kAddressPostCodeKey,
            kAddressCountryCodeKey,
            kAddressAdministrativeDivisionKey,
            kAddressPhoneCountryCodeKey,
            kAddressMobileNumberKey,
            kAddressEmailAddressKey
        ] ],
        @[ @"primary_account", @[
            kIsPrimaryAccountDetailsOnKey,
            kPrimaryAccountNameKey,
            kPrimaryAccountAccountNumberKey,
            kPrimaryAccountDateOfBirthKey,
            kPrimaryAccountPostCodeKey
        ] ],
        @[ @"apple_pay", @[
            kMerchantIdKey,
            kIsApplePayBillingContactInfoRequired,
            kIsApplePayShippingContactInfoRequired,
            kIsBillingContactFieldPostalAddressRequiredKey,
            kIsBillingContactFieldPhoneRequiredKey,
            kIsBillingContactFieldEmailRequiredKey,
            kIsBillingContactFieldNameRequiredKey,
            kIsShippingContactFieldPostalAddressRequiredKey,
            kIsShippingContactFieldPhoneRequiredKey,
            kIsShippingContactFieldEmailRequiredKey,
            kIsShippingContactFieldNameRequiredKey,
            kIsRecurringPaymentOnKey,
            kRecurringPaymentDescriptionKey,
            kRecurringPaymentBillingAgreementKey,
            kRecurringPaymentManagementUrlKey,
            kRecurringPaymentLabelKey,
            kRecurringPaymentAmountKey,
            kRecurringPaymentIntervalUnitKey,
            kRecurringPaymentIntervalCountKey,
            kRecurringPaymentStartDateKey,
            kRecurringPaymentEndDateKey,
            kIsAutomaticReloadPaymentOnKey,
            kAutomaticReloadPaymentDescriptionKey,
            kAutomaticReloadPaymentBillingAgreementKey,
            kAutomaticReloadPaymentManagementUrlKey,
            kAutomaticReloadPaymentLabelKey,
            kAutomaticReloadPaymentAmountKey,
            kAutomaticReloadPaymentThresholdAmountKey,
            kIsDeferredPaymentOnKey,
            kDeferredPaymentDescriptionKey,
            kDeferredPaymentBillingAgreementKey,
            kDeferredPaymentManagementUrlKey,
            kDeferredPaymentLabelKey,
            kDeferredPaymentAmountKey,
            kDeferredPaymentDeferredDateKey,
            kDeferredPaymentFreeCancellationDateKey
        ] ],
        @[ @"others", @[
            kAVSEnabledKey,
            kShouldPaymentMethodsDisplayAmount,
            kShouldPaymentButtonDisplayAmount,
            kIsInitialRecurringPaymentKey,
            kIsDelayedAuthorisationOnKey,
            kIsAllowIncrementOnKey,
            kIsDisableNetworkTokenisationOnKey,
            kSupportedNetworksJsonKey,
            kPaymentMethodsJsonKey
        ] ],
        @[ @"token_payments", @[
            kShouldAskForCSCKey,
            kShouldAskForCardholderNameKey
        ] ]
    ];
}

+ (NSDictionary<NSString *, NSString *> *)paymentMethodKeysByValue {
    return @{
        @"CARD": kCardPaymentMethodEnabledKey,
        @"APPLE_PAY": kApplePayPaymentMethodEnabledKey
    };
}

+ (NSDictionary<NSString *, NSString *> *)invertedDictionary:(NSDictionary<NSString *, NSString *> *)dictionary {
    NSMutableDictionary<NSString *, NSString *> *inverted = [NSMutableDictionary new];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        inverted[value] = key;
    }];
    return inverted;
}

+ (NSString *)exportSettingsFromDefaults:(NSUserDefaults *)defaults {
    NSMutableDictionary *root = [NSMutableDictionary new];

    for (NSArray *section in [self sections]) {
        NSString *name = section[0];
        NSMutableDictionary *values = [NSMutableDictionary new];
        for (NSString *key in section[1]) {
            id value = [self exportValueForKey:key fromDefaults:defaults];
            if (value) {
                values[key] = value;
            }
        }
        if (values.count > 0) {
            root[name] = values;
        }
    }

    NSData *data = [NSJSONSerialization dataWithJSONObject:root
                                                   options:NSJSONWritingPrettyPrinted | NSJSONWritingSortedKeys
                                                     error:nil];
    NSString *json = data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil;
    return json ?: @"{}";
}

+ (id)exportValueForKey:(NSString *)key fromDefaults:(NSUserDefaults *)defaults {
    if ([key isEqualToString:kPaymentSessionEnabledJsonKey]) {
        id stored = [defaults objectForKey:kIsPaymentSessionOnKey];
        return [stored isKindOfClass:NSNumber.class] ? @([stored boolValue]) : nil;
    }

    if ([key isEqualToString:kSupportedNetworksJsonKey]) {
        return [self enabledValuesFrom:[self cardNetworkKeysByValue] inDefaults:defaults];
    }

    if ([key isEqualToString:kPaymentMethodsJsonKey]) {
        return [self enabledValuesFrom:[self paymentMethodKeysByValue] inDefaults:defaults];
    }

    if ([key isEqualToString:kChallengeRequestIndicatorKey]) {
        NSString *stored = [defaults stringForKey:key];
        return stored ? ([self invertedDictionary:[self challengeRequestIndicatorImportValues]][stored] ?: stored) : nil;
    }

    if ([key isEqualToString:kScaExemptionKey]) {
        NSString *stored = [defaults stringForKey:key];
        return stored ? ([self invertedDictionary:[self scaExemptionImportValues]][stored] ?: stored) : nil;
    }

    id value = [defaults objectForKey:key];
    if ([value isKindOfClass:NSString.class] || [value isKindOfClass:NSNumber.class]) {
        return value;
    }
    if ([value isKindOfClass:NSArray.class]) {
        NSMutableArray<NSString *> *strings = [NSMutableArray new];
        for (id element in (NSArray *)value) {
            if (element == NSNull.null) {
                continue;
            }
            [strings addObject:[NSString stringWithFormat:@"%@", element]];
        }
        return strings;
    }
    return nil;
}

+ (NSArray<NSString *> *)enabledValuesFrom:(NSDictionary<NSString *, NSString *> *)keysByValue
                                inDefaults:(NSUserDefaults *)defaults {
    BOOL anyPresent = NO;
    NSMutableArray<NSString *> *enabled = [NSMutableArray new];
    for (NSString *value in keysByValue) {
        NSString *key = keysByValue[value];
        if ([defaults objectForKey:key] != nil) {
            anyPresent = YES;
            if ([defaults boolForKey:key]) {
                [enabled addObject:value];
            }
        }
    }
    if (!anyPresent) {
        return nil;
    }
    return [enabled sortedArrayUsingSelector:@selector(compare:)];
}

@end
