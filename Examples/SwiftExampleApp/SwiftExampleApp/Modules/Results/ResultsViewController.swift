//
//  ResultsViewController.swift
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

class ResultsViewController: UIViewController, ResultsInteractorOutput {

    // MARK: - Constants

    private let kCellIdentifier = "ResultsCell"

    // MARK: - Variables

    var interactor: ResultsInteractorInput!
    var coordinator: Coordinator?
    private var viewModels: [ResultsViewModel] = []

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        registerCells()
        interactor.viewDidLoad()
    }

    // MARK: - View model configuration

    func configure(with viewModels: [ResultsViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }

    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }

    // MARK: - Layout setup

    private func setupLayout() {
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
        tableView.register(ResultsCell.self,
                           forCellReuseIdentifier: kCellIdentifier)
    }

    // MARK: - Lazy instantiations

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.accessibilityIdentifier = "ResultsView"
        return tableView
    }()
}

extension ResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let selectedModel = viewModels[indexPath.row]

        if let subResult = selectedModel.subResult {
            coordinator?.pushTo(.results(subResult))
        }
    }
}

extension ResultsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier,
                                                 for: indexPath)

        if let resultsCell = cell as? ResultsCell {
            resultsCell.configure(with: viewModels[indexPath.row])
        }

        return cell
    }

}
