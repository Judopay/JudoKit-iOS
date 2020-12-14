//
//  PBBAViewController.swift
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

import UIKit
import JudoKit_iOS

class PBBAViewController: UIViewController, PBBAInteractorOutput {

    // MARK: - Constants

    private let kButtonHeight: CGFloat = 50.0
    private let kButtonWidth: CGFloat = 310.0

    // MARK: - Variables

    var interactor: PBBAInteractorInput!
    var coordinator: Coordinator?

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    // MARK: - Protocol methods

    func navigateToResultsModule(with result: Result) {
        coordinator?.pushTo(.results(result))
    }

    // MARK: - Layout setup

    private func setupLayout() {
        pbbaButton.delegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(pbbaButton)
    }

    // MARK: - Lazy instantiations

    private lazy var pbbaButton: JPPBBAButton = {
        let screenSize = UIScreen.main.bounds.size
        let originX = screenSize.width / 2 - kButtonWidth / 2
        let originY = screenSize.height / 2 - kButtonHeight / 2

        let frame = CGRect(x: originX,
                           y: originY,
                           width: kButtonWidth,
                           height: kButtonHeight)

        return JPPBBAButton(frame: frame)
    }()
}

extension PBBAViewController: JPPBBAButtonDelegate {

    func pbbaButtonDidPress(_ sender: JPPBBAButton) {
        interactor.didTapPBBAButton()
    }
}
