//
//  JPConfigurationValidationServiceTest.swift
//  JudoKit-iOSTests
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

import XCTest

@testable import JudoKit

class JPAppleConfigurationValidationServiceTest: XCTestCase {
    var amount: JPAmount!
    var configuration: JPConfiguration!
    let consumerReference = "judoPay-sample-app"
    var configValidation: JPConfigurationValidationService!
    lazy var reference = JPReference(consumerReference: consumerReference)
    
    var applePayConfigurations: JPApplePayConfiguration {
        let items = [JPPaymentSummaryItem(label: "item 1", amount: 0.01),
                     JPPaymentSummaryItem(label: "item 2", amount: 0.02),
                     JPPaymentSummaryItem(label: "Judo Pay", amount: 0.03)]
        let configurations = JPApplePayConfiguration(merchantId: "merchantId",
                                                     currency: "EUR",
                                                     countryCode: "GB",
                                                     paymentSummaryItems: items)
        return configurations
    }
    
    override func setUp() {
        configValidation = JPConfigurationValidationServiceImp()
        amount = JPAmount("fv", currency: "GBR")
        configuration = JPConfiguration(judoID: "judoId", amount: self.amount, reference: reference)
        configuration.supportedCardNetworks = [.networkVisa, .networkMasterCard, .networkAMEX]
        configuration.applePayConfiguration = applePayConfigurations
    }
    
    func testAppleConfigIfValid() {
        let error = configValidation.valiadateApplePay(configuration)
        XCTAssertNil(error, "Error must be nil for a valid Apple Pay configuration")
    }
    
    func testAppleConfigForNil() {
        configuration.applePayConfiguration = nil
        let error = configValidation.valiadateApplePay(configuration)
        XCTAssertNotNil(error, "Error must not be nil for an invalid Apple Pay configuration")
    }
    
    func testAppleConfigForPaymentSummaryItemsEmpty() {
        configuration.applePayConfiguration?.paymentSummaryItems.removeAll()
        let error = configValidation.valiadateApplePay(configuration)
        XCTAssertNotNil(error, "Error must not be nil when no Payment Summary Items are present")
    }
    
    func testAppleConfigForShipingMethods() {
        configuration.applePayConfiguration?.requiredShippingContactFields = .postalAddress
        configuration.applePayConfiguration?.shippingMethods?.removeAll()
        let error = configValidation.valiadateApplePay(configuration)
        XCTAssertNotNil(error, "Error must not be nil when no Shipping Methods are specified")
    }
    
    func testAppleConfigForInvalidCountryCode() {
        configuration.applePayConfiguration?.countryCode = ""
        let error = configValidation.valiadateApplePay(configuration)
        XCTAssertNotNil(error, "Error must not be nil when no Country Code is specified")
    }
    
    func testAppleConfigForInvalidMerchantId() {
        configuration.applePayConfiguration?.merchantId = ""
        let error = configValidation.valiadateApplePay(configuration)
        XCTAssertNotNil(error, "Error must not be nil when no Merchant ID is specified")
    }
    
    func testAppleConfigForUnsuportedCurrency() {
        configuration.applePayConfiguration?.currency = "XYZ"
        let error = configValidation.valiadateApplePay(configuration)
        XCTAssertNotNil(error, "Error must not be nil when the Currency Code is invalid")
    }
}
