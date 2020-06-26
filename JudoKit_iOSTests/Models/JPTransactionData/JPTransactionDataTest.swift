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
    
    var dic = ["receiptId":"receiptId",
               "orderId": "orderId",
               "type":"Payment",
               "createdAt":"createdAt",
               "result":"Success",
               "message":"message",
               "redirectUrl":"redirectUrl",
               "merchantName":"merchantName",
               "appearsOnStatementAs":"appearsOnStatementAs",
               "paymentMethod":"paymentMethod",
               "siteId":"siteId",
               "merchantPaymentReference":"merchantPaymentReference",
               "consumer":["consumerReference":"consumerReference",
                           "consumerToken":"consumerToken"],
               "orderDetails":["orderId":"orderId",
                               "orderStatus":"orderStatus",
                               "orderFailureReason":"orderFailureReason",
                               "timestamp":"timestamp",
                               "amount":999],
               "cardDetails":["cardLastfour":"cardLastfour",
                              "endDate":"endDate",
                              "cardToken":"cardToken",
                              "cardNumber":"cardNumber",
                              "cardCategory":"cardCategory",
                              "cardCountry":"cardCountry",
                              "cardFunding":"cardFunding",
                              "cardScheme":"cardScheme",
                              "cardType":0]] as [String : Any]
    
    /*
     * GIVEN: Creating JPTransactionData designed init
     *
     * WHEN: populating with dictionary
     *
     * THEN: should create correct fields in JPTransactionData object
     */
    func test_InitWithDictionary_WhenInitTransactionData_ShouldPopulateRight() {
        let transactionDataSUT = JPTransactionData(dictionary: dic)
        transactionDataSUT.receiptId = "receiptId"
        transactionDataSUT.type = .payment
        transactionDataSUT.createdAt = "createdAt"
        transactionDataSUT.result = .success
        transactionDataSUT.message = "message"
        transactionDataSUT.redirectUrl = "redirectUrl"
        
        transactionDataSUT.cardDetails?.cardToken = "cardToken"
        transactionDataSUT.cardDetails?.cardLastFour = "cardLastfour"
        transactionDataSUT.cardDetails?.endDate = "endDate"
        transactionDataSUT.cardDetails?.cardNumber = "cardNumber"
        transactionDataSUT.cardDetails?.cardCategory = "cardCategory"
        transactionDataSUT.cardDetails?.cardCountry = "cardCountry"
        transactionDataSUT.cardDetails?.cardFunding = "cardFunding"
        transactionDataSUT.cardDetails?.cardScheme = "cardScheme"
    }
    
    /*
     * GIVEN: Creating JPTransactionData designed init
     *
     * GIVEN: retrieve paymentToken
     *
     * THEN: should create correct fields in JPPaymentToken object
     */
    func test_PaymentToken_WhenTransactionInites_ShouldReturnJPPaymentToken() {
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
