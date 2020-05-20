//
//  NSArrayAdditionsTest.swift
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

class NSArrayAdditionsTest: XCTestCase {
    let sutArrayCard: NSArray = ["UK", "USA"]
    
    /*
     * GIVEN: NSArray addition for prefix check
     *
     * WHEN: array contains prefix
     *
     * THEN: should return true bool value
     */
    func test_ContainsPrefix_WhenItIsInArray_ShouldReturnTrue() {
        let contain = sutArrayCard.containsPrefix("UK")
        XCTAssertTrue(contain)
    }
    
    /*
     * GIVEN: NSArray addition for prefix check
     *
     * WHEN: array doesnt contains prefix
     *
     * THEN: should return false bool value
     */
    func test_ContainsPrefix_WhenItIsNotInArray_ShouldReturnFalse() {
        let notContaining = sutArrayCard.containsPrefix("MD")
        XCTAssertFalse(notContaining)
    }
}
