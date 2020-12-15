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
    private let kContentBottomOffset: CGFloat = 100.0

    // MARK: - Variables

    var interactor: PBBAInteractorInput!
    var coordinator: Coordinator?

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        setupTargets()
        interactor.viewDidLoad()
    }

    // MARK: - Protocol methods

    func navigateToResultsModule(with result: Result) {
        coordinator?.pushTo(.results(result))
    }

    func shouldDisplayTransactionStatusElements(_ shouldDisplay: Bool) {
        contentStackView.isHidden = !shouldDisplay
    }

    // MARK: - User actions

    @objc private func didTapGetTransactionButton() {
        interactor.checkTransactionStatus()
    }

    // MARK: - Layout setup

    private func setupLayout() {
        pbbaButton.delegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(pbbaButton)

        contentStackView.addArrangedSubview(orderIDLabel)
        contentStackView.addArrangedSubview(getTransactionStatusButton)

        view.addSubview(contentStackView)
    }

    private func setupConstraints() {
        let constraints = [
            getTransactionStatusButton.widthAnchor.constraint(equalToConstant: kButtonWidth),
            getTransactionStatusButton.heightAnchor.constraint(equalToConstant: kButtonHeight),
            contentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                     constant: -kContentBottomOffset)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func setupTargets() {
        getTransactionStatusButton.addTarget(self,
                                             action: #selector(didTapGetTransactionButton),
                                             for: .touchDown)
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

    private lazy var orderIDLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        label.textColor = .systemGreen
        return label
    }()

    private lazy var getTransactionStatusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        button.setTitle("Check transaction status", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 5.0
        return button
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20.0
        return stackView
    }()
}

extension PBBAViewController: JPPBBAButtonDelegate {

    func pbbaButtonDidPress(_ sender: JPPBBAButton) {
        interactor.didTapPBBAButton()
    }
}
