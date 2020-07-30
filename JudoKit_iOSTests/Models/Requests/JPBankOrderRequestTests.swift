//
//  JPBankOrderRequestTests.swift
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

class JPBankOrderRequestTests: XCTestCase {
    
    let kIDEALAccountHolderName = "IDEAL Bank";
    let kIDEALCountry = "NL";
    let kPaymentMethodIDEAL = "IDEAL";

    let kPbBAAccountHolderName = "PBBA User";
    let kPbBACountry = "GB";
    let kPaymentMethodPbBA = "PBBA";
    let kPbBABIC = "RABONL2U";
    
    var configuration: JPConfiguration {
        let amount = JPAmount("0.01", currency: "GBP")
        
        let reference = JPReference(consumerReference: "consumer", paymentReference: "payment")
        reference.metaData = ["exampleKey": "exampleValue"];
        
        let configuration = JPConfiguration(judoID: "judoID", amount: amount, reference: reference)
        
        return configuration
    }
    
    /*
     * GIVEN: A [JPBankOrderSaleRequest] is being initialized
     *
     *  WHEN: A valid [JPConfiguration] instance is passed as a parameter
     *
     *  THEN: The request parameters are going to be set correctly
     */
    func test_onDefaultInitialization_SetValidProperties() {
        let bankRequest = JPBankOrderSaleRequest(configuration: configuration)
        
        XCTAssertEqual(bankRequest.judoId, configuration.judoId)
        
        XCTAssertEqual(bankRequest.amount?.stringValue, configuration.amount.amount)
        XCTAssertEqual(bankRequest.currency, configuration.amount.currency)
        
        XCTAssertEqual(bankRequest.merchantConsumerReference, configuration.reference.consumerReference)
        XCTAssertEqual(bankRequest.merchantPaymentReference, configuration.reference.paymentReference)
        XCTAssertEqual(bankRequest.paymentMetadata, configuration.reference.metaData)
    }
    
    /*
     * GIVEN: A [JPBankOrderSaleRequest] is being initialized via the PBBA initializer
     *
     *  WHEN: A valid [JPConfiguration] instance is passed as a parameter
     *
     *  THEN: The request parameters are going to be set correctly
     */
    func test_onIDEALInitialization_SetIDEALProperties() {
        let bankRequest = JPBankOrderSaleRequest.idealRequest(with: configuration, andBIC: "12345")
        
        XCTAssertEqual(bankRequest.judoId, configuration.judoId)
        
        XCTAssertEqual(bankRequest.amount?.stringValue, configuration.amount.amount)
        XCTAssertEqual(bankRequest.currency, configuration.amount.currency)
        
        XCTAssertEqual(bankRequest.merchantConsumerReference, configuration.reference.consumerReference)
        XCTAssertEqual(bankRequest.merchantPaymentReference, configuration.reference.paymentReference)
        XCTAssertEqual(bankRequest.paymentMetadata, configuration.reference.metaData)
        
        XCTAssertEqual(bankRequest.country, kIDEALCountry)
        XCTAssertEqual(bankRequest.accountHolderName, kIDEALAccountHolderName)
        XCTAssertEqual(bankRequest.paymentMethod, kPaymentMethodIDEAL)
        XCTAssertEqual(bankRequest.bic, "12345")
    }
    
    /*
     * GIVEN: A [JPBankOrderSaleRequest] is being initialized via the PBBA initializer
     *
     *  WHEN: A valid [JPConfiguration] instance is passed as a parameter
     *
     *  THEN: The request parameters are going to be set correctly
     */
    func test_onPayByBankInitialization_SetPBBAProperties() {
        let bankRequest = JPBankOrderSaleRequest.pbbaRequest(with: configuration)
        
        XCTAssertEqual(bankRequest.judoId, configuration.judoId)
        
        XCTAssertEqual(bankRequest.amount?.stringValue, configuration.amount.amount)
        XCTAssertEqual(bankRequest.currency, configuration.amount.currency)
        
        XCTAssertEqual(bankRequest.merchantConsumerReference, configuration.reference.consumerReference)
        XCTAssertEqual(bankRequest.merchantPaymentReference, configuration.reference.paymentReference)
        XCTAssertEqual(bankRequest.paymentMetadata, configuration.reference.metaData)
        
        XCTAssertEqual(bankRequest.country, kPbBACountry)
        XCTAssertEqual(bankRequest.accountHolderName, kPbBAAccountHolderName)
        XCTAssertEqual(bankRequest.paymentMethod, kPaymentMethodPbBA)
        XCTAssertEqual(bankRequest.bic, kPbBABIC)
    }
    
}
