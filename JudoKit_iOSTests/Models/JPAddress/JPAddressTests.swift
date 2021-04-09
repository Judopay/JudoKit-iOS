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
    
    let dictionaryForInit = ["address1":"address1",
                             "address2":"address2",
                             "address3":"address3",
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
        let address = JPAddress(address1: "address1",
                                address2: "address2",
                                address3: "address3",
                                town: "town",
                                countryCode: 123,
                                postCode: "postCode")
        
        XCTAssertEqual(address.address1, "address1")
        XCTAssertEqual(address.address2, "address2")
        XCTAssertEqual(address.address3, "address3")
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
        XCTAssertEqual(address.address1, "address1")
        XCTAssertEqual(address.address2, "address2")
        XCTAssertEqual(address.address3, "address3")
        XCTAssertEqual(address.town, "town")
        XCTAssertEqual(address.countryCode, 123)
        XCTAssertEqual(address.postCode, "postCode")
    }
}
