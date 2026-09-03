import InAppSettingsKit

extension IASKAppSettingsViewController {
    func updateHiddenKeys() {
        let hiddenKeys = computeHiddenKeys(from: [kIsPaymentSessionOnKey,
                                                  kIsTokenAndSecretOnKey,
                                                  kIsAddressOnKey,
                                                  kIsRecommendationOnKey,
                                                  kIsPrimaryAccountDetailsOnKey,
                                                  kIsRecurringPaymentOnKey,
                                                  kIsDeferredPaymentOnKey])
        setHiddenKeys(hiddenKeys, animated: false)
    }

    func computeHiddenKeys(from keys: [String]) -> Set<String> {
        var hiddenKeys: Set<String> = [
            kTokenKey,
            kSecretKey,

            kSessionTokenKey,
            kPaymentSessionKey,

            kRsaKey,
            kRecommendationUrlKey,
            kRecommendationTimeoutKey,

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
            kRecurringPaymentBillingAgreementKey,
            kRecurringPaymentManagementUrlKey,
            kRecurringPaymentLabelKey,
            kRecurringPaymentAmountKey,
            kRecurringPaymentIntervalUnitKey,
            kRecurringPaymentIntervalCountKey,
            kRecurringPaymentStartDateKey,
            kRecurringPaymentEndDateKey,

            kDeferredPaymentDescriptionKey,
            kDeferredPaymentBillingAgreementKey,
            kDeferredPaymentManagementUrlKey,
            kDeferredPaymentLabelKey,
            kDeferredPaymentAmountKey,
            kDeferredPaymentDeferredDateKey,
            kDeferredPaymentFreeCancellationDateKey
        ]

        if keys.contains(kIsPaymentSessionOnKey), Settings.standard.isSessionAuthorizationOn {
            hiddenKeys.remove(kSessionTokenKey)
            hiddenKeys.remove(kPaymentSessionKey)
            UserDefaults.standard.setValue(false, forKey: kIsTokenAndSecretOnKey)
        }

        if keys.contains(kIsTokenAndSecretOnKey), Settings.standard.isBasicAuthorizationOn {
            hiddenKeys.remove(kTokenKey)
            hiddenKeys.remove(kSecretKey)
            UserDefaults.standard.setValue(false, forKey: kIsPaymentSessionOnKey)
        }

        if keys.contains(kIsRecommendationOnKey), Settings.standard.isRecommendationOn {
            hiddenKeys.remove(kRsaKey)
            hiddenKeys.remove(kRecommendationUrlKey)
            hiddenKeys.remove(kRecommendationTimeoutKey)
        }

        if keys.contains(kIsAddressOnKey), Settings.standard.isAddressOn {
            hiddenKeys.remove(kAddressLine1Key)
            hiddenKeys.remove(kAddressLine2Key)
            hiddenKeys.remove(kAddressLine3Key)
            hiddenKeys.remove(kAddressTownKey)
            hiddenKeys.remove(kAddressPostCodeKey)
            hiddenKeys.remove(kAddressCountryCodeKey)
            hiddenKeys.remove(kAddressAdministrativeDivisionKey)
            hiddenKeys.remove(kAddressPhoneCountryCodeKey)
            hiddenKeys.remove(kAddressMobileNumberKey)
            hiddenKeys.remove(kAddressEmailAddressKey)
        }

        if keys.contains(kIsPrimaryAccountDetailsOnKey), Settings.standard.isPrimaryAccountDetailsOn {
            hiddenKeys.remove(kPrimaryAccountNameKey)
            hiddenKeys.remove(kPrimaryAccountAccountNumberKey)
            hiddenKeys.remove(kPrimaryAccountDateOfBirthKey)
            hiddenKeys.remove(kPrimaryAccountPostCodeKey)
        }

        if keys.contains(kIsRecurringPaymentOnKey), Settings.standard.isRecurringPaymentOn {
            hiddenKeys.remove(kRecurringPaymentDescriptionKey)
            hiddenKeys.remove(kRecurringPaymentBillingAgreementKey)
            hiddenKeys.remove(kRecurringPaymentManagementUrlKey)
            hiddenKeys.remove(kRecurringPaymentLabelKey)
            hiddenKeys.remove(kRecurringPaymentAmountKey)
            hiddenKeys.remove(kRecurringPaymentIntervalUnitKey)
            hiddenKeys.remove(kRecurringPaymentIntervalCountKey)
            hiddenKeys.remove(kRecurringPaymentStartDateKey)
            hiddenKeys.remove(kRecurringPaymentEndDateKey)
            UserDefaults.standard.setValue(false, forKey: kIsDeferredPaymentOnKey)
        }

        if keys.contains(kIsDeferredPaymentOnKey), Settings.standard.isDeferredPaymentOn {
            hiddenKeys.remove(kDeferredPaymentDescriptionKey)
            hiddenKeys.remove(kDeferredPaymentBillingAgreementKey)
            hiddenKeys.remove(kDeferredPaymentManagementUrlKey)
            hiddenKeys.remove(kDeferredPaymentLabelKey)
            hiddenKeys.remove(kDeferredPaymentAmountKey)
            hiddenKeys.remove(kDeferredPaymentDeferredDateKey)
            hiddenKeys.remove(kDeferredPaymentFreeCancellationDateKey)
            UserDefaults.standard.setValue(false, forKey: kIsRecurringPaymentOnKey)
        }

        return hiddenKeys
    }
}
