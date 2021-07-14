//
//  JPApplePayControllerTest.swift
//  JPApplePayServiceTest
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

class JPApplePayControllerTest: XCTestCase {

    private var sut: JPApplePayController!

    lazy var amount = JPAmount("0.01", currency: "GBP")
    lazy var reference = JPReference(consumerReference: "consumerReference")
    lazy var configuration = JPConfiguration(judoID: "123456", amount: amount, reference: reference)
    lazy var authBlock: JPApplePayAuthorizationBlock = { _,_ in }
    lazy var didFinishBlock: JPApplePayDidFinishBlock = { _ in }

    lazy var summaryItems = [JPPaymentSummaryItem(label: "item", amount: 0.15)];
    lazy var appleConfig = JPApplePayConfiguration(merchantId: "merchantId",
                                                   currency: "GBP",
                                                   countryCode: "GB",
                                                   paymentSummaryItems: summaryItems)

    /**
     * GIVEN: Apple Pay should be presented on the screen
     *
     * WHEN: a valid Apple Pay configuration is passed into the JPConfiguration object
     *
     * THEN: a configured UIViewController should be returned
     */
    func test_WhenValidApplePayConfiguration_ReturnConfiguredUIViewController() {
        configuration.applePayConfiguration = appleConfig
        sut = JPApplePayController(configuration: configuration)
        let controller = sut.applePayViewController(authorizationBlock: authBlock, didFinish: didFinishBlock)
        XCTAssertNotNil(controller)
    }

}
