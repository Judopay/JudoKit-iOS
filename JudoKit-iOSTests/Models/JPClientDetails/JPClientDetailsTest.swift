//
//  JPClientDetailsTest.swift
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

class JPClientDetailsTest: XCTestCase {
    
    /*
    * GIVEN: Creating JPClientDetails from key and value
    *
    * WHEN: keys and value are strings
    *
    * THEN: should create correct fields in JPClientDetails object
    */
    func test_InitWithKey_WhenFieldsAreAtring_ShouldPopulateProperties() {
        let clientDetails = JPClientDetails(key: "Key", value: "Value")
        XCTAssertEqual(clientDetails.key, "Key")
        XCTAssertEqual(clientDetails.value, "Value")
    }
    
    /*
    * GIVEN: Creating JPClientDetails from dictionary
    *
    * WHEN: keys and value are strings in dictionary
    *
    * THEN: should create correct fields in JPClientDetails object
    */
    func test_DetailsWithDictionary_WhenDictionary_ShouldPopulateProperties() {
        let clientDetails = JPClientDetails(dictionary: ["key": "Key", "value": "Value"])
        XCTAssertEqual(clientDetails.key, "Key")
        XCTAssertEqual(clientDetails.value, "Value")
    }

    /*
    * GIVEN: Creating JPClientDetails from key and value
    *
    * WHEN: convert client details to dictionary
    *
    * THEN: should create correct dictionary
    */
    func test_ToDictionary_ConvertingToDictionary_ShouldCreateClientDictionary() {
        let clientDetails = JPClientDetails(key: "Key", value: "Value")
        let dic = clientDetails.toDictionary() as NSDictionary
        XCTAssertEqual(dic.object(forKey: "key") as! String, "Key")
        XCTAssertEqual(dic.object(forKey: "value") as! String, "Value")
    }
}
