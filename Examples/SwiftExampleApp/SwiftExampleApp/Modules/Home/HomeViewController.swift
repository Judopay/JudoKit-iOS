//
//  HomeViewController.swift
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

class HomeViewController: UIViewController, HomeInteractorOutput {

    // MARK: - Constants

    private let kCellIdentifier = "FeatureCell"
    private let kNavigationItemTitle = "JudoPay Examples"
    private let kHeaderTitle = "FEATURES"
    private let kReceiptIDAlertTitle = "Enter your Receipt ID"
    private let kReceiptIDAlertPlaceholder = "Your Receipt ID"
    private var viewModels: [FeatureViewModel] = []

    // MARK: - Variables

    var interactor: HomeInteractorInput!
    var coordinator: Coordinator?

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        registerCells()
        interactor.viewDidLoad()
    }

    // MARK: - User actions

    @objc private func didTapSettingsButton() {
        coordinator?.pushTo(.settings)
    }

    // MARK: - View model configuration

    func configure(with viewModels: [FeatureViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }

    func displayReceiptInputAlert() {
        displayInputAlert(with: kReceiptIDAlertTitle,
                          placeholder: kReceiptIDAlertPlaceholder) { [weak self] input in
            self?.interactor.getTransactionDetails(for: input)
        }
    }

    func navigateToResultsModule(with result: Result) {
        coordinator?.pushTo(.results(result))
    }

    func navigateToTokenModule() {
        coordinator?.pushTo(.tokenTransactions)
    }

    func navigateToPBBAModule() {
        coordinator?.pushTo(.payByBankApp)
    }

    // MARK: - PBBA Deeplinking

    func handlePBBAStatus(with url: URL) {
        interactor.handlePBBAStatus(with: url)
    }

    // MARK: - Layout setup

    private func setupLayout() {
        navigationItem.title = kNavigationItemTitle
        navigationItem.rightBarButtonItem = settingsButton
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func registerCells() {
        tableView.register(FeatureCell.self, forCellReuseIdentifier: kCellIdentifier)
    }

    // MARK: - Lazy instantiations

    private lazy var settingsButton: UIBarButtonItem = {
        let settingsIcon = UIImage(named: "settings-black")
        let button = UIBarButtonItem(image: settingsIcon,
                                     style: .done,
                                     target: self,
                                     action: #selector(didTapSettingsButton))
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt
                    indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let type = viewModels[indexPath.row].type
        interactor.didSelectFeature(with: type)
    }
}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier)

        if let featureCell = cell as? FeatureCell {
            featureCell.configure(with: viewModels[indexPath.row])
        }

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return kHeaderTitle
    }
}
