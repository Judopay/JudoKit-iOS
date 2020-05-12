//
//  JPTransactionServiceTest.swift
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

@testable import JudoKit

class JPTransactionServiceTest: XCTestCase {
    
    let sut = JPTransactionService(token: "TOKEN", andSecret: "SECRET")
    lazy var transactionAmmount = JPAmount("100.0", currency: "EUR")
    lazy var transactionReference = JPReference(consumerReference: "consumerReference",
                                                paymentReference: "PaymentReference")
    lazy var transactionConfigurations = JPConfiguration(judoID: "JUDAID",
                                                         amount: transactionAmmount,
                                                         reference: transactionReference)
    
    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testTransactionWithConfigurations() {
        let transaction = sut.transaction(with: transactionConfigurations)
        
        XCTAssertEqual(transaction.amount!.amount, transactionAmmount.amount)
        XCTAssertEqual(transaction.amount!.currency, transactionAmmount.currency)
        XCTAssertEqual(transaction.reference!.consumerReference, transactionReference.consumerReference)
        XCTAssertEqual(transaction.reference!.paymentReference, transactionReference.paymentReference)
    }
    
    func testIsSandbox() {
        XCTAssertFalse(sut.isSandboxed)
        sut.isSandboxed = true
        XCTAssertTrue(sut.isSandboxed)
    }
    
    func testSendRequest() {
        let stubObject = ["paymentMethod":"PBBA",
                          "siteId": "xxx-xxx-siteId",
                          "orderDetails": ["orderId": "xxx-orderid",
                                           "orderStatus": "PENDING",
                                           "timestamp": "2020-05-05T07:29:04.663Z",
                                           "currency": "GBP",
                                           "amount": 0.15,
                                           "refundedAmount": 0.0],
                          "merchantPaymentReference": "xxx-xxx-ref_id",
                          "merchantConsumerReference": "reference"] as [String : Any]
        
        stub(condition: isHost("api.judopay.com")) { _ in
            return HTTPStubsResponse(jsonObject: stubObject, statusCode: 200, headers: nil)
        }
        
        let expectation = self.expectation(description: "expect")
        
        sut.sendRequest(withEndpoint: "order/bank/statusrequest/123",
                        httpMethod: .GET,
                        parameters: nil) { (response, error) in
                            XCTAssertEqual("xxx-xxx-siteId", response!.items!.first!.judoId)
                            XCTAssertEqual("PBBA", response!.items!.first!.paymentMethod)
                            XCTAssertEqual("xxx-xxx-ref_id", response!.items!.first!.paymentReference)
                            XCTAssertEqual(stubObject["siteId"] as! String,
                                           response!.items!.first!.rawData["siteId"] as! String)
                            XCTAssertEqual(stubObject["paymentMethod"] as! String,
                                           response!.items!.first!.rawData["paymentMethod"] as! String)
                            XCTAssertEqual(stubObject["merchantPaymentReference"] as! String,
                                           response!.items!.first!.rawData["merchantPaymentReference"] as! String)
                            XCTAssertEqual(stubObject["merchantConsumerReference"] as! String,
                                           response!.items!.first!.rawData["merchantConsumerReference"] as! String)
                            
                            let orderDetails = response!.items!.first!.rawData["orderDetails"] as! [String : Any]
                            let stubOrderDetails = stubObject["orderDetails"] as! [String : Any]
                            XCTAssertEqual(stubOrderDetails["orderId"] as! String, orderDetails["orderId"] as! String)
                            XCTAssertEqual(stubOrderDetails["orderStatus"] as! String, orderDetails["orderStatus"] as! String)
                            XCTAssertEqual(stubOrderDetails["timestamp"] as! String, orderDetails["timestamp"] as! String)
                            XCTAssertEqual(stubOrderDetails["currency"] as! String, orderDetails["currency"] as! String)
                            XCTAssertEqual(stubOrderDetails["amount"] as! Double, orderDetails["amount"] as! Double)
                            XCTAssertEqual(stubOrderDetails["refundedAmount"] as! Double, orderDetails["refundedAmount"] as! Double)
                            XCTAssertNil(error)
                            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}

