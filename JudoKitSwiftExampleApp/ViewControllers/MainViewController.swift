import UIKit
import JudoKitObjC

class MainViewController: UITableViewController {

    var settings: Settings = Settings(isAVSEnabled: false, currency: "GBP")
    var judoKit: JudoKit!

    var transactionData: JPTransactionData?

    static let consumerReference = "judoPay-sample-app"

    var testAmount: JPAmount {
        return JPAmount("0.01", currency: settings.currency)
    }

    var testPaymentApplePayConfiguration: ApplePayConfiguration {
        return applePayConfiguration(with: .payment, currency: settings.currency)
    }

    var testPreAuthApplePayConfiguration: ApplePayConfiguration {
        return applePayConfiguration(with: .preAuth, currency: settings.currency)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = false

        judoKit = JudoKit(token: token, secret: secret)
        judoKit.apiSession.sandboxed = true
        judoKit.theme.showSecurityMessage = true
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultFeatures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let feature = defaultFeatures[indexPath.row]

        cell.textLabel?.text = feature.title
        cell.detailTextLabel?.text = feature.details

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let feature = defaultFeatures[indexPath.row]
        perform(feature.action)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController,
        let controller = navigation.viewControllers.first as? SettingsTableViewController {
            controller.settings = self.settings
            controller.delegate = self
        }

        if let applePayViewController = segue.destination as? StandaloneApplePayViewController {
            applePayViewController.judoKit = judoKit
            applePayViewController.currency = settings.currency
        }
    }
}

extension MainViewController: SettingsTableViewControllerDelegate {
    func settingsTable(viewController: SettingsTableViewController, didUpdate settings: Settings) {
        self.settings = settings
    }
}
