//
//  JPPaymentRequestTests.swift
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

class JPPaymentRequestTests: XCTestCase {
    
    var configuration: JPConfiguration {
        let amount = JPAmount("0.01", currency: "GBP")
        
        let reference = JPReference(consumerReference: "consumer", paymentReference: "payment")
        reference.metaData = ["exampleKey": "exampleValue"];
        
        let configuration = JPConfiguration(judoID: "judoID", amount: amount, reference: reference)
        
        return configuration
    }
    
    /*
     * GIVEN: A [JPPaymentRequest] is being initialized
     *
     *  WHEN: A valid [JPConfiguration] instance is passed as a parameter
     *
     *  THEN: The request parameters are going to be set correctly
     */
    func test_onDefaultInitialization_SetValidProperties() {
        let paymentRequest = JPPaymentRequest(configuration: configuration)
        
        XCTAssertEqual(paymentRequest.judoId, "judoID")
        
        XCTAssertEqual(paymentRequest.amount, configuration.amount.amount)
        XCTAssertEqual(paymentRequest.currency, configuration.amount.currency)
        
        XCTAssertEqual(paymentRequest.yourConsumerReference, configuration.reference.consumerReference)
        XCTAssertEqual(paymentRequest.yourPaymentReference, configuration.reference.paymentReference)
        XCTAssertEqual(paymentRequest.yourPaymentMetaData, configuration.reference.metaData)
    }
    
    /*
     * GIVEN: A [JPPaymentRequest] is being initialized
     *
     *  WHEN: A valid [JPConfiguration] and [JPCard] instance are passed as a parameter
     *
     *  THEN: The request parameters are going to be set correctly
     */
    func test_OnCardDetailsInitialization_SetValidProperties() {
        
        let cardDetails = JPCard(cardNumber: "1111 2222 3333 4444",
                                 cardholderName: "Silvester Stallone",
                                 expiryDate: "01/00",
                                 secureCode: "123")
        
        cardDetails.cardAddress = JPAddress(line1: "Line 1",
                                            line2: "Line 2",
                                            line3: "Line 3",
                                            town: "Town",
                                            countryCode:123,
                                            postCode: "Postcode")
        
        let paymentRequest = JPPaymentRequest(configuration: configuration, andCardDetails: cardDetails)
        
        XCTAssertEqual(paymentRequest.judoId, "judoID")
        
        XCTAssertEqual(paymentRequest.amount, configuration.amount.amount)
        XCTAssertEqual(paymentRequest.currency, configuration.amount.currency)
        
        XCTAssertEqual(paymentRequest.yourConsumerReference, configuration.reference.consumerReference)
        XCTAssertEqual(paymentRequest.yourPaymentReference, configuration.reference.paymentReference)
        XCTAssertEqual(paymentRequest.yourPaymentMetaData, configuration.reference.metaData)
        
        XCTAssertEqual(paymentRequest.cardNumber, cardDetails.cardNumber)
        XCTAssertEqual(paymentRequest.expiryDate, cardDetails.expiryDate)
        XCTAssertEqual(paymentRequest.cv2, cardDetails.secureCode)
        
        XCTAssertEqual(paymentRequest.cardAddress?.line1, cardDetails.cardAddress?.line1)
        XCTAssertEqual(paymentRequest.cardAddress?.line2, cardDetails.cardAddress?.line2)
        XCTAssertEqual(paymentRequest.cardAddress?.line3, cardDetails.cardAddress?.line3)
        XCTAssertEqual(paymentRequest.cardAddress?.town, cardDetails.cardAddress?.town)
        XCTAssertEqual(paymentRequest.cardAddress?.countryCode, cardDetails.cardAddress?.countryCode)
        XCTAssertEqual(paymentRequest.cardAddress?.postCode, cardDetails.cardAddress?.postCode)
    }
    
}
