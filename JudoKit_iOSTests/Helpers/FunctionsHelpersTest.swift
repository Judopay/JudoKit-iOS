//
//  FunctionsHelpersTest.swift
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

class FunctionsHelpersTest: XCTestCase {
    
    /*
     * GIVEN: global func for getting aspect ratio
     *
     * WHEN: based on simulator
     *
     * THEN: should be no nil and bigger then zero
     */
    func test_getWidthAspectRatio_WhenSimulator_ShouldBeNonZero() {
        let sutAspect = getWidthAspectRatio()
        XCTAssertNotNil(sutAspect)
        XCTAssertTrue(sutAspect > 0)
    }
    
    /*
     * GIVEN: global func for getting user agent
     *
     * WHEN: based on simulator
     *
     * THEN: should be no nil
     */
    func test_getUserAgent_WhenSimulator_ShouldBeNonZero() {
        let sutUserAgent = getUserAgent()
        XCTAssertNotNil(sutUserAgent)
    }
    
    /*
     * GIVEN: global func for getting ip adress
     *
     * WHEN: based on simulator
     *
     * THEN: should be no nil
     */
    func test_getIPAddress_WhenSimulator_ShouldBeNonZero() {
        let sutIPAddress = getIPAddress()
        XCTAssertNotNil(sutIPAddress)
    }
    
    /*
     * GIVEN: global func for getting the string representation of an object
     *
     * WHEN: object is nil
     *
     * THEN: should return the null string representation
     */
    func test_getSafeStringRepresentation_WhenNilIsProvided_ShouldReturnNilRepresentation() {
        let result = getSafeStringRepresentation(nil)
        XCTAssertTrue(result == "(null)")
    }
    
    /*
     * GIVEN: global func for getting the string representation of an object
     *
     * WHEN: object is a number
     *
     * THEN: should return the number string representation
     */
    func test_getSafeStringRepresentation_WhenNumberIsProvided_ShouldReturnNumberRepresentation() {
        let result = getSafeStringRepresentation(1)
        XCTAssertTrue(result == "1")
    }
    
    /*
     * GIVEN: global func for getting the string representation of an object
     *
     * WHEN: object is a string
     *
     * THEN: should return the given string
     */
    func test_getSafeStringRepresentation_WhenStringIsProvided_ShouldReturnTheGivenString() {
        let result = getSafeStringRepresentation("string")
        XCTAssertTrue(result == "string")
    }
    
    /*
     * GIVEN: global func to get query parameters RFC3986 escaped
     *
     * WHEN: a single query string pair is provided as a parameter
     *
     * THEN: should return the expected string
     */
    func test_queryParameters_WhenASingleQueryStringPairIsProvided_ShouldReturnTheExpectedString() {
        let result = queryParameters([JPQueryStringPair("name", "value")])
        XCTAssertTrue(result == "name=value")
    }
    
    /*
     * GIVEN: global func to get query parameters RFC3986 escaped
     *
     * WHEN: multiple query string pairs are provided as a parameter
     *
     * THEN: should return the expected string
     */
    func test_queryParameters_WhenMultipleQueryStringPairsAreProvided_ShouldReturnTheExpectedString() {
        let result = queryParameters([JPQueryStringPair("name1", "value1"), JPQueryStringPair("name2", "value2")])
        XCTAssertTrue(result == "name1=value1&name2=value2")
    }
    
    /*
     * GIVEN: global func to get query parameters RFC3986 escaped
     *
     * WHEN: multiple query string pairs are provided as a parameter
     *
     * THEN: should return the expected string escaped
     */
    func test_queryParameters_WhenMultipleQueryStringPairsAreProvided_ShouldReturnTheExpectedEscapedString() {
        let result = queryParameters([JPQueryStringPair("na@me", "val#ue-to-escape["), JPQueryStringPair("na:m e", "val:ue-to-esc]")])
        XCTAssertTrue(result == "na%40me=val%23ue-to-escape%5B&na%3Am%20e=val%3Aue-to-esc%5D")
    }
}
