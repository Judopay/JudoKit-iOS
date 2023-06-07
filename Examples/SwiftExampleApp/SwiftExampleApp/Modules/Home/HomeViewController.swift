import UIKit

class HomeViewController: UIViewController, HomeInteractorOutput {
    // MARK: - Constants

    private let kCellIdentifier = "FeatureCell"
    private let kNavigationItemTitle = "Judopay Examples"
    private let kHeaderTitle = "Features"
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

    func navigateToNoUICardPayModule() {
        coordinator?.pushTo(.noUICardPay)
    }

    func navigateToPBBAModule() {
        coordinator?.pushTo(.payByBankApp)
    }

    func navigateToApplePayModule() {
        coordinator?.pushTo(.applePay)
    }

    // MARK: - PBBA Deeplinking

    func handlePBBAStatus(with url: URL) {
        interactor.handlePBBAStatus(with: url)
    }

    // MARK: - Layout setup

    private func setupLayout() {
        navigationItem.title = kNavigationItemTitle
        navigationItem.backButtonTitle = " "
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
        let settingsIcon = UIImage(named: "settings_black")
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = viewModels[indexPath.row].type
        interactor.didSelectFeature(with: type)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier)

        if let featureCell = cell as? FeatureCell {
            featureCell.configure(with: viewModels[indexPath.row])
        }

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        kHeaderTitle
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "To view test card details:\nSign in to judo and go to Developer/Tools."
    }
}
