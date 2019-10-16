import Foundation
import JudoKitObjC

func applePayConfiguration(with transactionType: TransactionType, currency: String) -> ApplePayConfiguration {
    let items = [
    PaymentSummaryItem(label: "Item 1", amount: 0.01),
    PaymentSummaryItem(label: "Item 2", amount: 0.02),
    PaymentSummaryItem(label: "Item 3", amount: 0.03)
    ]

    let configuration = ApplePayConfiguration(judoId: judoId,
                                              reference: "judopay-sample-app",
                                              merchantId: merchantId,
                                              currency: currency,
                                              countryCode: "GB",
                                              paymentSummaryItems: items)
    configuration.transactionType = transactionType
    configuration.requiredShippingContactFields = .all
    configuration.requiredBillingContactFields = .all
    configuration.returnedContactInfo = .all

    return configuration
}
