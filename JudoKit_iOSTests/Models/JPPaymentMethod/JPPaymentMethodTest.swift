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
     * WHEN: insert version and name
     *
     * THEN: should create correct fields in JPPaymentMethod object
     */
    func test_pbba_WhenDesignatedInit_ShouldFillFields() {
        let sut = JPPaymentMethod.pbba()
        XCTAssertEqual(sut?.title, nil)
        XCTAssertNotNil(sut)
    }
    
    /*
     * GIVEN: Creating JPPaymentMethod with class Init cards
     *
     * WHEN: insert version and name
     *
     * THEN: should create correct fields in JPPaymentMethod object
     */
    func test_card_WhenDesignatedInit_ShouldFillFields() {
        let sut = JPPaymentMethod.card()
        XCTAssertEqual(sut?.title, "Cards")
        XCTAssertNotNil(sut)
    }
    
    /*
     * GIVEN: Creating JPPaymentMethod with class Init iDeal
     *
     * WHEN: insert version and name
     *
     * THEN: should create correct fields in JPPaymentMethod object
     */
    func test_iDeal_WhenDesignatedInit_ShouldFillFields() {
        let sut = JPPaymentMethod.iDeal()
        XCTAssertEqual(sut?.title, "iDeal")
        XCTAssertNotNil(sut)
    }
    
    /*
     * GIVEN: Creating JPPaymentMethod with class Init applePay
     *
     * WHEN: insert version and name
     *
     * THEN: should create correct fields in JPPaymentMethod object
     */
    func test_applePay_WhenDesignatedInit_ShouldFillFields() {
        let sut = JPPaymentMethod.applePay()
        XCTAssertEqual(sut?.title, nil)
        XCTAssertNotNil(sut)
    }
}
