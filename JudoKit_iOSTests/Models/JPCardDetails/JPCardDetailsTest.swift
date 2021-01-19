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
     * GIVEN: Creating JPCardDetails designated init
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
     * THEN: should return nil after formating
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
     * WHEN: card number is entered completely
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
    
    /*
     * GIVEN: Creating JPCardDetails from dictionary
     *
     * WHEN: card network is Visa
     *
     * THEN: should parse cardNetwork as Visa
     */
    func test_ParsingCardType_WhenVisa_ShouldReturnVisaNetwork() {
        var dic = cardDetailsDic["cardDetails"]! as! [AnyHashable : Any]
        
        dic["cardType"] = 1
        let cardDetails1 = JPCardDetails(dictionary: dic)
        
        dic["cardType"] = 3
        let cardDetails2 = JPCardDetails(dictionary: dic)

        dic["cardType"] = 11
        let cardDetails3 = JPCardDetails(dictionary: dic)

        dic["cardType"] = 13
        let cardDetails4 = JPCardDetails(dictionary: dic)

        XCTAssertEqual(cardDetails1.cardNetwork, JPCardNetworkType.visa)
        XCTAssertEqual(cardDetails2.cardNetwork, JPCardNetworkType.visa)
        XCTAssertEqual(cardDetails3.cardNetwork, JPCardNetworkType.visa)
        XCTAssertEqual(cardDetails4.cardNetwork, JPCardNetworkType.visa)
    }
    
    /*
     * GIVEN: Creating JPCardDetails from dictionary
     *
     * WHEN: card network is MasterCard
     *
     * THEN: should parse cardNetwork as MasterCard
     */
    func test_ParsingCardType_WhenMasterCard_ShouldReturnMasterCardNetwork() {
        var dic = cardDetailsDic["cardDetails"]! as! [AnyHashable : Any]
        
        dic["cardType"] = 2
        let cardDetails1 = JPCardDetails(dictionary: dic)
        
        dic["cardType"] = 12
        let cardDetails2 = JPCardDetails(dictionary: dic)

        XCTAssertEqual(cardDetails1.cardNetwork, JPCardNetworkType.masterCard)
        XCTAssertEqual(cardDetails2.cardNetwork, JPCardNetworkType.masterCard)
    }
    
    /*
     * GIVEN: Creating JPCardDetails from dictionary
     *
     * WHEN: card network is ChinaUnionPay
     *
     * THEN: should parse cardNetwork as ChinaUnionPay
     */
    func test_ParsingCardType_WhenChinaUnionPay_ShouldReturnChinaUnionPayNetwork() {
        var dic = cardDetailsDic["cardDetails"]! as! [AnyHashable : Any]
        
        dic["cardType"] = 7
        let cardDetails = JPCardDetails(dictionary: dic)
        
        XCTAssertEqual(cardDetails.cardNetwork, JPCardNetworkType.chinaUnionPay)
    }
    
    /*
     * GIVEN: Creating JPCardDetails from dictionary
     *
     * WHEN: card network is AMEX
     *
     * THEN: should parse cardNetwork as AMEX
     */
    func test_ParsingCardType_WhenAMEX_ShouldReturnAMEXNetwork() {
        var dic = cardDetailsDic["cardDetails"]! as! [AnyHashable : Any]
        
        dic["cardType"] = 8
        let cardDetails = JPCardDetails(dictionary: dic)
        
        XCTAssertEqual(cardDetails.cardNetwork, JPCardNetworkType.AMEX)
    }
    
    /*
     * GIVEN: Creating JPCardDetails from dictionary
     *
     * WHEN: card network is JCB
     *
     * THEN: should parse cardNetwork as JCB
     */
    func test_ParsingCardType_WhenJCB_ShouldReturnJCBNetwork() {
        var dic = cardDetailsDic["cardDetails"]! as! [AnyHashable : Any]
        
        dic["cardType"] = 9
        let cardDetails = JPCardDetails(dictionary: dic)
        
        XCTAssertEqual(cardDetails.cardNetwork, JPCardNetworkType.JCB)
    }
    
    /*
     * GIVEN: Creating JPCardDetails from dictionary
     *
     * WHEN: card network is Maestro
     *
     * THEN: should parse cardNetwork as Maestro
     */
    func test_ParsingCardType_WhenMaestro_ShouldReturnMaestroNetwork() {
        var dic = cardDetailsDic["cardDetails"]! as! [AnyHashable : Any]
        
        dic["cardType"] = 10
        let cardDetails = JPCardDetails(dictionary: dic)
        
        XCTAssertEqual(cardDetails.cardNetwork, JPCardNetworkType.maestro)
    }
    
    /*
     * GIVEN: Creating JPCardDetails from dictionary
     *
     * WHEN: card network is Discover
     *
     * THEN: should parse cardNetwork as Discover
     */
    func test_ParsingCardType_WhenDiscover_ShouldReturnDiscoverNetwork() {
        var dic = cardDetailsDic["cardDetails"]! as! [AnyHashable : Any]
        
        dic["cardType"] = 14
        let cardDetails = JPCardDetails(dictionary: dic)
        
        XCTAssertEqual(cardDetails.cardNetwork, JPCardNetworkType.discover)
    }
    
    /*
     * GIVEN: Creating JPCardDetails from dictionary
     *
     * WHEN: card network is DinersClub
     *
     * THEN: should parse cardNetwork as DinersClub
     */
    func test_ParsingCardType_WhenDinersClub_ShouldReturnDinersClubNetwork() {
        var dic = cardDetailsDic["cardDetails"]! as! [AnyHashable : Any]
        
        dic["cardType"] = 17
        let cardDetails = JPCardDetails(dictionary: dic)
        
        XCTAssertEqual(cardDetails.cardNetwork, JPCardNetworkType.dinersClub)
    }
    
    /*
     * GIVEN: Creating JPCardDetails from dictionary
     *
     * WHEN: card network is Unknown
     *
     * THEN: should parse cardNetwork as Unknown
     */
    func test_ParsingCardType_WhenUnknown_ShouldReturnUnknownNetwork() {
        var dic = cardDetailsDic["cardDetails"]! as! [AnyHashable : Any]
        
        dic["cardType"] = -1
        let cardDetails = JPCardDetails(dictionary: dic)
        
        XCTAssertEqual(cardDetails.cardNetwork, [])
    }
    
    /*
     * GIVEN: Creating JPCardDetails from dictionary
     *
     * WHEN: card network is Unknown
     * AND: cardNumber is known
     *
     * THEN: should return cardNetwork based on given cardNumber
     */
    func test_ParsingCardType_WhenUnknown_And_CardNumberIsKnown_ShouldReturnNetworkBasedOnCardNumber() {
        var dic = cardDetailsDic["cardDetails"]! as! [AnyHashable : Any]
        
        dic["cardType"] = 100
        let cardDetails = JPCardDetails(dictionary: dic)
        cardDetails.cardNumber = "4111 1111 1111 1111"
        
        XCTAssertEqual(cardDetails.cardNetwork, JPCardNetworkType.visa)
    }
}
