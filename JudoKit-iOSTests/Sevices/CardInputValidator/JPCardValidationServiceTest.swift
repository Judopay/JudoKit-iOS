//
//  JPCardValidationServiceTest.swift
//  JudoKit-iOSTests
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
    
    func testLuhnValidVisa() {
        let result = sut.validateCardNumberInput("4929939187355598", forSupportedNetworks: .visa)
        XCTAssertEqual(result!.formattedInput, "4929 9391 8735 5598")
        XCTAssertTrue(result!.isValid)
    }
    
    func testLuhnValidVisaForMaster() {
        let result = sut.validateCardNumberInput("4929939187355598", forSupportedNetworks: .maestro)
        XCTAssertEqual(result!.formattedInput, "4929 9391 8735 5598")
        XCTAssertFalse(result!.isValid)
        XCTAssertEqual(result!.errorMessage, "Visa is not supported")
    }
    
    func testValidateSecurityMoreThanMax() {
        let result = sut.validateSecureCodeInput("1234")
        XCTAssertEqual(result!.formattedInput!,  "123")
    }
    
    func testValidateSecurityExact() {
        let result = sut.validateSecureCodeInput("123")
        XCTAssertTrue(result!.isInputAllowed)
    }
    
    func testValidateSecurityLess() {
        let result = sut.validateSecureCodeInput("12")
        XCTAssertTrue(result!.isInputAllowed)
        XCTAssertFalse(result!.isValid)
    }
    
    func testValidateCarholderNameInput() {
        let result = sut.validateCardholderNameInput("Alex ABC")
        XCTAssertTrue(result!.isInputAllowed)
        XCTAssertTrue(result!.isValid)
    }
    
    func testValidateExpiryDateInput() {
        let result = sut.validateExpiryDateInput("12/06")
        XCTAssertTrue(result!.isInputAllowed)
        XCTAssertFalse(result!.isValid)
    }
    
    func testValidateCountryInput() {
        let result = sut.validateCountryInput("USA")
        XCTAssertTrue(result!.isInputAllowed)
        XCTAssertTrue(result!.isValid)
    }
    
    func testValidatePostalCodeInput() {
        let result = sut.validatePostalCodeInput("12345")
        XCTAssertTrue(result!.isInputAllowed)
        XCTAssertFalse(result!.isValid)
    }
}
