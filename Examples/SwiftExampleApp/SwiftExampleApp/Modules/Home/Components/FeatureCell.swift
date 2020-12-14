//
//  FeatureCell.swift
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

class FeatureCell: UITableViewCell {

    // MARK: - Constants

    private let kContentOffset: CGFloat = 10.0
    private let kContentSpacing: CGFloat = 5.0
    private let kFontSize: CGFloat = 16.0

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
        setupConstraints()
    }

    // MARK: - View model configuration

    func configure(with viewModel: FeatureViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }

    // MARK: - Layout setup

    private func setupLayout() {
        backgroundColor = .systemBackground
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(subtitleLabel)
        addSubview(contentStackView)
    }

    private func setupConstraints() {
        let constraints = [
            contentStackView.topAnchor.constraint(equalTo: topAnchor,
                                                  constant: kContentOffset),

            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                      constant: kContentOffset),

            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                       constant: -kContentOffset),

            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                     constant: -kContentOffset)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Lazy instantiation

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = kContentSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: kFontSize, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: kFontSize)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
