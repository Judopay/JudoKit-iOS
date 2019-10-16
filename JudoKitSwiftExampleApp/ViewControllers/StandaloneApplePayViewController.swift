import UIKit
import PassKit
import JudoKitObjC

class StandaloneApplePayViewController: UIViewController {

    var currency = "GBP"
    var judoKit: JudoKit?

    override func viewDidLoad() {
        super.viewDidLoad()

        var subview: UIView

        if PKPaymentAuthorizationViewController.canMakePayments() {
            let style: PKPaymentButtonStyle = self.traitCollection.userInterfaceStyle == .dark ? .white : .black
            let button = PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: style)
            button.addTarget(self, action: #selector(performApplePay), for: .touchUpInside)

            subview = button
        } else {
            let label = UILabel(frame: .zero)
            label.font = UIFont(name: "Helvetica", size: 16)
            label.text = "Apple Pay is not available on this device"
            label.numberOfLines = 0
            label.textColor = UIColor.secondaryLabel

            subview = label
        }

        view.addSubview(subview)

        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @objc func performApplePay() {
        let configuration = applePayConfigurationWith(transactionType: .payment, currency: currency)

        judoKit?.invokeApplePay(with: configuration, completion: { (response, error) in
            if let judoError = error as NSError? {
                self.handle(error: judoError)
                return
            }

            if let response = response, let items = response.items, items.count > 0 {
                let detailsViewController = ResponseDetailsTableViewController(title: "Transaction details",
                                                                                data: response.detailsTableData)
                self.navigationController?.pushViewController(detailsViewController, animated: true)
            }
        })
    }
}
