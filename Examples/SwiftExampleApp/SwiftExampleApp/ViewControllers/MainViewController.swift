import UIKit
import JudoKit_iOS

class MainViewController: UITableViewController {
    var settings = Settings(isAVSEnabled: false, currency: .GBP)
    var basicAuthorization: JPAuthorization = JPBasicAuthorization(token: token, andSecret: secret)
    var judoKit: JudoKit?
    var locationManager = CLLocationManager()
    let consumerReference = "judoPay-sample-app"
    lazy var reference = JPReference(consumerReference: consumerReference)
    
    let defaultFeatures = [
        DemoFeature(type: .payment,
                    title: "Pay with card",
                    details: "by entering card details"),
        
        DemoFeature(type: .preAuth,
                    title: "PreAuth with card",
                    details: "by entering card details"),
        
        DemoFeature(type: .createCardToken,
                    title: "Register card",
                    details: "to be stored for future transactions"),
        
        DemoFeature(type: .checkCard,
                    title: "Check card",
                    details: "to validate a card"),
        
        DemoFeature(type: .saveCard,
                    title: "Save card",
                    details: "to be stored for future transactions"),
        DemoFeature(type: .applePayPayment,
                    title: "Apple Pay payment",
                    details: "with a wallet card"),
        
        DemoFeature(type: .applePayPreAuth,
                    title: "Apple Pay preAuth",
                    details: "with a wallet card"),
        
        DemoFeature(type: .paymentMethods,
                    title: "Payment Method",
                    details: "with default payment methods"),
        
        DemoFeature(type: .preAuthMethods,
                    title: "PreAuth Methods",
                    details: "with default preauth methods"),
        
        DemoFeature(type: .serverToServer,
                    title: "Server-to-Server payment methods",
                    details: "with default Server-to-Server payment methods")
    ]
    
    var amount: JPAmount {
        return  JPAmount("0.01", currency: settings.currency.rawValue)
    }
    
    var configuration: JPConfiguration {
        let configuration = JPConfiguration(judoID: judoId, amount: self.amount, reference: reference)
        configuration.supportedCardNetworks = [.visa, .masterCard, .AMEX]
        configuration.uiConfiguration.isAVSEnabled = settings.isAVSEnabled
        configuration.applePayConfiguration = applePayConfigurations
        return configuration
    }
    
    var applePayConfigurations: JPApplePayConfiguration {
        let items = [JPPaymentSummaryItem(label: "item 1", amount: 0.01),
                     JPPaymentSummaryItem(label: "item 2", amount: 0.02),
                     JPPaymentSummaryItem(label: "Judo Pay", amount: 0.03)]
        let configurations = JPApplePayConfiguration(merchantId: merchantId,
                                                     currency: self.settings.currency.rawValue,
                                                     countryCode: "GB",
                                                     paymentSummaryItems: items)
        configurations.requiredShippingContactFields = .all
        configurations.shippingMethods = [JPPaymentShippingMethod(identifier: "shiping", detail: "details", label: "label", amount: 0.01, type: .final)]
        return configurations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = false
        judoKit = JudoKit(authorization: basicAuthorization)
        judoKit?.isSandboxed = true
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: Table view datasource
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
        
        switch feature.type {
        case .payment:
            pay()
            
        case .preAuth:
            preAuth()
            
        case .createCardToken:
            createCardToken()
            
        case .saveCard:
            saveCard()
            
        case .checkCard:
            checkCard()
            
        case .applePayPayment:
            applePayPayment()
            
        case .applePayPreAuth:
            applePayPreAuth()
            
        case .paymentMethods:
            navigateToPaymentMethods()
            
        case .preAuthMethods:
            navigateToPreAuthMethods()
            
        case .serverToServer:
            navigateToServerToServerMethods()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController,
            let controller = navigation.viewControllers.first as? SettingsTableViewController {
            controller.settings = self.settings
            controller.delegate = self
        }
    }
    
    // MARK: Actions
    @objc func pay() {
        self.judoKit?.invokeTransaction(with: .payment,
                                        configuration: configuration,
                                        completion: {[weak self] (response, error) in
                                            self?.handle(response: response, error: error)
        })
    }
    
    @objc func preAuth() {
        self.judoKit?.invokeTransaction(with: .preAuth,
                                        configuration: configuration,
                                        completion: {[weak self] (response, error) in
                                            self?.handle(response: response, error: error)
        })
    }
    
    @objc func createCardToken() {
        self.judoKit?.invokeTransaction(with: .registerCard,
                                        configuration: configuration,
                                        completion: {[weak self] (response, error) in
                                            self?.handle(response: response, error: error)
        })
    }
    
    @objc func saveCard() {
        self.judoKit?.invokeTransaction(with: .saveCard,
                                        configuration: configuration,
                                        completion: {[weak self] (response, error) in
                                            self?.handle(response: response, error: error)
        })
    }
    
    @objc func checkCard() {
        self.judoKit?.invokeTransaction(with: .checkCard,
                                        configuration: configuration,
                                        completion: {[weak self] (response, error) in
                                            self?.handle(response: response, error: error)
        })
    }
    
    
    @objc func applePayPayment() {
        self.judoKit?.invokeApplePay(with: .payment,
                                     configuration: configuration,
                                     completion: {[weak self] (response, error) in
                                        self?.handle(response: response, error: error)
        })
    }
    
    @objc func applePayPreAuth() {
        self.judoKit?.invokeApplePay(with: .preAuth,
                                     configuration: configuration,
                                     completion: {[weak self] (response, error) in
                                        self?.handle(response: response, error: error)
        })
    }
    
    @objc func navigateToPaymentMethods() {
        self.judoKit?.invokePaymentMethodScreen(with: .payment,
                                                configuration: configuration,
                                                completion: {[weak self] (response, error) in
                                                    self?.handle(response: response, error: error)
        })
    }
    
    @objc func navigateToPreAuthMethods() {
        self.judoKit?.invokePaymentMethodScreen(with: .preAuth,
                                                configuration: configuration,
                                                completion: {[unowned self] (response, error) in
                                                    self.handle(response: response, error: error)
        })
    }
    
    @objc func navigateToServerToServerMethods() {
        self.judoKit?.invokePaymentMethodScreen(with: .serverToServer,
                                                configuration: configuration,
                                                completion: {[weak self] (response, error) in
                                                    self?.handle(response: response, error: error)
        })
    }
    
    
    // MARK: - Helper methods
    
    func handle(response: JPResponse?, error: Error?) {
        if let error = error {
            self.presentAlert(with: "Error", message: error.localizedDescription)
            return
        }
        
        guard let response = response else {
            return
        }
        let detailsViewController = TransactionDetailsTableViewController(title: "Payment receipt",
                                                                          response: response)
        dismiss(animated: true) {
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
    
    func presentAlert(with title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension MainViewController: SettingsTableViewControllerDelegate {
    func settingsTable(viewController: SettingsTableViewController, didUpdate settings: Settings) {
        self.settings = settings
    }
}
