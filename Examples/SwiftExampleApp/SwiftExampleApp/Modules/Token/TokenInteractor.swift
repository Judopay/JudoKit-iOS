import JudoKit_iOS

protocol TokenInteractorInput {
    func viewDidLoad()
    func didChange(scheme: String?)
    func didChange(token: String?)
    func didChange(csc: String?)
    func didChange(cardholderName: String?)
    func didTapSaveCardButton()
    func didTapTokenPaymentButton()
    func didTapTokenPreAuthButton()
}

protocol TokenInteractorOutput: AnyObject {
    func updateFields(withScheme: String?, token: String?, csc: String?, cardholderName: String?)
    func navigateToResultsModule(with result: Result)
    func areTokenTransactionButtonsEnabled(_ isEnabled: Bool)
    func displayErrorAlert(with error: NSError)
}

class TokenInteractor: TokenInteractorInput {
    // MARK: - Variables

    private var scheme: String? {
        didSet {
            updateTransactionButtonState()
        }
    }

    private var cardToken: String? {
        didSet {
            updateTransactionButtonState()
        }
    }

    private var csc: String?
    private var cardholderName: String? {
        didSet {
            updateTransactionButtonState()
        }
    }

    private let featureService: FeatureService
    weak var output: TokenInteractorOutput?

    // MARK: - Initializer

    init(with featureService: FeatureService) {
        self.featureService = featureService
        scheme = "2"
        csc = "341"
        cardholderName = "CHALLENGE"
    }

    // MARK: - Protocol methods

    func viewDidLoad() {
        output?.updateFields(withScheme: scheme, token: cardToken, csc: csc, cardholderName: cardholderName)
        updateTransactionButtonState()
    }

    func didChange(scheme: String?) {
        self.scheme = scheme
    }

    func didChange(token: String?) {
        cardToken = token
    }

    func didChange(csc: String?) {
        self.csc = csc
    }

    func didChange(cardholderName: String?) {
        self.cardholderName = cardholderName
    }

    func didTapSaveCardButton() {
        featureService.invokeTransaction(with: .saveCard,
                                         completion: completion)
    }

    func didTapTokenPaymentButton() {
        featureService.invokeTokenTransaction(with: .payment,
                                              details: cardTransactionDetails,
                                              completion: completion)
    }

    func didTapTokenPreAuthButton() {
        featureService.invokeTokenTransaction(with: .preAuth,
                                              details: cardTransactionDetails,
                                              completion: completion)
    }

    // MARK: - Helpers

    private var cardTransactionDetails: JPCardTransactionDetails {
        let details = JPCardTransactionDetails(configuration: featureService.configuration)
        details.cardToken = cardToken
        details.cardType = NSNumber(value: Int(scheme ?? "") ?? 0)._jp_toCardNetworkType()
        details.securityCode = csc?.isEmpty == false ? csc : nil
        details.cardholderName = cardholderName
        return details
    }

    private func updateTransactionButtonState() {
        output?.areTokenTransactionButtonsEnabled(scheme?.isEmpty == false && cardToken?.isEmpty == false && cardholderName?.isEmpty == false)
    }

    private func handleError(_ error: JPError) {
        output?.displayErrorAlert(with: error)
    }

    private func handleResponse(_ response: JPResponse) {
        if response.type == .saveCard {
            guard let cardDetails = response.cardDetails else {
                return
            }

            scheme = cardDetails.rawCardNetwork?.stringValue
            cardToken = cardDetails.cardToken
            cardholderName = cardDetails.cardHolderName
            output?.updateFields(withScheme: scheme, token: cardToken, csc: nil, cardholderName: cardholderName)

            return
        }

        let result = Result(from: response)
        output?.areTokenTransactionButtonsEnabled(false)
        output?.navigateToResultsModule(with: result)
    }

    // MARK: - Lazy instantiations

    private lazy var completion: JPCompletionBlock = { [weak self] response, error in
        DispatchQueue.main.async {
            if let error = error {
                self?.handleError(error)
                return
            }
            if let response = response {
                self?.handleResponse(response)
            }
        }
    }
}
