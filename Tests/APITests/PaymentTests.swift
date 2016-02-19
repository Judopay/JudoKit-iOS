//
//  PaymentTests.swift
//  Judo
//
//  Copyright (c) 2016 Alternative Payments Ltd
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
import CoreLocation
import JudoKitObjC


class PaymentTests: XCTestCase {
    
    let judo = JudoKit(token: token, secret: secret)
    
    override func setUp() {
        super.setUp()
        
        judo.currentAPISession.sandboxed = true
    }
    
    
    
    override func tearDown() {
        judo.currentAPISession.sandboxed = false
        
        super.tearDown()
    }
    
    
    
    func testPayment() {
        let amount = JPAmount(amount: "30", currency: "GBP")
        let payment = judo.paymentWithJudoId(strippedJudoID, amount: amount, consumerReference: "consumer0053252")
        XCTAssertNotNil(payment)
    }
    
    
    func testJudoMakeValidPayment() {
        // Given
        let address = JPAddress(line1: "242 Acklam Road", line2: "Westbourne Park", line3: nil, postCode: "W10 5JJ", town: "London")
        let card = JPCard(cardNumber: "4976000000003436", expiryDate: "12/15", secureCode: "452")
        card.cardAddress = address
        let amount = JPAmount(amount: "30", currency: "GBP")
        let emailAddress = "hans@email.com"
        let mobileNumber = "07100000000"
        
        let location = CLLocationCoordinate2D(latitude: 0, longitude: 65)
        
        let expectation = self.expectationWithDescription("payment expectation")
        
        // When
        let makePayment = judo.paymentWithJudoId(strippedJudoID, amount: amount, consumerReference: "consumer0053252")
        makePayment.card = card
        makePayment.location = location
        makePayment.mobileNumber = mobileNumber
        makePayment.emailAddress = emailAddress
        makePayment.sendWithCompletion({ (data, error) -> () in
            if let error = error {
                XCTFail("api call failed with error: \(error)")
            } else {
                expectation.fulfill()
            }
        })
        // Then
        XCTAssertNotNil(makePayment)
        XCTAssertEqual(makePayment.judoId, strippedJudoID)
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    
    func testJudoMakeValidTokenPayment() {
        // Given
        let address = JPAddress(line1: "242 Acklam Road", line2: "Westbourne Park", line3: nil, postCode: "W10 5JJ", town: "London")
        let card = JPCard(cardNumber: "4976000000003436", expiryDate: "12/15", secureCode: "452")
        card.cardAddress = address
        let amount = JPAmount(amount: "30", currency: "GBP")
        let emailAddress = "hans@email.com"
        let mobileNumber = "07100000000"
        
        let location = CLLocationCoordinate2D(latitude: 0, longitude: 65)
        
        let expectation = self.expectationWithDescription("payment expectation")
        
        // When
        let makePayment = judo.paymentWithJudoId(strippedJudoID, amount: amount, consumerReference: "consumer0053252")
        makePayment.card = card
        makePayment.location = location
        makePayment.mobileNumber = mobileNumber
        makePayment.emailAddress = emailAddress
        makePayment.sendWithCompletion({ (data, error) -> () in
            if let _ = error {
                XCTFail()
            } else {
                guard let uData = data, items = uData.items, item = items.first else {
                    XCTFail("no data available")
                    return // BAIL
                }
                let payToken = JPPaymentToken(consumerToken: item.consumer.consumerToken, cardToken: item.cardDetails.cardToken!)
                let payment = self.judo.paymentWithJudoId(strippedJudoID, amount: amount, consumerReference: "consumer0053252")
                payment.paymentToken = payToken
                payment.sendWithCompletion({ (data, error) -> () in
                    if let error = error {
                        XCTFail("api call failed with error: \(error)")
                    } else {
                        expectation.fulfill()
                    }
                })
            }
        })
        // Then
        XCTAssertNotNil(makePayment)
        XCTAssertEqual(makePayment.judoId, strippedJudoID)
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    func testJudoValidation() {
        // Given
        let address = JPAddress(line1: "242 Acklam Road", line2: "Westbourne Park", line3: nil, postCode: "W10 5JJ", town: "London")
        let card = JPCard(cardNumber: "4976000000003436", expiryDate: "12/15", secureCode: "452")
        card.cardAddress = address
        let amount = JPAmount(amount: "30", currency: "GBP")
        let emailAddress = "hans@email.com"
        let mobileNumber = "07100000000"
        
        let location = CLLocationCoordinate2D(latitude: 0, longitude: 65)
        
        let expectation = self.expectationWithDescription("payment expectation")
        
        // When
        let makePayment = judo.paymentWithJudoId(strippedJudoID, amount: amount, consumerReference: "consumer0053252")
        makePayment.card = card
        makePayment.location = location
        makePayment.mobileNumber = mobileNumber
        makePayment.emailAddress = emailAddress
        makePayment.validateWithCompletion { response, error in
            if let error = error {
                XCTAssertEqual(error.code, JudoErrorCode.Validation_Passed)
            } else {
                XCTFail("api call failed with error: \(error)")
            }
            expectation.fulfill()
        }
        // Then
        XCTAssertNotNil(makePayment)
        XCTAssertEqual(makePayment.judoId, strippedJudoID)
        
        self.waitForExpectationsWithTimeout(30.0, handler: nil)
        
    }

}
