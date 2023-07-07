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
            return textFieldWithIdentifier("Card Number Field")
        }
    }
    
    var cardholderTextField: XCUIElement? {
        get {
            return textFieldWithIdentifier("Cardholder Name Field")
        }
    }
    
    var expiryDateTextField: XCUIElement? {
        get {
            return textFieldWithIdentifier("Expiry Date Field")
        }
    }
    
    var securityCodeTextField: XCUIElement? {
        get {
            return textFieldWithIdentifier("Security Code Field")
        }
    }
    
    var cardDetailsSubmitButton: XCUIElement? {
        get {
            return buttonWithIdentifier("Submit Button")
        }
    }
    
    var settingsButton: XCUIElement? {
        get {
            return buttonWithIdentifier("Settings Button")
        }
    }
    
    var cancelButton: XCUIElement? {
        get {
            return buttonWithLabel("CANCEL")
        }
    }
    
    var cancelButton3DS2: XCUIElement? {
        get {
            return buttonWithLabel("Cancel")
        }
    }
    
    func configureSettings() {
        launchArguments += ["-judo_id", "judo_id",
                            "-token", "token",
                            "-secret", "secret",
                            "-is_sandboxed", "true",
                            "-is_token_and_secret_on", "true",
                            "-should_ask_for_billing_information", "false"]
    }
}
