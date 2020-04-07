//
//  JPConfigurationValidationServiceTest.swift
//  JudoKitObjCTests
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
@testable import JudoKitObjC

class JPConfigurationValidationServiceTest: XCTestCase {
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
    }
    
    func initAppleConfig() {
        configuration.applePayConfiguration = applePayConfigurations
    }
    
    func testInvalidCharacters() {
        let isNotValid = configValidation.isTransactionNotValide(with: configuration, transactionType: .DefaultTransaction) { (response, errror) in
            XCTAssertEqual(errror!.localizedDescription, "Amount should be a number")
        }
        XCTAssertTrue(isNotValid)

    }
    
    func testEmptyCurrency() {
        amount = JPAmount("0.1", currency: "")
        configuration.amount = amount
        let isNotValid = configValidation.isTransactionNotValide(with: configuration, transactionType: .DefaultTransaction) { (response, errror) in
            XCTAssertEqual(errror!.localizedDescription, "Currency cannot be empty")
        }
        XCTAssertTrue(isNotValid)
    }
    
    func testNilJudoId() {
        configuration = nil
        let isNotValid = configValidation.isTransactionNotValide(with: configuration, transactionType: .DefaultTransaction) { (response, errror) in
            XCTAssertEqual(errror!.localizedDescription, "JudoId cannot be null or empty")
        }
        XCTAssertTrue(isNotValid)
    }
    
    func testConsumerReferenceInvalid() {
        setUp()
        let reference40Characters = String(repeating: "J", count: Int(kMaximumLenghtForConsumerReference + 1))
        configuration.reference = JPReference(consumerReference: reference40Characters)
        let isNotValid = configValidation.isTransactionNotValide(with: configuration, transactionType: .DefaultTransaction) { (response, errror) in
            XCTAssertEqual(errror!.localizedDescription, "Consumer Reference is invalied")
        }
        XCTAssertTrue(isNotValid)
    }
    
//MARK: start testing apple validation rules
    func testAppleConfigIfValid() {
        initAppleConfig()
        let isNotValid = configValidation.isTransactionNotValide(with: configuration, transactionType: .AppleTransaction, completion: nil)
        XCTAssertFalse(isNotValid)
    }
    
    func testAppleConfigForNil() {
        configuration.applePayConfiguration = nil
        let isNotValid = configValidation.isTransactionNotValide(with: configuration, transactionType: .AppleTransaction) { (response, errror) in
            XCTAssertEqual(errror!.localizedDescription, "Apple Configuration is empty")
        }
        XCTAssertTrue(isNotValid)
    }
    
    func testAppleConfigForPaymentSummaryItemsEmpty() {
        initAppleConfig()
        configuration.applePayConfiguration?.paymentSummaryItems.removeAll()
        let isNotValid = configValidation.isTransactionNotValide(with: configuration, transactionType: .AppleTransaction) { (response, errror) in
            XCTAssertEqual(errror!.localizedDescription, "Payment items couldn't be empty")
        }
        XCTAssertTrue(isNotValid)
    }
    
    func testAppleConfigForShipingMethods() {
        initAppleConfig()
        configuration.applePayConfiguration?.requiredShippingContactFields = .postalAddress
        configuration.applePayConfiguration?.shippingMethods?.removeAll()
        let isNotValid = configValidation.isTransactionNotValide(with: configuration, transactionType: .AppleTransaction) { (response, errror) in
            XCTAssertEqual(errror!.localizedDescription, "Specify shipinng methonds")
        }
        XCTAssertTrue(isNotValid)
    }
    
    func testAppleConfigForInvalidCountryCode() {
        initAppleConfig()
        configuration.applePayConfiguration?.countryCode = ""
        let isNotValid = configValidation.isTransactionNotValide(with: configuration, transactionType: .AppleTransaction) { (response, errror) in
            XCTAssertEqual(errror!.localizedDescription, "Country Code is invalid")
        }
        XCTAssertTrue(isNotValid)
    }
    
    func testAppleConfigForInvalidMerchantId() {
        initAppleConfig()
        configuration.applePayConfiguration?.merchantId = ""
        let isNotValid = configValidation.isTransactionNotValide(with: configuration, transactionType: .AppleTransaction) { (response, errror) in
            XCTAssertEqual(errror!.localizedDescription, "Merchant Id cannot be empty")
        }
        XCTAssertTrue(isNotValid)
    }
    
    func testAppleConfigForUnsuportedCurrency() {
        initAppleConfig()
        configuration.applePayConfiguration?.currency = "XYZ"
        let isNotValid = configValidation.isTransactionNotValide(with: configuration, transactionType: .AppleTransaction) { (response, errror) in
            XCTAssertEqual(errror!.localizedDescription, "Unsuported Currency")
        }
        XCTAssertTrue(isNotValid)
    }
}
