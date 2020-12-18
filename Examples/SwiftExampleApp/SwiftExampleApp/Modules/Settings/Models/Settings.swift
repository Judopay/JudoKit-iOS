//
//  Settings.swift
//  SwiftExampleApp
//
//  Copyright (c) 2020 Alternative Payments Ltd
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

import JudoKit_iOS

class Settings {

    // MARK: - Constants

    private let kDefaultConsumerReference = "my-unique-consumer-ref"

    // MARK: - Variables

    private let userDefaults: UserDefaults
    public static let standard = Settings()

    // MARK: - Initializers

    private init() {
        userDefaults = .standard
    }

    init(with userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    // MARK: - Getters

    public var isSandboxed: Bool {
        return userDefaults.bool(forKey: kSandboxedKey)
    }

    public var judoID: String {
        return userDefaults.string(forKey: kJudoIdKey) ?? ""
    }

    public var isBasicAuthorizationOn: Bool {
        return userDefaults.bool(forKey: kIsTokenAndSecretOnKey)
    }

    public var isSessionAuthorizationOn: Bool {
        return userDefaults.bool(forKey: kIsPaymentSessionOnKey)
    }

    public var authorization: JPAuthorization {

        if isBasicAuthorizationOn {
            let token = userDefaults.string(forKey: kTokenKey) ?? ""
            let secret = userDefaults.string(forKey: kSecretKey) ?? ""
            return JPBasicAuthorization(token: token, andSecret: secret)
        }

        let token = userDefaults.string(forKey: kSessionTokenKey) ?? ""
        let session = userDefaults.string(forKey: kPaymentSessionKey) ?? ""
        return JPSessionAuthorization(token: token, andPaymentSession: session)
    }

    public var reference: JPReference {

        var paymentReference = JPReference.generatePaymentReference()
        var consumerReference = kDefaultConsumerReference

        if let storedPaymentRef = userDefaults.string(forKey: kPaymentReferenceKey), !storedPaymentRef.isEmpty {
            paymentReference = storedPaymentRef
        }

        if let storedConsumerRef = userDefaults.string(forKey: kConsumerReferenceKey), !storedConsumerRef.isEmpty {
            consumerReference = storedConsumerRef
        }

        return JPReference(consumerReference: consumerReference,
                           paymentReference: paymentReference)
    }

    public var amount: JPAmount {
        let amount = userDefaults.string(forKey: kAmountKey) ?? ""
        let currency = userDefaults.string(forKey: kCurrencyKey) ?? ""
        return JPAmount(amount, currency: currency)
    }

    public var applePayMerchantID: String {
        userDefaults.string(forKey: kMerchantIdKey) ?? ""
    }

    public var supportedCardNetworks: JPCardNetworkType {

        var networks: JPCardNetworkType = []

        if userDefaults.bool(forKey: kVisaEnabledKey) {
            networks.insert(.visa)
        }

        if userDefaults.bool(forKey: kMasterCardEnabledKey) {
            networks.insert(.masterCard)
        }

        if userDefaults.bool(forKey: kMaestroEnabledKey) {
            networks.insert(.maestro)
        }

        if userDefaults.bool(forKey: kAMEXEnabledKey) {
            networks.insert(.AMEX)
        }

        if userDefaults.bool(forKey: kChinaUnionPayEnabledKey) {
            networks.insert(.chinaUnionPay)
        }

        if userDefaults.bool(forKey: kJCBEnabledKey) {
            networks.insert(.JCB)
        }

        if userDefaults.bool(forKey: kDiscoverEnabledKey) {
            networks.insert(.discover)
        }

        if userDefaults.bool(forKey: kDinersClubEnabledKey) {
            networks.insert(.dinersClub)
        }

        return networks
    }

    public var paymentMethods: [JPPaymentMethod] {

        var paymentMethods: [JPPaymentMethod] = []

        if userDefaults.bool(forKey: kCardPaymentMethodEnabledKey) {
            paymentMethods.append(JPPaymentMethod.card())
        }

        if userDefaults.bool(forKey: kApplePayPaymentMethodEnabledKey) {
            paymentMethods.append(JPPaymentMethod.applePay())
        }

        if userDefaults.bool(forKey: kiDEALPaymentMethodEnabledKey) {
            paymentMethods.append(JPPaymentMethod.iDeal())
        }

        if userDefaults.bool(forKey: kPbbaPaymentMethodEnabledKey) {
            paymentMethods.append(JPPaymentMethod.pbba())
        }

        return paymentMethods
    }

    public var isAVSEnabled: Bool {
        return userDefaults.bool(forKey: kAVSEnabledKey)
    }

    public var shouldPaymentMethodsDisplayAmount: Bool {
        return userDefaults.bool(forKey: kShouldPaymentMethodsDisplayAmount)
    }

    public var shouldPaymentButtonDisplayAmount: Bool {
        return userDefaults.bool(forKey: kShouldPaymentButtonDisplayAmount)
    }

    public var shouldPaymentMethodsVerifySecurityCode: Bool {
        return userDefaults.bool(forKey: kShouldPaymentMethodsVerifySecurityCode)
    }
}
