//
//  XCUIApplication+Additions.swift
//  ObjectiveCExampleAppUITests
//
//  Copyright © 2023 Judopay. All rights reserved.
//

import XCTest

extension XCUIApplication {
    
    func cellWithIdentifier(_ identifier: String) -> XCUIElement? {
        return cells.matching(identifier: identifier).firstMatch
    }
    
    func textFieldWithIdentifier(_ identifier: String) -> XCUIElement? {
        return otherElements.matching(identifier: identifier).firstMatch
    }

    func buttonWithIdentifier(_ identifier: String) -> XCUIElement? {
        return buttons.matching(identifier: identifier).firstMatch
    }
    
    func buttonWithLabel(_ label: String) -> XCUIElement? {
        return buttons.matching(NSPredicate(format: "label == %@", label)).firstMatch
    }
        
    var cardNumberTextField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.cardNumberField)
        }
    }
    
    var cardholderTextField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.cardHolderNameField)
        }
    }
    
    var expiryDateTextField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.expiryDateField)
        }
    }
    
    var securityCodeTextField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.securityCodeField)
        }
    }
    
    var cardDetailsSubmitButton: XCUIElement? {
        get {
            return buttonWithIdentifier(Selectors.cardDetailsSubmitButtonSelector)
        }
    }
    
    var settingsButton: XCUIElement? {
        get {
            return buttonWithIdentifier(Selectors.settingsSectionButton)
        }
    }
    
    var cancelButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.cancelCardEntryButton)
        }
    }
    
    var cancelButton3DS2: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.threeDS2CancelButton)
        }
    }
    
    var tokenizeNewCardButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.tokenizeNewCardButtonSelector)
        }
    }
    
    var tokenPaymentButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.tokenPaymentButtonSelector)
        }
    }
    
    var tokenPreauthButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.tokenPreAuthButton)
        }
    }
    
    var addCard: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.addNewCardButton)
        }
    }
    
    var payNowButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.payNowButtonSelector)
        }
    }
    
    var editCardsButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.editCardsButtonSelector)
        }
    }
    
    var deleteCardButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.deleteCardButtonSelector)
        }
    }
    
    func configureSettings() {
        let judoID = ProcessInfo.processInfo.environment["TEST_API_JUDO_ID"]
        let apiToken = ProcessInfo.processInfo.environment["TEST_API_TOKEN"]
        let apiSecret = ProcessInfo.processInfo.environment["TEST_API_SECRET"]
        
        launchArguments += ["-judo_id", judoID ?? "",
                            "-token", apiToken ?? "",
                            "-secret", apiSecret ?? "",
                            "-is_sandboxed", "true",
                            "-is_token_and_secret_on", "true",
                            "-should_ask_for_billing_information", "false",
                            "-challenge_request_indicator", "challengeAsMandate"]
    }
    
    func fillCardSheetDetails(cardNumber: String, cardHolder: String, expiryDate: String, securityCode: String) {
        cardNumberTextField?.tapAndTypeText(cardNumber)
        cardholderTextField?.tapAndTypeText(cardHolder)
        expiryDateTextField?.tapAndTypeText(expiryDate)
        securityCodeTextField?.tapAndTypeText(securityCode)
    }
}
