//
//  JPApplePayWrappersTests.swift
//  JudoKit_iOSTests
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

import XCTest
@testable import JudoKit_iOS

class JPApplePayWrappersTests: XCTestCase {

    lazy var amount = JPAmount("0.01", currency: "GBP")
    lazy var reference = JPReference(consumerReference: "consumerReference")
    lazy var configuration = JPConfiguration(judoID: "judoId",
                                             amount: amount,
                                             reference: reference)

    lazy var summaryItems = [JPPaymentSummaryItem(label: "item", amount: 0.15)];
    lazy var appleConfig = JPApplePayConfiguration(merchantId: "merchantId",
                                                   currency: "GBP",
                                                   countryCode: "GB",
                                                   paymentSummaryItems: summaryItems)

    /**
     * GIVEN: JPApplePayWrappers is used to create a PKPaymentAuthorizationViewController
     *
     * WHEN: the required Apple Pay parameters are not present in the JPConfiguration
     *
     * THEN: the method should return nil
     */
    func test_OnPaymentControllerCreation_WhenMissingOrInvalidProperty_ReturnNil() {
        let paymentController = JPApplePayWrappers.pkPaymentController(for: configuration)
        XCTAssertNil(paymentController)
    }

    /**
     * GIVEN: JPApplePayWrappers is used to create a PKPaymentAuthorizationViewController
     *
     * WHEN: the required Apple Pay parameters are present in the JPConfiguration
     *
     * THEN: an instance of PKPaymentAuthorizationViewController should be returned
     */
    func test_OnPaymentControllerCreation_WhenValidProperties_ReturnController() {
        configuration.applePayConfiguration = appleConfig
        let paymentController = JPApplePayWrappers.pkPaymentController(for: configuration)
        XCTAssertNotNil(paymentController)
    }

    /**
     * GIVEN: JPApplePayWrappers is used to map the supported payment methods
     *
     * WHEN: the supported payment method inside the Apple Pay configuration is set to [.visa]
     *
     * THEN: the returned array should contain a single mapped [.visa] value
     */
    func test_OnPaymentNetworkMapping_WhenCardNetworkVisa_MapToVisa() {
        configuration.applePayConfiguration = appleConfig
        configuration.applePayConfiguration?.supportedCardNetworks = .visa
        let networks = JPApplePayWrappers.pkPaymentNetworks(for: configuration)

        XCTAssertEqual(networks?.first, .visa)
    }

    /**
     * GIVEN: JPApplePayWrappers is used to map the supported payment methods
     *
     * WHEN: the supported payment method inside the Apple Pay configuration is set to [.masterCard]
     *
     * THEN: the returned array should contain a single mapped [.masterCard] value
     */
    func test_OnPaymentNetworkMapping_WhenCardNetworkMastercard_MapToMastercard() {
        configuration.applePayConfiguration = appleConfig
        configuration.applePayConfiguration?.supportedCardNetworks = .masterCard
        let networks = JPApplePayWrappers.pkPaymentNetworks(for: configuration)

        XCTAssertEqual(networks?.first, .masterCard)
    }

    /**
     * GIVEN: JPApplePayWrappers is used to map the supported payment methods
     *
     * WHEN: the supported payment method inside the Apple Pay configuration is set to [.AMEX]
     *
     * THEN: the returned array should contain a single mapped [.amex] value
     */
    func test_OnPaymentNetworkMapping_WhenCardNetworkAmex_MapToAmex() {
        configuration.applePayConfiguration = appleConfig
        configuration.applePayConfiguration?.supportedCardNetworks = .AMEX
        let networks = JPApplePayWrappers.pkPaymentNetworks(for: configuration)

        XCTAssertEqual(networks?.first, .amex)
    }

    /**
     * GIVEN: JPApplePayWrappers is used to map the supported payment methods
     *
     * WHEN: the supported payment method inside the Apple Pay configuration is set to [.maestro]
     *
     * THEN: the returned array should contain a single mapped [.maestro] value
     */
    @available(iOS 12.0, *)
    func test_OnPaymentNetworkMapping_WhenCardNetworkMaestro_MapToMaestro() {
        configuration.applePayConfiguration = appleConfig
        configuration.applePayConfiguration?.supportedCardNetworks = .maestro
        let networks = JPApplePayWrappers.pkPaymentNetworks(for: configuration)

        XCTAssertEqual(networks?.first, .maestro)
    }

    /**
     * GIVEN: JPApplePayWrappers is used to map the supported payment methods
     *
     * WHEN: the supported payment method inside the Apple Pay configuration is set to [.JCB]
     *
     * THEN: the returned array should contain a single mapped [.JCB] value
     */
    func test_OnPaymentNetworkMapping_WhenCardNetworkJCB_MapToJCB() {
        configuration.applePayConfiguration = appleConfig
        configuration.applePayConfiguration?.supportedCardNetworks = .JCB
        let networks = JPApplePayWrappers.pkPaymentNetworks(for: configuration)

        XCTAssertEqual(networks?.first, .JCB)
    }

    /**
     * GIVEN: JPApplePayWrappers is used to map the supported payment methods
     *
     * WHEN: the supported payment method inside the Apple Pay configuration is set to [.discover]
     *
     * THEN: the returned array should contain a single mapped [.discover] value
     */
    func test_OnPaymentNetworkMapping_WhenCardNetworkDiscover_MapToDiscover() {
        configuration.applePayConfiguration = appleConfig
        configuration.applePayConfiguration?.supportedCardNetworks = .discover
        let networks = JPApplePayWrappers.pkPaymentNetworks(for: configuration)

        XCTAssertEqual(networks?.first, .discover)
    }

    /**
     * GIVEN: JPApplePayWrappers is used to map the supported payment methods
     *
     * WHEN: the supported payment method inside the Apple Pay configuration is set to [.chinaUnionPay]
     *
     * THEN: the returned array should contain a single mapped [.chinaUnionPay] value
     */
    func test_OnPaymentNetworkMapping_WhenCardNetworkUnionPay_MapToUnionPay() {
        configuration.applePayConfiguration = appleConfig
        configuration.applePayConfiguration?.supportedCardNetworks = .chinaUnionPay
        let networks = JPApplePayWrappers.pkPaymentNetworks(for: configuration)

        XCTAssertEqual(networks?.first, .chinaUnionPay)
    }

    /**
     * GIVEN: JPApplePayWrappers is used to map the supported payment methods
     *
     * WHEN: the supported payment method inside the Apple Pay configuration is set to [.all]
     *
     * THEN: the returned array should contain all supported payment networks
     */
    func test_OnPaymentNetworkMapping_WhenAllSelected_MapAllValues() {
        configuration.applePayConfiguration = appleConfig
        configuration.applePayConfiguration?.supportedCardNetworks = .all
        let networks = JPApplePayWrappers.pkPaymentNetworks(for: configuration)

        XCTAssertEqual(networks?.count, 7)
    }
}
