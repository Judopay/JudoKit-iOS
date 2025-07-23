//
//  JPCardTransactionServiceHelperTests.swift
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
@testable import Judo3DS2_iOS

class JPCardTransactionServiceHelperTests: XCTestCase {
    
    // MARK: - buildEventString Tests
    
    /*
     * GIVEN: buildEventString function is called
     *
     * WHEN: valid event type and pairs are provided
     *
     * THEN: should return correctly formatted string
     */
    func test_buildEventString_WithValidInput_ShouldReturnFormattedString() {
        let eventType = "TestEvent"
        let pairs = ["key1": "value1", "key2": "value2"]
        
        let result = buildEventString(eventType, pairs)
        
        XCTAssertTrue(result.contains("TestEvent"))
        XCTAssertTrue(result.contains("key1=value1"))
        XCTAssertTrue(result.contains("key2=value2"))
        XCTAssertTrue(result.contains("|"))
    }
    
    /*
     * GIVEN: buildEventString function is called
     *
     * WHEN: empty pairs dictionary is provided
     *
     * THEN: should return only event type
     */
    func test_buildEventString_WithEmptyPairs_ShouldReturnOnlyEventType() {
        let eventType = "TestEvent"
        let pairs: [String: Any] = [:]
        
        let result = buildEventString(eventType, pairs)
        
        XCTAssertEqual(result, "TestEvent")
    }
    
    /*
     * GIVEN: buildEventString function is called
     *
     * WHEN: nil values are provided
     *
     * THEN: should handle nil values gracefully
     */
    func test_buildEventString_WithNilValues_ShouldHandleGracefully() {
        let eventType = "TestEvent"
        let pairs = ["key1": nil, "key2": "value2"]
        
        let result = buildEventString(eventType, pairs as [String : Any])
        
        XCTAssertTrue(result.contains("TestEvent"))
        XCTAssertTrue(result.contains("key2=value2"))
    }
    
}

// MARK: - 3DS2 Event Formatted String Tests

class JP3DSEventFormattedStringTests: XCTestCase {
    
    /*
     * GIVEN: JP3DSCompletionEvent is created
     *
     * WHEN: toFormattedEventString is called
     *
     * THEN: should return correctly formatted string
     */
    func test_JP3DSCompletionEvent_ToFormattedEventString_ShouldReturnFormattedString() {
        let completionEvent = JP3DSCompletionEvent()
        completionEvent.sdkTransactionID = "test_sdk_transaction_id"
        completionEvent.transactionStatus = "Y"
        
        let result = completionEvent.toFormattedEventString()
        
        XCTAssertTrue(result.contains("Completed"))
        XCTAssertTrue(result.contains("SDKTransactionID=test_sdk_transaction_id"))
        XCTAssertTrue(result.contains("transactionStatus=Y"))
    }
        
    /*
     * GIVEN: JP3DSProtocolErrorEvent is created
     *
     * WHEN: toFormattedEventString is called
     *
     * THEN: should return correctly formatted string
     */
    func test_JP3DSProtocolErrorEvent_ToFormattedEventString_ShouldReturnFormattedString() {
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
        
        let result = protocolErrorEvent.toFormattedEventString()
        
        XCTAssertTrue(result.contains("ProtocolError"))
        XCTAssertTrue(result.contains("SDKTransactionID=test_sdk_transaction_id"))
        XCTAssertTrue(result.contains("errorMessage="))
        XCTAssertTrue(result.contains("test_error_code"))
        XCTAssertTrue(result.contains("test_description"))
    }
    
    /*
     * GIVEN: JP3DSRuntimeErrorEvent is created
     *
     * WHEN: toFormattedEventString is called
     *
     * THEN: should return correctly formatted string
     */
    func test_JP3DSRuntimeErrorEvent_ToFormattedEventString_ShouldReturnFormattedString() {
        let runtimeErrorEvent = JP3DSRuntimeErrorEvent()
        runtimeErrorEvent.errorCode = "test_error_code"
        runtimeErrorEvent.errorMessage = "test_error_message"
        
        let result = runtimeErrorEvent.toFormattedEventString()
        
        XCTAssertTrue(result.contains("RuntimeError"))
        XCTAssertTrue(result.contains("errorCode=test_error_code"))
        XCTAssertTrue(result.contains("errorMessage=test_error_message"))
    }
    
} 
