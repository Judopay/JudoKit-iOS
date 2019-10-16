import Foundation
import JudoKitObjC

extension JPResponse {

    var detailsTableData: [DetailsTableViewSection] {
        var data: [DetailsTableViewSection] = []

        if let transactionData = items?.first {

            var stampDate = ""
            if let createdAtDate = Formatters.inputDateFormatter.date(from: transactionData.createdAt) {
                stampDate = Formatters.outputDateFormatter.string(from: createdAtDate)
            }

            var formattedAmount = ""
            if let transactionAmount = transactionData.amount, let amount = Double(transactionAmount.amount) {
                Formatters.numberFormatter.currencyCode = transactionAmount.currency
                formattedAmount = Formatters.numberFormatter.string(from: NSNumber(value: amount)) ?? ""
            }

            // General
            let generalRows = [
            DetailsTableViewRow(title: "Date", value: stampDate),
            DetailsTableViewRow(title: "Amount", value: formattedAmount),
            DetailsTableViewRow(title: "Resolution", value: transactionData.message ?? "")
            ]
            data.append(DetailsTableViewSection(title: "General", rows: generalRows))

            // Card details
            if let cardDetails = transactionData.cardDetails {
                let cardDetailsRows = [
                    DetailsTableViewRow(title: "Card last 4 digits", value: cardDetails.cardLastFour ?? ""),
                    DetailsTableViewRow(title: "End date", value: cardDetails.endDate ?? ""),
                    DetailsTableViewRow(title: "Card token", value: cardDetails.cardToken ?? ""),
                    DetailsTableViewRow(title: "Card type", value: "\(cardDetails.cardNetwork.rawValue)"),
                    DetailsTableViewRow(title: "Bank", value: cardDetails.bank ?? ""),
                    DetailsTableViewRow(title: "Card category", value: cardDetails.cardCategory ?? ""),
                    DetailsTableViewRow(title: "Card country", value: cardDetails.cardCountry ?? ""),
                    DetailsTableViewRow(title: "Card funding", value: cardDetails.cardFunding ?? ""),
                    DetailsTableViewRow(title: "Card scheme", value: cardDetails.cardScheme ?? "")
                ]
                data.append(DetailsTableViewSection(title: "Card Details", rows: cardDetailsRows))
            }
        }

        if let billingInformation = billingInfo {
            data.append(DetailsTableViewSection(title: "Billing Details",
                                                 rows: contactDetailsRows(from: billingInformation)))
        }

        if let shippingInformation = shippingInfo {
            data.append(DetailsTableViewSection(title: "Shipping Details",
                                                 rows: contactDetailsRows(from: shippingInformation)))
        }

        return data
    }

    private func contactDetailsRows(from contact: ContactInformation) -> [DetailsTableViewRow] {

        var nameComponents: [String] = []
        var addressComponents: [String] = []

        nameComponents.append(contact.name?.namePrefix ?? "")
        nameComponents.append(contact.name?.givenName ?? "")
        nameComponents.append(contact.name?.middleName ?? "")
        nameComponents.append(contact.name?.familyName ?? "")
        nameComponents.append(contact.name?.nameSuffix ?? "")

        addressComponents.append(contact.postalAddress?.street ?? "")
        addressComponents.append(contact.postalAddress?.city ?? "")
        addressComponents.append(contact.postalAddress?.country ?? "")
        addressComponents.append(contact.postalAddress?.state ?? "")
        addressComponents.append(contact.postalAddress?.postalCode ?? "")

        return [
            DetailsTableViewRow(title: "Email", value: contact.emailAddress ?? ""),
            DetailsTableViewRow(title: "Name", value: nameComponents.joined(separator: " ")),
            DetailsTableViewRow(title: "Phone", value: contact.phoneNumber ?? ""),
            DetailsTableViewRow(title: "Postal Address", value: addressComponents.joined(separator: " "))
        ]
    }
}
