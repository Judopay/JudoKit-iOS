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
    func displayErrorAlert(with error: NSError)
    func navigateToResultsModule(with result: Result)
    func navigateToTokenModule()
}

class HomeInteractor: HomeInteractorInput {

    // MARK: - Variables

    weak var output: HomeInteractorOutput?
    private let repository: FeatureRepository
    private let service: FeatureService
    private let settings: Settings

    // MARK: - Initializers

    init(with repository: FeatureRepository, and service: FeatureService) {
        self.repository = repository
        self.service = service
        settings = Settings.standard
    }

    // MARK: - Protocol methods

    func viewDidLoad() {
        output?.configure(with: repository.features)
    }

    func didSelectFeature(with featureType: FeatureType) {
        switch featureType {
        case .payment, .preAuth, .registerCard, .checkCard, .saveCard:
            let type = transactionType(for: featureType)
            service.invokeTransaction(with: type, completion: completion)
        case .applePay, .applePreAuth:
            let mode = transactionMode(for: featureType)
            service.invokeApplePay(with: mode, completion: completion)
        case .paymentMethods, .preAuthMethods, .serverToServer:
            let mode = transactionMode(for: featureType)
            service.invokePaymentMethods(with: mode, completion: completion)
        case .payByBank:
            navigateToPayByBankModule()
        case .tokenPayments:
            output?.navigateToTokenModule()
        case .transactionDetails:
            output?.displayReceiptInputAlert()
        }
    }

    func getTransactionDetails(for receiptID: String) {
        service.getTransactionDetails(with: receiptID, and: completion)
    }

    private func transactionType(for feature: FeatureType) -> JPTransactionType {

        let featureMap: [ FeatureType: JPTransactionType ] = [
            .payment: .payment,
            .preAuth: .preAuth,
            .registerCard: .registerCard,
            .checkCard: .checkCard,
            .saveCard: .saveCard
        ]

        return featureMap[feature] ?? .payment
    }

    private func transactionMode(for feature: FeatureType) -> JPTransactionMode {

        let featureMap: [ FeatureType: JPTransactionMode ] = [
            .applePay: .payment,
            .applePreAuth: .preAuth,
            .paymentMethods: .payment,
            .preAuthMethods: .preAuth,
            .serverToServer: .serverToServer
        ]

        return featureMap[feature] ?? .payment
    }

    // MARK: - Helper methods

    private func navigateToPayByBankModule() {
        // Navigate to PBBA module
    }

    // MARK: - Lazy instantiations

    private lazy var completion: JPCompletionBlock = { [weak self] response, error in

        if let error = error {
            self?.output?.displayErrorAlert(with: error)
            return
        }

        if let response = response {
            let result = Result(from: response)
            self?.output?.navigateToResultsModule(with: result)
            return
        }
    }
}
