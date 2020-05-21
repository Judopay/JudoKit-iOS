//
//  JPTransactionTest.swift
//  JudoKit-iOSTests
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

class JPTransactionTest: XCTestCase {
    let amount = JPAmount(amount: "989", currency: "USD")
    
    /*
     * GIVEN: Creating JPTransaction with Designated Init
     *
     * WHEN: insert receiptId and amount
     *
     * THEN: should create correct parameters fields
     */
    func test_InitWithType_WhenSetupAmountAndEReciep_ShouldPopulateParameters() {
        let transactionSUT = JPTransaction(type: .payment, receiptId: "recieptId", amount: amount)
        XCTAssertEqual(transactionSUT.amount?.amount, "989")
        XCTAssertEqual(transactionSUT.amount?.currency, "USD")
    }
    
    /*
     * GIVEN: Creating card and insert in JPTransaction object
     *
     * WHEN: card fields are valid
     *
     * THEN: should create correct properties from card fields
     */
    func test_SetCard_WhenCardPropertiesExist_ShouldPopulateParameters() {
        let transactionSUT = JPTransaction(type: .payment)
        let card = JPCard(cardNumber: "cardNumber", cardholderName: "cardholderName", expiryDate: "expiryDate", secureCode: "secureCode")
        transactionSUT.card = card
        
        XCTAssertEqual(transactionSUT.card?.cardNumber, "cardNumber")
        XCTAssertEqual(transactionSUT.card?.cardholderName, "cardholderName")
        XCTAssertEqual(transactionSUT.card?.expiryDate, "expiryDate")
        XCTAssertEqual(transactionSUT.card?.secureCode, "secureCode")
    }
}
