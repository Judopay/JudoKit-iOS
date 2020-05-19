//
//  JPAmountTests.swift
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

class JPAmountTests: XCTestCase {
    
    /*
    * GIVEN: Creating JPAmount using Convenient Init
    *
    * WHEN: setup default amount and currency
    *
    * THEN: should create correct fields in JPAmount object
    */
    func test_ConvenientInit_WhenFieldsAreValid_ShouldPopulateProperties() {
        let amount = JPAmount.init("123", currency: "USD")
        XCTAssertEqual(amount.amount, "123")
        XCTAssertEqual(amount.currency, "USD")
    }
    
    
    /*
    * GIVEN: Creating JPAmount using Designated Init
    *
    * WHEN: setup default amount and currency
    *
    * THEN: should create correct fields in JPAmount object
    */
    func test_Initializer_WhenFieldsAreValid_ShouldPopulateProperties() {
        let amount = JPAmount(amount: "123", currency: "USD")
        XCTAssertEqual(amount.amount, "123")
        XCTAssertEqual(amount.currency, "USD")
    }
}
