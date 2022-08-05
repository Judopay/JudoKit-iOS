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

@testable import JudoKit_iOS
import XCTest

class JPAddressTests: XCTestCase {
    let dictionaryForInit = ["address1": "line1",
                             "address2": "line2",
                             "address3": "line3",
                             "town": "town",
                             "billingCountry": "billingCountry",
                             "postCode": "postCode",
                             "countryCode": 123] as [String: Any]

    var address: JPAddress!

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
        let address = JPAddress(address1: "line1",
                                address2: "line2",
                                address3: "line3",
                                town: "town",
                                postCode: "postCode",
                                countryCode: 123)

        XCTAssertEqual(address.address1, "line1")
        XCTAssertEqual(address.address2, "line2")
        XCTAssertEqual(address.address3, "line3")
        XCTAssertEqual(address.town, "town")
        XCTAssertEqual(address.postCode, "postCode")
        XCTAssertEqual(address.countryCode, 123)
    }

    /*
     * GIVEN: Creating JPAddress from dictionary
     *
     * WHEN: setup all properties
     *
     * THEN: should create correct fields in JPAddress object
     */
    func test_initWithDictionary() {
        XCTAssertEqual(address.address1, "line1")
        XCTAssertEqual(address.address2, "line2")
        XCTAssertEqual(address.address3, "line3")
        XCTAssertEqual(address.town, "town")
        XCTAssertEqual(address.postCode, "postCode")
        XCTAssertEqual(address.countryCode, 123)
    }
}
