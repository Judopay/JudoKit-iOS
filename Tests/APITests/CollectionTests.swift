//
//  CollectionTests.swift
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

class CollectionTests: JudoTestCase {
    
    func testCollection() {
        
        let expectation = self.expectationWithDescription("payment expectation")
        
        // Given I have made a pre-authorisation
        let preAuth = judo.preAuthWithJudoId(myJudoID, amount: oneGBPAmount, reference: validReference)
        preAuth.card = validVisaTestCard
        
        preAuth.sendWithCompletion { (response, error) in
            
            if let error = error {
                XCTFail("api call failed with error: \(error)")
                expectation.fulfill()
                return
            }
            
            // And I have a receipt ID of a given transaction
            // And I have the amount of that transaction
            guard let receiptId = response?.items?.first?.receiptId,
                let amount = response?.items?.first?.amount else {
                    XCTFail("receipt ID was not available in response")
                    expectation.fulfill()
                    return
            }
            
            // When I perform a collection
            let collection = self.judo.collectionWithReceiptId(receiptId, amount: amount)
            collection.sendWithCompletion({ (response, error) -> () in
                // Then I receive a successful response
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                }
                
                XCTAssertNotNil(response)
                XCTAssertNotNil(response?.items?.first)
                
                expectation.fulfill();
            })
            
            XCTAssertNotNil(collection)
            
        }
        
        XCTAssertNotNil(preAuth)
        XCTAssertEqual(preAuth.judoId, myJudoID)
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
        
    }
    
}
