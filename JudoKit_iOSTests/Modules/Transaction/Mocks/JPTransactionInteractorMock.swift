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

import XCTest
@testable import JudoKit_iOS

enum SendTransactionTest {
    case error
    case noToken
    case validData
    case threedDSError
}

class JPTransactionInteractorMock: JPTransactionInteractor {
    var testSendTransaction: SendTransactionTest = .validData
    var type: JPTransactionType = .saveCard
    lazy var validationService = JPCardValidationService()
    var trasactionSent = false
    var completeTransaction = false
    var handle3DS = false
    
    var mode: JPCardDetailsMode = .default
    func cardDetailsMode() -> JPCardDetailsMode {
        return mode
    }
    
    func cardNetworkType() -> JPCardNetworkType {
        return .visa
    }
    
    func generatePayButtonTitle() -> String! {
        return "Pay"
    }
    
    func updateKeychain(withCardModel viewModel: JPTransactionViewModel!, andToken token: String!) {
    }
    
    func isAVSEnabled() -> Bool {
        return true
    }
    
    func transactionType() -> JPTransactionType {
        return type
    }
    
    func handleCameraPermissions(completion: ((AVAuthorizationStatus) -> Void)!) {
        
    }
    
    func getSelectableCountryNames() -> [String]! {
        return ["UK"]
    }
    
    func getConfiguredCardAddress() -> JPAddress! {
        return JPAddress()
    }
    
    func handle3DSecureTransaction(fromError error: Error!, completion: JPCompletionBlock!) {
        let jpError = JPError(domain: "Domain test", code: 123, userInfo: nil)
        completion(nil, jpError)
        handle3DS = true
    }
    
    func completeTransaction(with response: JPResponse!, error: JPError!) {
        completeTransaction = true
    }
    
    func storeError(_ error: Error!) {
        
    }
    
    func resetCardValidationResults() {
        
    }
    
    func validateCardNumberInput(_ input: String!) -> JPValidationResult! {
        return validationService.validateCardNumberInput(input, forSupportedNetworks: .visa)
    }
    
    func validateCardholderNameInput(_ input: String!) -> JPValidationResult! {
        return validationService.validateCardholderNameInput(input)
    }
    
    func validateExpiryDateInput(_ input: String!) -> JPValidationResult! {
        return validationService.validateExpiryDateInput(input)
    }
    
    func validateSecureCodeInput(_ input: String!) -> JPValidationResult! {
        return validationService.validateSecureCodeInput(input)
    }
    
    func validateCountryInput(_ input: String!) -> JPValidationResult! {
        return validationService.validateCountryInput(input)
    }
    
    func validatePostalCodeInput(_ input: String!) -> JPValidationResult! {
        return validationService.validatePostalCodeInput(input)
    }
    
    func sendTransaction(with card: JPCard!, completionHandler: JPCompletionBlock!) {
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
            let jpError = JPError.judo3DSRequest(withPayload: ["":""])
            completionHandler(nil, jpError)
            trasactionSent = true
        }
    }
    
    var dic = ["receiptId":"receiptId",
               "orderId": "orderId",
               "type":"Payment",
               "createdAt":"createdAt",
               "result":"Success",
               "message":"message",
               "redirectUrl":"redirectUrl",
               "merchantName":"merchantName",
               "appearsOnStatementAs":"appearsOnStatementAs",
               "paymentMethod":"paymentMethod",
               "judoId":"judoId",
               "merchantPaymentReference":"merchantPaymentReference",
               "consumer":["consumerReference":"consumerReference",
                           "consumerToken":"consumerToken"],
               "orderDetails":["orderId":"orderId",
                               "orderStatus":"orderStatus",
                               "orderFailureReason":"orderFailureReason",
                               "timestamp":"timestamp",
                               "amount":999],
               "cardDetails":["cardLastfour":"cardLastfour",
                              "endDate":"endDate",
                              "cardToken":"cardToken",
                              "cardNumber":"cardNumber",
                              "cardCategory":"cardCategory",
                              "cardCountry":"cardCountry",
                              "cardFunding":"cardFunding",
                              "cardScheme":"cardScheme",
                              "cardType":0]] as [String : Any]
}
