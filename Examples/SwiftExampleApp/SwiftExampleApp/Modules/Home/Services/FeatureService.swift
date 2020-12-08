//
//  FeatureService.swift
//  SwiftExampleApp
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
import JudoKit_iOS

class FeatureService {
    
    // MARK: - SDK Methods
    
    func invokePayment(with completion: @escaping JPCompletionBlock) {
        invokeTransaction(with: .payment, completion: completion)
    }
    
    func invokePreAuth(with completion: @escaping JPCompletionBlock) {
        invokeTransaction(with: .preAuth, completion: completion)
    }
    
    func invokeRegisterCard(with completion: @escaping JPCompletionBlock) {
        invokeTransaction(with: .registerCard, completion: completion)
    }
    
    func invokeCheckCard(with completion: @escaping JPCompletionBlock) {
        invokeTransaction(with: .checkCard, completion: completion)
    }
    
    func invokeSaveCard(with completion: @escaping JPCompletionBlock) {
        invokeTransaction(with: .saveCard, completion: completion)
    }
    
    func invokeApplePay(with completion: @escaping JPCompletionBlock) {
        invokeApplePay(with: .payment, completion: completion)
    }
    
    func invokeApplePreAuth(with completion: @escaping JPCompletionBlock) {
        invokeApplePay(with: .preAuth, completion: completion)
    }
    
    func invokePaymentMethods(with completion: @escaping JPCompletionBlock) {
        invokePaymentMethods(with: .payment, completion: completion)
    }
    
    func invokePreAuthMethods(with completion: @escaping JPCompletionBlock) {
        invokePaymentMethods(with: .preAuth, completion: completion)
    }
    
    func invokeServerToServerMethods(with completion: @escaping JPCompletionBlock) {
        invokePaymentMethods(with: .serverToServer, completion: completion)
    }
    
    func getTransactionDetails(with receiptID: String,
                               and completion: @escaping JPCompletionBlock) {
        apiService?.fetchTransaction(withReceiptId: receiptID, completion: completion)
    }
    
    // MARK: - Helper methods
    
    private func invokeTransaction(with type: JPTransactionType,
                                   completion: @escaping JPCompletionBlock) {
        
        judoKit?.invokeTransaction(with: type,
                                   configuration: configuration,
                                   completion: completion)
    }
    
    private func invokePaymentMethods(with mode: JPTransactionMode,
                                      completion: @escaping JPCompletionBlock) {
        
        judoKit?.invokePaymentMethodScreen(with: mode,
                                           configuration: configuration,
                                           completion: completion)
    }
    
    private func invokeApplePay(with mode: JPTransactionMode,
                                completion: @escaping JPCompletionBlock) {
        
        judoKit?.invokeApplePay(with: mode,
                                configuration: configuration,
                                completion: completion)
    }
    
    // MARK: - Lazy instantiation
    
    private lazy var judoKit: JudoKit? = {
        let authorization: JPAuthorization = JPBasicAuthorization(token: "", andSecret: "")
        let judoKit = JudoKit(authorization: authorization)
        judoKit?.isSandboxed = true
        return judoKit
    }()
    
    private lazy var apiService: JPApiService? = {
        let authorization: JPAuthorization = JPBasicAuthorization(token: "", andSecret: "")
        let apiService = JPApiService(authorization: authorization, isSandboxed: true)
        return apiService
    }()
    
    private lazy var configuration: JPConfiguration = {
        let amount = JPAmount(amount: "0.01", currency: "GBP")
        let reference = JPReference(consumerReference: "consumerReference")
        
        let summaryItem = JPPaymentSummaryItem(label: "Tim Cook", amount: 99.99)
        let applePayConfiguration = JPApplePayConfiguration(merchantId: "123456",
                                                            currency: "GBP",
                                                            countryCode: "GB", paymentSummaryItems: [summaryItem])
        
        let configuration = JPConfiguration(judoID: "123456",
                                            amount: amount,
                                            reference: reference)
        
        configuration.applePayConfiguration = applePayConfiguration
        
        return configuration
    }()
}
