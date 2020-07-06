//
//  NSNumberFormatterTests.swift
//  JudoKit_iOSTests
//
//  Copyright (c) 2020 Alternative Payments Ltd
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

import Foundation
import XCTest
@testable import JudoKit_iOS

class NSNumberFormatterTests: XCTestCase {
    
    /*
     * GIVEN: a valid amount and currency code is provided
     *
     * THEN: the localized & formatted amount string should be returned
     */
    func test_OnValidAmountAndCurrency_ReturnFormattedString() {
        let formattedNumber = NumberFormatter.formattedAmount("12", withCurrencyCode: "GBP")
        XCTAssertEqual("£12", formattedNumber)
    }
    
    /*
     * GIVEN: a valid amount and currency code is provided
     *
     * WHEN: the amount does not contain fractional digits
     *
     * THEN: the fractional digits should not be displayed on the formatted string
     */
    func test_OnRoundedAmount_DoNotDisplayFractionalDigits() {
        let formattedNumber = NumberFormatter.formattedAmount("12.00", withCurrencyCode: "GBP")
        XCTAssertEqual("£12", formattedNumber)
    }
    
    /*
     * GIVEN: a valid amount and currency code is provided
     *
     * WHEN: the amount does contain fractional digits
     *
     * THEN: the fractional digits should be displayed on the formatted string
     */
    func test_OnNonRoundedAmount_DisplayTwoFractionalDigits() {
        let formattedNumber = NumberFormatter.formattedAmount("12.20", withCurrencyCode: "GBP")
        XCTAssertEqual("£12.20", formattedNumber)
    }
    
    /*
     * GIVEN: a valid amount and currency code is provided
     *
     * WHEN: the amount contains more than 3 digits
     *
     * THEN: the formatted number should be separated by a comma
     */
    func test_OnLargeAmount_SeparateWithComma() {
        let formattedNumber = NumberFormatter.formattedAmount("1000", withCurrencyCode: "GBP")
        XCTAssertEqual("£1,000", formattedNumber)
    }
    
    /*
     * GIVEN: an invalid amount and valid currency code is provided
     *
     * THEN: the returned string should represent the [NaN] value
     */
    func test_OnInvalidAmountAndValidCurrency_ReturnNaN() {
        let formattedNumber = NumberFormatter.formattedAmount("asd", withCurrencyCode: "GBP")
        XCTAssertEqual("NaN", formattedNumber)
    }
    
    /*
     * GIVEN: an valid amount and unknown currency code is provided
     *
     * THEN: the returned amount should display a generated currency based on the input
     */
    func test_OnValidAmountAndInvalidCurrency_ReturnGeneratedValue() {
        let formattedNumber = NumberFormatter.formattedAmount("12", withCurrencyCode: "Silvester Stallone")
        XCTAssertEqual("Sil 12", formattedNumber)
    }
    
}
