//
//  HomeInteractor.swift
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

protocol HomeInteractorInput {
    func viewDidLoad()
    func didSelectFeature(with type: FeatureType)
    func getTransactionDetails(for receiptID: String)
}

protocol HomeInteractorOutput: class {
    func configure(with viewModels: [FeatureViewModel])
    func displayReceiptInputAlert()
}

class HomeInteractor: HomeInteractorInput {
    
    // MARK: - Variables
    
    weak var output: HomeInteractorOutput?
    private let repository: FeatureRepository
    private let service: FeatureService
    
    // MARK: - Initializers
    
    init(with repository: FeatureRepository, and service: FeatureService) {
        self.repository = repository
        self.service = service
    }
    
    // MARK: - Protocol methods
    
    func viewDidLoad() {
        output?.configure(with: repository.features)
    }
    
    func didSelectFeature(with type: FeatureType) {
        switch type {
        case .payment:
            service.invokePayment(with: completion)
        case .preAuth:
            service.invokePreAuth(with: completion)
        case .registerCard:
            service.invokeRegisterCard(with: completion)
        case .checkCard:
            service.invokeCheckCard(with: completion)
        case .saveCard:
            service.invokeSaveCard(with: completion)
        case .applePay:
            service.invokeApplePay(with: completion)
        case .applePreAuth:
            service.invokeApplePreAuth(with: completion)
        case .paymentMethods:
            service.invokePaymentMethods(with: completion)
        case .preAuthMethods:
            service.invokePreAuthMethods(with: completion)
        case .serverToServer:
            service.invokeServerToServerMethods(with: completion)
        case .payByBank:
            navigateToPayByBankModule()
        case .tokenPayments:
            navigateToTokenPaymentsModule()
        case .transactionDetails:
            output?.displayReceiptInputAlert()
        }
    }
    
    func getTransactionDetails(for receiptID: String) {
        service.getTransactionDetails(with: receiptID, and: completion)
    }
    
    // MARK: - Helper methods
    
    private func navigateToPayByBankModule() {
        // Navigate to PBBA module
    }
    
    private func navigateToTokenPaymentsModule() {
        // Navigate to Token Payments module
    }
    
    // MARK: - Lazy instantiations
    
    private lazy var completion: JPCompletionBlock = { response, error in
        // Handle response/error
    }
}
