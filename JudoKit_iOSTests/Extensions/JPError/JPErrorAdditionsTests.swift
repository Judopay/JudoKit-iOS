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
     * GIVEN: when initialize JPError (RequestFailed type)
     *
     * WHEN: error object is populated with fields
     *
     * THEN: should return right description(localizaed)
     */
    func test_JudoRequestFailedError_WhenIsCreated_ShouldContainRightLocalization() {
        let error = JPError.judoRequestFailedError()
        XCTAssertEqual(error.localizedDescription, "Sorry, we're currently unable to process this request.")
    }
    
    /*
     * GIVEN: when initialize JPError (JSON Serialization type)
     *
     * WHEN: it is populated by JudoError with raw value 1
     *
     * THEN: should return right error code (JSONSerializationFailed)
     */
    func test_judoJSONSerializationFailedWithError() {
        let testError = NSError(domain: "test", code: 400, userInfo: nil)
        let error = JPError.judoJSONSerializationFailedWithError(testError)
        let judoErrorJSONSerializationFailed = Int(JudoError(rawValue: 1)!.rawValue)
        XCTAssertEqual(error.code, judoErrorJSONSerializationFailed)
    }
    
    /*
     * GIVEN: when initialize JPError (JudoId Missing type)
     *
     * WHEN: it is populated by JudoError with raw value 2
     *
     * THEN: should return right error code (ErrorJudoIdMissing)
     */
    func test_judoJudoIdMissingError() {
        let error = JPError.judoJudoIdMissingError()
        let judoErrorJudoIdMissing = Int(JudoError(rawValue: 2)!.rawValue)
        XCTAssertEqual(error.code, judoErrorJudoIdMissing)
    }
    
    /*
     * GIVEN: when initialize JPError (Amount Missing type)
     *
     * WHEN: it is populated with all fields automatically
     *
     * THEN: should return right localizedFailureReason
     */
    func test_judoAmountMissingError() {
        let error = JPError.judoAmountMissingError()
        XCTAssertEqual(error.localizedFailureReason, "The amount has not been set for a transaction that requires it (custom UI)")
    }
    
    /*
     * GIVEN: when initialize JPError (Reference Missing type)
     *
     * WHEN: it is populated with all fields automatically
     *
     * THEN: should return right localizedFailureReason
     */
    func test_judoReferenceMissingError() {
        let error = JPError.judoReferenceMissingError()
        XCTAssertEqual(error.localizedFailureReason, "The reference has not been set for a transaction that requires it (custom UI)")
    }
    
    /*
     * GIVEN: when initialize JPError (Token Missing type)
     *
     * WHEN: it is populated with all fields automatically
     *
     * THEN: should return right localizedFailureReason
     */
    func test_judoTokenMissingError() {
        let error = JPError.judoTokenMissingError()
        XCTAssertEqual(error.localizedFailureReason, "The card token could not be retrieved from the response")
    }
    
    /*
     * GIVEN: when initialize JPError (Duplicate Transaction type)
     *
     * WHEN: it is populated with all fields automatically
     *
     * THEN: should return right error.code, rawVaule 7 (ErrorJudoIdMissing)
     */
    func test_judoDuplicateTransactionError() {
        let error = JPError.judoDuplicateTransactionError()
        let judoErrorJudoIdMissing = Int(JudoError(rawValue: 7)!.rawValue)
        XCTAssertEqual(error.code, judoErrorJudoIdMissing)
    }
    
    /*
     * GIVEN: when initialize JPError (3DS Request Failed type)
     *
     * WHEN: it is populated with all fields automatically
     *
     * THEN: should return right error.code, rawVaule 11 (UnderlyingError)
     */
    func test_judo3DSRequestFailedErrorWithUnderlyingError() {
        let testError = NSError(domain: "test", code: 400, userInfo: nil)
        let error = JPError.judo3DSRequestFailedError(withUnderlyingError: testError)
        let errorWithUnderlyingError = Int(JudoError(rawValue: 11)!.rawValue)
        XCTAssertEqual(error.code, errorWithUnderlyingError)
    }
    
    /*
     * GIVEN: when initialize JPError (User Did Cancel type)
     *
     * WHEN: it is populated with all fields automatically
     *
     * THEN: should return right localizedFailureReason
     */
    func test_judoUserDidCancelError() {
        let error = JPError.judoUserDidCancelError()
        XCTAssertEqual(error.localizedFailureReason, "Received when user cancels the payment journey")
    }
    
    /*
     * GIVEN: when initialize JPError (Parameter error type)
     *
     * WHEN: it is populated with all fields automatically
     *
     * THEN: should return right error.code, rawVaule 14 (parameterError), should return right localizedFailureReason
     */
    func test_judoParameterError() {
        let error = JPError.judoParameterError()
        let parameterError = Int(JudoError(rawValue: 14)!.rawValue)
        XCTAssertEqual(error.code, parameterError)
        XCTAssertEqual(error.localizedDescription, "Sorry, we're currently unable to process this request.")
    }
    
    /*
     * GIVEN: when initialize JPError (Internet Connection type)
     *
     * WHEN: it is populated with all fields automatically
     *
     * THEN: should return right localizedFailureReason
     */
    func test_judoInternetConnectionError() {
        let error = JPError.judoInternetConnectionError()
        XCTAssertEqual(error.localizedFailureReason, "Please check your internet connection and try again.")
    }
    
    /*
     * GIVEN: when initialize JPError (JPApple Pay Configuration type)
     *
     * WHEN: it is populated with all fields automatically
     *
     * THEN: should return right error.code, rawVaule 16 (JudoErrorApplePayConfiguration)
     */
    func test_judoJPApplePayConfigurationError() {
        let error = JPError.judoJPApplePayConfigurationError()
        let JudoErrorApplePayConfiguration = Int(JudoError(rawValue: 16)!.rawValue)
        XCTAssertEqual(error.code, JudoErrorApplePayConfiguration)
    }
    
    /*
     * GIVEN: when initialize JPError (Response Parse type)
     *
     * WHEN: it is populated with all fields automatically
     *
     * THEN: should return right localizedFailureReason and localizedDescription
     */
    func test_judoResponseParseError() {
        let error = JPError.judoResponseParseError()
        XCTAssertEqual(error.localizedFailureReason, "An error with a response from the backend API")
        XCTAssertEqual(error.localizedDescription, "Sorry, we're currently unable to process this request.")
    }
    
    /*
     * GIVEN: when initialize JPError (Missing Checksum type)
     *
     * WHEN: it is populated with all fields automatically
     *
     * THEN: should return right localizedFailureReason and localizedDescription
     */
    func test_judoMissingChecksumError() {
        let error = JPError.judoMissingChecksumError()
        XCTAssertEqual(error.localizedFailureReason, "No checksum parameter present in iDEAL redirect URL")
        XCTAssertEqual(error.localizedDescription, "No checksum parameter present in iDEAL redirect URL")
    }
    
    /*
     * GIVEN: when initialize JPError (Request Timeout type)
     *
     * WHEN: it is populated with all fields automatically
     *
     * THEN: should return right error.code, rawVaule 0 (JudoError)
     */
    func test_judoRequestTimeoutError() {
        let error = JPError.judoRequestTimeoutError()
        let timeoutError = Int(JudoError(rawValue: 0)!.rawValue)
        XCTAssertEqual(error.code, timeoutError)
    }
    
    /*
     * GIVEN: when initialize JPError (Invalid Card Number type)
     *
     * WHEN: it is populated with all fields automatically
     *
     * THEN: should return right error.code, rawVaule 17 (cardNumberError)
     */
    func test_judoInvalidCardNumberError() {
        let error = JPError.judoInvalidCardNumberError()
        let cardNumberError = Int(JudoError(rawValue: 17)!.rawValue)
        XCTAssertEqual(error.code, cardNumberError)
    }
    
    /*
     * GIVEN: when initialize JPError (Unsupported Card Network type)
     *
     * WHEN: it is populated with all fields automatically
     *
     * THEN: should return right localizedDescription
     */
    func test_judoUnsupportedCardNetwork() {
        let error = JPError.judoUnsupportedCardNetwork(.AMEX)
        XCTAssertEqual(error.localizedDescription, "AmEx is not supported")
    }
    
    /*
     * GIVEN: when initialize JPError (Jailbroken Device Disallowed type)
     *
     * WHEN: it is populated with all fields automatically
     *
     * THEN: should return right localizedFailureReason
     */
    func test_judoJailbrokenDeviceDisallowedError() {
        let error = JPError.judoJailbrokenDeviceDisallowedError()
        XCTAssertEqual(error.localizedFailureReason, "The device the code is currently running is jailbroken. Jailbroken devices are not allowed when instantiating a new Judo session")
    }
    
    /*
     * GIVEN: when initialize JPError (Input Mismatch type)
     *
     * WHEN: it is populated with all fields automatically and custom message: "Test error"
     *
     * THEN: should return right localizedDescription: Test error
     */
    func test_judoInputMismatchErrorWithMessage() {
        let error = JPError.judoInputMismatchError(withMessage: "Test error")
        XCTAssertEqual(error.localizedDescription, "Test error")
    }
    
    /*
     * GIVEN: when initialize JPError from JPTransactionData
     *
     * WHEN: it is populated with custom dictionary in raw data
     *
     * THEN: should return right data in userInfo
     */
    func test_judoErrorFromTransactionData() {
        let data = JPTransactionData()
        data.rawData = ["test": "testData"]
        let errorUserInfo = (JPError.judoError(from: data).userInfo)["test"] as! String
        XCTAssertEqual(errorUserInfo, "testData")
    }
    
    /*
     * GIVEN: when initialize JPError from dictionary
     *
     * WHEN: it is populated with custom dictionary
     *
     * THEN: should return right data in userInfo
     */
    func test_judoErrorFromDictionary() {
        let error = JPError.judoError(from: ["test": "testData"])
        let errorUserInfo = error.userInfo["test"] as! String
        XCTAssertEqual(errorUserInfo, "testData")
    }
    
    /*
     * GIVEN: when initialize JPError from dictionary
     *
     * WHEN: it is populated with NSUnderlyingError keyword
     *
     * THEN: should return right data in userInfo
     */
    func test_judoErrorFromError() {
        let testError = NSError(domain: "test", code: 400, userInfo: nil)
        let error = JPError.judoError(fromError: testError)
        let errorUserInfo = error.userInfo["NSUnderlyingError"] as! NSError
        XCTAssertEqual(testError, errorUserInfo)
    }
    
    /*
     * GIVEN: when initialize JPError 3DSRequest with payload
     *
     * WHEN: it is populated with custom payload
     *
     * THEN: should return right data in userInfo
     */
    func test_judo3DSRequestWithPayload() {
        let error = JPError.judo3DSRequest(withPayload: ["test": "testData"])
        let errorUserInfo = error.userInfo["test"] as! String
        XCTAssertEqual(errorUserInfo, "testData")
    }
    
    /*
     * GIVEN: when initialize JPError InvalidIDEALCurrency
     *
     * WHEN: it is populated error fields
     *
     * THEN: should return right localizedDescription
     */
    func test_judoInvalidIDEALCurrencyError() {
        let error = JPError.judoInvalidIDEALCurrencyError()
        XCTAssertEqual(error.localizedDescription, "Cannot make iDEAL transactions with currencies different than EUR")
    }
    
    /*
     * GIVEN: when initialize JPError ApplePayNotSupported
     *
     * WHEN: it is populated error fields
     *
     * THEN: should return right localizedDescription
     */
    func test_judoApplePayNotSupportedError() {
        let error = JPError.judoApplePayNotSupportedError()
        XCTAssertEqual(error.localizedDescription, "Apple Pay is not supported on your device")
    }
    
    /*
     * GIVEN: when initialize JPError ApplePayNotSupported
     *
     * WHEN: it is populated error fields
     *
     * THEN: should return right localizedDescription
     */
    func test_judoSiteIDMissingError() {
        let error = JPError.judoSiteIDMissingError()
        XCTAssertEqual(error.localizedDescription, "Site ID is missing")
    }
}
