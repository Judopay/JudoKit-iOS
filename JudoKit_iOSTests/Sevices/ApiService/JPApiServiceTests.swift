//
//  JPApiServiceTests.swift
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

import Foundation

import XCTest
@testable import JudoKit_iOS

class JPApiServiceTests: XCTestCase {
    
    var authorization: JPAuthorization!
    var sut: JPApiService!
    
    lazy var transactionAmmount = JPAmount("100.0", currency: "EUR")
    
    lazy var transactionReference = JPReference(consumerReference: "consumerReference",
                                                paymentReference: "PaymentReference")
    
    lazy var transactionConfigurations = JPConfiguration(judoID: "JUDOID",
                                                         amount: transactionAmmount,
                                                         reference: transactionReference)
    
    override func setUp() {
        super.setUp()
        HTTPStubs.setEnabled(true)
        authorization = JPBasicAuthorization(token: "token", andSecret: "secret")
        sut = JPApiService(authorization: authorization, isSandboxed: true)
        
        stub(condition: isHost("api-sandbox.judopay.com")) { _ in
            return HTTPStubsResponse(fileAtPath: OHPathForFile("SuccessResponsePBBA.json", type(of: self))!,
                                     statusCode: 200,
                                     headers: nil)
        }
    }
    
    override func tearDown() {
        authorization = nil
        sut = nil
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    /*
     * GIVEN: the JPApiService instance has been successfully initialized
     *
     * THEN:  the properties must be set correctly
     */
    func test_OnInitialization_SetProperties() {
        XCTAssertTrue(sut.isSandboxed)
        XCTAssertNotNil(sut.authorization)
    }
    
    /*
     * GIVEN: a payment transaction is invoked
     *
     * WHEN:  the JPPaymentRequest is passed a valid configuration
     *
     * THEN:  the transaction should complete successfully
     */
    func test_OnValidPaymentRequest_ReturnResponse() {
        let paymentRequest = JPPaymentRequest(configuration: transactionConfigurations)
        let expectation = self.expectation(description: "await payment response")
        
        sut.invokePayment(with: paymentRequest) { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 6, handler: nil)
    }

    /*
     * GIVEN: a pre-auth transaction is invoked
     *
     * WHEN:  the JPPaymentRequest is passed a valid configuration
     *
     * THEN:  the transaction should complete successfully
     */
    func test_OnValidPreAuthRequest_ReturnResponse() {
        let paymentRequest = JPPaymentRequest(configuration: transactionConfigurations)
        let expectation = self.expectation(description: "await preauth response")
        
        sut.invokePreAuthPayment(with: paymentRequest) { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 6, handler: nil)
    }
    
    /*
     * GIVEN: a save card transaction is invoked
     *
     * WHEN:  the JPSaveCardRequest is passed a valid configuration
     *
     * THEN:  the transaction should complete successfully
     */
    func test_OnValidSaveCardRequest_ReturnResponse() {
        let saveCardRequest = JPSaveCardRequest(configuration: transactionConfigurations)
        let expectation = self.expectation(description: "await save card response")
        
        sut.invokeSaveCard(with: saveCardRequest) { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 6, handler: nil)
    }
    
    /*
     * GIVEN: a register card transaction is invoked
     *
     * WHEN:  the JPRegisterCardRequest is passed a valid configuration
     *
     * THEN:  the transaction should complete successfully
     */
    func test_OnValidRegisterCardRequest_ReturnResponse() {
        let registerCardRequest = JPRegisterCardRequest(configuration: transactionConfigurations)
        let expectation = self.expectation(description: "await register card response")
        
        sut.invokeRegisterCard(with: registerCardRequest) { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 6, handler: nil)
    }
    
    /*
     * GIVEN: a check card transaction is invoked
     *
     * WHEN:  the JPCheckCardRequest is passed a valid configuration
     *
     * THEN:  the transaction should complete successfully
     */
    func test_OnValidCheckCardRequest_ReturnResponse() {
        let checkCardRequest = JPCheckCardRequest(configuration: transactionConfigurations)
        let expectation = self.expectation(description: "await check card response")
        
        sut.invokeCheckCard(with: checkCardRequest) { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 6, handler: nil)
    }
    
    /*
     * GIVEN: a token payment transaction is invoked
     *
     * WHEN:  the JPTokenRequest is passed a valid configuration
     *
     * THEN:  the transaction should complete successfully
     */
    func test_OnValidTokenPaymentRequest_ReturnResponse() {
        let tokenPaymentRequest = JPTokenRequest(configuration: transactionConfigurations)
        let expectation = self.expectation(description: "await token payment response")
        
        sut.invokeTokenPayment(with: tokenPaymentRequest) { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 6, handler: nil)
    }
    
    /*
     * GIVEN: a token pre-auth transaction is invoked
     *
     * WHEN:  the JPTokenRequest is passed a valid configuration
     *
     * THEN:  the transaction should complete successfully
     */
    func test_OnValidTokenPreAuthRequest_ReturnResponse() {
        let tokenPaymentRequest = JPTokenRequest(configuration: transactionConfigurations)
        let expectation = self.expectation(description: "await token pre-auth response")
        
        sut.invokePreAuthTokenPayment(with: tokenPaymentRequest) { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 6, handler: nil)
    }
    
    /*
     * GIVEN: an Apple Pay payment transaction is invoked
     *
     * WHEN:  the JPApplePayRequest is passed a valid configuration
     *
     * THEN:  the transaction should complete successfully
     */
    func test_OnValidApplePayPaymentRequest_ReturnResponse() {
        let applePayRequest = JPApplePayRequest(configuration: transactionConfigurations)
        let expectation = self.expectation(description: "await ApplePay payment response")
        
        sut.invokeApplePayPayment(with: applePayRequest) { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 6, handler: nil)
    }
    
    /*
     * GIVEN: an Apple Pay pre-auth transaction is invoked
     *
     * WHEN:  the JPApplePayRequest is passed a valid configuration
     *
     * THEN:  the transaction should complete successfully
     */
    func test_OnValidApplePayPreAuthRequest_ReturnResponse() {
        let applePayRequest = JPApplePayRequest(configuration: transactionConfigurations)
        let expectation = self.expectation(description: "await ApplePay pre-auth response")
        
        sut.invokePreAuthApplePayPayment(with: applePayRequest) { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 6, handler: nil)
    }
    
    /*
     * GIVEN: a Bank sale transaction is invoked
     *
     * WHEN:  the JPBankOrderSaleRequest is passed a valid configuration
     *
     * THEN:  the request should complete successfully
     */
    func test_OnValidBankSaleRequest_ReturnResponse() {
        let bankOrderSaleRequest = JPBankOrderSaleRequest(configuration: transactionConfigurations)
        let expectation = self.expectation(description: "await bank sale response")
        
        sut.invokeBankSale(with: bankOrderSaleRequest) { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 6, handler: nil)
    }
    
    /*
     * GIVEN: a Order status transaction is invoked
     *
     * WHEN:  the order ID is valid
     *
     * THEN:  the request should complete successfully
     */
    func test_OnValidOrderStatusRequest_ReturnResponse() {
        let expectation = self.expectation(description: "await order status response")
        
        sut.invokeOrderStatus(withOrderId: "12345") { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 6, handler: nil)
    }
    
    /*
     * GIVEN: a Order status transaction is invoked
     *
     * WHEN:  the order ID is valid
     *
     * THEN:  the request should complete successfully
     */
    func test_OnValid3DSecureRequest_ReturnResponse() {
        let expectation = self.expectation(description: "await 3DS transaction response")
        
        let result = JP3DSecureAuthenticationResult(paRes: "paRes", andMd: "md")
        
        sut.invokeComplete3dSecure(withReceiptId: "12345",
                                   authenticationResult: result) { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 6, handler: nil)
    }
}
