//
//  JPCardValidationServiceTest.swift
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

class JPCardValidationServiceTest: XCTestCase {
    var sut: JPCardValidationService!
    
    override func setUp() {
        super.setUp()
        sut = JPCardValidationService()
    }
    
    /*
     * GIVEN: Validate card number input
     *
     * WHEN: invoking validateCardNumberInput
     *
     * THEN: should return true
     */
    func test_ValidateCardNumberInput_WhenIsValid_ShouldFormatLuhnValid() {
        let result = sut.validateCardNumberInput("4929939187355598", forSupportedNetworks: .visa)
        XCTAssertEqual(result!.formattedInput, "4929 9391 8735 5598")
        XCTAssertTrue(result!.isValid)
    }
    
    /*
     * GIVEN: Validate card number input for type .maestro
     *
     * WHEN: card number is Visa, and Visa is not supported
     *
     * THEN: should throw error with specific message
     */
    func tes_ValidateCardNumberInput_WhenCardTypeIsNotSupporter_ShouldThrowErrorWithMessage() {
        let result = sut.validateCardNumberInput("4929939187355598", forSupportedNetworks: .maestro)
        XCTAssertEqual(result!.formattedInput, "4929 9391 8735 5598")
        XCTAssertFalse(result!.isValid)
        XCTAssertEqual(result!.errorMessage, "Visa is not supported")
    }
    
    /*
     * GIVEN: Validate Security code for Visa
     *
     * WHEN: code is more then 4 character for visa
     *
     * THEN: should format result, subscript to 3
     */
    func test_ValidateSecureCodeInput_WhenCodeIsBiggerThenMax_ShouldSubscriptCode() {
        let result = sut.validateSecureCodeInput("1234")
        XCTAssertEqual(result!.formattedInput!,  "123")
    }
    
    /*
     * GIVEN: Validate Security code for Visa
     *
     * WHEN: code is less then 3 character for visa
     *
     * THEN: should return valid result
     */
    func test_ValidateSecureCodeInput_WhenThreeCharacters_ShouldValidate() {
        _  = sut.validateCardNumberInput("4929939187355598", forSupportedNetworks: .visa)
        let result = sut.validateSecureCodeInput("123")
        XCTAssertTrue(result!.isInputAllowed)
        XCTAssertTrue(result!.isValid)
    }
    
    /*
     * GIVEN: Validate Security code for Visa
     *
     * WHEN: code is less then 3 character for visa
     *
     * THEN: should return invalid result
     */
    func test_ValidateSecureCodeInput_WhenCodeIsLessThenMinimum_ShouldThrowInValidResponse()  {
        _  = sut.validateCardNumberInput("4929939187355598", forSupportedNetworks: .visa)
        let result = sut.validateSecureCodeInput("12")
        XCTAssertTrue(result!.isInputAllowed)
        XCTAssertFalse(result!.isValid)
    }
    
    /*
     * GIVEN: validate card holder
     *
     * WHEN: name is valid
     *
     * THEN: should return valid result
     */
    func test_ValidateCarholderNameInput_WhenNameIsValid_ShouldReturnValidResponse() {
        let result = sut.validateCardholderNameInput("Alex ABC")
        XCTAssertTrue(result!.isInputAllowed)
        XCTAssertTrue(result!.isValid)
    }
    
    /*
     * GIVEN: validate Expiry Date
     *
     * WHEN: Date is expired
     *
     * THEN: should return invalid result
     */
    func test_ValidateExpiryDateInput_WhenDateIsExpired_ShouldReturnInValidEResult() {
        let result = sut.validateExpiryDateInput("12/06")
        XCTAssertTrue(result!.isInputAllowed)
        XCTAssertFalse(result!.isValid)
    }
    
    /*
     * GIVEN: validate Country
     *
     * WHEN: selected country is supported
     *
     * THEN: should return valid result
     */
    func test_ValidateCountryInput_WhenCountryUSAIsSupported_ShouldReturnValidResult() {
        let result = sut.validateCountryInput("USA")
        XCTAssertTrue(result!.isInputAllowed)
        XCTAssertTrue(result!.isValid)
    }
    
    /*
     * GIVEN: validate postal code
     *
     * WHEN: inserted not valid post code for UK
     *
     * THEN: should return invalid error
     */
    func test_ValidatePostalCodeInput_WhenInvalidCodeForUK_ShouldReturnInvalidResult() {
        _ = sut.validateCountryInput("UK")
        let result = sut.validatePostalCodeInput("12345")
        XCTAssertTrue(result!.isInputAllowed)
        XCTAssertFalse(result!.isValid)
    }
    
    /*
     * GIVEN: reseting all validation
     *
     * THEN: should set nil to lastCardNumberValidationResult
     */
    func test_resetCardValidationResults() {
        sut.resetCardValidationResults()
        XCTAssertNil(sut.lastCardNumberValidationResult)
    }
    
    /*
     * GIVEN: validate expiry date
     *
     * WHEN: there is 4 characters total
     *
     * THEN: should return that input is allowed
     */
    func test_ValidateExpiryDateInput_When4Characters_ShouldReturnInputAllowed() {
        let result = sut.validateExpiryDateInput("12/0")
        XCTAssertTrue(result!.isInputAllowed)
    }
    
    /*
     * GIVEN: validate expiry date
     *
     * WHEN: there is 3 characters total
     *
     * THEN: should return that input is allowed
     */
    func test_ValidateExpiryDateInput_When3Characters_ShouldReturnInputAllowed() {
        let result = sut.validateExpiryDateInput("1/0")
        XCTAssertTrue(result!.isInputAllowed)
    }
    
    /*
     * GIVEN: validate expiry date
     *
     * WHEN: there is 2 characters total
     *
     * THEN: should return that input is allowed
     */
    func test_ValidateExpiryDateInput_When2Characters_ShouldReturnInputAllowed() {
        let result = sut.validateExpiryDateInput("12")
        XCTAssertTrue(result!.isInputAllowed)
    }
    
    /*
     * GIVEN: validate expiry date
     *
     * WHEN: there is 1 characters total
     *
     * THEN: should return that input is allowed
     */
    func test_ValidateExpiryDateInput_When1Characters_ShouldReturnInputAllowed() {
        let result = sut.validateExpiryDateInput("1")
        XCTAssertTrue(result!.isInputAllowed)
    }
    
    /*
     * GIVEN: validate expiry date
     *
     * WHEN: there is 0 characters total
     *
     * THEN: should return that input is allowed
     */
    func test_ValidateExpiryDateInput_When0Characters_ShouldReturnInputAllowed() {
        let result = sut.validateExpiryDateInput("")
        XCTAssertTrue(result!.isInputAllowed)
    }
    
    /*
     * GIVEN: validate postal code
     *
     * WHEN: inserted valid post code for Other (input.length <= kOtherPostalCodeLength)
     *
     * THEN: should return valid
     */
    func test_ValidatePostalCodeInput_WhenValidCodeForMD_ShouldReturnValidResult() {
        _ = sut.validateCountryInput("Other")
        let result = sut.validatePostalCodeInput("200")
        XCTAssertTrue(result!.isInputAllowed)
        XCTAssertTrue(result!.isValid)
    }
    
    /*
     * GIVEN: validate postal code
     *
     * WHEN: inserted invalid post code for Other (input.length <= kOtherPostalCodeLength)
     *
     * THEN: should return Input Not Allowed
     */
    func test_ValidatePostalCodeInput_WhenInValidCodeForMD_ShouldReturnInputNotAllowed() {
        _ = sut.validateCountryInput("Other")
        let result = sut.validatePostalCodeInput("123457890")
        XCTAssertFalse(result!.isInputAllowed)
    }
}
