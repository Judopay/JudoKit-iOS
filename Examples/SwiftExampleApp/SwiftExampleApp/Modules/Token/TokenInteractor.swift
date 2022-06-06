//
//  ResultsInteractor.swift
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

import JudoKit_iOS

protocol TokenInteractorInput {
    func viewDidLoad()
    func didTapSaveCardButton()
    func didTapTokenPaymentButton()
    func didTapTokenPreAuthButton()
}

protocol TokenInteractorOutput: AnyObject {
    func navigateToResultsModule(with result: Result)
    func areTokenTransactionButtonsEnabled(_ isEnabled: Bool)
    func displayErrorAlert(with error: NSError)
}

class TokenInteractor: TokenInteractorInput {

    // MARK: - Variables

    private var cardToken: String?
    private let featureService: FeatureService
    weak var output: TokenInteractorOutput?

    // MARK: - Initializer

    init(with featureService: FeatureService) {
        self.featureService = featureService
    }

    // MARK: - Protocol methods

    func viewDidLoad() {
        output?.areTokenTransactionButtonsEnabled(false)
    }

    func didTapSaveCardButton() {
        featureService.invokeTransaction(with: .saveCard,
                                         completion: completion)
    }

    func didTapTokenPaymentButton() {
        featureService.invokeTokenTransaction(with: .payment,
                                              cardToken: cardToken ?? "",
                                              completion: completion)
    }

    func didTapTokenPreAuthButton() {
        featureService.invokeTokenTransaction(with: .preAuth,
                                              cardToken: cardToken ?? "",
                                              completion: completion)
    }

    // MARK: - Helpers

    private func handleError(_ error: JPError) {

        if error.code == JudoError.Judo3DSRequestError.rawValue {
            featureService.handle3DSTransaction(with: error,
                                                completion: completion)
            return
        }

        output?.displayErrorAlert(with: error)
    }

    private func handleResponse(_ response: JPResponse) {
        if response.type == .saveCard {

            guard let cardToken = response.cardDetails?.cardToken else {
                return
            }

            output?.areTokenTransactionButtonsEnabled(true)
            self.cardToken = cardToken

            return
        }

        let result = Result(from: response)
        output?.areTokenTransactionButtonsEnabled(false)
        output?.navigateToResultsModule(with: result)
    }

    // MARK: - Lazy instantiations

    private lazy var completion: JPCompletionBlock = { [weak self] response, error in
        if let error = error {
            self?.handleError(error)
            return
        }

        if let response = response {
            self?.handleResponse(response)
        }
    }
}
