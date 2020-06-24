//
//  JPOrderDetailsTest.swift
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

class JPOrderDetailsTest: XCTestCase {
    var cardDetailsDic: Dictionary<String, AnyObject>!
    
    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "OrderDetails", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonResult = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        cardDetailsDic = jsonResult as? Dictionary<String, AnyObject>
    }
    
    /*
     * GIVEN: Creating JPOrderDetails from dictionary/Json
     *
     * WHEN: dictionary are parsed from json stub: JPOrderDetails.json
     *
     * THEN: should create correct fields in JPOrderDetails object
     */
    func test_InitWithDictionary_WhenRecieveJson_ShouldPopulateFields() {
        let cardDetails = JPOrderDetails(dictionary: cardDetailsDic["orderDetails"] as! [AnyHashable : Any])
        XCTAssertEqual(cardDetails.amount, 0.14999999999999999)
        XCTAssertEqual(cardDetails.timestamp, "2020-05-19T10:25:22.238Z")
        XCTAssertNil(cardDetails.orderFailureReason)
        XCTAssertEqual(cardDetails.orderStatus, "SUCCEEDED")
        XCTAssertEqual(cardDetails.orderId, "BTO-P5nhpXwATLSvJvI4WP90Dg")
    }
    
}

