//
//  TokenViewController.swift
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

class TokenViewController: UIViewController, TokenInteractorOutput {

    // MARK: - Constants
    
    private let kButtonHeight: CGFloat = 50.0
    private let kHorizontalOffset: CGFloat = 20.0
    
    // MARK: - Variables

    var interactor: TokenInteractorInput!
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

    func areTokenTransactionButtonsEnabled(_ isEnabled: Bool) {
        tokenPaymentButton.backgroundColor = isEnabled ? .black : .gray
        tokenPreAuthButton.backgroundColor = isEnabled ? .black : .gray

        tokenPaymentButton.isEnabled = isEnabled
        tokenPreAuthButton.isEnabled = isEnabled
    }

    func navigateToResultsModule(with result: Result) {
        coordinator?.pushTo(.results(result))
    }

    // MARK: - User actions

    @objc private func didTapSaveCardButton() {
        interactor.didTapSaveCardButton()
    }

    @objc private func didTapTokenPaymentsButton() {
        interactor.didTapTokenPaymentButton()
    }

    @objc private func didTapTokenPreAuthButton() {
        interactor.didTapTokenPreAuthButton()
    }

    // MARK: - Layout setup

    private func setupLayout() {
        view.backgroundColor = .white

        tokenButtonsStackView.addArrangedSubview(tokenPaymentButton)
        tokenButtonsStackView.addArrangedSubview(tokenPreAuthButton)

        contentStackView.addArrangedSubview(saveCardButton)
        contentStackView.addArrangedSubview(tokenButtonsStackView)

        view.addSubview(contentStackView)
    }

    private func setupConstraints() {

        let constraints = [
            saveCardButton.heightAnchor.constraint(equalToConstant: kButtonHeight),
            tokenPaymentButton.heightAnchor.constraint(equalToConstant: kButtonHeight),
            tokenPreAuthButton.heightAnchor.constraint(equalToConstant: kButtonHeight),
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: kHorizontalOffset),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -kHorizontalOffset)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func setupTargets() {
        saveCardButton.addTarget(self,
                                 action: #selector(didTapSaveCardButton),
                                 for: .touchDown)

        tokenPaymentButton.addTarget(self,
                                    action: #selector(didTapTokenPaymentsButton),
                                    for: .touchDown)

        tokenPreAuthButton.addTarget(self,
                                     action: #selector(didTapTokenPreAuthButton),
                                     for: .touchDown)
    }

    // MARK: - Lazy instantiations

    private let tokenButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 50
        return stackView
    }()

    private let saveCardButton: UIButton = {
        return button(named: "Save Card")
    }()

    private let tokenPaymentButton: UIButton = {
        return button(named: "Token Payment")
    }()

    private let tokenPreAuthButton: UIButton = {
        return button(named: "Token PreAuth")
    }()

    private static func button(named name: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle(name, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        button.layer.cornerRadius = 10.0
        return button
    }

}
