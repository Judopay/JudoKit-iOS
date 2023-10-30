import UIKit
import JudoKit_iOS

class ViewController: UIViewController {
    
    @IBAction func onPaymentButtonTap(_ sender: Any) {
        let amount = JPAmount("1.50", currency: "GBP")
        let reference = JPReference(consumerReference: "consumer-ref")
        let configuration = JPConfiguration(judoID: "112233", amount: amount, reference: reference)
        
        let authorisation = JPSessionAuthorization(token: "my-token", andPaymentSession: "my-session-token")
        let kit = JudoKit(authorization: authorisation)
        
        kit?.invokeTransaction(with: .payment, configuration: configuration) { response, error in
            // handle callback
        }
    }
}
