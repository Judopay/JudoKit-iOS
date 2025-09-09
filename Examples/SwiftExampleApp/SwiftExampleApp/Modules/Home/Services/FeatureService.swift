import Foundation
import JudoKit_iOS

class FeatureService {
    private let settings = Settings.standard

    // MARK: - SDK Methods

    func invokeTransaction(with type: JPTransactionType,
                           completion: @escaping JPCompletionBlock) {
        updateAuthorization()
        judoKit?.invokeTransaction(with: type,
                                   configuration: configuration,
                                   completion: completion)
    }

    func invokeApplePay(with mode: JPTransactionMode,
                        completion: @escaping JPCompletionBlock) {
        updateAuthorization()
        judoKit?.invokeApplePay(with: mode,
                                configuration: configuration,
                                completion: completion)
    }

    func invokePaymentMethods(with mode: JPTransactionMode,
                              completion: @escaping JPCompletionBlock) {
        updateAuthorization()
        judoKit?.invokePaymentMethodScreen(with: mode,
                                           configuration: configuration,
                                           completion: completion)
    }

    func invokeTokenTransaction(with type: JPTransactionType,
                                details: JPCardTransactionDetails,
                                completion: @escaping JPCompletionBlock) {
        updateAuthorization()
        judoKit?.invokeTokenTransaction(with: type,
                                        configuration: configuration,
                                        details: details,
                                        completion: completion)
    }

    func invokePayment(withDetails details: JPCardTransactionDetails, completion: @escaping JPCompletionBlock) {
        transactionService.invokePayment(with: details, andCompletion: completion)
    }

    func invokePreAuthPayment(withDetails details: JPCardTransactionDetails, completion: @escaping JPCompletionBlock) {
        transactionService.invokePreAuthPayment(with: details, andCompletion: completion)
    }

    func invokeCheckCard(withDetails details: JPCardTransactionDetails, completion: @escaping JPCompletionBlock) {
        transactionService.invokeCheckCard(with: details, andCompletion: completion)
    }

    func getTransactionDetails(with receiptID: String,
                               and completion: @escaping JPCompletionBlock) {
        apiService.fetchTransaction(withReceiptId: receiptID, completion: completion)
    }

    func checkTransactionStatus(for orderID: String,
                                completion: @escaping JPCompletionBlock) {
        apiService.invokeOrderStatus(withOrderId: orderID, andCompletion: completion)
    }

    // MARK: -
    private func updateAuthorization() {
        judoKit?.authorization = settings.authorization
        judoKit?.isSandboxed = settings.isSandboxed
    }
    
    private lazy var judoKit: JudoKit? = {
        let judo = JudoKit(authorization: settings.authorization)
        judo?.isSandboxed = settings.isSandboxed
        return judo
    }()

    private var apiService: JPApiService {
        JPApiService(authorization: settings.authorization,
                     isSandboxed: settings.isSandboxed)
    }

    private var transactionService: JPCardTransactionService {
        JPCardTransactionService(authorization: settings.authorization, isSandboxed: settings.isSandboxed, andConfiguration: configuration)
    }

    var configuration: JPConfiguration {
        let config = JPConfiguration(judoID: settings.judoId,
                                     amount: settings.amount,
                                     reference: settings.reference)
        config.paymentMethods = settings.paymentMethods
        config.uiConfiguration = uiConfiguration
        config.uiConfiguration.threeDSUICustomization = settings.threeDSUICustomization
        config.supportedCardNetworks = settings.supportedCardNetworks
        config.applePayConfiguration = applePayConfiguration
        config.isInitialRecurringPayment = config.isInitialRecurringPayment
        config.cardAddress = settings.address
        config.isDelayedAuthorisation = settings.isDelayedAuthorisationOn
        config.emailAddress = settings.emailAddress
        config.phoneCountryCode = settings.phoneCountryCode
        config.mobileNumber = settings.mobileNumber
        if let scaExemption = settings.scaExemption {
            config.scaExemption = scaExemption
        }
        if let challengeRequestIndicator = settings.challengeRequestIndicator {
            config.challengeRequestIndicator = challengeRequestIndicator
        }
        config.threeDSTwoMaxTimeout = Int32(settings.threeDsTwoMaxTimeout)
        if let messageVersion = settings.threeDSTwoMessageVersion, !messageVersion.isEmpty {
            config.threeDSTwoMessageVersion = messageVersion
        }
        config.recommendationConfiguration = settings.recommendationConfiguration
        return config
    }

    private var applePayConfiguration: JPApplePayConfiguration {
        let item = JPPaymentSummaryItem(label: "Tim Cook",
                                        amount: NSDecimalNumber(string: settings.amount.amount))

        let appleConfig = JPApplePayConfiguration(merchantId: settings.applePayMerchantID,
                                                  currency: settings.amount.currency,
                                                  countryCode: "GB",
                                                  paymentSummaryItems: [item])

        let expressDelivery = JPPaymentShippingMethod(identifier: "1",
                                                      detail: "Next day delivery to your location",
                                                      label: "Express Delivery",
                                                      amount: 25.0,
                                                      type: .final)

        let freeDelivery = JPPaymentShippingMethod(identifier: "2",
                                                   detail: "Delivery by Monday next week",
                                                   label: "Free Delivery",
                                                   amount: 0.0,
                                                   type: .final)

        appleConfig.shippingType = .shippingTypeDelivery
        appleConfig.shippingMethods = [freeDelivery, expressDelivery]

        appleConfig.requiredBillingContactFields = settings.applePayBillingContactFields
        appleConfig.requiredShippingContactFields = settings.applePayShippingContactFields
        appleConfig.returnedContactInfo = settings.applePayReturnedContactInfo
        appleConfig.supportedCardNetworks = settings.supportedCardNetworks

        return appleConfig
    }

    private var uiConfiguration: JPUIConfiguration {
        let uiConfig = JPUIConfiguration()
        uiConfig.isAVSEnabled = settings.isAVSEnabled
        uiConfig.shouldPaymentMethodsDisplayAmount = settings.shouldPaymentMethodsDisplayAmount
        uiConfig.shouldPaymentButtonDisplayAmount = settings.shouldPaymentButtonDisplayAmount
        uiConfig.shouldAskForBillingInformation = settings.shouldAskForBillingInformation
        uiConfig.shouldAskForCSC = settings.shouldAskForCSC
        uiConfig.shouldAskForCardholderName = settings.shouldAskForCardholderName
        return uiConfig
    }
}
