//
//  JPTransactionDataTest.swift
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

class JPTransactionDataTest: XCTestCase {
    
    var dic: [String : Any]! = nil
    
    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: type(of: self))
        let dic = bundle.path(forResource: "TransactionData", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: dic), options: .mappedIfSafe)
        let jsonResult = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        self.dic = jsonResult as? Dictionary<String, AnyObject>
    }
    
    /*
     * GIVEN: Creating JPTransactionData designated init
     *
     * WHEN: populating with dictionary
     *
     * THEN: should create correct fields in JPTransactionData object
     */
    func test_InitWithDictionary_WhenInitTransactionData_ShouldPopulateRight() {
        let transactionDataSUT = JPTransactionData(dictionary: dic)
        XCTAssertEqual(transactionDataSUT.receiptId, "receiptId")
        XCTAssertEqual(transactionDataSUT.type, .payment)
        XCTAssertEqual(transactionDataSUT.createdAt, "createdAt")
        XCTAssertEqual(transactionDataSUT.result, .success)
        XCTAssertEqual(transactionDataSUT.message, "message")
        XCTAssertEqual(transactionDataSUT.redirectUrl, "redirectUrl")
        
        XCTAssertEqual(transactionDataSUT.cardDetails?.cardToken, "cardToken")
        XCTAssertEqual(transactionDataSUT.cardDetails?.cardLastFour, "cardLastfour")
        XCTAssertEqual(transactionDataSUT.cardDetails?.endDate, "endDate")
        XCTAssertEqual(transactionDataSUT.cardDetails?.cardNumber, "cardNumber")
        XCTAssertEqual(transactionDataSUT.cardDetails?.cardCategory, "cardCategory")
        XCTAssertEqual(transactionDataSUT.cardDetails?.cardCountry, "cardCountry")
        XCTAssertEqual(transactionDataSUT.cardDetails?.cardFunding, "cardFunding")
        XCTAssertEqual(transactionDataSUT.cardDetails?.cardScheme, "cardScheme")
    }
    
    /*
     * GIVEN: Creating JPTransactionData designated init
     *
     * GIVEN: retrieve paymentToken
     *
     * THEN: should create correct fields in JPPaymentToken object
     */
    func test_PaymentToken_WhenTransactionInits_ShouldReturnJPPaymentToken() {
        let transactionDataSUT = JPTransactionData(dictionary: dic)
        let tokenSUT = transactionDataSUT.paymentToken
        XCTAssertEqual(tokenSUT.cardToken, "cardToken")
        XCTAssertEqual(tokenSUT.consumerToken, "consumerToken")
    }
    
    /*
     * GIVEN: Creating JPTransactionData Declined
     *
     * GIVEN: retrieve result
     *
     * THEN: should create correct fields Declined
     */
    func test_PaymentToken_WhenTransactionDeclined_ShouldReturnDeclinedType() {
        dic["result"] = "Declined"
        let transactionDataSUT = JPTransactionData(dictionary: dic)
        XCTAssertEqual(transactionDataSUT.result, .declined)
    }
}
