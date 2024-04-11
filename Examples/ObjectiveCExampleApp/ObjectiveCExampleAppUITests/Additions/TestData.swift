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
    
    static let ALLOW = "ALLOW"
    static let PREVENT = "PREVENT"
    static let REVIEW = "REVIEW"
    static let AUTHORISE = "AUTHORISE"
    static let AUTHENTICATE = "AUTHENTICATE"
    static let TRA = "TRANSACTION_RISK_ANALYSIS"
    static let LOW_VALUE = "LOW_VALUE"
    static let NO_CHALLENGE = "NO_CHALLENGE_REQUESTED"
    static let NO_PREFERENCE = "NO_PREFERENCE"
    static let CHALLENGE_MANDATE = "CHALLENGE_REQUESTED_AS_MANDATE"
    static let CHALLENGE_REQUESTED = "CHALLENGE_REQUESTED"
    
    static let VALID_EMAIL = "user@test.com"
    static let VALID_MOBILE = "07812345678"
    static let VALID_ADDRESS = "235 Regent Street"
    static let VALID_CITY = "London"
    static let VALID_POSTCODE = "W1B 2EL"
    static let VALID_ADDRESS_TWO = "West End"
    static let VALID_COUNTRY_CODE = "826"
    
    static let INVALID_POSTCODE = "38GL112"
    
    static let INVALID_POSTCODE_LABEL = "Invalid postcode entered"
    static let INVALID_ZIPCODE_LABEL = "Invalid ZIP code entered"
}
