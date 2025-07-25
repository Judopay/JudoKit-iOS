//
//  NSStringAdditionsTests.swift
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

import XCTest
@testable import JudoKit_iOS

class NSStringAdditionsTests: XCTestCase {
    
    /*
     * GIVEN: A string with card type(Visa)
     *
     * WHEN: it is valid and could be translated to enum
     *
     * THEN: should return right enum value
     */
    func test_CardNetwork_WhenStringIsValid_ShouldReturnRightType() {
        let cardNumber = "4444"
        let type = cardNumber._jp_cardNetwork
        XCTAssertEqual(type, JPCardNetworkType.visa)
    }
    
    /*
     * GIVEN: A string with card type
     *
     * WHEN: it is invalid and couldnt be translated to enum
     *
     * THEN: should return JPCardNetworkTypeUnknown type
     */
    func test_CardNetwork_WhenStringIsInValid_ShouldReturnTypeUnknown() {
        let cardNumber = "1111"
        let type = cardNumber._jp_cardNetwork
        let unKnownType = JPCardNetworkType(rawValue: 0)
        XCTAssertEqual(type, unKnownType)
    }
    
    /*
     * GIVEN: A string with card number
     *
     * WHEN: it is valid and luhn valid
     *
     * THEN: should return right valid bool for this number
     */
    func test_IsCardNumberValid_WhenNumberLuhnValid_ShouldReturnValid() {
        let cardValid = "4929939187355598"
        XCTAssertTrue(cardValid._jp_isValidCardNumber)
    }
    
    /*
     * GIVEN: A string is a key from localization
     *
     * THEN: should return value(localication) for current string
     */
    func test_Localized_WhenKeyFromTranslate_ShouldReturnTranslatedString() {
        let keyForTranslate = "jp_post_code_hint"
        XCTAssertEqual(keyForTranslate._jp_localized(), "Postcode")
    }
    
    /*
     * GIVEN: A string with currency
     *
     * WHEN: is supported
     *
     * THEN: should return symbol for currency string
     */
    func test_ToCurrencySymbol_WhenSupportedCurrencyString_ShouldReturnSymbolForCurrency(){
        let usdSymbol = "USD"
        let symbol = usdSymbol._jp_toCurrencySymbol()
        let expectation = numberFormatterForAmount(amount: 0.0, currencyCode: usdSymbol)?.currencySymbol ?? ""
        XCTAssertEqual(symbol, expectation)
    }
    
    /*
     * GIVEN: A raw string from numbers
     *
     * WHEN: making first character bold
     *
     * THEN: should return AttributedString with first bold character
     */
    func test_AttributedStringWithBoldSubstring_WhenSgtringFromNumbers_Shouldtrue() {
        let keyForTranslate = "122"
        let sut = keyForTranslate._jp_attributedString(withBoldSubstring: "1")
        let attributes = sut.attributes(at: 0, effectiveRange: nil)
        XCTAssertEqual((attributes.first?.value as! UIFont).fontName, ".SFUI-Semibold")
    }

    /*
     * GIVEN: A string is checked for a numeric pattern
     *
     * WHEN: the pattern contains only digits
     *
     * THEN: the method should return true
     */
    func test_WhenNumericCheck_IfContainsOnlyDigits_ReturnTrue() {
        XCTAssertTrue("12345"._jp_isNumeric)
        XCTAssertFalse("123.45"._jp_isNumeric)
        XCTAssertFalse("-12345"._jp_isNumeric)
        XCTAssertFalse("12 34 5"._jp_isNumeric)
    }

    /*
     * GIVEN: A string is checked for expiry date format
     *
     * WHEN: the format is either dd/dd or dd-dd, where d is a digit
     *
     * THEN: the method should return true
     */
    func test_WhenExpiryDateFormatCheck_IfContainsValidFormat_ReturnTrue() {
        XCTAssertTrue("00/00"._jp_isExpiryDate)
        XCTAssertTrue("00-00"._jp_isExpiryDate)
        XCTAssertTrue("00/2000"._jp_isExpiryDate)
        XCTAssertTrue("00-2000"._jp_isExpiryDate)
        XCTAssertFalse("0/00"._jp_isExpiryDate)
        XCTAssertFalse("00/0"._jp_isExpiryDate)
        XCTAssertFalse("-00/00"._jp_isExpiryDate)
        XCTAssertFalse("0.0/00"._jp_isExpiryDate)
        XCTAssertFalse("00 00"._jp_isExpiryDate)
        XCTAssertFalse("00 - 00"._jp_isExpiryDate)
        XCTAssertFalse("00 / 00"._jp_isExpiryDate)
    }
    
    /*
     * GIVEN: A string is sanitized and addapted to expected expiry date format
     *
     * WHEN: the format is either dd/dd or dd-dd or dd/dddd or dd-dddd, where d is a digit
     *
     * THEN: the method should return a date formatted as dd/dd or nil
     */
    func test_WhenSanitizedExpiryDate_ReturnExpectedDateFormat() {
        XCTAssertTrue("00/00"._jp_sanitizedExpiryDate() == "00/00")
        XCTAssertTrue("00-00"._jp_sanitizedExpiryDate() == "00/00")
        XCTAssertTrue("00/2000"._jp_sanitizedExpiryDate() == "00/00")
        XCTAssertTrue("00-2000"._jp_sanitizedExpiryDate() == "00/00")
        XCTAssertTrue("0000-2000"._jp_sanitizedExpiryDate() == nil)
    }
    
}
