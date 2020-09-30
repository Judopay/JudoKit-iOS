//
//  JPPaymentSummaryItemTests.swift
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

class JPPaymentSummaryItemTests: XCTestCase {

    private var sut: JPPaymentSummaryItem!

    /**
     * GIVEN: a JPPaymentSummaryItem is initialized
     *
     * WHEN: the partial initialization method is used
     *
     * THEN: the specified properties must be set, and [type] should default to [.final]
     */
    func test_OnPartialInitialization_SetDefaultProperties() {
        sut = JPPaymentSummaryItem(label: "Hello", amount: 0.01)
        XCTAssertEqual(sut.label, "Hello")
        XCTAssertEqual(sut.amount, 0.01)
        XCTAssertEqual(sut.type, .final)
    }

    /**
     * GIVEN: a JPPaymentSummaryItem is initialized
     *
     * WHEN: the full initialization method is used
     *
     * THEN: all the properties must be set correctly
     */
    func test_OnFullInitialization_SetAllProperties() {
        sut = JPPaymentSummaryItem(label: "Hello", amount: 0.01, type: .pending)
        XCTAssertEqual(sut.label, "Hello")
        XCTAssertEqual(sut.amount, 0.01)
        XCTAssertEqual(sut.type, .pending)
    }

}
