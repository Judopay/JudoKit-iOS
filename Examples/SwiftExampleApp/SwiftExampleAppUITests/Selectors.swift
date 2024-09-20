//
//  Selectors.swift
//  SwiftExampleAppUITests
//
//  Created by Eugene Zhernakov on 19/09/2024.
//  Copyright © 2024 Judopay. All rights reserved.
//

import Foundation

class Selectors {
    struct CardEntry {
        static let cardNumberField = "Card Number Field"
        static let cardHolderNameField = "Cardholder Name Field"
        static let expiryDateField = "Expiry Date Field"
        static let securityCodeField = "Security Code Field"
        static let cardDetailsSubmitButtonSelector = "Submit Button"
        static let cancelCardEntryButton = "CANCEL"
    }
    struct FeatureList {
        static let payWithCard = "Pay with card"
        static let preAuthWithCard = "Pre-auth with card"
        static let registerCard = "Register card"
        static let checkCard = "Check card"
        static let tokenPayment = "Token Payments"
        static let paymentMethods = "Payment methods"
        static let preAuthMethods = "PreAuth methods"
        static let settingsSectionButton = "settingsButton"
    }
    struct TokenPayments {
        static let tokenizeNewCardButtonSelector = "Tokenize a new card"
        static let tokenPaymentButtonSelector = "Payment"
        static let tokenPreAuthButton = "Preauth"
    }
    struct PaymentMethods {
        static let addNewCardButton = "ADD CARD"
        static let payNowButtonSelector = "PAY NOW"
        static let editCardsButtonSelector = "EDIT"
        static let deleteCardButtonSelector = "Delete"
    }
    struct BillingInfo {
        static let emailField = "Cardholder Email Field"
        static let phoneField = "Cardholder phone number Field"
        static let addressOneField = "Cardholder address line 1 code Field"
        static let addressTwoField = "Cardholder address line 2 Field"
        static let cityField = "Cardholder city Field"
        static let postCodeField = "Post Code Field"
        static let addAddressLineButton = "Add address line Button"
        static let fieldErrorLabel = "Error Floating Label"
        static let stateField = "State Field"
        static let countryField = "Country Field"
    }
    struct Other {
        static let threeDS2CancelButton = "Cancel"
        static let resultsTable = "Results View"
        static let cancelButton = "Cancel"
    }
    struct ResultsView {
        static let receiptIdValue = "receiptId Value"
        static let typeValue = "type Value"
        static let messageValue = "message Value"
        static let resultValue = "result Value"
    }
}
