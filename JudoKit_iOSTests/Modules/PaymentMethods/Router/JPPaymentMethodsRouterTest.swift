//
//  JPPaymentMethodsRouterTest.swift
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

class JPPaymentMethodsRouterTest: XCTestCase {
    var sut: JPPaymentMethodsRouterImpl!
    let controller = JPPaymentMethodsViewController()
    
    override func setUp() {
        super.setUp()
        sut = JPPaymentMethodsRouterImpl()
        sut.viewController = controller
    }
    
    /*
     * GIVEN: send user to iDeal controller
     *
     * WHEN: siteid is missing
     *
     * THEN: should return error from router
     */
    func test_NavigateToIDEALModuleWithBank_WhenNoSiteID_ShouldReturnError() {
        let bank = JPIDEALBank(type: .ING)
        
        let expectation = self.expectation(description: "site id is missing for iDeal")
        let completion: JPCompletionBlock = { (response, error) in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        sut.navigateToIDEALModule(with: bank, andCompletion: completion)
        waitForExpectations(timeout: 1, handler: nil)
    }
}
