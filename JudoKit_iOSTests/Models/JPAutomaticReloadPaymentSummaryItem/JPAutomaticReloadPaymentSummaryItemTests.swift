//
//  JPAutomaticReloadPaymentSummaryItemTests.swift
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

@available(iOS 16.0, *)
class JPAutomaticReloadPaymentSummaryItemTests: XCTestCase {

    private let label = "Store top-up"
    private let amount = NSDecimalNumber(string: "20.00")
    private let thresholdAmount = NSDecimalNumber(string: "5.00")

    private var sut: JPAutomaticReloadPaymentSummaryItem!

    override func setUp() {
        super.setUp()
        sut = JPAutomaticReloadPaymentSummaryItem(label: label,
                                                  amount: amount,
                                                  thresholdAmount: thresholdAmount)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    /**
     * GIVEN: a JPAutomaticReloadPaymentSummaryItem is initialized
     *
     * WHEN: the designated initializer is used
     *
     * THEN: the label must be set correctly
     */
    func test_OnInitialization_SetsLabel() {
        XCTAssertEqual(sut.label, label)
    }

    /**
     * GIVEN: a JPAutomaticReloadPaymentSummaryItem is initialized
     *
     * WHEN: the designated initializer is used
     *
     * THEN: the amount must be set correctly
     */
    func test_OnInitialization_SetsAmount() {
        XCTAssertEqual(sut.amount, amount)
    }

    /**
     * GIVEN: a JPAutomaticReloadPaymentSummaryItem is initialized
     *
     * WHEN: the designated initializer is used
     *
     * THEN: the thresholdAmount must be set correctly
     */
    func test_OnInitialization_SetsThresholdAmount() {
        XCTAssertEqual(sut.thresholdAmount, thresholdAmount)
    }

    /**
     * GIVEN: a JPAutomaticReloadPaymentSummaryItem is initialized
     *
     * WHEN: toPKAutomaticReloadPaymentSummaryItem is called
     *
     * THEN: the returned PKAutomaticReloadPaymentSummaryItem must have a matching label
     */
    func test_ToPKItem_MapsLabel() {
        let pkItem = sut.toPKAutomaticReloadPaymentSummaryItem()
        XCTAssertEqual(pkItem.label, label)
    }

    /**
     * GIVEN: a JPAutomaticReloadPaymentSummaryItem is initialized
     *
     * WHEN: toPKAutomaticReloadPaymentSummaryItem is called
     *
     * THEN: the returned PKAutomaticReloadPaymentSummaryItem must have a matching amount
     */
    func test_ToPKItem_MapsAmount() {
        let pkItem = sut.toPKAutomaticReloadPaymentSummaryItem()
        XCTAssertEqual(pkItem.amount, amount)
    }

    /**
     * GIVEN: a JPAutomaticReloadPaymentSummaryItem is initialized
     *
     * WHEN: toPKAutomaticReloadPaymentSummaryItem is called
     *
     * THEN: the returned PKAutomaticReloadPaymentSummaryItem must have a matching thresholdAmount
     */
    func test_ToPKItem_MapsThresholdAmount() {
        let pkItem = sut.toPKAutomaticReloadPaymentSummaryItem()
        XCTAssertEqual(pkItem.thresholdAmount, thresholdAmount)
    }
}
