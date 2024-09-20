//
//  CardPaymentUITests.swift
//  SwiftExampleAppUITests
//
//  Created by Eugene Zhernakov on 19/09/2024.
//  Copyright © 2024 Judopay. All rights reserved.
//

import XCTest

final class CardPaymentUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.configureSettings(isRavelinTest: false)
        addUIInterruptionMonitor(withDescription: "System Dialog") { (alert) -> Bool in
            alert.buttons["Allow While Using App"].tap()
            return true
        }
    }

    func testSuccessfulTransaction() {
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: Constants.CardDetails.cardNumber,
                             cardHolder: Constants.CardDetails.cardHolderName,
                             expiryDate: Constants.CardDetails.cardExpiry,
                             securityCode: Constants.CardDetails.cardSecurityCode)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
}
