import InAppSettingsKit
import JudoKit_iOS

private struct CreatePaymentSessionRequest {
    let judoId: String
    let amount: String
    let currency: String
    let yourConsumerReference: String
    let yourPaymentReference: String
    let disableNetworkTokenisation: Bool

    var dictionaryRepresentation: [String: Any] {
        [
            "judoId": judoId,
            "amount": amount,
            "currency": currency,
            "yourConsumerReference": yourConsumerReference,
            "yourPaymentReference": yourPaymentReference,
            "disableNetworkTokenisation": disableNetworkTokenisation
        ]
    }
}

extension SettingsViewController: IASKSettingsDelegate {
    func settingsViewControllerDidEnd(_ settingsViewController: IASKAppSettingsViewController) {
        // noop
    }

    func settingsViewController(_ settingsViewController: IASKAppSettingsViewController,
                                buttonTappedFor specifier: IASKSpecifier) {
        if specifier.key == kGeneratePaymentSessionKey {
            createPaymentSession()
        }
    }

    private func createPaymentSession() {
        let settings = Settings.standard
        let amount = settings.amount
        let reference = settings.reference
        let paymentReference = reference.paymentReference
        let consumerReference = reference.consumerReference

        settings.persistGeneratedReferencesIfNeeded(paymentReference: paymentReference,
                                                    consumerReference: consumerReference)

        let baseURLString = settings.isSandboxed ? kJudoSandboxBaseURL : kJudoBaseURL
        let url = URL(string: "\(baseURLString)/webpayments/payments")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("JudoKit-iOS Swift Examples", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue("6.26.0", forHTTPHeaderField: "Api-Version")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")

        let token = settings.token ?? ""
        let secret = settings.secret ?? ""
        let authorization = "Basic \(Data("\(token):\(secret)".utf8).base64EncodedString())"
        request.setValue(authorization, forHTTPHeaderField: "Authorization")

        let paymentRequest = CreatePaymentSessionRequest(
            judoId: settings.judoId,
            amount: amount.amount,
            currency: amount.currency,
            yourConsumerReference: consumerReference,
            yourPaymentReference: paymentReference,
            disableNetworkTokenisation: settings.isDisableNetworkTokenisationOn
        )
        request.httpBody = try? JSONSerialization.data(withJSONObject: paymentRequest.dictionaryRepresentation)

        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            DispatchQueue.main.async {
                self?.onCreatePaymentSessionComplete(data: data, error: error)
            }
        }.resume()
    }

    private func onCreatePaymentSessionComplete(data: Data?, error: Error?) {
        if let error {
            displayAlert(message: "Error: \(error.localizedDescription).")
            return
        }

        do {
            guard let data,
                  let responseDict = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                displayAlert(message: "JSON deserialization error.")
                return
            }

            guard let paymentSession = responseDict["reference"] as? String, !paymentSession.isEmpty else {
                displayAlert(message: "Error: missing payment session reference.")
                return
            }

            Settings.standard.updateAuthorization(withPaymentSession: paymentSession,
                                                  andToken: Settings.standard.token)
            displayAlert(message: "Success generating payment session, settings updated, navigating back to main screen.") { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        } catch {
            displayAlert(message: "JSON deserialization error: \(error.localizedDescription).")
        }
    }
}
