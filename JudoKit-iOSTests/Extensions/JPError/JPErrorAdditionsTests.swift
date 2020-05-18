//
//  JPErrorAdditionsTests.swift
//  JudoKit-iOSTests
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
     * GIVEN: when initialize JPError (child of NSError)
     *
     * THEN: should return right description(localizaed), domain and type
     */
    
    func test_judoRequestFailedError() {
        let error = JPError.judoRequestFailedError()
        XCTAssertEqual(error.localizedDescription, "Sorry, we're currently unable to process this request.")
    }
    
    func test_judoJSONSerializationFailedWithError() {
        let testError = NSError(domain: "test", code: 400, userInfo: nil)
        let error = JPError.judoJSONSerializationFailedWithError(testError)
        let judoErrorJSONSerializationFailed = Int(JudoError(rawValue: 1)!.rawValue)
        XCTAssertEqual(error.code, judoErrorJSONSerializationFailed)
    }
    
    func test_judoJudoIdMissingError() {
        let error = JPError.judoJudoIdMissingError()
        let judoErrorJudoIdMissing = Int(JudoError(rawValue: 2)!.rawValue)
        XCTAssertEqual(error.code, judoErrorJudoIdMissing)
    }
    
    func test_judoAmountMissingError() {
        let error = JPError.judoAmountMissingError()
        XCTAssertEqual(error.localizedFailureReason, "The amount has not been set for a transaction that requires it (custom UI)")
    }
    
    func test_judoReferenceMissingError() {
        let error = JPError.judoReferenceMissingError()
        XCTAssertEqual(error.localizedFailureReason, "The reference has not been set for a transaction that requires it (custom UI)")
    }
    
    func test_judoTokenMissingError() {
        let error = JPError.judoTokenMissingError()
        XCTAssertEqual(error.localizedFailureReason, "The card token could not be retrieved from the response")
    }
    
    func test_judoDuplicateTransactionError() {
        let error = JPError.judoDuplicateTransactionError()
        let judoErrorJudoIdMissing = Int(JudoError(rawValue: 7)!.rawValue)
        XCTAssertEqual(error.code, judoErrorJudoIdMissing)
    }
    
    func test_judo3DSRequestFailedErrorWithUnderlyingError() {
        let testError = NSError(domain: "test", code: 400, userInfo: nil)
        let error = JPError.judo3DSRequestFailedError(withUnderlyingError: testError)
        let errorWithUnderlyingError = Int(JudoError(rawValue: 11)!.rawValue)
        XCTAssertEqual(error.code, errorWithUnderlyingError)
    }
    
    func test_judoUserDidCancelError() {
        let error = JPError.judoUserDidCancelError()
        XCTAssertEqual(error.localizedFailureReason, "Received when user cancels the payment journey")
    }
    
    func test_judoParameterError() {
        let error = JPError.judoParameterError()
        let parameterError = Int(JudoError(rawValue: 14)!.rawValue)
        XCTAssertEqual(error.code, parameterError)
        XCTAssertEqual(error.localizedDescription, "Sorry, we're currently unable to process this request.")
    }
    
    func test_judoInternetConnectionError() {
        let error = JPError.judoInternetConnectionError()
        XCTAssertEqual(error.localizedFailureReason, "Please check your internet connection and try again.")
    }
    
    func test_judoJPApplePayConfigurationError() {
        let error = JPError.judoJPApplePayConfigurationError()
        let JudoErrorJudoIdMissing = Int(JudoError(rawValue: 16)!.rawValue)
        XCTAssertEqual(error.code, JudoErrorJudoIdMissing)
    }
    
    func test_judoResponseParseError() {
        let error = JPError.judoResponseParseError()
        XCTAssertEqual(error.localizedFailureReason, "An error with a response from the backend API")
        XCTAssertEqual(error.localizedDescription, "Sorry, we're currently unable to process this request.")
    }
    
    func test_judoMissingChecksumError() {
        let error = JPError.judoMissingChecksumError()
        XCTAssertEqual(error.localizedFailureReason, "No checksum parameter present in iDEAL redirect URL")
        XCTAssertEqual(error.localizedDescription, "No checksum parameter present in iDEAL redirect URL")
    }
    
    func test_judoRequestTimeoutError() {
        let error = JPError.judoRequestTimeoutError()
        let timeoutError = Int(JudoError(rawValue: 0)!.rawValue)
        XCTAssertEqual(error.code, timeoutError)
    }
    
    func test_judoInvalidCardNumberError() {
        let error = JPError.judoInvalidCardNumberError()
        let cardNumberError = Int(JudoError(rawValue: 17)!.rawValue)
        XCTAssertEqual(error.code, cardNumberError)
    }
    
    func test_judoUnsupportedCardNetwork() {
        let error = JPError.judoUnsupportedCardNetwork(.AMEX)
        XCTAssertEqual(error.localizedDescription, "AmEx is not supported")
    }
    
    func test_judoJailbrokenDeviceDisallowedError() {
        let error = JPError.judoJailbrokenDeviceDisallowedError()
        XCTAssertEqual(error.localizedFailureReason, "The device the code is currently running is jailbroken. Jailbroken devices are not allowed when instantiating a new Judo session")
    }
    
    func test_judoInputMismatchErrorWithMessage() {
        let error = JPError.judoInputMismatchError(withMessage: "Test error")
        XCTAssertEqual(error.localizedDescription, "Test error")
    }
    
    func test_judoErrorFromTransactionData() {
        let data = JPTransactionData()
        data.rawData = ["test": "testData"]
        let errorUserInfo = (JPError.judoError(from: data).userInfo)["test"] as! String
        XCTAssertEqual(errorUserInfo, "testData")
    }
    
    func test_judoErrorFromDictionary() {
        let error = JPError.judoError(from: ["test": "testData"])
        let errorUserInfo = error.userInfo["test"] as! String
        XCTAssertEqual(errorUserInfo, "testData")
    }
    
    func test_judoErrorFromError() {
        let testError = NSError(domain: "test", code: 400, userInfo: nil)
        let error = JPError.judoError(fromError: testError)
        let errorUserInfo = error.userInfo["NSUnderlyingError"] as! NSError
        XCTAssertEqual(testError, errorUserInfo)
    }
    
    func test_judo3DSRequestWithPayload() {
        let error = JPError.judo3DSRequest(withPayload: ["test": "testData"])
        let errorUserInfo = error.userInfo["test"] as! String
        XCTAssertEqual(errorUserInfo, "testData")
    }
    
    func test_judoInvalidIDEALCurrencyError() {
        let error = JPError.judoInvalidIDEALCurrencyError()
        XCTAssertEqual(error.localizedDescription, "Cannot make iDEAL transactions with currencies different than EUR")
    }
    
    func test_judoApplePayNotSupportedError() {
        let error = JPError.judoApplePayNotSupportedError()
        XCTAssertEqual(error.localizedDescription, "Apple Pay is not supported on your device")
    }
    
    func test_judoSiteIDMissingError() {
        let error = JPError.judoSiteIDMissingError()
        XCTAssertEqual(error.localizedDescription, "Site ID is missing")
    }
}
