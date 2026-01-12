//
//  Fabrick3DSTests.swift
//  ObjectiveCExampleAppUITests
//
//  Created by Eugene Zhernakov on 08/10/2025.
//  Copyright © 2025 Judopay. All rights reserved.
//

import XCTest

final class Fabrick3DSTests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.configureSettings(isRavelinTest: false, isFabrickTest: true)
        addUIInterruptionMonitor(withDescription: "System Dialog") { (alert) -> Bool in
            alert.buttons["Allow While Using App"].tap()
            return true
        }
    }
    
    func testFabrick3DS2VisaFlow() {
        app.launchArguments += ["-is_using_fabrick_3ds_service", "true", "-is_sandboxed", "false"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.FABRICK_CARDHOLDER,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapPayNowButton(app)
        fill3DS2Code(app, "12345")
        tapCompleteButton(app, true)
        assertResultObject(app, "Payment", "AuthCode: ", "Success", true)
    }
    
    func testFabrickMCFrictionlessFlow() {
        app.launchArguments += ["-is_using_fabrick_3ds_service", "true", "-is_sandboxed", "false", "-challenge_request_indicator", "noPreference"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.MC_CARD_NUMBER,
                             cardHolder: TestData.CardDetails.FRICTIONLESS_CARDHOLDER,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapPayNowButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success", true)
    }
}
