//
//  IdealUITests.swift
//  ObjectiveCExampleAppUITests
//
//  Created by Eugene Zhernakov on 18/11/2024.
//  Copyright © 2024 Judopay. All rights reserved.
//

import XCTest

final class IdealUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.configureSettings(isRavelinTest: false, isIdealTest: true)
        addUIInterruptionMonitor(withDescription: "System Dialog") { (alert) -> Bool in
            alert.buttons["Allow While Using App"].tap()
            return true
        }
    }
    
    func testSuccessfulIdealTransaction() {
        app.launch()
        app.swipeUp()
        app.cellWithIdentifier(Selectors.FeatureList.paymentMethods)?.tap()
        app.payNowButton?.tap()
        let nextButton = app.buttons[Selectors.Ideal.nextButton]
        nextButton.tap()
        let loginButton = app.buttons[Selectors.Ideal.loginButton]
        loginButton.tap()
        let paymentButton = app.buttons[Selectors.Ideal.makePaymentButton]
        paymentButton.tap()
        let backToAppButton = app.buttons[Selectors.Ideal.backButton]
        backToAppButton.tap()
        assertIdealResultObject(app, "IDEAL", "SUCCEEDED")
    }
    
    func testCancelIdealTransaction() {
        app.launch()
        app.swipeUp()
        app.cellWithIdentifier(Selectors.FeatureList.paymentMethods)?.tap()
        app.payNowButton?.tap()
        let abortButton = app.buttons[Selectors.Ideal.abortButton]
        abortButton.tap()
        sleep(3)
        let snackbar = app.staticTexts[TestData.Other.IDEAL_CANCELLED_PAYMENT_ALERT]
        XCTAssert(snackbar.exists, "Alert error message not displayed")
    }
}
