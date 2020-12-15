//
//  PBBAInteractor.swift
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

protocol PBBAInteractorInput {
    func viewDidLoad()
    func didTapPBBAButton()
    func checkTransactionStatus()
}

protocol PBBAInteractorOutput: class {
    func displayErrorAlert(with error: NSError)
    func shouldDisplayTransactionStatusElements(_ shouldDisplay: Bool)
    func navigateToResultsModule(with result: Result)
}

class PBBAInteractor: PBBAInteractorInput {

    // MARK: - Variables

    weak var output: PBBAInteractorOutput?
    private let featureService: FeatureService
    private var orderID: String?

    // MARK: - Initializers

    init(with service: FeatureService) {
        featureService = service
    }

    // MARK: - Protocol methods

    func viewDidLoad() {
        output?.shouldDisplayTransactionStatusElements(false)
    }

    func didTapPBBAButton() {
        featureService.invokePBBATransaction(with: nil,
                                             completion: completion)
    }

    func checkTransactionStatus() {
        guard let orderID = orderID else { return }
        featureService.checkTransactionStatus(for: orderID,
                                              completion: completion)
    }

    // MARK: - Lazy instantiations

    private lazy var completion: JPCompletionBlock = { [weak self] response, error in

        if let error = error {
            self?.output?.displayErrorAlert(with: error)
            return
        }

        guard let response = response else {
            self?.output?.displayErrorAlert(with: JPError.judoRequestFailedError())
            return
        }

        if response.orderDetails?.orderStatus != nil {
            let result = Result(from: response)
            self?.output?.navigateToResultsModule(with: result)
            return
        }

        self?.output?.shouldDisplayTransactionStatusElements(true)
        self?.orderID = response.orderDetails?.orderId
    }
}
