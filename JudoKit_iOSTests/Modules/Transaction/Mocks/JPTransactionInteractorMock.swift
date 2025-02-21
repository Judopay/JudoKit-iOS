//
//  JPTransactionInteractorMock.swift
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

@testable import JudoKit_iOS
import XCTest

enum SendTransactionTest {
    case error
    case noToken
    case validData
    case threedDSError
}

class JPTransactionInteractorMock: JPTransactionInteractor {
    
    var mode: JPPresentationMode = .cardInfo
    var type: JPTransactionType = .saveCard
    var testSendTransaction: SendTransactionTest = .validData
    
    var transactionSent = false
    var completeTransaction = false
    
    lazy var validationService = JPCardValidationService()
    
    func presentationMode() -> JPPresentationMode {
        mode
    }
    
    func getConfiguredTheme() -> JPTheme {
        JPTheme()
    }
    
    func transactionType() -> JPTransactionType {
        type
    }
    
    func cardNetworkType() -> JPCardNetworkType {
        .visa
    }
    
    func getConfiguredCardTransactionDetails() -> JPCardTransactionDetails? {
        nil
    }
    
    func handleCameraPermissions(completion: @escaping (AVAuthorizationStatus) -> Void) {
        
    }
    
    func getFilteredCountries(bySearch searchString: String?) -> [JPCountry] {
        [JPCountry()]
    }
    
    func getConfiguredCardAddress() -> JPAddress {
        JPAddress()
    }
    
    func completeTransaction(with response: JPResponse?, error: JPError?) {
        completeTransaction = true
    }
    
    func storeError(_ error: Error) {
        
    }
    
    func resetCardValidationResults() {
        
    }
    
    func validateCardNumberInput(_ input: String) -> JPValidationResult {
        validationService.validateCardNumberInput(input, forSupportedNetworks: .visa)
    }
    
    func validateCardholderNameInput(_ input: String) -> JPValidationResult {
        validationService.validateCardholderNameInput(input)
    }
    
    func validateExpiryDateInput(_ input: String) -> JPValidationResult {
        validationService.validateExpiryDateInput(input)
    }
    
    func validateSecureCodeInput(_ input: String, trimIfTooLong trim: Bool) -> JPValidationResult {
        validationService.validateSecureCodeInput(input, trimIfTooLong: trim)
    }
    
    func validateCountryInput(_ input: String) -> JPValidationResult {
        validationService.validateCountryInput(input)
    }
    
    func validatePostalCodeInput(_ input: String) -> JPValidationResult {
        validationService.validatePostalCodeInput(input)
    }
    
    func validateBillingEmailInput(_ input: String) -> JPValidationResult {
        validationService.validateBillingEmailInput(input)
    }
    
    func validateBillingCountryInput(_ input: String) -> JPValidationResult {
        validationService.validateBillingCountryInput(input)
    }
    
    func validateBillingAdministrativeDivisionInput(_ input: String) -> JPValidationResult {
        validationService.validateBillingAdministrativeDivisionInput(input)
    }
    
    func validateBillingPhoneCodeInput(_ input: String) -> JPValidationResult {
        validationService.validateBillingPhoneCodeInput(input)
    }
    
    func validateBillingPhoneInput(_ input: String) -> JPValidationResult {
        validationService.validateBillingPhoneInput(input)
    }
    
    func validateBillingAddressLineInput(_ input: String) -> JPValidationResult {
        validationService.validateBillingAddressLineInput(input)
    }
    
    func validateBillingCity(_ input: String) -> JPValidationResult {
        validationService.validateBillingCityInput(input)
    }
    
    func validateBillingPostalCodeInput(_ input: String) -> JPValidationResult {
        validationService.validateBillingPostalCodeInput(input)
    }
    
    func sendTransaction(with details: JPCardTransactionDetails, completionHandler: @escaping JPCompletionBlock) {
        switch testSendTransaction {
        case .error:
            let jpError = JPError(domain: "Domain test", code: 123, userInfo: nil)
            completionHandler(nil, jpError)
            transactionSent = true
        case .noToken:
            let jpResponse = JPResponse()
            completionHandler(jpResponse, nil)
            transactionSent = true
        case .validData:
            let jpResponse = JPResponse()
            completionHandler(jpResponse, nil)
            transactionSent = true
        case .threedDSError:
            let jpError = JPError.threeDSRequest(withPayload: ["": ""])
            completionHandler(nil, jpError)
            transactionSent = true
        }    }
    
    func sendTokenTransaction(with details: JPCardTransactionDetails, completionHandler: @escaping JPCompletionBlock) {
        switch testSendTransaction {
        case .error:
            let jpError = JPError(domain: "Domain test", code: 123, userInfo: nil)
            completionHandler(nil, jpError)
            transactionSent = true
        case .noToken:
            let jpResponse = JPResponse()
            completionHandler(jpResponse, nil)
            transactionSent = true
        case .validData:
            let jpResponse = JPResponse()
            completionHandler(jpResponse, nil)
            transactionSent = true
        case .threedDSError:
            let jpError = JPError.threeDSRequest(withPayload: ["": ""])
            completionHandler(nil, jpError)
            transactionSent = true
        }
    }
    
    func generatePayButtonTitle() -> String {
        "Pay"
    }
    
    func configuration() -> JPConfiguration {
        JPConfiguration()
    }
    
}
