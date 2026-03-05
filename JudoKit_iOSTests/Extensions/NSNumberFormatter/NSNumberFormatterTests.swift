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
    
    // Helper to create a formatter with a consistent locale for testing
    private func createTestFormatter(currencyCode: String, isFractional: Bool) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US") // Use consistent locale for tests
        formatter.currencyCode = currencyCode
        formatter.maximumFractionDigits = isFractional ? 2 : 0
        return formatter
    }
    
    // Helper to get expected formatted string using test locale
    private func expectedFormat(_ amount: String, currencyCode: String) -> String {
        let amountNumber = NSDecimalNumber(string: amount)
        let isFractional = amountNumber.doubleValue != Double(Int(amountNumber.doubleValue))
        let formatter = createTestFormatter(currencyCode: currencyCode, isFractional: isFractional)
        return formatter.string(from: amountNumber) ?? ""
    }
    
    /*
     * GIVEN: a valid amount and currency code is provided
     *
     * THEN: the localized & formatted amount string should be returned
     */
    func test_OnValidAmountAndCurrency_ReturnFormattedString() {
        let formattedNumber = NumberFormatter._jp_formattedAmount("12", withCurrencyCode: "GBP")
        _ = expectedFormat("12", currencyCode: "GBP")
        
        XCTAssertNotNil(formattedNumber)
        XCTAssertTrue(formattedNumber?.contains("12") ?? false, "Should contain the amount")
        XCTAssertTrue(formattedNumber?.contains("£") ?? false, "Should contain the currency symbol")
    }
    
    /*
     * GIVEN: a valid amount and currency code is provided
     *
     * WHEN: the amount does not contain fractional digits
     *
     * THEN: the fractional digits should not be displayed on the formatted string
     */
    func test_OnRoundedAmount_DoNotDisplayFractionalDigits() {
        let formattedNumber = NumberFormatter._jp_formattedAmount("12.00", withCurrencyCode: "GBP")
        
        XCTAssertNotNil(formattedNumber)
        XCTAssertTrue(formattedNumber?.contains("12") ?? false, "Should contain the amount")
        XCTAssertTrue(formattedNumber?.contains("£") ?? false, "Should contain the currency symbol")
        XCTAssertFalse(formattedNumber?.contains(".00") ?? true, "Should not display fractional digits for rounded amounts")
        XCTAssertFalse(formattedNumber?.contains(",00") ?? true, "Should not display fractional digits for rounded amounts")
    }
    
    /*
     * GIVEN: a valid amount and currency code is provided
     *
     * WHEN: the amount does contain fractional digits
     *
     * THEN: the fractional digits should be displayed on the formatted string
     */
    func test_OnNonRoundedAmount_DisplayTwoFractionalDigits() {
        let formattedNumber = NumberFormatter._jp_formattedAmount("12.20", withCurrencyCode: "GBP")
        
        XCTAssertNotNil(formattedNumber)
        XCTAssertTrue(formattedNumber?.contains("12") ?? false, "Should contain the amount")
        XCTAssertTrue(formattedNumber?.contains("20") ?? false, "Should contain the fractional part")
        XCTAssertTrue(formattedNumber?.contains("£") ?? false, "Should contain the currency symbol")

        let hasFractionalPart = (formattedNumber?.contains("12.20") ?? false) || (formattedNumber?.contains("12,20") ?? false)
        XCTAssertTrue(hasFractionalPart, "Should display two fractional digits")
    }
    
    /*
     * GIVEN: a valid amount and currency code is provided
     *
     * WHEN: the amount contains more than 3 digits
     *
     * THEN: the formatted number should be separated by a comma
     */
    func test_OnLargeAmount_SeparateWithComma() {
        let formattedNumber = NumberFormatter._jp_formattedAmount("1000", withCurrencyCode: "GBP")
        
        XCTAssertNotNil(formattedNumber)
        XCTAssertTrue(formattedNumber?.contains("1") ?? false, "Should contain the amount")
        XCTAssertTrue(formattedNumber?.contains("000") ?? false, "Should contain the zeros")
        XCTAssertTrue(formattedNumber?.contains("£") ?? false, "Should contain the currency symbol")

        let hasThousandsSeparator = (formattedNumber?.contains("1,000") ?? false) || (formattedNumber?.contains("1.000") ?? false)
        XCTAssertTrue(hasThousandsSeparator, "Should use thousands separator for large amounts")
    }
    
    /*
     * GIVEN: an invalid amount and valid currency code is provided
     *
     * THEN: the returned string should represent the [NaN] value
     */
    func test_OnInvalidAmountAndValidCurrency_ReturnNaN() {
        let formattedNumber = NumberFormatter._jp_formattedAmount("asd", withCurrencyCode: "GBP")
        XCTAssertEqual("NaN", formattedNumber)
    }
    
    /*
     * GIVEN: an valid amount and unknown currency code is provided
     *
     * THEN: the returned amount should display a generated currency based on the input
     */
    func test_OnValidAmountAndInvalidCurrency_ReturnGeneratedValue() {
        let formattedNumber = NumberFormatter._jp_formattedAmount("12", withCurrencyCode: "Silvester Stallone")
        
        XCTAssertNotNil(formattedNumber)
        XCTAssertTrue(formattedNumber?.contains("12") ?? false, "Should contain the amount")
        XCTAssertTrue(formattedNumber?.contains("SIL") ?? false, "Should contain the generated currency code")
    }
    
}
