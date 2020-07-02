//
//  JPTransactionEnricherTest.swift
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

class JPTransactionEnricherTest: XCTestCase {
    let sut = JPTransactionService(token: "TOKEN", andSecret: "SECRET")
    lazy var transactionAmmount = JPAmount("100.0", currency: "EUR")
    lazy var transactionReference = JPReference(consumerReference: "consumerReference",
                                                paymentReference: "PaymentReference")
    lazy var transactionConfigurations = JPConfiguration(judoID: "JUDOID",
                                                         amount: transactionAmmount,
                                                         reference: transactionReference)
    
    let enrich = JPTransactionEnricher(token: "token", secret: "secret")
    
    /*
     * GIVEN: Creating JPTransactionEnricher designed init
     *
     * WHEN: all fields are valid
     *
     * THEN: should create correct fields in JPTransactionEnricher object
     */
    func test_initWithToken() {
        let enricher = JPTransactionEnricher(token: "token", secret: "secret")
        XCTAssertNotNil(enricher)
    }
    
    /*
     * GIVEN: JPTransactionEnricher object
     *
     * WHEN: transaction type is .checkCard
     *
     * THEN: should return transaction, without enrich it
     */
    func test_enrichTransaction() {
        let expectation = self.expectation(description: "get response from enricher")
        sut.transactionType = .checkCard
        let transaction = sut.transaction(with: transactionConfigurations)
        
        let completion: () -> Void = {
            XCTAssertNil(transaction.getParameters()["EnhancedPaymentDetail"])
            expectation.fulfill()
        }
        
        enrich.enrichTransaction(transaction, withCompletion: completion)
        waitForExpectations(timeout: 1, handler: nil)
    }
}
