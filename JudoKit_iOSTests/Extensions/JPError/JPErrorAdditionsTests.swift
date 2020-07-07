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
        let error = JPError.judoRequestFailedError()
        XCTAssertEqual(error.localizedDescription, "Sorry, we're currently unable to process this request.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoJSONSerializationFailedWithError initializer
     *
     * THEN:  it should set the correct error code
     */
    func test_WhenJudoJSONSerializationFailedWithError_SetCorrectErrorCode() {
        let testError = NSError(domain: "test", code: 400, userInfo: nil)
        let error = JPError.judoJSONSerializationFailedWithError(testError)
        let judoErrorJSONSerializationFailed = Int(JudoError(rawValue: 1)!.rawValue)
        XCTAssertEqual(error.code, judoErrorJSONSerializationFailed)
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoJudoIdMissingError initializer
     *
     * THEN:  it should set the correct error code
     */
    func test_WhenJudoJudoIdMissingError_SetCorrectErrorCode() {
        let error = JPError.judoJudoIdMissingError()
        let judoErrorJudoIdMissing = Int(JudoError(rawValue: 2)!.rawValue)
        XCTAssertEqual(error.code, judoErrorJudoIdMissing)
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoAmountMissingError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoAmountMissingError_SetCorrectLocalizedDescription() {
        let error = JPError.judoAmountMissingError()
        XCTAssertEqual(error.localizedFailureReason, "The amount has not been set for a transaction that requires it (custom UI)")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoReferenceMissingError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoReferenceMissingError_SetCorrectLocalizedDescription() {
        let error = JPError.judoReferenceMissingError()
        XCTAssertEqual(error.localizedFailureReason, "The reference has not been set for a transaction that requires it (custom UI)")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoTokenMissingError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoTokenMissingError_SetCorrectLocalizedDescription() {
        let error = JPError.judoTokenMissingError()
        XCTAssertEqual(error.localizedFailureReason, "The card token could not be retrieved from the response")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoDuplicateTransactionError initializer
     *
     * THEN:  it should set the correct error code
     */
    func test_WhenJudoDuplicateTransactionError_SetCorrectErrorCode() {
        let error = JPError.judoDuplicateTransactionError()
        let judoErrorJudoIdMissing = Int(JudoError(rawValue: 7)!.rawValue)
        XCTAssertEqual(error.code, judoErrorJudoIdMissing)
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judo3DSRequestFailedError initializer
     *
     * THEN:  it should set the correct error code
     */
    func test_WhenJudo3DSRequestFailedError_SetCorrectErrorCode() {
        let testError = NSError(domain: "test", code: 400, userInfo: nil)
        let error = JPError.judo3DSRequestFailedError(withUnderlyingError: testError)
        let errorWithUnderlyingError = Int(JudoError(rawValue: 11)!.rawValue)
        XCTAssertEqual(error.code, errorWithUnderlyingError)
        XCTAssertEqual(error.userInfo.count, 4)
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoUserDidCancelError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoUserDidCancelError_SetCorrectLocalizedDescription() {
        let error = JPError.judoUserDidCancelError()
        XCTAssertEqual(error.localizedFailureReason, "Received when user cancels the payment journey")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoParameterError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoParameterError_SetCorrectLocalizedDescription() {
        let error = JPError.judoParameterError()
        let parameterError = Int(JudoError(rawValue: 14)!.rawValue)
        XCTAssertEqual(error.code, parameterError)
        XCTAssertEqual(error.localizedDescription, "Sorry, we're currently unable to process this request.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoInternetConnectionError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoInternetConnectionError_SetCorrectLocalizedDescription() {
        let error = JPError.judoInternetConnectionError()
        XCTAssertEqual(error.localizedFailureReason, "Please check your internet connection and try again.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoJPApplePayConfigurationError initializer
     *
     * THEN:  it should set the correct error code
     */
    func test_WhenJudoInputMismatchError_SetCorrectErrorCode() {
        let error = JPError.judoJPApplePayConfigurationError()
        let JudoErrorApplePayConfiguration = Int(JudoError(rawValue: 16)!.rawValue)
        XCTAssertEqual(error.code, JudoErrorApplePayConfiguration)
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoResponseParseError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoResponseParseError_SetCorrectLocalizedDescription() {
        let error = JPError.judoResponseParseError()
        XCTAssertEqual(error.localizedFailureReason, "An error with a response from the backend API")
        XCTAssertEqual(error.localizedDescription, "Sorry, we're currently unable to process this request.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoMissingChecksumError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoMissingChecksumError_SetCorrectLocalizedDescription() {
        let error = JPError.judoMissingChecksumError()
        XCTAssertEqual(error.localizedFailureReason, "No checksum parameter present in iDEAL redirect URL")
        XCTAssertEqual(error.localizedDescription, "No checksum parameter present in iDEAL redirect URL")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoRequestTimeoutError initializer
     *
     * THEN:  it should set the correct error code
     */
    func test_WhenJudoRequestTimeoutError_SetCorrectErrorCode() {
        let error = JPError.judoRequestTimeoutError()
        let timeoutError = Int(JudoError(rawValue: 0)!.rawValue)
        XCTAssertEqual(error.code, timeoutError)
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoInvalidCardNumberError initializer
     *
     * THEN:  it should set the correct error code
     */
    func test_WhenJudoInvalidCardNumberError_SetCorrectErrorCode() {
        let error = JPError.judoInvalidCardNumberError()
        let cardNumberError = Int(JudoError(rawValue: 17)!.rawValue)
        XCTAssertEqual(error.code, cardNumberError)
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoUnsupportedCardNetwork AMEX initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoUnsupportedCardNetwork_SetCorrectLocalizedDescription() {
        let error = JPError.judoUnsupportedCardNetwork(.AMEX)
        XCTAssertEqual(error.localizedDescription, "American Express is not supported")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoJailbrokenDeviceDisallowedError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoJailbrokenDeviceDisallowedError_SetCorrectLocalizedDescription() {
        let error = JPError.judoJailbrokenDeviceDisallowedError()
        XCTAssertEqual(error.localizedFailureReason, "The device the code is currently running is jailbroken. Jailbroken devices are not allowed when instantiating a new Judo session")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoInputMismatchError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoInputMismatchError_SetCorrectLocalizedDescription() {
        let error = JPError.judoInputMismatchError(withMessage: "Test error")
        XCTAssertEqual(error.localizedDescription, "Test error")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoInputMismatchError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoInputMismatchErrorWithNilMessage_SetCorrectLocalizedDescription() {
        let error = JPError.judoInputMismatchError(withMessage: nil)
        XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (com.judo.error error 12.)")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoInputMismatchError initializer
     *
     * THEN:  it should set the correct user info parameter
     */
    func test_WhenJudoErrorFromData_SetCorrectUserInfo() {
        let data = JPTransactionData()
        data.rawData = ["test": "testData"]
        let errorUserInfo = (JPError.judoError(from: data).userInfo)["test"] as! String
        XCTAssertEqual(errorUserInfo, "testData")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoInputMismatchError initializer
     *
     * THEN:  it should set the correct user info parameter
     */
    func test_WhenJudoErrorWithDic_SetCorrectUserInfo() {
        let error = JPError.judoError(from: ["test": "testData"])
        let errorUserInfo = error.userInfo["test"] as! String
        XCTAssertEqual(errorUserInfo, "testData")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoError initializer
     *
     * THEN:  it should set the correct user info parameter
     */
    func test_WhenJudoErrorWithError_SetCorrectUserInfo() {
        let testError = NSError(domain: "test", code: 400, userInfo: nil)
        let error = JPError.judoError(fromError: testError)
        let errorUserInfo = error.userInfo["NSUnderlyingError"] as! NSError
        XCTAssertEqual(testError, errorUserInfo)
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judo3DSRequest initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudo3DSRequest_SetCorrectLocalizedDescription() {
        let error = JPError.judo3DSRequest(withPayload: ["test": "testData"])
        let errorUserInfo = error.userInfo["test"] as! String
        XCTAssertEqual(errorUserInfo, "testData")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoInvalidIDEALCurrencyError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoInvalidIDEALCurrencyError_SetCorrectLocalizedDescription() {
        let error = JPError.judoInvalidIDEALCurrencyError()
        XCTAssertEqual(error.localizedDescription, "Cannot make iDEAL transactions with currencies different than EUR")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoApplePayNotSupportedError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoApplePayNotSupportedError_SetCorrectLocalizedDescription() {
        let error = JPError.judoApplePayNotSupportedError()
        XCTAssertEqual(error.localizedDescription, "Apple Pay is not supported on your device")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoSiteIDMissingError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoSiteIDMissingError_SetCorrectLocalizedDescription() {
        let error = JPError.judoSiteIDMissingError()
        XCTAssertEqual(error.localizedDescription, "Site ID is missing")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoInvalidPBBACurrency initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoInvalidPBBACurrency_SetCorrectLocalizedDescription() {
        let error = JPError.judoInvalidPBBACurrency()
        XCTAssertEqual(error.localizedDescription, "Cannot make PBBA transactions with currencies different than GBP")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoPBBAURLSchemeMissing initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoPBBAURLSchemeMissing_SetCorrectLocalizedDescription() {
        let error = JPError.judoPBBAURLSchemeMissing()
        XCTAssertEqual(error.localizedDescription, "Pay By Bank requires a URL Scheme to be set in order to handle navigation between apps")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoPaymentMethodMissingError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoPaymentMethodMissingError_SetCorrectLocalizedDescription() {
        let error = JPError.judoPaymentMethodMissingError()
        XCTAssertEqual(error.localizedDescription, "Sorry, we're currently unable to process this request.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judo3DSRequestFailedError initializer without UnderlyingError
     *
     * THEN:  it should set the correct error code
     */
    func test_WhenJudo3DSRequestFailedErrorWithoutUnderlyingError_SetCorrectErrorCode() {
        let error = JPError.judo3DSRequestFailedError(withUnderlyingError: nil)
        let errorWithUnderlyingError = Int(JudoError(rawValue: 11)!.rawValue)
        XCTAssertEqual(error.code, errorWithUnderlyingError)
        XCTAssertEqual(error.userInfo.count, 3)
    }
}
