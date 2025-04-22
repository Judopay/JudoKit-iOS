//
//  TestData.swift
//  ObjectiveCExampleAppUITests
//
//  Created by Eugene Zhernakov on 07/07/2023.
//  Copyright © 2023 Judopay. All rights reserved.
//

import Foundation

class TestData {
    struct CardDetails {
        static let CARD_NUMBER = "4976 3500 0000 6891"
        static let CARDHOLDER_NAME = "Test User"
        static let CARD_EXPIRY = "1225"
        static let CARD_SECURITY_CODE = "341"
        static let WRONG_CV2 = "123"
    }
    struct Ravelin {
        static let ALLOW = "ALLOW"
        static let PREVENT = "PREVENT"
        static let REVIEW = "REVIEW"
        static let AUTHORISE = "AUTHORISE"
        static let AUTHENTICATE = "AUTHENTICATE"
        static let TRA = "transactionriskanalysis"
        static let LOW_VALUE = "lowvalue"
        static let NO_CHALLENGE = "noChallenge"
        static let NO_PREFERENCE = "nopreference"
        static let CHALLENGE_MANDATE = "challengeasmandate"
        static let CHALLENGE_PREFERRED = "challengepreferred"
    }
    struct BillingInfo {
        static let VALID_EMAIL = "user@test.com"
        static let VALID_MOBILE = "07812345678"
        static let VALID_ADDRESS = "235 Regent Street"
        static let VALID_CITY = "London"
        static let VALID_POSTCODE = "W1B 2EL"
        static let VALID_ADDRESS_TWO = "West End"
        static let VALID_COUNTRY_CODE = "826"
        static let INVALID_POSTCODE = "38GL112"
        static let SPECIAL_CHARACTERS = "#$@*"
        static let INVALID_POSTCODE_LABEL = "Invalid postcode entered"
        static let INVALID_ZIPCODE_LABEL = "Invalid ZIP code entered"
        static let INVALID_EMAIL_LABEL = "Please enter a valid email"
        static let INVALID_PHONE_LABEL = "Please enter a valid mobile number"
        static let INVALID_ADDRESS_LABEL = "Please enter a valid address"
        static let INVALID_CITY_LABEL = "Please enter a valid city"
    }
}
