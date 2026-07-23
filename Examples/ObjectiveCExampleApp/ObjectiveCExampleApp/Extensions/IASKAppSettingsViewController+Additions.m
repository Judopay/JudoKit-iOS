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
        kIsRecurringPaymentOnKey,
        kIsAutomaticReloadPaymentOnKey,
        kIsDeferredPaymentOnKey
    ]];
    [self setHiddenKeys:hiddenKeys];
}

- (void)didChangedSettingsWithKeys:(NSArray<NSString *> *)keys {

    NSSet *hiddenKeys;

    if ([keys containsObject:kIsPaymentSessionOnKey]) {
        hiddenKeys = [self computeHiddenKeysWithPriority:@[ kIsPaymentSessionOnKey, kIsAddressOnKey, kIsPrimaryAccountDetailsOnKey, kIsRecommendationOnKey, kIsRecurringPaymentOnKey ]];
    } else if ([keys containsObject:kIsTokenAndSecretOnKey]) {
        hiddenKeys = [self computeHiddenKeysWithPriority:@[ kIsTokenAndSecretOnKey, kIsAddressOnKey, kIsPrimaryAccountDetailsOnKey, kIsRecommendationOnKey, kIsRecurringPaymentOnKey ]];
    } else if ([keys containsObject:kIsAddressOnKey] || [keys containsObject:kIsPrimaryAccountDetailsOnKey] || [keys containsObject:kIsRecommendationOnKey] || [keys containsObject:kIsRecurringPaymentOnKey] || [keys containsObject:kIsAutomaticReloadPaymentOnKey] || [keys containsObject:kIsDeferredPaymentOnKey]) {
        hiddenKeys = [self computeHiddenKeysWithPriority:@[ kIsPaymentSessionOnKey, kIsTokenAndSecretOnKey, kIsRecommendationOnKey, kIsAddressOnKey, kIsPrimaryAccountDetailsOnKey, kIsRecurringPaymentOnKey, kIsAutomaticReloadPaymentOnKey, kIsDeferredPaymentOnKey ]];
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
        kRecommendationTimeoutKey,
        kIsRecommendationHaltTransactionOnKey,

        kAddressLine1Key,
        kAddressLine2Key,
        kAddressLine3Key,
        kAddressTownKey,
        kAddressPostCodeKey,
        kAddressCountryCodeKey,
        kAddressAdministrativeDivisionKey,
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
        kRecurringPaymentEndDateKey,

        kAutomaticReloadPaymentDescriptionKey,
        kAutomaticReloadPaymentBillingAgreementKey,
        kAutomaticReloadPaymentManagementUrlKey,
        kAutomaticReloadPaymentLabelKey,
        kAutomaticReloadPaymentAmountKey,
        kAutomaticReloadPaymentThresholdAmountKey,

        kDeferredPaymentDescriptionKey,
        kDeferredPaymentBillingAgreementKey,
        kDeferredPaymentManagementUrlKey,
        kDeferredPaymentLabelKey,
        kDeferredPaymentAmountKey,
        kDeferredPaymentDeferredDateKey,
        kDeferredPaymentFreeCancellationDateKey
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
            kRecommendationTimeoutKey,
            kIsRecommendationHaltTransactionOnKey,
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
            kAddressAdministrativeDivisionKey,
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

    if ([keys containsObject:kIsAutomaticReloadPaymentOnKey] && Settings.defaultSettings.isApplePayAutomaticReloadPaymentOn) {
        [hiddenKeys removeObjectsInArray:@[
            kAutomaticReloadPaymentDescriptionKey,
            kAutomaticReloadPaymentBillingAgreementKey,
            kAutomaticReloadPaymentManagementUrlKey,
            kAutomaticReloadPaymentLabelKey,
            kAutomaticReloadPaymentAmountKey,
            kAutomaticReloadPaymentThresholdAmountKey
        ]];
    }

    if ([keys containsObject:kIsDeferredPaymentOnKey] && Settings.defaultSettings.isApplePayDeferredPaymentOn) {
        [hiddenKeys removeObjectsInArray:@[
            kDeferredPaymentDescriptionKey,
            kDeferredPaymentBillingAgreementKey,
            kDeferredPaymentManagementUrlKey,
            kDeferredPaymentLabelKey,
            kDeferredPaymentAmountKey,
            kDeferredPaymentDeferredDateKey,
            kDeferredPaymentFreeCancellationDateKey
        ]];
    }

    return [NSSet setWithArray:hiddenKeys];
}

@end
