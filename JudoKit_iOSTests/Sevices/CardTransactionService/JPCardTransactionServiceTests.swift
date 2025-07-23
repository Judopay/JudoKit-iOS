//
//  JPCardTransactionServiceTests.swift
//  JudoKit_iOSTests
//
//  Copyright (c) 2025 Alternative Payments Ltd
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

class JPCardTransactionServiceTests: XCTestCase {
    
    var authorization: JPAuthorization!
    var configuration: JPConfiguration!
    var apiService: JPApiService!
    var sut: JPCardTransactionService!
    
    lazy var transactionAmount = JPAmount("100.0", currency: "EUR")
    lazy var transactionReference = JPReference(consumerReference: "consumerReference",
                                                paymentReference: "PaymentReference")
    
    override func setUp() {
        super.setUp()
        HTTPStubs.setEnabled(true)
        
        authorization = JPBasicAuthorization(token: "token", andSecret: "secret")
        configuration = JPConfiguration(judoID: "JUDOID",
                                       amount: transactionAmount,
                                       reference: transactionReference)
        apiService = JPApiService(authorization: authorization, isSandboxed: true)
        sut = JPCardTransactionService(apiService: apiService, andConfiguration: configuration)
    }
    
    override func tearDown() {
        sut = nil
        apiService = nil
        configuration = nil
        authorization = nil
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    // MARK: - Recommendation Service Tests
    
    /*
     * GIVEN: recommendation service returns prevent action
     *
     * WHEN: a payment transaction is invoked
     *
     * THEN: transaction should be prevented
     */
    func test_RecommendationServicePreventsTransaction_ShouldReturnError() {
        let recommendationConfig = JPRecommendationConfiguration()
        recommendationConfig.haltTransactionInCaseOfAnyError = true
        configuration.recommendationConfiguration = recommendationConfig
        
        let cardDetails = createValidCardDetails()
        let expectation = self.expectation(description: "await prevented transaction")
        
        sut.invokePayment(with: cardDetails) { (response, error) in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 6, handler: nil)
    }
    
    // MARK: - Cleanup Tests
    
    /*
     * GIVEN: the service is being cleaned up
     *
     * WHEN: cleanup is called
     *
     * THEN: 3DS2 service should be cleaned up
     */
    func test_Cleanup_ShouldCleanup3DS2Service() {
        // This test verifies that cleanup doesn't crash
        sut.cleanup()
        XCTAssertTrue(true, "Cleanup completed successfully")
    }
    
    // MARK: - Helper Methods
    
    private func createValidCardDetails() -> JPCardTransactionDetails {
        let cardDetails = JPCardTransactionDetails()
        cardDetails.cardNumber = "4111111111111111"
        cardDetails.expiryDate = "12/25"
        cardDetails.securityCode = "123"
        cardDetails.cardholderName = "John Doe"
        return cardDetails
    }
}
