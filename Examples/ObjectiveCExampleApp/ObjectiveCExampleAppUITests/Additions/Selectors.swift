//
//  Selectors.swift
//  ObjectiveCExampleAppUITests
//
//  Created by Eugene Zhernakov on 26/10/2023.
//  Copyright © 2023 Judopay. All rights reserved.
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
        static let settingsSectionButton = "Settings Button"
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
        static let wormholyButton = "Network requests inspector button"
        static let paymentsRequestLabel = "/transactions/payments"
        static let viewBodyLabel = "View body"
        static let dismissButton = "Dismiss button"
        static let searchButton = "Search"
        static let requestBodySearchTerm = "referencenumber"
        static let padSearchTerm = "primaryaccountdetails"
        static let haltTransactionSwitch = "Halt transaction in case of any error"
        static let backButton = "Judopay examples"
        static let cancelledPaymentToastLabel = "messageLabel"
    }
    struct Ideal {
        static let makePaymentButton = "Make Payment"
        static let nextButton = "Next"
        static let loginButton = "Login"
        static let backButton = "Back to where you came from"
        static let abortButton = "Abort"
    }
}
