//
//  JPDeferredPaymentSummaryItemTests.swift
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

class JPDeferredPaymentSummaryItemTests: XCTestCase {

    private let label = "Hotel booking"
    private let amount = NSDecimalNumber(string: "150.00")
    private let deferredDate = Date(timeIntervalSinceReferenceDate: 1_000_000)

    private var sut: JPDeferredPaymentSummaryItem!

    override func setUp() {
        super.setUp()
        sut = JPDeferredPaymentSummaryItem(label: label,
                                           amount: amount,
                                           deferredDate: deferredDate)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    /**
     * GIVEN: a JPDeferredPaymentSummaryItem is initialized
     *
     * WHEN: the designated initializer is used
     *
     * THEN: the label must be set correctly
     */
    func test_OnInitialization_SetsLabel() {
        XCTAssertEqual(sut.label, label)
    }

    /**
     * GIVEN: a JPDeferredPaymentSummaryItem is initialized
     *
     * WHEN: the designated initializer is used
     *
     * THEN: the amount must be set correctly
     */
    func test_OnInitialization_SetsAmount() {
        XCTAssertEqual(sut.amount, amount)
    }

    /**
     * GIVEN: a JPDeferredPaymentSummaryItem is initialized
     *
     * WHEN: the designated initializer is used
     *
     * THEN: the deferredDate must be set correctly
     */
    func test_OnInitialization_SetsDeferredDate() {
        XCTAssertEqual(sut.deferredDate, deferredDate)
    }

    /**
     * GIVEN: a JPDeferredPaymentSummaryItem is initialized
     *
     * WHEN: toPKDeferredPaymentSummaryItem is called
     *
     * THEN: the returned PKDeferredPaymentSummaryItem must have a matching label
     */
    @available(iOS 15.0, *)
    func test_ToPKItem_MapsLabel() {
        let pkItem = sut.toPKDeferredPaymentSummaryItem()
        XCTAssertEqual(pkItem.label, label)
    }

    /**
     * GIVEN: a JPDeferredPaymentSummaryItem is initialized
     *
     * WHEN: toPKDeferredPaymentSummaryItem is called
     *
     * THEN: the returned PKDeferredPaymentSummaryItem must have a matching amount
     */
    @available(iOS 15.0, *)
    func test_ToPKItem_MapsAmount() {
        let pkItem = sut.toPKDeferredPaymentSummaryItem()
        XCTAssertEqual(pkItem.amount, amount)
    }

    /**
     * GIVEN: a JPDeferredPaymentSummaryItem is initialized
     *
     * WHEN: toPKDeferredPaymentSummaryItem is called
     *
     * THEN: the returned PKDeferredPaymentSummaryItem must have a matching deferredDate
     */
    @available(iOS 15.0, *)
    func test_ToPKItem_MapsDeferredDate() {
        let pkItem = sut.toPKDeferredPaymentSummaryItem()
        XCTAssertEqual(pkItem.deferredDate, deferredDate)
    }
}
