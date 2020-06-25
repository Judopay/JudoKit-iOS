//
//  JPPrimaryAccountDetailsTest.swift
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

class JPPrimaryAccountDetailsTest: XCTestCase {
    let dic = ["name":"name",
               "accountNumber":"accountNumber",
               "dateOfBirth":"dateOfBirth",
               "postCode":"postCode"]
    /*
     * GIVEN: Creating JPPrimaryAccountDetails designed init
     *
     * WHEN: all fields are valid
     *
     * THEN: should create correct fields in JPPrimaryAccountDetails object
     */
    func test_InitFromDictionary_WhenDesignedInit_ShouldCreateObject() {
        let sut = JPPrimaryAccountDetails(from: dic)
        XCTAssertEqual(sut.name, "name")
        XCTAssertEqual(sut.accountNumber, "accountNumber")
        XCTAssertEqual(sut.dateOfBirth, "dateOfBirth")
        XCTAssertEqual(sut.postCode, "postCode")
    }
    
    /*
     * GIVEN: Creating JPPrimaryAccountDetails class init
     *
     * WHEN: all fields are valid
     *
     * THEN: should create correct fields in JPPrimaryAccountDetails object
     */
    func test_DetailsFromDictionary_WhenClassInit_ShouldCreateObject() {
        let sut = JPPrimaryAccountDetails.init(from: dic)
        XCTAssertEqual(sut.name, "name")
        XCTAssertEqual(sut.accountNumber, "accountNumber")
        XCTAssertEqual(sut.dateOfBirth, "dateOfBirth")
        XCTAssertEqual(sut.postCode, "postCode")
    }
    
    /*
     * GIVEN: Creating JPPrimaryAccountDetails designed init
     *
     * WHEN: all fields are valid
     *
     * THEN: should create correct dictionary from properties
     */
    func test_ToDictionary_WhenDesignedInit_ShouldCreateDictionaryFromObject() {
        let sut = JPPrimaryAccountDetails(from: dic)
        let dic = sut.toDictionary() as! Dictionary<String, String>
        XCTAssertEqual(dic, dic)
    }
}
