//
//  JPRegisterCardRequestTests.swift
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

class JPRegisterCardRequestTests: XCTestCase {
    
    var configuration: JPConfiguration {
        let amount = JPAmount("1.01", currency: "EUR")
        
        let reference = JPReference(consumerReference: "consumer", paymentReference: "payment")
        reference.metaData = ["exampleKey": "exampleValue"];
        
        let configuration = JPConfiguration(judoID: "judoID", amount: amount, reference: reference)
        
        return configuration
    }
    
    /*
     * GIVEN: A [JPRegisterCardRequest] is being initialized
     *
     *  WHEN: A valid [JPConfiguration] instance is passed as a parameter
     *
     *  THEN: The properties are set with the correct values
     */
    func test_onInitialization_SetValidProperties() {
        let registerCardRequest = JPRegisterCardRequest(configuration: configuration)
        
        XCTAssertEqual(registerCardRequest.judoId, "judoID")
        
        XCTAssertEqual(registerCardRequest.amount, "1.01")
        XCTAssertEqual(registerCardRequest.currency, configuration.amount.currency)
        
        XCTAssertEqual(registerCardRequest.yourConsumerReference, configuration.reference.consumerReference)
        XCTAssertEqual(registerCardRequest.yourPaymentReference, configuration.reference.paymentReference)
        XCTAssertEqual(registerCardRequest.yourPaymentMetaData, configuration.reference.metaData)
    }
    
    /*
     * GIVEN: A [JPRegisterCardRequest] is being initialized
     *
     *  WHEN: The [JPConfiguration] instance does not have any amount
     *
     *  THEN: The amount defaults to "0.01 GBP"
     */
    func test_onNoCurrencyInitialization_SetDefaultCurrency() {
        
        let registerCardRequest = JPRegisterCardRequest(configuration: configuration)
        registerCardRequest.amount = nil;
        registerCardRequest.currency = nil;
        
        XCTAssertEqual(registerCardRequest.judoId, "judoID")
        
        XCTAssertEqual(registerCardRequest.amount, "0.01")
        XCTAssertEqual(registerCardRequest.currency, "GBP")
        
        XCTAssertEqual(registerCardRequest.yourConsumerReference, configuration.reference.consumerReference)
        XCTAssertEqual(registerCardRequest.yourPaymentReference, configuration.reference.paymentReference)
        XCTAssertEqual(registerCardRequest.yourPaymentMetaData, configuration.reference.metaData)
    }
}
