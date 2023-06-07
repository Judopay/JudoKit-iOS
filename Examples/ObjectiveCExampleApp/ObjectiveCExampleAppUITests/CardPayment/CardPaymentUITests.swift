//
//  CardPaymentUITests.swift
//  ObjectiveCExampleAppUITests
//
//  Copyright © 2023 Judopay. All rights reserved.
//

import XCTest

final class CardPaymentUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app = XCUIApplication()

        // Settings updates
        UserDefaults.standard.set(true, forKey: "is_sandboxed")
        UserDefaults.standard.set("123456", forKey: "judo_id")
        UserDefaults.standard.set(true, forKey: "is_token_and_secret_on")
        UserDefaults.standard.set("my-secret", forKey: "secret")
        UserDefaults.standard.set("my-token", forKey: "token")
    }

    func testOnValidCardDetailsInputSubmitButtonShouldBeEnabled() {
        app.launch()
        
        app.cellWithIdentifier("Pay with card")?.tap()
        
        app.cardNumberTextField?.tapAndTypeText("4111 1111 1111 1111")
        app.cardholderTextField?.tapAndTypeText("John Doe")
        app.expiryDateTextField?.tapAndTypeText("1125")
        app.securityCodeTextField?.tapAndTypeText("234")
        
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
    }

}
