//
//  JPCountryTest.swift
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

class JPCountryTest: XCTestCase {
    
    /*
     * GIVEN: String representing UK country
     *
     * WHEN: getting iso Code For Country
     *
     * THEN: should return 826 numeric code
     */
    func test_isoCodeForCountry_WhenUK_ShouldReturnRightISOCode() {
        XCTAssertEqual(JPCountry.isoCode(forCountry: "United Kingdom"), 826)
    }
    
    /*
     * GIVEN: String representing USA country
     *
     * WHEN: getting iso Code For Country
     *
     * THEN: should return 840 numeric code
     */
    func test_isoCodeForCountry_WhenUSA_ShouldReturnRightISOCode() {
        XCTAssertEqual(JPCountry.isoCode(forCountry: "United States"), 840)
    }
    
    /*
     * GIVEN: String representing Canada country
     *
     * WHEN: getting iso Code For Country
     *
     * THEN: should return 124 numeric code
     */
    func test_isoCodeForCountry_WhenCanada_ShouldReturnRightISOCode() {
        XCTAssertEqual(JPCountry.isoCode(forCountry: "Canada"), 124)
    }
    
}
