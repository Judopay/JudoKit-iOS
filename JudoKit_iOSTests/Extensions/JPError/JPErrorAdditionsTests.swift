//
//  JPErrorAdditionsTests.swift
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

class JPErrorAdditionsTests: XCTestCase {

    /*
     * GIVEN: the JPError is initialized with the custom judoRequestFailedError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoRequestFailedError_SetCorrectLocalizedDescription() {
        let error = JPError.requestFailedError()
        XCTAssertEqual(error.localizedDescription, "The request has failed or responded without data.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoJSONSerializationFailedWithError initializer
     *
     * THEN:  it should set the correct error code
     */
    func test_WhenJudoJSONSerializationFailedWithError_SetCorrectErrorCode() {
        let testError = NSError(domain: "test", code: 400, userInfo: nil)
        let error = JPError.jsonSerializationFailedWithError(testError)
        let judoErrorJSONSerializationFailed = Int(JudoError(rawValue: 1)!.rawValue)
        XCTAssertEqual(error.code, judoErrorJSONSerializationFailed)
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoUserDidCancelError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoUserDidCancelError_SetCorrectLocalizedDescription() {
        let error = JPError.userDidCancelError()
        XCTAssertEqual(error.localizedFailureReason, "The user closed the transaction flow without completing the transaction.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoParameterError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoParameterError_SetCorrectLocalizedDescription() {
        let error = JPError.responseParseError()
        let parameterError = Int(JudoError(rawValue: 1)!.rawValue)
        XCTAssertEqual(error.code, parameterError)
        XCTAssertEqual(error.localizedDescription, "Unexpected response format returned.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoInternetConnectionError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoInternetConnectionError_SetCorrectLocalizedDescription() {
        let error = JPError.internetConnectionError()
        XCTAssertEqual(error.localizedFailureReason, "The request could not be sent due to no internet connection.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoResponseParseError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoResponseParseError_SetCorrectLocalizedDescription() {
        let error = JPError.responseParseError()
        XCTAssertEqual(error.localizedFailureReason, "The response did not contain some of the required parameters needed to complete the transaction.")
        XCTAssertEqual(error.localizedDescription, "Unexpected response format returned.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoRequestTimeoutError initializer
     *
     * THEN:  it should set the correct error code
     */
    func test_WhenJudoRequestTimeoutError_SetCorrectErrorCode() {
        let error = JPError.requestTimeoutError()
        let timeoutError = Int(JudoError(rawValue: 1)!.rawValue)
        XCTAssertEqual(error.code, timeoutError)
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoInvalidCardNumberError initializer
     *
     * THEN:  it should set the correct error code
     */
    func test_WhenJudoInvalidCardNumberError_SetCorrectErrorCode() {
        let error = JPError.invalidCardNumberError()
        let cardNumberError = Int(JudoError(rawValue: 0)!.rawValue)
        XCTAssertEqual(error.code, cardNumberError)
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoUnsupportedCardNetwork AMEX initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoUnsupportedCardNetwork_SetCorrectLocalizedDescription() {
        let error = JPError.unsupportedCardNetwork(.AMEX)
        XCTAssertEqual(error.localizedDescription, "American Express is not supported")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judo3DSRequest initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudo3DSRequest_SetCorrectLocalizedDescription() {
        let error = JPError.threeDSRequest(withPayload: ["test": "testData"])
        let errorUserInfo = error.userInfo["test"] as! String
        XCTAssertEqual(errorUserInfo, "testData")
    }

    /*
     * GIVEN: the JPError is initialized with the custom judoApplePayNotSupportedError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoApplePayNotSupportedError_SetCorrectLocalizedDescription() {
        let error = JPError.applePayNotSupportedError()
        XCTAssertEqual(error.localizedDescription, "Apple Pay is not supported on this device.")
    }

    /*
     * GIVEN: the JPError is initialized from an NSDictionary
     *
     * WHEN:  a 'code' field is present
     *
     * AND:   a 'message' field is present
     *
     * THEN:  the correct error should be generated
     */
    func test_WhenJudoDictionaryContainsMessage_ParseCorrectError() {

        let sampleResponseFormat: [String: Any] = [
            "code":404,
            "message": "Page not found!"
        ]

        let error = JPError.init(from: sampleResponseFormat)
        XCTAssertEqual(error.code, 404)
        XCTAssertEqual(error.localizedDescription, "Page not found!")
    }

    /*
     * GIVEN: the JPError is initialized from an NSDictionary
     *
     * WHEN:  a 'code' field is present
     *
     * AND:   a 'message' field is not present
     *
     * THEN:  the correct error should be generated
     */
    func test_WhenJudoDictionaryDoesNotContainsMessage_ParseCorrectError() {

        let sampleResponseFormat: [String: Any] = [
            "code":404,
            "sample": "Page not found!!"
        ]

        let error = JPError.init(from: sampleResponseFormat)
        XCTAssertEqual(error.code, 404)
        XCTAssertEqual(error.localizedDescription, "The request has failed with no underlying message.")
    }

    /*
     * GIVEN: the JPError is initialized from an NSDictionary
     *
     * WHEN:  a 'code' field is present
     *
     * AND:   a 'details' field is present with a 'message' parameter
     *
     * THEN:  the correct error should be generated
     */
    func test_WhenJudoDictionaryContainsDetailsWithMessage_ParseCorrectError() {

        let sampleResponseFormat: [String: Any] = [
            "code":404,
            "details": ["message": "Page not found!"]
        ]

        let error = JPError.init(from: sampleResponseFormat)
        XCTAssertEqual(error.code, 404)
        XCTAssertEqual(error.localizedDescription, "Page not found!")
    }

    /*
     * GIVEN: the JPError is initialized from an NSDictionary
     *
     * WHEN:  a 'code' field is present
     *
     * AND:   a 'details' field is present with no 'message' parameter
     *
     * THEN:  the correct error should be generated
     */
    func test_WhenJudoDictionaryContainsDetailsWithNoMessage_ParseCorrectError() {

        let sampleResponseFormat: [String: Any] = [
            "code":404,
            "details": ["sample": "Page not found!"]
        ]

        let error = JPError.init(from: sampleResponseFormat)
        XCTAssertEqual(error.code, 404)
        XCTAssertEqual(error.localizedDescription, "The request has failed with no underlying message.")
    }

    /*
     * GIVEN: the JPError is initialized from an NSDictionary
     *
     * WHEN:  a 'code' field is present
     *
     * AND:   a 'details' field is present as the first element of an array dictionary with a 'message' parameter
     *
     * THEN:  the correct error should be generated
     */
    func test_WhenJudoDictionaryContainsDetailsArrayWithMessage_ParseCorrectError() {

        let sampleResponseFormat: [String: Any] = [
            "code":404,
            "details": [
                ["message": "Page not found!"],
            ]
        ]

        let error = JPError.init(from: sampleResponseFormat)
        XCTAssertEqual(error.code, 404)
        XCTAssertEqual(error.localizedDescription, "Page not found!")
    }

    /*
     * GIVEN: the JPError is initialized from an NSDictionary
     *
     * WHEN:  a 'code' field is present
     *
     * AND:   a 'details' field is present as the first element of an array dictionary with no 'message' parameter
     *
     * THEN:  the correct error should be generated
     */
    func test_WhenJudoDictionaryContainsDetailsArrayWithNoMessage_ParseCorrectError() {

        let sampleResponseFormat: [String: Any] = [
            "code":404,
            "details": [
                ["sample": "Page not found!"],
            ]
        ]

        let error = JPError.init(from: sampleResponseFormat)
        XCTAssertEqual(error.code, 404)
        XCTAssertEqual(error.localizedDescription, "The request has failed with no underlying message.")
    }

    /*
     * GIVEN: the JPError is initialized from an NSDictionary
     *
     * WHEN:  a 'code' field is present
     *
     * AND:   a 'details' dictionary as well as a 'message' field are present
     *
     * THEN:  the 'details' dictionary message should be prioritized
     */
    func test_WhenJudoDictionaryContainsDetailsAndMessage_PrioritizeDetails() {

        let sampleResponseFormat: [String: Any] = [
            "code":404,
            "message": "Another error message!",
            "details": [
                "message": "Page not found!",
            ]
        ]

        let error = JPError.init(from: sampleResponseFormat)
        XCTAssertEqual(error.code, 404)
        XCTAssertEqual(error.localizedDescription, "Page not found!")
    }
}
