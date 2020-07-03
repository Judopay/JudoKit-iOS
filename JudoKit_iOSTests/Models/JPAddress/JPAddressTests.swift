//
//  JPAddressTests.swift
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

class JPAddressTests: XCTestCase {
    
    let dictionaryForInit = ["line1":"line1",
                             "line2":"line2",
                             "line3":"line3",
                             "postCode":"postCode",
                             "town":"town",
                             "countryCode":123] as [String : Any]
    
    var address: JPAddress! = nil
    
    override func setUp() {
        super.setUp()
        address = JPAddress(dictionary: dictionaryForInit)
    }
    
    /*
     * GIVEN: Creating JPAddress designated init
     *
     * WHEN: setup all properties
     *
     * THEN: should create correct fields in JPAddress object
     */
    func test_InitDesignated() {
        let address = JPAddress(line1: "line1", line2: "line2", line3: "line3", town: "town", countryCode: 123, postCode: "postCode")
        XCTAssertEqual(address.line1, "line1")
        XCTAssertEqual(address.line2, "line2")
        XCTAssertEqual(address.line3, "line3")
        XCTAssertEqual(address.town, "town")
        XCTAssertEqual(address.countryCode, 123)
        XCTAssertEqual(address.postCode, "postCode")
    }
    
    /*
     * GIVEN: Creating JPAddress from dictionary
     *
     * WHEN: setup all properties
     *
     * THEN: should create correct fields in JPAddress object
     */
    func test_initWithDictionary() {
        XCTAssertEqual(address.line1, "line1")
        XCTAssertEqual(address.line2, "line2")
        XCTAssertEqual(address.line3, "line3")
        XCTAssertEqual(address.town, "town")
        XCTAssertEqual(address.countryCode, 123)
        XCTAssertEqual(address.postCode, "postCode")
    }
    
    /*
     * GIVEN: Creating Dictionary from JPAddress object
     *
     * WHEN: setup all properties
     *
     * THEN: should create correct Dictionary
     */
    func test_DictionaryRepresentation_WhenDeserializeObject_ShouldReturnRightDictionery() {
        let dictionary = address.dictionaryRepresentation!
        XCTAssertEqual(dictionary["line1"] as! String, "line1")
        XCTAssertEqual(dictionary["line2"] as! String, "line2")
        XCTAssertEqual(dictionary["line3"] as! String, "line3")
        XCTAssertEqual(dictionary["town"] as! String, "town")
        XCTAssertEqual(dictionary["countryCode"] as! NSNumber, 123)
        XCTAssertEqual(dictionary["postCode"] as! String, "postCode")
    }
}
