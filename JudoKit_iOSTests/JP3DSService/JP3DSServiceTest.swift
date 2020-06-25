//
//  JP3DSServiceTest.swift
//  JudoKit-iOSTests
//
//  Copyright (c) 2020 Alternative Payments Ltd
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

class JP3DSServiceTest: XCTestCase {
    let transactionService = JPTransactionService(token: "TOKEN", andSecret: "SECRET")
    lazy var transactionAmmount = JPAmount("100.0", currency: "EUR")
    lazy var transactionReference = JPReference(consumerReference: "consumerReference",
                                                paymentReference: "PaymentReference")
    lazy var transactionConfigurations = JPConfiguration(judoID: "JUDOID",
                                                         amount: transactionAmmount,
                                                         reference: transactionReference)

    var transaction: JPTransaction!
    
    override func setUp() {
        transaction = transactionService.transaction(with: transactionConfigurations)
    }
    
    /*
     * GIVEN: Invoke 3DSecure ViewController
     *
     * WHEN: injecting transaction object
     *
     * THEN: should keep same transaction model after presenting 3DSecure ViewController
     */
    func test_Invoke3DSecureViewControllerWithError_WhenInkectTransacton_ShouldKeepTransaction() {
        let service = JP3DSService()
        service.transaction = transaction
        let error = JPError(domain: "", code: Int(JudoError.error3DSRequest.rawValue), userInfo: nil)
        service.invoke3DSecureViewControllerWithError(error) { _, _ in }
        XCTAssertEqual(service.transaction, self.transaction)
    }
}
