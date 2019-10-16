import UIKit
import JudoKitObjC

extension UIViewController {

    func handle(_ response: JPResponse?, error: Error?) -> JPTransactionData? {
        if let judoError = error as NSError? {
            self.handle(error: judoError)
        } else if let response = response, let items = response.items, items.count > 0 {
            self.handle(response: response)
            return response.items?.first
        }

        return nil
    }

    func handle(error: NSError) {
        if error.userDidCancelOperation {
            dismiss(animated: true, completion: nil)
            return
        }

        dismiss(animated: true) {
            self.presentAlert(with: "Error", message: error.judoMessage)
        }
    }

    func handle(response: JPResponse) {
        let detailsViewController = ResponseDetailsTableViewController(title: "Payment receipt",
                                                                        data: response.detailsTableData)
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
