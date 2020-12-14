//
//  FeatureService.swift
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

import Foundation
import JudoKit_iOS

class FeatureService {

    private let settings = Settings.standard

    // MARK: - SDK Methods

    func invokeTransaction(with type: JPTransactionType,
                           completion: @escaping JPCompletionBlock) {

        judoKit?.invokeTransaction(with: type,
                                   configuration: configuration,
                                   completion: completion)
    }

    func invokeApplePay(with mode: JPTransactionMode,
                        completion: @escaping JPCompletionBlock) {

        judoKit?.invokeApplePay(with: mode,
                                configuration: configuration,
                                completion: completion)
    }

    func invokePaymentMethods(with mode: JPTransactionMode,
                              completion: @escaping JPCompletionBlock) {

        judoKit?.invokePaymentMethodScreen(with: mode,
                                           configuration: configuration,
                                           completion: completion)
    }

    func invokeTokenTransaction(with mode: JPTransactionMode,
                                cardToken: String,
                                completion: @escaping JPCompletionBlock) {

        let tokenRequest = JPTokenRequest(configuration: configuration,
                                          andCardToken: cardToken)

        if mode == .payment {
            apiService.invokeTokenPayment(with: tokenRequest,
                                          andCompletion: completion)
            return
        }

        apiService.invokePreAuthTokenPayment(with: tokenRequest,
                                             andCompletion: completion)
    }

    func handle3DSTransaction(with error: JPError,
                              completion: @escaping JPCompletionBlock) {

        let threeDSConfiguration = JP3DSConfiguration(error: error)
        let threeDSService = JP3DSService(apiService: apiService)
        threeDSService.invoke3DSecure(with: threeDSConfiguration, completion: completion)
    }

    func invokePBBATransaction(with url: URL?,
                               completion: @escaping JPCompletionBlock) {
        let currentConfiguration = configuration
        currentConfiguration.pbbaConfiguration?.deeplinkURL = url
        judoKit?.invokePBBA(with: currentConfiguration, completion: completion)
    }

    func getTransactionDetails(with receiptID: String,
                               and completion: @escaping JPCompletionBlock) {
        apiService.fetchTransaction(withReceiptId: receiptID, completion: completion)
    }

    // MARK: - Getters

    private var judoKit: JudoKit? {
        let judo = JudoKit(authorization: settings.authorization)
        judo?.isSandboxed = settings.isSandboxed
        return judo
    }

    private var apiService: JPApiService {
        return JPApiService(authorization: settings.authorization,
                            isSandboxed: settings.isSandboxed)
    }

    private var configuration: JPConfiguration {
        let config = JPConfiguration(judoID: settings.judoID,
                                     amount: settings.amount,
                                     reference: settings.reference)

        config.paymentMethods = settings.paymentMethods
        config.supportedCardNetworks = settings.supportedCardNetworks
        config.applePayConfiguration = applePayConfiguration
        config.pbbaConfiguration = pbbaConfiguration
        config.uiConfiguration = uiConfiguration

        return config
    }

    private var applePayConfiguration: JPApplePayConfiguration {

        let item = JPPaymentSummaryItem(label: "Tim Cook",
                                        amount: NSDecimalNumber(string: settings.amount.amount))

        let appleConfig = JPApplePayConfiguration(merchantId: settings.applePayMerchantID,
                                                  currency: settings.amount.currency,
                                                  countryCode: "GB",
                                                  paymentSummaryItems: [item])

        let expressDelivery = JPPaymentShippingMethod(identifier: "1",
                                                      detail: "Next day delivery to your location",
                                                      label: "Express Delivery",
                                                      amount: 25.0,
                                                      type: .final)

        let freeDelivery = JPPaymentShippingMethod(identifier: "2",
                                                   detail: "Delivery by Monday next week",
                                                   label: "Free Delivery",
                                                   amount: 0.0,
                                                   type: .final)

        appleConfig.shippingType = .shippingTypeDelivery
        appleConfig.shippingMethods = [ freeDelivery, expressDelivery ]

        appleConfig.requiredBillingContactFields = .all
        appleConfig.requiredShippingContactFields = .all

        return appleConfig
    }

    private var pbbaConfiguration: JPPBBAConfiguration {
        let pbbaConfig = JPPBBAConfiguration(deeplinkScheme: "judoSwift://pay",
                                             andDeeplinkURL: nil)

        pbbaConfig.appearsOnStatement = "JudoPay"
        pbbaConfig.emailAddress = "developersupport@judopay.com"
        pbbaConfig.mobileNumber = "111-222-333"

        return pbbaConfig
    }

    private var uiConfiguration: JPUIConfiguration {
        let uiConfig = JPUIConfiguration()
        uiConfig.isAVSEnabled = settings.isAVSEnabled
        uiConfig.shouldPaymentButtonDisplayAmount = settings.shouldPaymentButtonDisplayAmount
        uiConfig.shouldPaymentMethodsDisplayAmount = settings.shouldPaymentMethodsDisplayAmount
        uiConfig.shouldPaymentMethodsVerifySecurityCode = settings.shouldPaymentMethodsVerifySecurityCode
        return uiConfig
    }
}
