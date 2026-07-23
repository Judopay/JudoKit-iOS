//
//  JPAutomaticReloadPaymentRequestTests.swift
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
class JPAutomaticReloadPaymentRequestTests: XCTestCase {

    private let paymentDescription = "Automatic top-up"
    private let managementURL = URL(string: "https://example.com/manage")!
    private let billingLabel = "Top-up"
    private let billingAmount = NSDecimalNumber(string: "20.00")
    private let thresholdAmount = NSDecimalNumber(string: "5.00")
    private let billingAgreement = "Billing agreement text"
    private let tokenNotificationURL = URL(string: "https://example.com/token-notify")!

    private var billingItem: JPAutomaticReloadPaymentSummaryItem!
    private var sut: JPAutomaticReloadPaymentRequest!

    override func setUp() {
        super.setUp()
        billingItem = JPAutomaticReloadPaymentSummaryItem(label: billingLabel,
                                                          amount: billingAmount,
                                                          thresholdAmount: thresholdAmount)
        sut = JPAutomaticReloadPaymentRequest(paymentDescription: paymentDescription,
                                              automaticReloadBilling: billingItem,
                                              andManagementURL: managementURL)
    }

    override func tearDown() {
        billingItem = nil
        sut = nil
        super.tearDown()
    }

    /**
     * GIVEN: a JPAutomaticReloadPaymentRequest is initialized
     *
     * WHEN: the designated initializer is used
     *
     * THEN: the paymentDescription must be set correctly
     */
    func test_OnInitialization_SetsPaymentDescription() {
        XCTAssertEqual(sut.paymentDescription, paymentDescription)
    }

    /**
     * GIVEN: a JPAutomaticReloadPaymentRequest is initialized
     *
     * WHEN: the designated initializer is used
     *
     * THEN: the managementURL must be set correctly
     */
    func test_OnInitialization_SetsManagementURL() {
        XCTAssertEqual(sut.managementURL, managementURL)
    }

    /**
     * GIVEN: a JPAutomaticReloadPaymentRequest is initialized
     *
     * WHEN: the designated initializer is used
     *
     * THEN: the automaticReloadBilling item must be set correctly
     */
    func test_OnInitialization_SetsAutomaticReloadBilling() {
        XCTAssertEqual(sut.automaticReloadBilling.label, billingLabel)
        XCTAssertEqual(sut.automaticReloadBilling.amount, billingAmount)
        XCTAssertEqual(sut.automaticReloadBilling.thresholdAmount, thresholdAmount)
    }

    /**
     * GIVEN: a JPAutomaticReloadPaymentRequest is initialized
     *
     * WHEN: only required properties are provided
     *
     * THEN: optional properties should be nil by default
     */
    func test_OnInitialization_OptionalPropertiesAreNil() {
        XCTAssertNil(sut.billingAgreement)
        XCTAssertNil(sut.tokenNotificationURL)
    }

    /**
     * GIVEN: a JPAutomaticReloadPaymentRequest is initialized
     *
     * WHEN: toPKAutomaticReloadPaymentRequest is called
     *
     * THEN: the returned request must have matching paymentDescription and managementURL
     */
    func test_ToPKRequest_MapsRequiredProperties() {
        let pkRequest = sut.toPKAutomaticReloadPaymentRequest()
        XCTAssertNotNil(pkRequest)
        XCTAssertEqual(pkRequest?.paymentDescription, paymentDescription)
        XCTAssertEqual(pkRequest?.managementURL, managementURL)
    }

    /**
     * GIVEN: a JPAutomaticReloadPaymentRequest is initialized
     *
     * WHEN: billingAgreement is set and toPKAutomaticReloadPaymentRequest is called
     *
     * THEN: the returned request must have the billingAgreement set
     */
    func test_ToPKRequest_MapsBillingAgreementWhenSet() {
        sut.billingAgreement = billingAgreement
        let pkRequest = sut.toPKAutomaticReloadPaymentRequest()
        XCTAssertEqual(pkRequest?.billingAgreement, billingAgreement)
    }

    /**
     * GIVEN: a JPAutomaticReloadPaymentRequest is initialized
     *
     * WHEN: tokenNotificationURL is set and toPKAutomaticReloadPaymentRequest is called
     *
     * THEN: the returned request must have the tokenNotificationURL set
     */
    func test_ToPKRequest_MapsTokenNotificationURLWhenSet() {
        sut.tokenNotificationURL = tokenNotificationURL
        let pkRequest = sut.toPKAutomaticReloadPaymentRequest()
        XCTAssertEqual(pkRequest?.tokenNotificationURL, tokenNotificationURL)
    }
}
