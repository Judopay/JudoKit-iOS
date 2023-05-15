import InAppSettingsKit

extension IASKAppSettingsViewController {
    func updateHiddenKeys() {
        let hiddenKeys = computeHiddenKeys(from: [kIsPaymentSessionOnKey,
                                                  kIsTokenAndSecretOnKey,
                                                  kIsAddressOnKey,
                                                  kIsPrimaryAccountDetailsOnKey])
        setHiddenKeys(hiddenKeys, animated: false)
    }

    func computeHiddenKeys(from keys: [String]) -> Set<String> {
        var hiddenKeys: Set<String> = [
            kTokenKey,
            kSecretKey,

            kSessionTokenKey,
            kPaymentSessionKey,

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
            kPrimaryAccountPostCodeKey
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

        if keys.contains(kIsAddressOnKey), Settings.standard.isAddressOn {
            hiddenKeys.remove(kAddressLine1Key)
            hiddenKeys.remove(kAddressLine2Key)
            hiddenKeys.remove(kAddressLine3Key)
            hiddenKeys.remove(kAddressTownKey)
            hiddenKeys.remove(kAddressPostCodeKey)
            hiddenKeys.remove(kAddressCountryCodeKey)
            hiddenKeys.remove(kAddressStateKey)
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

        return hiddenKeys
    }
}
