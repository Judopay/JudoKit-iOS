//
//  TestData.swift
//  ObjectiveCExampleAppUITests
//
//  Created by Eugene Zhernakov on 07/07/2023.
//  Copyright © 2023 Judopay. All rights reserved.
//

import Foundation

class TestData {
    static let CARD_NUMBER = "4976 3500 0000 6891"
    static let CARDHOLDER_NAME = "Test User"
    static let CARD_EXPIRY = "1225"
    static let CARD_SECURITY_CODE = "341"

    static let PAY_WITH_CARD_LABEL = "Pay with card"
    static let PREAUTH_WITH_CARD_LABEL = "Pre-auth with card"
    static let REGISTER_CARD_LABEL = "Register card"
    static let CHECK_CARD_LABEL = "Check card"
    static let TOKEN_PAYMENTS_LABEL = "Token Payments"
    static let PAYMENT_METHODS_LABEL = "Payment methods"
    static let PREAUTH_METHODS_LABEL = "PreAuth methods"

    static let CANCEL_BUTTON = "Cancel"
    
    static let CANCELLED_PAYMENT_TOAST = "The transaction was cancelled by the user."
    static let CANCELLED_3DS2_PAYMENT_TOAST = "Unable to process transaction. Card authentication failed with 3DS Server."
}
