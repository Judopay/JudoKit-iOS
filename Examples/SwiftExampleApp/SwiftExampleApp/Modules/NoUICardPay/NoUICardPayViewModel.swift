import JudoKit_iOS
import SwiftUI

class NoUICardPayViewModel: ObservableObject {
    private let featureService: FeatureService
    @Published var errorMessage = ""
    @Published var showAlert = false
    @Published var result: Result?

    init(featureService: FeatureService) {
        self.featureService = featureService
    }

    func payWithCardToken() {
        featureService.invokePayment(withDetails: cardTransactionDetails, completion: completion)
    }

    func preAuthWithCardToken() {
        featureService.invokePreAuthPayment(withDetails: cardTransactionDetails, completion: completion)
    }

    private var cardTransactionDetails: JPCardTransactionDetails {
        let details = JPCardTransactionDetails()
        details.cardNumber = "4976350000006891"
        details.cardholderName = "CHALLENGE"
        details.expiryDate = "12/25"
        details.securityCode = "341"
        details.emailAddress = "federico.onco@gmail.com"
        details.mobileNumber = "7866868430"
        details.phoneCountryCode = "44"
        details.billingAddress = JPAddress(
            address1: "Holbeck Row",
            address2: nil,
            address3: nil,
            town: "London",
            postCode: "se151qa",
            countryCode: 826,
            state: nil)
        return details
    }

    private lazy var completion: JPCompletionBlock = { [weak self] response, error in
        DispatchQueue.main.async {
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.showAlert = true
                return
            }
            if let response = response {
                self?.result = Result(from: response)
            }
        }
    }
}
