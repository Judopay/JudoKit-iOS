//
//  JPApplePayServiceTest.swift
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

class JPApplePayServiceTest: XCTestCase {

    private var sut: JPApplePayService!

    lazy var amount = JPAmount("0.01", currency: "GBP")
    lazy var reference = JPReference(consumerReference: "consumerReference")
    lazy var configuration = JPConfiguration(judoID: "123456", amount: amount, reference: reference)
    lazy var authorization: JPAuthorization = JPBasicAuthorization(token: "token", andSecret: "secret")
    lazy var apiService = JPApiService(authorization: authorization, isSandboxed: true)

    override func setUp() {
        super.setUp()
        HTTPStubs.setEnabled(true)
        sut = JPApplePayService(apiService: apiService)
    }

    override func tearDown() {
        HTTPStubs.setEnabled(false)
        sut = nil
        super.tearDown()
    }

    /**
     * GIVEN: Apple Pay is being veririfed
     *
     * WHEN: the app is executed on an iOS Simulator
     *
     * THEN: Apple Pay should be set up by default
     */
    func test_WhenUsingSimulator_ApplePayShouldBeSetUp() {
        XCTAssertTrue(JPApplePayService.canMakePayments(using: self.configuration))
    }

    /**
     * GIVEN: Apple Pay Service checks for Apple Pay support
     *
     * WHEN: the app is executed on an iOS Simulator
     *
     * THEN: Apple Pay should be supported by default
     */
    func test_WhenUsingSimulator_ApplePayShouldBeSupported() {
        XCTAssertTrue(JPApplePayService.isApplePaySupported())
    }

}
