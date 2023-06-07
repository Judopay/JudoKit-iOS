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
    
}
