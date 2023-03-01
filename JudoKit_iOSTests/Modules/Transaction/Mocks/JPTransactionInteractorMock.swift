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
    func configuration() -> JPConfiguration {
        JPConfiguration()
    }

    var testSendTransaction: SendTransactionTest = .validData
    var type: JPTransactionType = .saveCard
    lazy var validationService = JPCardValidationService()
    var trasactionSent = false
    var completeTransaction = false

    var mode: JPCardDetailsMode = .default
    func cardDetailsMode() -> JPCardDetailsMode {
        mode
    }

    func cardNetworkType() -> JPCardNetworkType {
        .visa
    }

    func generatePayButtonTitle() -> String {
        "Pay"
    }

    func updateKeychain(withCardModel viewModel: JPTransactionViewModel, andToken token: String) {}

    func isAVSEnabled() -> Bool {
        true
    }

    func getConfiguredTheme() -> JPTheme {
        JPTheme()
    }

    func transactionType() -> JPTransactionType {
        type
    }

    func handleCameraPermissions(completion: (AVAuthorizationStatus) -> Void) {}

    func getFilteredCountries(bySearch searchString: String?) -> [JPCountry] {
        [JPCountry()]
    }

    func getSelectableCountryNames() -> [String]! {
        ["UK"]
    }

    func getConfiguredCardAddress() -> JPAddress {
        JPAddress()
    }

    func completeTransaction(with response: JPResponse?, error: JPError?) {
        completeTransaction = true
    }

    func storeError(_ error: Error) {}

    func resetCardValidationResults() {}

    func validateCardNumberInput(_ input: String) -> JPValidationResult {
        validationService.validateCardNumberInput(input, forSupportedNetworks: .visa)
    }

    func validateCardholderEmailInput(_ input: String) -> JPValidationResult {
        validationService.validateCardholderEmailInput(input)
    }

    func validateCardholderPhoneCodeInput(_ input: String) -> JPValidationResult {
        validationService.validateCardholderPhoneCodeInput(input)
    }

    func validateCardholderPhoneInput(_ input: String) -> JPValidationResult {
        validationService.validateCardholderPhoneInput(input)
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

    func validateStateInput(_ input: String) -> JPValidationResult {
        validationService.validateStateInput(input)
    }

    func validatePostalCodeInput(_ input: String) -> JPValidationResult {
        validationService.validatePostalCodeInput(input)
    }

    func validateAddressLineInput(_ input: String) -> JPValidationResult {
        validationService.validateAddressLineInput(input)
    }

    func validateCity(_ input: String) -> JPValidationResult {
        validationService.validateCityInput(input)
    }

    func sendTransaction(with details: JPCardTransactionDetails, completionHandler: @escaping JPCompletionBlock) {
        switch testSendTransaction {
        case .error:
            let jpError = JPError(domain: "Domain test", code: 123, userInfo: nil)
            completionHandler(nil, jpError)
            trasactionSent = true
        case .noToken:
            let jpResponse = JPResponse()
            completionHandler(jpResponse, nil)
            trasactionSent = true
        case .validData:
            let jpResponse = JPResponse()
            completionHandler(jpResponse, nil)
            trasactionSent = true
        case .threedDSError:
            let jpError = JPError.threeDSRequest(withPayload: ["": ""])
            completionHandler(nil, jpError)
            trasactionSent = true
        }
    }

    var dic = ["receiptId": "receiptId",
               "orderId": "orderId",
               "type": "Payment",
               "createdAt": "createdAt",
               "result": "Success",
               "message": "message",
               "redirectUrl": "redirectUrl",
               "merchantName": "merchantName",
               "appearsOnStatementAs": "appearsOnStatementAs",
               "paymentMethod": "paymentMethod",
               "judoId": "judoId",
               "merchantPaymentReference": "merchantPaymentReference",
               "consumer": ["consumerReference": "consumerReference",
                            "consumerToken": "consumerToken"],
               "orderDetails": ["orderId": "orderId",
                                "orderStatus": "orderStatus",
                                "orderFailureReason": "orderFailureReason",
                                "timestamp": "timestamp",
                                "amount": 999],
               "cardDetails": ["cardLastfour": "cardLastfour",
                               "endDate": "endDate",
                               "cardToken": "cardToken",
                               "cardNumber": "cardNumber",
                               "cardCategory": "cardCategory",
                               "cardCountry": "cardCountry",
                               "cardFunding": "cardFunding",
                               "cardScheme": "cardScheme",
                               "cardType": 0]] as [String: Any]
}
