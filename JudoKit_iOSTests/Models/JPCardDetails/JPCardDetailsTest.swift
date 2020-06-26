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
    
    /*
     * GIVEN: Creating JPCardDetails from dictionary
     *
     * WHEN: endDate is nil
     *
     * THEN: should format end date and return nil
     */
    func test_FormattedExpiryDate_WhenEndDateNil_ShouldReturnNil() {
        var dic = cardDetailsDic["cardDetails"]! as! [AnyHashable : Any]
        dic["endDate"] = nil;
        let cardDetails = JPCardDetails(dictionary: dic)
        XCTAssertNil(cardDetails.formattedExpiryDate())
    }
    
    /*
     * GIVEN: Creating JPCardDetails from dictionary
     *
     * WHEN: endDate contain 4 digits
     *
     * THEN: should format right
     */
    func test_FormattedExpiryDate_WhenEndDate4Digits_ShouldReturnFormated() {
        var dic = cardDetailsDic["cardDetails"]! as! [AnyHashable : Any]
        dic["endDate"] = "1020";
        let cardDetails = JPCardDetails(dictionary: dic)
        XCTAssertEqual(cardDetails.formattedExpiryDate(), "10/20")
    }
    
    /*
     * GIVEN: Creating JPCardDetails from dictionary
     *
     * WHEN: cardLastfour is nil
     *
     * THEN: should format nil
     */
    func test_FormattedCardLastFour_WhenNil_ShouldReturnNil() {
        var dic = cardDetailsDic["cardDetails"]! as! [AnyHashable : Any]
        dic["cardLastfour"] = nil;
        let cardDetails = JPCardDetails(dictionary: dic)
        XCTAssertNil(cardDetails.formattedCardLastFour())
    }
    
    /*
     * GIVEN: Creating JPCardDetails from dictionary
     *
     * WHEN: cardNumber is full fill
     *
     * THEN: should format 1111
     */
    func test_FormattedCardLastFour_WhenCardNumber_ShouldReturnRight() {
        var dic = cardDetailsDic["cardDetails"]! as! [AnyHashable : Any]
        dic["cardNumber"] = "1111111111111111";
        let cardDetails = JPCardDetails(dictionary: dic)
        cardDetails.formattedCardLastFour()
        XCTAssertEqual(cardDetails.cardLastFour, "1111")
    }
    
    /*
     * GIVEN: Creating JPCardDetails from dictionary
     *
     * WHEN: card network is AMEX
     *
     * THEN: should format AMEX
     */
    func test_FormattedCardLastFour_WhenAmex_ShouldReturnAmexFormat() {
        let dic = cardDetailsDic["cardDetails"]! as! [AnyHashable : Any]
        let cardDetails = JPCardDetails(dictionary: dic)
        cardDetails.cardNetwork = .AMEX
        XCTAssertEqual(cardDetails.formattedCardLastFour(), "**** ****** *1111")
    }
    
    /*
     * GIVEN: Creating JPCardDetails from dictionary
     *
     * WHEN: card network is Unknown
     *
     * THEN: should format v
     */
    func test_FormattedCardLastFour_WhenUnknown_ShouldReturnRightFormat() {
        let dic = cardDetailsDic["cardDetails"]! as! [AnyHashable : Any]
        let cardDetails = JPCardDetails(dictionary: dic)
        cardDetails.cardNetwork = JPCardNetworkType(rawValue: 0)
        XCTAssertEqual(cardDetails.formattedCardLastFour(), "**** 1111")
    }
}
