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
        static let cardNumber = "4976 3500 0000 6891"
        static let cardholderName = "Test User"
        static let cardExpiry = "1230"
        static let cardSecurityCode = "341"
        static let wrongCV2 = "123"
        static let fabrickCardholder = "Challenge Required"
        static let masterCardNumber = "5555 5555 5555 4444"
        static let frictionlessCardholder = "Frictionless Successful"
    }
    struct Ravelin {
        static let allow = "ALLOW"
        static let prevent = "PREVENT"
        static let review = "REVIEW"
        static let authorise = "AUTHORISE"
        static let authenticate = "AUTHENTICATE"
        static let tra = "transactionriskanalysis"
        static let lowValue = "lowvalue"
        static let noChallenge = "noChallenge"
        static let noPreference = "nopreference"
        static let challengeMandated = "challengeasmandate"
        static let challengePreferred = "challengepreferred"
    }
    struct BillingInfo {
        static let validEmail = "user@test.com"
        static let validMobile = "07812345678"
        static let validAddress = "235 Regent Street"
        static let validCity = "London"
        static let validPostcode = "W1B 2EL"
        static let validAddressTwo = "West End"
        static let validCountryCode = "826"
        static let invalidPostcode = "38GL112"
        static let specialCharacters = "#$@*"
        static let invalidPostcodeLabel = "Invalid postcode entered"
        static let invalidZipcodeLabel = "Invalid ZIP code entered"
        static let invalidEmailLabel = "Please enter a valid email"
        static let invalidPhoneLabel = "Please enter a valid mobile number"
        static let invalidAddressLabel = "Please enter a valid address"
        static let invalidCityLabel = "Please enter a valid city"
    }
}
