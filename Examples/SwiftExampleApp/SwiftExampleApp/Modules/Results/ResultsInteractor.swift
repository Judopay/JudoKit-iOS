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

protocol ResultsInteractorInput {
    func viewDidLoad()
}

protocol ResultsInteractorOutput: class {
    func configure(with viewModels: [ResultsViewModel])
    func setNavigationTitle(_ title: String)
}

class ResultsInteractor: ResultsInteractorInput {

    // MARK: - Variables

    weak var output: ResultsInteractorOutput?
    private let result: Result

    // MARK: - Initializers

    init(with result: Result) {
        self.result = result
    }

    // MARK: - Protocol methods

    func viewDidLoad() {
        output?.setNavigationTitle(result.title)

        let viewModels = result.items.map {
            ResultsViewModel(title: $0.title,
                             subtitle: $0.value,
                             subResult: $0.subResult)
        }

        output?.configure(with: viewModels)
    }
}
