//
//  ApplePayViewController.swift
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

class ApplePayViewController: UIViewController {

    // MARK: - Variables

    private let kButtonTypeContentHeight: CGFloat = 1200.0
    private let kButtonStyleContentHeight: CGFloat = 500.0

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
    }

    // MARK: - User actions

    @objc private func didSwitchSegment() {
        buttonStyleStackView.isHidden = (segmentedControl.selectedSegmentIndex == 0)
        buttonTypesStackView.isHidden = (segmentedControl.selectedSegmentIndex != 0)

        let height = (segmentedControl.selectedSegmentIndex == 0)
            ? kButtonTypeContentHeight
            : kButtonStyleContentHeight

        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width - 100,
                                        height: height)
    }

    // MARK: - Layout setup

    private func setupLayout() {

        navigationItem.title = "Apple Pay Buttons"

        view.addSubview(segmentedControl)
        view.addSubview(scrollView)
        scrollView.addSubview(buttonTypesStackView)
        scrollView.addSubview(buttonStyleStackView)

        setupButtonStyles()
        setupButtonTypes()

        view.backgroundColor = .systemGroupedBackground
        buttonStyleStackView.isHidden = true
    }

    private func setupConstraints() {

        let segmentControlConstraints = [
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: 200.0),
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor,
                                                  constant: 200)
        ]

        let scrollViewConstraints = [
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor,
                                            constant: 50.0)
        ]

        NSLayoutConstraint.activate(segmentControlConstraints)
        NSLayoutConstraint.activate(scrollViewConstraints)
    }

    // MARK: - Helper methods

    private func setupButtonStyles() {
        let styles: [JPApplePayButtonStyle] = [.white, .whiteOutline, .black]
        var buttons = styles.compactMap { JPApplePayButton(type: .buy, style: $0) }

        if #available(iOS 14.0, *) {
            buttons.append(JPApplePayButton(type: .buy, style: .automatic))
        }

        buttons.forEach {
            buttonStyleStackView.addArrangedSubview($0)
            $0.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        }
        buttonStyleStackView.addArrangedSubview(UIView())
    }

    private func setupButtonTypes() {
        let types: [JPApplePayButtonType] = [.plain, .buy, .setUp, .inStore, .donate]
        var buttons = types.compactMap { JPApplePayButton(type: $0, style: .black) }

        if #available(iOS 12.0, *) {
            let ios12Types: [JPApplePayButtonType] = [.checkout, .book, .subscribe]
            let ios12Buttons = ios12Types.compactMap { JPApplePayButton(type: $0, style: .black) }
            buttons.append(contentsOf: ios12Buttons)
        }

        if #available(iOS 14.0, *) {
            let ios14Types: [JPApplePayButtonType] = [.reload, .addMoney, .topUp, .order,
                                                      .rent, .support, .contribute, .tip]

            let ios14Buttons = ios14Types.compactMap { JPApplePayButton(type: $0, style: .black) }
            buttons.append(contentsOf: ios14Buttons)
        }

        buttons.forEach {
            buttonTypesStackView.addArrangedSubview($0)
            $0.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        }
        buttonTypesStackView.addArrangedSubview(UIView())
    }

    // MARK: - Lazy instantiations

    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.translatesAutoresizingMaskIntoConstraints = false

        control.insertSegment(withTitle: "Button Types",
                              at: 0,
                              animated: true)

        control.insertSegment(withTitle: "Button Styles",
                              at: 1,
                              animated: true)

        control.addTarget(self,
                          action: #selector(didSwitchSegment),
                          for: .valueChanged)

        return control
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width - 100,
                                        height: kButtonTypeContentHeight)
        return scrollView
    }()

    private lazy var buttonStyleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.frame = CGRect(x: 50, y: 0,
                                 width: UIScreen.main.bounds.size.width - 100,
                                 height: kButtonStyleContentHeight)
        stackView.axis = .vertical
        stackView.spacing = 20.0
        return stackView
    }()

    private lazy var buttonTypesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.frame = CGRect(x: 50, y: 0,
                                 width: UIScreen.main.bounds.size.width - 100,
                                 height: kButtonTypeContentHeight)
        stackView.axis = .vertical
        stackView.spacing = 20.0
        return stackView
    }()
}
