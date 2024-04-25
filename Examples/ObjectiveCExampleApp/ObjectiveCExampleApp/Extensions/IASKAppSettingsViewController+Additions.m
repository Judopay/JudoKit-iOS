#import "IASKAppSettingsViewController+Additions.h"
#import "Settings.h"

@implementation IASKAppSettingsViewController (Additions)

- (void)updateHiddenKeys {
    NSSet *hiddenKeys = [self computeHiddenKeysWithPriority:@[
        kIsPaymentSessionOnKey,
        kIsTokenAndSecretOnKey,
        kIsRecommendationOnKey,
        kIsAddressOnKey,
        kIsPrimaryAccountDetailsOnKey,
        kIsRecurringPaymentOnKey
    ]];
    [self setHiddenKeys:hiddenKeys];
}

- (void)didChangedSettingsWithKeys:(NSArray<NSString *> *)keys {

    NSSet *hiddenKeys;

    if ([keys containsObject:kIsPaymentSessionOnKey]) {
        hiddenKeys = [self computeHiddenKeysWithPriority:@[ kIsPaymentSessionOnKey, kIsAddressOnKey, kIsPrimaryAccountDetailsOnKey, kIsRecommendationOnKey, kIsRecurringPaymentOnKey ]];
    } else if ([keys containsObject:kIsTokenAndSecretOnKey]) {
        hiddenKeys = [self computeHiddenKeysWithPriority:@[ kIsTokenAndSecretOnKey, kIsAddressOnKey, kIsPrimaryAccountDetailsOnKey, kIsRecommendationOnKey, kIsRecurringPaymentOnKey ]];
    } else if ([keys containsObject:kIsAddressOnKey] || [keys containsObject:kIsPrimaryAccountDetailsOnKey] || [keys containsObject:kIsRecommendationOnKey] || [keys containsObject:kIsRecurringPaymentOnKey]) {
        hiddenKeys = [self computeHiddenKeysWithPriority:@[ kIsPaymentSessionOnKey, kIsTokenAndSecretOnKey, kIsRecommendationOnKey, kIsAddressOnKey, kIsPrimaryAccountDetailsOnKey, kIsRecurringPaymentOnKey ]];
    }

    if (hiddenKeys.count > 0) {
        [self setHiddenKeys:hiddenKeys animated:YES];
    }
}

- (NSSet *)computeHiddenKeysWithPriority:(NSArray *)keys {
    NSMutableArray *hiddenKeys = [NSMutableArray arrayWithArray:@[
        kTokenKey,
        kSecretKey,

        kSessionTokenKey,
        kPaymentSessionKey,
        kGeneratePaymentSessionKey,

        kRsaKey,
        kRecommendationUrlKey,
        kRecommendationApiTimeoutKey,
        kRecommendationHaltTransactionKey,

        kAddressLine1Key,
        kAddressLine2Key,
        kAddressLine3Key,
        kAddressTownKey,
        kAddressPostCodeKey,
        kAddressCountryCodeKey,
        kAddressStateKey,
        kAddressPhoneCountryCodeKey,
        kAddressMobileNumberKey,
        kAddressEmailAddressKey,

        kPrimaryAccountNameKey,
        kPrimaryAccountAccountNumberKey,
        kPrimaryAccountDateOfBirthKey,
        kPrimaryAccountPostCodeKey,

        kRecurringPaymentDescriptionKey,
        kRecurringPaymentManagementUrlKey,
        kRecurringPaymentBillingAgreementKey,
        kRecurringPaymentLabelKey,
        kRecurringPaymentAmountKey,
        kRecurringPaymentIntervalUnitKey,
        kRecurringPaymentIntervalCountKey,
        kRecurringPaymentStartDateKey,
        kRecurringPaymentEndDateKey
    ]];

    if ([keys containsObject:kIsPaymentSessionOnKey] && Settings.defaultSettings.isPaymentSessionAuthorizationOn) {
        [hiddenKeys removeObjectsInArray:@[ kSessionTokenKey, kPaymentSessionKey, kGeneratePaymentSessionKey]];
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:kIsTokenAndSecretOnKey];
    }

    if ([keys containsObject:kIsTokenAndSecretOnKey] && Settings.defaultSettings.isTokenAndSecretAuthorizationOn) {
        [hiddenKeys removeObjectsInArray:@[ kTokenKey, kSecretKey ]];
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:kIsPaymentSessionOnKey];
    }

    if ([keys containsObject:kIsRecommendationOnKey] && Settings.defaultSettings.isRecommendationFeatureOn) {
        [hiddenKeys removeObjectsInArray:@[
            kRsaKey,
            kRecommendationUrlKey,
            kRecommendationApiTimeoutKey,
            kRecommendationHaltTransactionKey,
        ]];
    }

    if ([keys containsObject:kIsAddressOnKey] && Settings.defaultSettings.isAddressOn) {
        [hiddenKeys removeObjectsInArray:@[
            kAddressLine1Key,
            kAddressLine2Key,
            kAddressLine3Key,
            kAddressTownKey,
            kAddressPostCodeKey,
            kAddressCountryCodeKey,
            kAddressStateKey,
            kAddressPhoneCountryCodeKey,
            kAddressMobileNumberKey,
            kAddressEmailAddressKey,
        ]];
    }

    if ([keys containsObject:kIsPrimaryAccountDetailsOnKey] && Settings.defaultSettings.isPrimaryAccountDetailsOn) {
        [hiddenKeys removeObjectsInArray:@[
            kPrimaryAccountNameKey,
            kPrimaryAccountAccountNumberKey,
            kPrimaryAccountDateOfBirthKey,
            kPrimaryAccountPostCodeKey
        ]];
    }

    if ([keys containsObject:kIsRecurringPaymentOnKey] && Settings.defaultSettings.isApplePayRecurringPaymentOn) {
        [hiddenKeys removeObjectsInArray:@[
            kRecurringPaymentDescriptionKey,
            kRecurringPaymentBillingAgreementKey,
            kRecurringPaymentManagementUrlKey,
            kRecurringPaymentLabelKey,
            kRecurringPaymentAmountKey,
            kRecurringPaymentIntervalUnitKey,
            kRecurringPaymentIntervalCountKey,
            kRecurringPaymentStartDateKey,
            kRecurringPaymentEndDateKey
        ]];
    }

    return [NSSet setWithArray:hiddenKeys];
}

@end
