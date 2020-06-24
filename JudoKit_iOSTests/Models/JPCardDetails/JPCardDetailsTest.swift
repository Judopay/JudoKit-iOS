//
//  JPCardDetailsTest.swift
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

class JPCardDetailsTest: XCTestCase {
    var cardDetailsDic: Dictionary<String, AnyObject>!
    
    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "CardDetails", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonResult = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        cardDetailsDic = jsonResult as? Dictionary<String, AnyObject>
    }
    
    /*
    * GIVEN: Creating JPCardDetails designed init
    *
    * WHEN: setup all properties
    *
    * THEN: should create correct fields in JPCardDetails object
    */
    func test_InitWithCardNumber_DesgignatedInitilizer() {
        let cardDetails = JPCardDetails(cardNumber: "4445", expiryMonth: 10, expiryYear: 2010)
        XCTAssertEqual(cardDetails.cardNumber, "4445")
        XCTAssertEqual(cardDetails.formattedExpiryDate(), "10/10")
    }
    
    /*
    * GIVEN: Creating JPCardDetails from dictionary
    *
    * WHEN: dictionary are parsed from json stub: CardDetails.json
    *
    * THEN: should create correct fields in JPCardDetails object
    */
    func test_InitWithDictionary_InitFromDisctionary() {
        let cardDetails = JPCardDetails(dictionary: cardDetailsDic["cardDetails"]! as! [AnyHashable : Any])
        XCTAssertEqual(cardDetails.cardLastFour, "1111")
        XCTAssertEqual(cardDetails.cardToken, "j7lQKJDfkTI3QbutMrxA9QQQZYQd2pXp")
        XCTAssertEqual(cardDetails.bank, "Jpmorgan Chase Bank, N.A.")
        XCTAssertEqual(cardDetails.cardCountry, "US")
        XCTAssertEqual(cardDetails.formattedCardLastFour(), "**** **** **** 1111")
        XCTAssertEqual(cardDetails.cardNetwork, .visa)
    }
    
}
