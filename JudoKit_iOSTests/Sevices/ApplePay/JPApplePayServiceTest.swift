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
    lazy var service = JPApiServiceiDealStub()
    lazy var configuration = JPConfiguration(judoID: "judoId",
                                             amount: JPAmount("123", currency: "EUR"),
                                             reference: JPReference(consumerReference: "consumerReference"))
    var sut: JPApplePayService! = nil
    
    override func setUp() {
        super.setUp()
        let appleConfig = JPApplePayConfiguration(merchantId: "merchantId", currency: "USD", countryCode: "UK", paymentSummaryItems: [JPPaymentSummaryItem(label: "item", amount: 0.15)])
        appleConfig.shippingMethods = [PaymentShippingMethod(label: "method", amount: 0.15)]
        configuration.applePayConfiguration = appleConfig
        sut = JPApplePayService(configuration:configuration,
                                andApiService:service)
    }
    
    /*
     * GIVEN: Checking apple method using simulated device
     *
     * THEN: should return true
     */
    func test_IsApplePaySetUp_WhenCallingApplePay_ShouldReturnTrueForSimulator() {
        let isApplePaySetUp = sut.isApplePaySetUp()
        XCTAssertTrue(isApplePaySetUp)
    }
    
    /*
     * GIVEN: Checking apple pay supported method for simulated device
     *
     * THEN: should return true
     */
    func test_IsApplePaySupported_WhenCheckingForSupport_ShouldReturnTrue() {
        let supported = JPApplePayService.isApplePaySupported()
        XCTAssertTrue(supported)
    }
    
    /*
     * GIVEN: a new instance of JPApplePayService is created
     *
     * WHEN: when a valid configuration and apiService is provided
     *
     * THEN: the returned instance of JPApplePayService should not be nil
     */
    func test_InitWithConfiguration_WhenParametresValid_ShouldReturnValidObject() {
        let applePayService = JPApplePayService(configuration: configuration, andApiService: service)
        XCTAssertNotNil(applePayService)
    }
    
    /*
     * GIVEN: Creating JPApplePayService with class Init
     *
     * WHEN: raw init
     *
     * THEN: should create correct non nill JPApplePayService object
     */
    func test_InitAppleService_WhenDesignatedInit_ShouldCreateObject() {
        let sut = JPApplePayService.init()
        XCTAssertNotNil(sut)
    }
    
    /*
     * GIVEN: Creating JPApplePayService with class Init
     *
     * WHEN: with configuration and service
     *
     * THEN: should create correct non nil JPApplePayService object
     */
    func test_InitAppleService_WhenClassInit_ShouldCreateObject() {
        let sut = JPApplePayService()
        XCTAssertNotNil(sut)
    }
    
    /*
     * GIVEN: Creating UIViewController with class Init
     *
     * WHEN: with type and nil completion
     *
     * THEN: should return nil UIViewController object
     */
    func test_initController_WhenPaymentType_ShouldCreateController() {
        configuration.applePayConfiguration?.shippingMethods = [PaymentShippingMethod(label: "method", amount: 0.15)]
        sut = JPApplePayService()
        let controller = sut.applePayViewController(with: .payment, completion: nil)
        XCTAssertNil(controller)
    }
}
