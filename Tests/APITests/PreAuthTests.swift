//
//  PreAuthTests.swift
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

class PreAuthTests: JudoTestCase {
    
    func testJudoMakeValidPreAuth() {
        // Given I have a Pre-authorization
        let payment = judo.preAuthWithJudoId(myJudoId, amount: oneGBPAmount, reference: validReference)
        
        // When I provide all the required fields
        payment.card = validVisaTestCard
        
        // Then I should be able to make a Pre-authorization
        let expectation = self.expectationWithDescription("payment expectation")
        
        payment.sendWithCompletion({ (response, error) -> () in
            if let error = error {
                XCTFail("api call failed with error: \(error)")
            }
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.items?.first)
            expectation.fulfill()
        })
        
        XCTAssertNotNil(payment)
        XCTAssertEqual(payment.judoId, myJudoId)
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testJudoMakePreAuthWithoutAmount() {
        // Given I have a Pre-authorization
        // When I do not provide an amount
        let payment = judo.preAuthWithJudoId(myJudoId, amount: invalidAmount, reference: validReference)
        
        payment.card = validVisaTestCard
        
        // Then I should receive an error
        let expectation = self.expectationWithDescription("payment expectation")
        
        payment.sendWithCompletion({ (response, error) -> () in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!.code, Int(JudoError.ErrorGeneral_Model_Error.rawValue))
            
            expectation.fulfill()
        })
        
        XCTAssertNotNil(payment)
        XCTAssertEqual(payment.judoId, myJudoId)
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    func testJudoMakePreAuthWithoutCurrency() {
        // Given I have a Pre-authorization
        // When I do not provide a currency
        let payment = judo.preAuthWithJudoId(myJudoId, amount: invalidCurrencyAmount, reference: validReference)
        
        payment.card = validVisaTestCard
        
        // Then I should receive an error
        let expectation = self.expectationWithDescription("payment expectation")
        
        payment.sendWithCompletion({ (response, error) -> () in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!.code, Int(JudoError.ErrorGeneral_Model_Error.rawValue))
            
            expectation.fulfill()
        })
        
        XCTAssertNotNil(payment)
        XCTAssertEqual(payment.judoId, myJudoId)
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    func testJudoMakePreAuthWithoutReference() {
        // Given I have a Pre-authorization
        // When I do not provide a consumer reference
        let payment = judo.preAuthWithJudoId(myJudoId, amount: oneGBPAmount, reference: invalidReference)
        
        payment.card = validVisaTestCard
        
        // Then I should receive an error
        let expectation = self.expectationWithDescription("payment expectation")
        
        payment.sendWithCompletion({ (response, error) -> () in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!.code, Int(JudoError.ErrorGeneral_Model_Error.rawValue))
            
            expectation.fulfill()
        })
        
        XCTAssertNotNil(payment)
        XCTAssertEqual(payment.judoId, myJudoId)
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
}
