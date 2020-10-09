//
//  JPPaymentMethodTest.swift
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

class JPPaymentMethodTest: XCTestCase {
    
    /*
     * GIVEN: Creating JPPaymentMethod with class Init pbba
     *
     * WHEN: init without properties
     *
     * THEN: should create JPPaymentMethod object with nil title
     */
    func test_pbba_WhenDesignatedInit_ShouldFillFields() {
        let sut = JPPaymentMethod.pbba()
        XCTAssertEqual(sut?.title, nil)
        XCTAssertNotNil(sut)
    }
    
    /*
     * GIVEN: Creating JPPaymentMethod with class Init cards
     *
     * WHEN: raw initialization
     *
     * THEN: should create correct fields in JPPaymentMethod object with right title
     */
    func test_card_WhenDesignatedInit_ShouldFillFields() {
        let sut = JPPaymentMethod.card()
        XCTAssertEqual(sut?.title, "Cards")
        XCTAssertNotNil(sut)
    }
    
    /*
     * GIVEN: Creating JPPaymentMethod with class Init iDeal
     *
     * WHEN: raw initialization
     *
     * THEN: should create correct fields in JPPaymentMethod object with right title
     */
    func test_iDeal_WhenDesignatedInit_ShouldFillFields() {
        let sut = JPPaymentMethod.iDeal()
        XCTAssertEqual(sut?.title, "iDeal")
        XCTAssertNotNil(sut)
    }
    
    /*
     * GIVEN: Creating JPPaymentMethod with class Init applePay
     *
     * WHEN: init without properties
     *
     * THEN: should create JPPaymentMethod object with nil title
     */
    func test_applePay_WhenDesignatedInit_ShouldFillFields() {
        let sut = JPPaymentMethod.applePay()
        XCTAssertEqual(sut?.title, nil)
        XCTAssertNotNil(sut)
    }

    /**
     * GIVEN: a JPPaymentMethod is initialized
     *
     * WHEN: the [.applePay] is selected as the type
     *
     * THEN: the correct icon and type must be set, and no title should be present
     */
    func test_OnInitialization_WhenApplePayType_SetApplePayProperties() {
        let sut = JPPaymentMethod(paymentMethodType: .applePay)
        XCTAssertEqual(sut!.iconName, "apple-pay-icon")
        XCTAssertNil(sut!.title)
        XCTAssertEqual(sut!.type, .applePay)
    }

    /**
     * GIVEN: a JPPaymentMethod is initialized
     *
     * WHEN: the [.cards] is selected as the type
     *
     * THEN: the correct icon, title and type must be set
     */
    func test_OnInitialization_WhenCardType_SetCardProperties() {
        let sut = JPPaymentMethod(paymentMethodType: .card)
        XCTAssertEqual(sut!.iconName, "cards-pay-icon")
        XCTAssertEqual(sut!.title, "Cards")
        XCTAssertEqual(sut!.type, .card)
    }

    /**
     * GIVEN: a JPPaymentMethod is initialized
     *
     * WHEN: the [.iDeal] is selected as the type
     *
     * THEN: the correct icon, title and type must be set
     */
    func test_OnInitialization_WhenIDEALType_SetIDEALProperties() {
        let sut = JPPaymentMethod(paymentMethodType: .iDeal)
        XCTAssertEqual(sut!.iconName, "ideal-pay-icon")
        XCTAssertEqual(sut!.title, "iDeal")
        XCTAssertEqual(sut!.type, .iDeal)
    }

    /**
     * GIVEN: a JPPaymentMethod is initialized
     *
     * WHEN: the [.pbba] is selected as the type
     *
     * THEN: the correct icon and type must be set, and no title should be present
     */
    func test_OnInitialization_WhenPBBAType_SetPBBAProperties() {
        let sut = JPPaymentMethod(paymentMethodType: .pbba)
        XCTAssertEqual(sut!.iconName, "pbba-pay-icon")
        XCTAssertNil(sut!.title)
        XCTAssertEqual(sut!.type, .pbba)
    }
}
