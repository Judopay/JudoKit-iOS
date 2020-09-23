//
//  JPIDEALServiceTest.swift
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

class JPIDEALServiceTest: XCTestCase {
    lazy var service = JPApiServiceiDealStub()
    lazy var configuration = JPConfiguration(judoID: "judoId",
                                             amount: JPAmount("123", currency: "EUR"),
                                             reference: JPReference(consumerReference: "consumerReference"))
    var sut: JPIDEALService! = nil
    let bank = JPIDEALBank(type: .ING)
    
    override func setUp() {
        super.setUp()
        HTTPStubs.setEnabled(true)
        sut = JPIDEALService(configuration:configuration,
                             apiService:service)
    }
    
    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
  
    /*
     * GIVEN: JPIDEALService calling bank sale point
     *
     * WHEN: Every parameter in config model is valid
     *
     * THEN: should return valid response
     */
    func test_RedirectURL_WhenBankiDeal_ShouldReturnValidiDealResponse() {
        
        let expectation = self.expectation(description: "get response from iDeal sale")
        let completion: JPCompletionBlock = { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        sut.redirectURL(for: bank, completion: completion)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    /*
     * GIVEN: JPIDEALService polling status
     *
     * WHEN: response is stuck at Pending status for more then 60 sec (kTimerDuration)
     *
     * THEN: should return error: "Request did not complete in the specified time"
     */
    func test_PollTransactionStatus_WhenPendingInfinite_ShouldThrowErrorAfterkTimerDuration() {
        let expectation = self.expectation(description: "get response from iDeal pending sale")
        
        let completion: JPCompletionBlock = { (response, error) in
            XCTAssertNil(response)
            XCTAssertEqual(error?.localizedDescription, "The request has timed out.")
            expectation.fulfill()
        }
        
        sut.pollTransactionStatus(forOrderId: "", checksum: "", completion: completion)
        waitForExpectations(timeout: 65, handler: nil)
    }
    
    /*
     * GIVEN: JPIDEALService polling status
     *
     * WHEN: response handled successfully
     *
     * THEN: should return response with status "SUCCESS"
     */
    func test_PollTransactionStatus_WhenResponseSuccess_ShouldReturnSuccess() {
        let expectation = self.expectation(description: "get response from iDeal success sale")
        
        let completion: JPCompletionBlock = { (response, error) in
            XCTAssertEqual(response?.orderDetails?.orderStatus, "SUCCESS")
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        sut.pollTransactionStatus(forOrderId: "123456", checksum: "", completion: completion)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
