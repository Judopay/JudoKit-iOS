//
//  Constants.swift
//  SwiftExampleAppUITests
//
//  Created by Eugene Zhernakov on 19/09/2024.
//  Copyright © 2024 Judopay. All rights reserved.
//

import Foundation

class Constants {
    struct CardDetails {
        static let cardNumber = "4976 3500 0000 6891"
        static let cardHolderName = "Challenge Required"
        static let cardExpiry = "1225"
        static let cardSecurityCode = "341"
        static let wrongCV2 = "123"
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
        static let invalidZIPCodeLabel = "Invalid ZIP code entered"
        static let invalidEmailLabel = "Please enter a valid email"
        static let invalidPhoneLabel = "Please enter a valid mobile number"
        static let invalidAddressLabel = "Please enter a valid address"
        static let invalidCityLabel = "Please enter a valid city"
    }
    struct Other {
        static let cancelledPaymentToast = "The transaction was cancelled by the user."
        static let cancelled3DS2Toast = "Unable to process transaction. Card authentication failed with 3DS Server."
    }
}
