//
//  CLLocationAdditionsTest.swift
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

class CLLocationAdditionsTest: XCTestCase {
    var myLocation: CLLocation!

    override func setUp() {
        super.setUp()
        myLocation = CLLocation(latitude: 51.5074, longitude: 0.1278)
    }

    /*
    * GIVEN: CLLocation addition for dictionary
    *
    * WHEN: initialize and make dictionary from location
    *
    * THEN: should be parsed in valid dictionary of coordinates
    */
    func testToDictionary() {
        let coordinateDictionary = myLocation._jp_toDictionary() as! [String: Double]
        XCTAssertEqual(coordinateDictionary.count, 2)
        XCTAssertEqual(coordinateDictionary["latitude"], 51.5074)
        XCTAssertEqual(coordinateDictionary["longitude"], 0.1278)
    }
}
