//
//  JPDeferredPaymentRequestTests.swift
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

@available(iOS 16.4, *)
class JPDeferredPaymentRequestTests: XCTestCase {

    private let paymentDescription = "Hotel pre-authorisation"
    private let managementURL = URL(string: "https://example.com/manage")!
    private let billingLabel = "Hotel booking"
    private let billingAmount = NSDecimalNumber(string: "150.00")
    private let deferredDate = Date(timeIntervalSinceReferenceDate: 1_000_000)
    private let billingAgreement = "Pre-authorisation terms"
    private let freeCancellationDate = Date(timeIntervalSinceReferenceDate: 500_000)
    private let tokenNotificationURL = URL(string: "https://example.com/token-notify")!

    private var billingItem: JPDeferredPaymentSummaryItem!
    private var sut: JPDeferredPaymentRequest!

    override func setUp() {
        super.setUp()
        billingItem = JPDeferredPaymentSummaryItem(label: billingLabel,
                                                   amount: billingAmount,
                                                   deferredDate: deferredDate)
        sut = JPDeferredPaymentRequest(paymentDescription: paymentDescription,
                                       deferredBilling: billingItem,
                                       andManagementURL: managementURL)
    }

    override func tearDown() {
        billingItem = nil
        sut = nil
        super.tearDown()
    }

    /**
     * GIVEN: a JPDeferredPaymentRequest is initialized
     *
     * WHEN: the designated initializer is used
     *
     * THEN: the paymentDescription must be set correctly
     */
    func test_OnInitialization_SetsPaymentDescription() {
        XCTAssertEqual(sut.paymentDescription, paymentDescription)
    }

    /**
     * GIVEN: a JPDeferredPaymentRequest is initialized
     *
     * WHEN: the designated initializer is used
     *
     * THEN: the managementURL must be set correctly
     */
    func test_OnInitialization_SetsManagementURL() {
        XCTAssertEqual(sut.managementURL, managementURL)
    }

    /**
     * GIVEN: a JPDeferredPaymentRequest is initialized
     *
     * WHEN: the designated initializer is used
     *
     * THEN: the deferredBilling item must be set correctly
     */
    func test_OnInitialization_SetsDeferredBilling() {
        XCTAssertEqual(sut.deferredBilling.label, billingLabel)
        XCTAssertEqual(sut.deferredBilling.amount, billingAmount)
        XCTAssertEqual(sut.deferredBilling.deferredDate, deferredDate)
    }

    /**
     * GIVEN: a JPDeferredPaymentRequest is initialized
     *
     * WHEN: only required properties are provided
     *
     * THEN: optional properties should be nil by default
     */
    func test_OnInitialization_OptionalPropertiesAreNil() {
        XCTAssertNil(sut.billingAgreement)
        XCTAssertNil(sut.tokenNotificationURL)
        XCTAssertNil(sut.freeCancellationDate)
        XCTAssertNil(sut.freeCancellationDateTimeZone)
    }

    /**
     * GIVEN: a JPDeferredPaymentRequest is initialized
     *
     * WHEN: toPKDeferredPaymentRequest is called
     *
     * THEN: the returned request must have matching paymentDescription and managementURL
     */
    func test_ToPKRequest_MapsRequiredProperties() {
        let pkRequest = sut.toPKDeferredPaymentRequest()
        XCTAssertNotNil(pkRequest)
        XCTAssertEqual(pkRequest?.paymentDescription, paymentDescription)
        XCTAssertEqual(pkRequest?.managementURL, managementURL)
    }

    /**
     * GIVEN: a JPDeferredPaymentRequest has billingAgreement set
     *
     * WHEN: toPKDeferredPaymentRequest is called
     *
     * THEN: the returned request must have the billingAgreement set
     */
    func test_ToPKRequest_MapsBillingAgreementWhenSet() {
        sut.billingAgreement = billingAgreement
        let pkRequest = sut.toPKDeferredPaymentRequest()
        XCTAssertEqual(pkRequest?.billingAgreement, billingAgreement)
    }

    /**
     * GIVEN: a JPDeferredPaymentRequest has freeCancellationDate set
     *
     * WHEN: toPKDeferredPaymentRequest is called
     *
     * THEN: the returned request must have the freeCancellationDate set
     */
    func test_ToPKRequest_MapsFreeCancellationDateWhenSet() {
        sut.freeCancellationDate = freeCancellationDate
        let pkRequest = sut.toPKDeferredPaymentRequest()
        XCTAssertEqual(pkRequest?.freeCancellationDate, freeCancellationDate)
    }

    /**
     * GIVEN: a JPDeferredPaymentRequest has tokenNotificationURL set
     *
     * WHEN: toPKDeferredPaymentRequest is called
     *
     * THEN: the returned request must have the tokenNotificationURL set
     */
    func test_ToPKRequest_MapsTokenNotificationURLWhenSet() {
        sut.tokenNotificationURL = tokenNotificationURL
        let pkRequest = sut.toPKDeferredPaymentRequest()
        XCTAssertEqual(pkRequest?.tokenNotificationURL, tokenNotificationURL)
    }
}
