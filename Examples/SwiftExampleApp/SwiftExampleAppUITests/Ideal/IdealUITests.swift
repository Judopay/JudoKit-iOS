//
//  IdealUITests.swift
//  SwiftExampleAppUITests
//
//  Created by Eugene Zhernakov on 19/11/2024.
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
        app.idealNextButton?.tap()
        app.idealLoginButton?.tap()
        app.idealPaymentButton?.tap()
        app.idealBackButton?.tap()
        app.assertIdealResultObject(app, "IDEAL", "SUCCEEDED")
    }
    
    func testCancelIdealTransaction() {
        app.launch()
        app.swipeUp()
        app.cellWithIdentifier(Selectors.FeatureList.paymentMethods)?.tap()
        app.payNowButton?.tap()
        app.idealAbortButton?.tap()
        sleep(3)
        let snackbar = app.staticTexts[Constants.Other.cancelledIdealTransactionAlert]
        XCTAssert(snackbar.exists, "Alert error message not displayed")
    }
}
