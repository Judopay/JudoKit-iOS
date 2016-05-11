//
//  DedupTestCase.swift
//  JudoTests
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
@testable import JudoKitObjC

class DedupTestCase: JudoTestCase {

    func testJudoMakeSuccesfulDedupPayment() {
        let payment = judo.paymentWithJudoId(myJudoId, amount: oneGBPAmount, reference: validReference)
        
        payment.card = validVisaTestCard
        
        let expectation = self.expectationWithDescription("payment expectation")
        
        payment.sendWithCompletion({ (response, error) -> () in
            
            if let error = error {
                XCTFail("api call failed with error: \(error)")
            }
            
            let payment2 = self.judo.paymentWithJudoId(myJudoId, amount: self.oneGBPAmount, reference: JPReference(consumerReference: "consumer reference"))
            
            payment2.card = self.validVisaTestCard
            
            payment2.sendWithCompletion({ (response, error) in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                }
                XCTAssertNotNil(response)
                XCTAssertNotNil(response?.items?.first)
                expectation.fulfill()
            })
            
        })
        
        XCTAssertNotNil(payment)
        XCTAssertEqual(payment.judoId, myJudoId)
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    func testJudoMakeDeclinedDedupPayment() {
        // Given I have a Payment
        let payment = judo.paymentWithJudoId(myJudoId, amount: oneGBPAmount, reference: validReference)
        
        // When I provide all the required fields
        payment.card = validVisaTestCard
        
        // Then I should be able to make a payment
        let expectation = self.expectationWithDescription("payment expectation")
        
        payment.sendWithCompletion({ (response, error) -> () in
            
            if let error = error {
                XCTFail("api call failed with error: \(error)")
            }
            
            payment.sendWithCompletion({ (response, error) in
                XCTAssertEqual(Int(JudoError.ErrorDuplicateTransaction.rawValue), error?.code)
                expectation.fulfill()
            })
            
        })
        
        XCTAssertNotNil(payment)
        XCTAssertEqual(payment.judoId, myJudoId)
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }

}
