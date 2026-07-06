//
//  SettingsImporter.swift
//  SwiftExampleApp
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

import Foundation

enum SettingsImporter {
    enum ImportError: LocalizedError {
        case invalidEncoding
        case notAnObject

        var errorDescription: String? {
            switch self {
            case .invalidEncoding:
                return "The provided text is not valid UTF-8."
            case .notAnObject:
                return "Expected a JSON object at the root."
            }
        }
    }

    static func importSettings(_ json: String, into defaults: UserDefaults = .standard) throws {
        guard let data = json.data(using: .utf8) else {
            throw ImportError.invalidEncoding
        }

        let object = try JSONSerialization.jsonObject(with: data, options: [])

        guard let root = object as? [String: Any] else {
            throw ImportError.notAnObject
        }

        for (key, value) in root {
            if let section = value as? [String: Any] {
                section.forEach { applyLeaf($0.value, forKey: $0.key, into: defaults) }
            } else {
                applyLeaf(value, forKey: key, into: defaults)
            }
        }
    }

    // JSON-dialect keys shared with the Android example app; they do not map 1:1
    // onto stored settings keys and are translated on import/export.
    private static let isPaymentSessionEnabledJsonKey = "is_payment_session_enabled"
    private static let supportedNetworksJsonKey = "supported_networks"
    private static let paymentMethodsJsonKey = "payment_methods"

    private static let cardNetworkKeysByValue: [String: String] = [
        "VISA": kVisaEnabledKey,
        "MASTERCARD": kMasterCardEnabledKey,
        "MAESTRO": kMaestroEnabledKey,
        "AMEX": kAMEXEnabledKey,
        "CHINA_UNION_PAY": kChinaUnionPayEnabledKey,
        "JCB": kJCBEnabledKey,
        "DISCOVER": kDiscoverEnabledKey,
        "DINERS_CLUB": kDinersClubEnabledKey
    ]

    private static let challengeRequestIndicatorImportValues: [String: String] = [
        "DON_T_SET": "dontSet",
        "NO_PREFERENCE": "noPreference",
        "NO_CHALLENGE": "noChallenge",
        "CHALLENGE_PREFERRED": "challengePreferred",
        "CHALLENGE_AS_MANDATE": "challengeAsMandate"
    ]

    private static let scaExemptionImportValues: [String: String] = [
        "DON_T_SET": "dontSet",
        "LOW_VALUE": "lowValue",
        "SECURE_CORPORATE": "secureCorporate",
        "TRUSTED_BENEFICIARY": "trustedBeneficiary",
        "TRANSACTION_RISK_ANALYSIS": "transactionRiskAnalysis"
    ]

    private static func applyLeaf(_ value: Any, forKey rawKey: String, into defaults: UserDefaults) {
        switch rawKey {
        case isPaymentSessionEnabledJsonKey:
            if let number = value as? NSNumber, isBoolean(number) {
                defaults.set(number.boolValue, forKey: kIsPaymentSessionOnKey)
                defaults.set(!number.boolValue, forKey: kIsTokenAndSecretOnKey)
            }
            return
        case supportedNetworksJsonKey:
            if let array = value as? [Any] {
                applyCardNetworks(array.map { "\($0)" }, into: defaults)
            }
            return
        case paymentMethodsJsonKey:
            if let array = value as? [Any] {
                applyPaymentMethods(array.map { "\($0)" }, into: defaults)
            }
            return
        default:
            break
        }

        switch value {
        case let array as [Any]:
            defaults.set(array.compactMap { $0 is NSNull ? nil : "\($0)" }, forKey: rawKey)
        case let number as NSNumber where isBoolean(number):
            defaults.set(number.boolValue, forKey: rawKey)
        case let number as NSNumber:
            defaults.set(number.stringValue, forKey: rawKey)
        case let string as String:
            defaults.set(storedValue(for: rawKey, value: string), forKey: rawKey)
        default:
            break
        }
    }

    private static func storedValue(for key: String, value: String) -> String {
        switch key {
        case kChallengeRequestIndicatorKey:
            return challengeRequestIndicatorImportValues[value] ?? value
        case kScaExemptionKey:
            return scaExemptionImportValues[value] ?? value
        default:
            return value
        }
    }

    private static func applyCardNetworks(_ values: [String], into defaults: UserDefaults) {
        let selected = Set(values.map { $0.uppercased() })
        for (value, key) in cardNetworkKeysByValue {
            defaults.set(selected.contains(value), forKey: key)
        }
    }

    private static func applyPaymentMethods(_ values: [String], into defaults: UserDefaults) {
        let selected = Set(values.map { $0.uppercased() })
        defaults.set(selected.contains("CARD"), forKey: kCardPaymentMethodEnabledKey)
        defaults.set(selected.contains("APPLE_PAY") || selected.contains("GOOGLE_PAY"),
                     forKey: kApplePayPaymentMethodEnabledKey)
    }

    private static func isBoolean(_ number: NSNumber) -> Bool {
        CFGetTypeID(number) == CFBooleanGetTypeID()
    }

    // MARK: - Export

    // Section layout mirrors SettingsImporter.SECTIONS in the Android example app
    // so both platforms produce the same JSON structure for shared fixtures.
    private static let sections: [(name: String, keys: [String])] = [
        ("api", [
            kSandboxedKey,
            kJudoIdKey,
            kTokenKey,
            kSecretKey,
            isPaymentSessionEnabledJsonKey,
            kPaymentSessionKey,
            kSessionTokenKey,
            kPaymentReferenceKey,
            kConsumerReferenceKey
        ]),
        ("recommendation", [
            kIsRecommendationOnKey,
            kRecommendationUrlKey,
            kRsaKey,
            kRecommendationTimeoutKey
        ]),
        ("three_ds", [
            kShouldAskForBillingInformationKey,
            kChallengeRequestIndicatorKey,
            kScaExemptionKey,
            kThreeDsTwoMaxTimeoutKey,
            kConnectTimeoutKey,
            kReadTimeoutKey,
            kWriteTimeoutKey,
            kThreeDSTwoMessageVersionKey
        ]),
        ("three_ds_ui_customisation", [
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
        ]),
        ("amount", [
            kAmountKey,
            kCurrencyKey
        ]),
        ("address", [
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
        ]),
        ("primary_account", [
            kIsPrimaryAccountDetailsOnKey,
            kPrimaryAccountNameKey,
            kPrimaryAccountAccountNumberKey,
            kPrimaryAccountDateOfBirthKey,
            kPrimaryAccountPostCodeKey
        ]),
        ("apple_pay", [
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
            kIsShippingContactFieldNameRequiredKey
        ]),
        ("others", [
            kAVSEnabledKey,
            kShouldPaymentMethodsDisplayAmount,
            kShouldPaymentButtonDisplayAmount,
            kIsInitialRecurringPaymentKey,
            kIsDelayedAuthorisationOnKey,
            supportedNetworksJsonKey,
            paymentMethodsJsonKey
        ]),
        ("token_payments", [
            kShouldAskForCSCKey,
            kShouldAskForCardholderNameKey
        ])
    ]

    private static let paymentMethodKeysByValue: [String: String] = [
        "CARD": kCardPaymentMethodEnabledKey,
        "APPLE_PAY": kApplePayPaymentMethodEnabledKey
    ]

    private static let challengeRequestIndicatorExportValues: [String: String] =
        Dictionary(uniqueKeysWithValues: challengeRequestIndicatorImportValues.map { ($0.value, $0.key) })

    private static let scaExemptionExportValues: [String: String] =
        Dictionary(uniqueKeysWithValues: scaExemptionImportValues.map { ($0.value, $0.key) })

    static func export(from defaults: UserDefaults = .standard) -> String {
        var root: [String: Any] = [:]
        for (name, keys) in sections {
            var section: [String: Any] = [:]
            for key in keys {
                if let value = exportValue(for: key, from: defaults) {
                    section[key] = value
                }
            }
            if !section.isEmpty {
                root[name] = section
            }
        }

        guard let data = try? JSONSerialization.data(withJSONObject: root, options: [.prettyPrinted, .sortedKeys]),
              let json = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return json
    }

    private static func exportValue(for key: String, from defaults: UserDefaults) -> Any? {
        switch key {
        case isPaymentSessionEnabledJsonKey:
            guard let number = defaults.object(forKey: kIsPaymentSessionOnKey) as? NSNumber else { return nil }
            return number.boolValue
        case supportedNetworksJsonKey:
            return enabledValues(from: cardNetworkKeysByValue, in: defaults)
        case paymentMethodsJsonKey:
            return enabledValues(from: paymentMethodKeysByValue, in: defaults)
        case kChallengeRequestIndicatorKey:
            return defaults.string(forKey: key).map { challengeRequestIndicatorExportValues[$0] ?? $0 }
        case kScaExemptionKey:
            return defaults.string(forKey: key).map { scaExemptionExportValues[$0] ?? $0 }
        default:
            switch defaults.object(forKey: key) {
            case let number as NSNumber where isBoolean(number):
                return number.boolValue
            case let number as NSNumber:
                return number
            case let string as String:
                return string
            case let array as [Any]:
                return array.map { "\($0)" }
            default:
                return nil
            }
        }
    }

    private static func enabledValues(from keysByValue: [String: String], in defaults: UserDefaults) -> [String]? {
        let present = keysByValue.filter { defaults.object(forKey: $0.value) != nil }
        guard !present.isEmpty else { return nil }
        return present.filter { defaults.bool(forKey: $0.value) }.keys.sorted()
    }
}
