//
//  JPCheckCardRequestTests.swift
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

class JPCheckCardRequestTests: XCTestCase {
    
    var configuration: JPConfiguration {
        let amount = JPAmount("0.01", currency: "GBP")
        
        let reference = JPReference(consumerReference: "consumer", paymentReference: "payment")
        reference.metaData = ["exampleKey": "exampleValue"];
        
        let configuration = JPConfiguration(judoID: "judoID", amount: amount, reference: reference)
        configuration.isInitialRecurringPayment = true;
        
        return configuration
    }
    
    /*
     * GIVEN: A [JPCheckCardRequest] is being initialized
     *
     *  WHEN: A valid [JPConfiguration] instance is passed as a parameter
     *
     *  THEN: The "initialRecurringPayment" should be set.
     */
    func test_onInitialization_SetValidProperties() {
        let checkCardRequest = JPCheckCardRequest(configuration: configuration)
        
        XCTAssertEqual(checkCardRequest.judoId, "judoID")
        
        XCTAssertEqual(checkCardRequest.amount, "0.00")
        XCTAssertEqual(checkCardRequest.currency, "GBP")
        
        XCTAssertEqual(checkCardRequest.yourConsumerReference, configuration.reference.consumerReference)
        XCTAssertEqual(checkCardRequest.yourPaymentReference, configuration.reference.paymentReference)
        XCTAssertEqual(checkCardRequest.yourPaymentMetaData, configuration.reference.metaData)
        XCTAssertTrue(checkCardRequest.initialRecurringPayment)
    }
    
    /*
     * GIVEN: A [JPCheckCardRequest] is being initialized
     *
     *  WHEN: A valid parameters are being passed to the initializer
     *
     *  THEN: The "initialRecurringPayment" should be set.
     */
    func test_onCardDetailsInitialization_SetValidProperties() {
        
        let cardDetails = JPCard(cardNumber: "4000000000000001",
                          cardholderName: "John",
                          expiryDate: "12/20",
                          secureCode: "123")
    
        let checkCardRequest = JPCheckCardRequest(configuration: configuration,
                                                  andCardDetails: cardDetails)
        
        XCTAssertEqual(checkCardRequest.judoId, "judoID")
        
        XCTAssertEqual(checkCardRequest.amount, "0.00")
        XCTAssertEqual(checkCardRequest.currency, "GBP")
        
        XCTAssertEqual(checkCardRequest.yourConsumerReference, configuration.reference.consumerReference)
        XCTAssertEqual(checkCardRequest.yourPaymentReference, configuration.reference.paymentReference)
        XCTAssertEqual(checkCardRequest.yourPaymentMetaData, configuration.reference.metaData)
        XCTAssertTrue(checkCardRequest.initialRecurringPayment)
    }
}
