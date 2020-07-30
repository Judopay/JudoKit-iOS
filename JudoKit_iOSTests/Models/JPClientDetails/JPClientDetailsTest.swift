//
//  JPClientDetailsTest.swift
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

class JPClientDetailsTest: XCTestCase {
    
    /*
     * GIVEN: Creating JPClientDetails designated init
     *
     * WHEN: all fields are valid
     *
     * THEN: should create correct fields in JPClientDetails object
     */
    func test_InitWithKey_WhenDesignatedInit_ShouldCreateObject() {
        let sut = JPClientDetails(key: "key", value: "value")
        XCTAssertEqual(sut.key, "key")
        XCTAssertEqual(sut.value, "value")
    }
    
    /*
     * GIVEN: Creating JPClientDetails class init
     *
     * WHEN: all fields are valid
     *
     * THEN: should create correct fields in JPClientDetails object
     */
    func test_DetailsWithDictionary_WhenClassInit_ShouldCreateObject() {
        let sut = JPClientDetails.init(dictionary: ["key":"key", "value":"value"])
        XCTAssertEqual(sut.key, "key")
        XCTAssertEqual(sut.value, "value")
    }
    
    /*
     * GIVEN: Creating JPClientDetails designated init
     *
     * WHEN: all fields are valid
     *
     * THEN: should create correct dictionary from properties
     */
    func test_ToDictionary_WhenDesignatedInit_ShouldCreateDictionaryFromObject() {
        let sut = JPClientDetails(key: "key", value: "value")
        let dic = sut.toDictionary()
        XCTAssertEqual(dic as! Dictionary, ["key":"key", "value":"value"])
    }
}
