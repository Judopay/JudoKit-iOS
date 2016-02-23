//
//  RefundTests.swift
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
import JudoKitObjC

class RefundTests: XCTestCase {
    
    let judo = JudoKit(token: token, secret: secret)
    
    override func setUp() {
        super.setUp()
        
        judo.apiSession.sandboxed = true
    }
    
    override func tearDown() {
        judo.apiSession.sandboxed = false
        
        super.tearDown()
    }
    
    func testRefund() {
        // Given
        let card = JPCard(cardNumber: "4976000000003436", expiryDate: "12/20", secureCode: "452")
        let amount = JPAmount(amount: "30", currency: "GBP")
        let emailAddress = "hans@email.com"
        let mobileNumber = "07100000000"
        
        let location = CLLocationCoordinate2D(latitude: 0, longitude: 65)
        
        let expectation = self.expectationWithDescription("refund expectation")
        
        // When
        let makePayment = judo.paymentWithJudoId(strippedJudoID, amount: amount, consumerReference: "consumer0053252")
        makePayment.card = card
        makePayment.location = location
        makePayment.mobileNumber = mobileNumber
        makePayment.emailAddress = emailAddress
        makePayment.sendWithCompletion({ (data, error) -> () in
            if let error = error {
                XCTFail("api call failed with error: \(error)")
                return // BAIL
            }
            
            // Given
            guard let receiptID = data?.items?.first?.receiptId else {
                XCTFail()
                return // BAIL
            }
            let amount = JPAmount(amount: "30", currency: "GBP")
            let payRef = "payment123asd"
            
            // When
            let refund = self.judo.refundWithReceiptId(receiptID, amount: amount, paymentReference: payRef)
            refund.sendWithCompletion({ (dict, error) -> () in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                }
                expectation.fulfill()
            })
            
            // Then
            XCTAssertNotNil(refund)
            
        })
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
}
