//
//  JPPaymentMethodsInteractorMock.swift
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

enum PaymentError {
    case duplicateeError
    case threeDSRequest
}

class JPPaymentMethodsInteractorMock: JPPaymentMethodsInteractor {
    
    var calledTransactionPayment = false
    var paymentTransactionDetailsParam: JPStoredCardDetails?
    var paymentTransactionCSCParam: String?
    var transactionCompleteError: Error?
    var cardSelected = false
    var startApplePay = false
    var startPolling = false
    var shouldVerify = false
    var shouldAskForCardholderNameValue = false
    var cardDetailsModeValue = JPPresentationMode.cardInfo
    var transactionMode = JPTransactionMode.payment
    var shouldFailWhenProcessApplePayment = false
    var storeError = false

    var errorType: PaymentError = .duplicateeError

    func processApplePayment(completion: @escaping JPCompletionBlock) {
        startApplePay = true
        if shouldFailWhenProcessApplePayment {
            completion(nil, JPError(domain: "Domain test", code: 123, userInfo: nil))
        } else {
            completion(JPResponse(), nil)
        }
    }
    
    func shouldVerifySecurityCode() -> Bool {
        shouldVerify
    }

    func shouldAskForCardholderName() -> Bool {
        shouldAskForCardholderNameValue
    }

    func configuredTransactionMode() -> JPTransactionMode {
        transactionMode
    }
    
    func updateKeychain(with details: JPCardDetails) {
        
    }
    
    func processServer(toServerCardPayment completion: @escaping JPCompletionBlock) {
        
    }

    func completeTransaction(with response: JPResponse?, andError error: Error?) {
        transactionCompleteError = error
    }

    func storeError(_ error: Error) {
        storeError = true
    }

    func setCardAsSelectedAt(_ index: UInt) {
        JPCardStorage.sharedInstance()?.setCardAsSelectedAt(index)
    }

    func orderCards() {
        JPCardStorage.sharedInstance()?.orderCards()
    }

    func setLastUsedCardAt(_ index: UInt) {}

    func paymentTransaction(with details: JPStoredCardDetails, securityCode: String?, andCompletion completion: JPCompletionBlock? = nil) {
        calledTransactionPayment = true
        paymentTransactionDetailsParam = details
        paymentTransactionCSCParam = securityCode
        if errorType == .threeDSRequest {
            let error = JPError.threeDSRequest(withPayload: ["": ""])
            completion?(nil, error)
        }
    }

    func selectCard(at index: UInt) {
        cardSelected = true
    }

    func deleteCard(with index: UInt) {
        JPCardStorage.sharedInstance()?.deleteCard(with: index)
    }

    func setCardAsDefaultAt(_ index: Int) {}

    func getStoredCardDetails() -> [JPStoredCardDetails] {
        let cards = JPCardStorage.sharedInstance()?.fetchStoredCardDetails()
        return cards as! [JPStoredCardDetails]
    }

    func getAmount() -> JPAmount {
        let amount = JPAmount("1.0", currency: "EUR")
        return amount
    }

    func getPaymentMethods() -> [JPPaymentMethod] {
        [JPPaymentMethod.card(), JPPaymentMethod.applePay()]
    }

    func isApplePaySetUp() -> Bool {
        false
    }

    func saveMockCards() {
        let calendar = Calendar.current

        let todaysDate = Date()
        let dateInTwoMonths = calendar.date(byAdding: .month, value: 1, to: todaysDate)!
        let expiredDate = calendar.date(byAdding: .month, value: -1, to: todaysDate)!
        let notExpiredDate = calendar.date(byAdding: .month, value: 3, to: todaysDate)!

        let dateFormater = DateFormatter()
        dateFormater.dateFormat = kMonthYearDateFormat

        let expiresSoonDateAsString = dateFormater.string(from: dateInTwoMonths)
        let expiredDateAsString = dateFormater.string(from: expiredDate)
        let notExpiredDateAsString = dateFormater.string(from: notExpiredDate)

        let validCard = JPStoredCardDetails(
            lastFour: "1111",
            expiryDate: notExpiredDateAsString,
            cardNetwork: .visa,
            cardToken: "token",
            cardholderName: "Bob")!
        let expiresSoonCard = JPStoredCardDetails(
            lastFour: "1111",
            expiryDate: expiresSoonDateAsString,
            cardNetwork: .visa,
            cardToken: "token",
            cardholderName: "Bob")!
        let expirdCard = JPStoredCardDetails(lastFour: "1111", expiryDate: expiredDateAsString, cardNetwork: .visa, cardToken: "token", cardholderName: "Bob")!

        JPCardStorage.sharedInstance()?.deleteCardDetails()
        JPCardStorage.sharedInstance()?.add(validCard)
        JPCardStorage.sharedInstance()?.add(expiresSoonCard)
        JPCardStorage.sharedInstance()?.add(expirdCard)
    }
}
