//
//  JP3DSChallengeStatusReceiverTests.swift
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

class JP3DSChallengeStatusReceiverTests: XCTestCase {
    
    var mockApiService: JPApiServiceMock!
    var mockCardDetails: JPCardTransactionDetails!
    var mockResponse: JPResponse!
    var mockCompletion: JPCompletionBlock!
    var sut: JP3DSChallengeStatusReceiverImpl!
    
    override func setUp() {
        super.setUp()
        
        mockApiService = JPApiServiceMock()
        mockCardDetails = createMockCardDetails()
        mockResponse = createMockResponse()
        mockCompletion = { _, _ in }
        
        sut = JP3DSChallengeStatusReceiverImpl(apiService: mockApiService,
                                              details: mockCardDetails,
                                              response: mockResponse,
                                              andCompletion: mockCompletion)
    }
    
    override func tearDown() {
        sut = nil
        mockCompletion = nil
        mockResponse = nil
        mockCardDetails = nil
        mockApiService = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    /*
     * GIVEN: JP3DSChallengeStatusReceiverImpl is initialized
     *
     * WHEN: all required parameters are provided
     *
     * THEN: the properties should be set correctly
     */
    func test_OnInitialization_SetProperties() {
        XCTAssertNotNil(sut.apiService)
        XCTAssertNotNil(sut.details)
        XCTAssertNotNil(sut.response)
        XCTAssertNotNil(sut.completion)
        XCTAssertEqual(sut.apiService, mockApiService)
        XCTAssertEqual(sut.details, mockCardDetails)
        XCTAssertEqual(sut.response, mockResponse)
    }
    
    // MARK: - Transaction Completed Tests
    
    /*
     * GIVEN: 3DS2 challenge is completed successfully
     *
     * WHEN: transactionCompletedWithCompletionEvent is called
     *
     * THEN: should call complete3DS2 with completion status
     */
    func test_TransactionCompleted_ShouldCallComplete3DS2() {
        let completionEvent = JP3DSCompletionEvent()
        completionEvent.sdkTransactionID = "test_sdk_transaction_id"
        completionEvent.transactionStatus = "Y"
        
        sut.transactionCompleted(with: completionEvent)
        
        XCTAssertTrue(mockApiService.complete3DS2Called)
        XCTAssertEqual(mockApiService.lastReceiptId, "test_receipt_id")
        XCTAssertNotNil(mockApiService.lastComplete3DS2Request)
    }
    
    // MARK: - Transaction Cancelled Tests
    
    /*
     * GIVEN: 3DS2 challenge is cancelled by user
     *
     * WHEN: transactionCancelled is called
     *
     * THEN: should call complete3DS2 with cancelled status
     */
    func test_TransactionCancelled_ShouldCallComplete3DS2WithCancelledStatus() {
        sut.transactionCancelled()
        
        XCTAssertTrue(mockApiService.complete3DS2Called)
        XCTAssertEqual(mockApiService.lastReceiptId, "test_receipt_id")
        XCTAssertNotNil(mockApiService.lastComplete3DS2Request)
        
        // Verify the request contains cancelled status
        if let request = mockApiService.lastComplete3DS2Request {
            XCTAssertEqual(request.threeDSSDKChallengeStatus, "Cancelled")
        }
    }
    
    // MARK: - Transaction Timed Out Tests
    
    /*
     * GIVEN: 3DS2 challenge times out
     *
     * WHEN: transactionTimedOut is called
     *
     * THEN: should call complete3DS2 with timeout status
     */
    func test_TransactionTimedOut_ShouldCallComplete3DS2WithTimeoutStatus() {
        sut.transactionTimedOut()
        
        XCTAssertTrue(mockApiService.complete3DS2Called)
        XCTAssertEqual(mockApiService.lastReceiptId, "test_receipt_id")
        XCTAssertNotNil(mockApiService.lastComplete3DS2Request)
        
        // Verify the request contains timeout status
        if let request = mockApiService.lastComplete3DS2Request {
            XCTAssertEqual(request.threeDSSDKChallengeStatus, "Timeout")
        }
    }
    
    // MARK: - Protocol Error Tests
    
    /*
     * GIVEN: 3DS2 challenge fails with protocol error
     *
     * WHEN: transactionFailedWithProtocolErrorEvent is called
     *
     * THEN: should call complete3DS2 with protocol error status
     */
    func test_TransactionFailedWithProtocolError_ShouldCallComplete3DS2WithProtocolErrorStatus() {
        let errorMessage = JP3DSErrorMessage()
        errorMessage.errorCode = "test_error_code"
        errorMessage.errorComponent = "test_component"
        errorMessage.errorDescription = "test_description"
        errorMessage.errorDetails = "test_details"
        errorMessage.errorMessageType = "test_message_type"
        errorMessage.messageVersionNumber = "2.1.0"
        
        let protocolErrorEvent = JP3DSProtocolErrorEvent()
        protocolErrorEvent.sdkTransactionID = "test_sdk_transaction_id"
        protocolErrorEvent.errorMessage = errorMessage
        
        sut.transactionFailed(with: protocolErrorEvent)
        
        XCTAssertTrue(mockApiService.complete3DS2Called)
        XCTAssertEqual(mockApiService.lastReceiptId, "test_receipt_id")
        XCTAssertNotNil(mockApiService.lastComplete3DS2Request)
        
        // Verify the request contains protocol error status
        if let request = mockApiService.lastComplete3DS2Request {
            XCTAssertTrue(request.threeDSSDKChallengeStatus!.contains("ProtocolError"))
            XCTAssertTrue(request.threeDSSDKChallengeStatus!.contains("test_error_code"))
            XCTAssertTrue(request.threeDSSDKChallengeStatus!.contains("test_description"))
        }
    }
    
    // MARK: - Runtime Error Tests
    
    /*
     * GIVEN: 3DS2 challenge fails with runtime error
     *
     * WHEN: transactionFailedWithRuntimeErrorEvent is called
     *
     * THEN: should call complete3DS2 with runtime error status
     */
    func test_TransactionFailedWithRuntimeError_ShouldCallComplete3DS2WithRuntimeErrorStatus() {
        let runtimeErrorEvent = JP3DSRuntimeErrorEvent()
        runtimeErrorEvent.errorCode = "test_error_code"
        runtimeErrorEvent.errorMessage = "test_error_message"
        
        sut.transactionFailed(with: runtimeErrorEvent)
        
        XCTAssertTrue(mockApiService.complete3DS2Called)
        XCTAssertEqual(mockApiService.lastReceiptId, "test_receipt_id")
        XCTAssertNotNil(mockApiService.lastComplete3DS2Request)
        
        // Verify the request contains runtime error status
        if let request = mockApiService.lastComplete3DS2Request {
            XCTAssertTrue(request.threeDSSDKChallengeStatus!.contains("RuntimeError"))
            XCTAssertTrue(request.threeDSSDKChallengeStatus!.contains("test_error_code"))
            XCTAssertTrue(request.threeDSSDKChallengeStatus!.contains("test_error_message"))
        }
    }
    
    // MARK: - Complete3DS2 Request Creation Tests
    
    /*
     * GIVEN: complete3DS2 request is created
     *
     * WHEN: with valid parameters
     *
     * THEN: should contain correct version and security code
     */
    func test_Complete3DS2Request_ShouldContainCorrectParameters() {
        sut.performComplete3DS2(withChallengeStatus: "TestStatus")
        
        XCTAssertTrue(mockApiService.complete3DS2Called)
        XCTAssertNotNil(mockApiService.lastComplete3DS2Request)
        
        if let request = mockApiService.lastComplete3DS2Request {
            XCTAssertEqual(request.version, "2.2.0")
            XCTAssertEqual(request.cv2, "123")
            XCTAssertEqual(request.threeDSSDKChallengeStatus, "TestStatus")
        }
    }
    
    
    // MARK: - Helper Methods
    
    private func createMockCardDetails() -> JPCardTransactionDetails {
        let cardDetails = JPCardTransactionDetails()
        cardDetails.cardNumber = "4111111111111111"
        cardDetails.expiryDate = "12/25"
        cardDetails.securityCode = "123"
        cardDetails.cardholderName = "John Doe"
        return cardDetails
    }
    
    private func createMockResponse() -> JPResponse {
        let data: [String: Any] = [
            "result": "Challenge completion is needed for 3D Secure 2",
            "acsSignedContent": "eyJhbGciOiJQUzI1NiIsIl41cdh1nJuNocc7LVNX1neoMR_kQiuhS1ac_ZqHO4y8aAMWGB4H71Rlf3_u9nbwvvX34KkoUoS8dIvrqT5j6DlJyQCicz0sePkEKm0J2H9gN24gttfiEOU0aMdMdaZaiwQ",
            "message": "Issuer ACS has responded with a Challenge URL",
            "acsRenderingType": [
                "acsInterface": "NATIVE",
                "acsUiTemplate": "OOB"
            ],
            "version": "2.2.0",
            "acsReferenceNumber": "3DS_LOA_ACS_INTE_020200_00293",
            "cReq": """
                ewogICJtZXNzYWdlVHlwZSIgOiAiQ1JlcSIsCiAgIm1lc3NhZ2VWZXJzaW9uIiA6ICIyLjIuMCIsCiAgInRocmVlRFNTZXJ2ZXJUcmFuc0lEIiA6ICI3NGE2ZTgwNS1lOGU5LTRhNDYtOTllMy1iZjEzMjEwMmQ4MjEiLAogICJhY3NUcmFuc0lEIiA6ICJiMzc4YTk5MC02N2UwLTQxZjAtOTA3ZC1iNTU4NjI4YTRjNDgiLAogICJjaGFsbGVuZ2VXaW5kb3dTaXplIiA6ICIwMSIKfQ
                """,
            "receiptId": "test_receipt_id"
        ]
        return JPResponse(dictionary: data)
    }
}

// MARK: - Mock Classes

class JPApiServiceMock: JPApiService {
    
    var complete3DS2Called = false
    var lastReceiptId: String?
    var lastComplete3DS2Request: JPComplete3DS2Request?
    
    override func invokeComplete3dSecureTwo(withReceiptId receiptId: String,
                                           request: JPComplete3DS2Request,
                                           andCompletion completion: @escaping JPCompletionBlock) {
        complete3DS2Called = true
        lastReceiptId = receiptId
        lastComplete3DS2Request = request
        
        // Call completion with success
        let response = JPResponse()
        completion(response, nil)
    }
} 
