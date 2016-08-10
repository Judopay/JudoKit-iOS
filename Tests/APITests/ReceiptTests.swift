//
//  ReceiptTests.swift
//  JudoKitObjCTests
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

class ReceiptTests: JudoTestCase {
    
    func testJudoTransactionReceipt() {

        let initialPayment = judo.paymentWithJudoId(myJudoId, amount: oneGBPAmount, reference: validReference)
        
        initialPayment.card = validVisaTestCard
        
        let expectation = self.expectationWithDescription("receipt fetch expectation")
        
        initialPayment.sendWithCompletion({ (response, error) -> () in
            if let error = error {
                XCTFail("api call failed with error: \(error)")
            }
            
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.items?.first)
            let receiptId = response?.items?.first?.receiptId as String!
            
            // Given i have a valid receiptID
            XCTAssertNotNil(receiptId, "Null receiptId");
            XCTAssertTrue(receiptId?.characters.count != 0, "Empty receiptId")
            XCTAssertNotNil(initialPayment)
            XCTAssertEqual(initialPayment.judoId, myJudoId)
            
            let payment = self.judo.paymentWithJudoId(myJudoId, amount: self.oneGBPAmount, reference: self.validReference)
            XCTAssertNotNil(payment)
            
            self.judo.receipt(receiptId).sendWithCompletion({ (dict, error) -> () in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                }
                expectation.fulfill()
            })
        })
        
        self.waitForExpectationsWithTimeout(30.0, handler: nil)
        
    }
    
    func testJudoTransactionAllReceipts() {
        // Given
        let expectation = self.expectationWithDescription("all receipts fetch expectation")
        
        judo.receipt(nil).sendWithCompletion({ (dict, error) -> () in
            if let error = error {
                XCTFail("api call failed with error: \(error)")
            }
            expectation.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(30.0, handler: nil)
        
    }
    
    
    func testJudoTransactionReceiptWithPagination() {
        // Given
        let page = JPPagination(offset: 8, pageSize: 4, sort: "time-ascending")
        let expectation = self.expectationWithDescription("all receipts fetch expectation")
        
        let receipt = judo.receipt(nil)
        
        receipt.listWithPagination(page) { (dict, error) -> () in
            if let error = error {
                XCTFail("api call failed with error: \(error)")
            } else {
                XCTAssertEqual(dict!.items?.count, 4)
                XCTAssertEqual(dict!.pagination!.offset, 8)
            }
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(30.0, handler: nil)
    }
    
}
