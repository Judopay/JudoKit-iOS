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
    var configValidation: ConfigurationValidationService!
    lazy var reference = JPReference(consumerReference: consumerReference)

    override func setUp() {
        configValidation = JPConfigurationValidationService()
        amount = JPAmount("fv", currency: "GBR")
        
        configuration = JPConfiguration(judoID: "judoId", amount: self.amount, reference: reference)
        configuration.supportedCardNetworks = [.networkVisa, .networkMasterCard, .networkAMEX]
    }
    
    func testInvalidCharacters() {
        let isNotValid = configValidation.validateTransaction(with: configuration) { (response, errror) in
            XCTAssert(errror!.localizedDescription == "Amount should be a number")
        }
        XCTAssertTrue(isNotValid)

    }
    
    func testEmptyCurrency() {
        amount = JPAmount("0.1", currency: "")
        configuration.amount = amount
        let isNotValid = configValidation.validateTransaction(with: configuration) { (response, errror) in
            XCTAssert(errror!.localizedDescription == "Currency cannot be empty")
        }
        XCTAssertTrue(isNotValid)
    }
    
    func testNilJudoId() {
        configuration = nil
        let isNotValid = configValidation.validateTransaction(with: configuration) { (response, errror) in
            XCTAssert(errror!.localizedDescription == "JudoId cannot be null or empty")
        }
        XCTAssertTrue(isNotValid)
    }
    
}
