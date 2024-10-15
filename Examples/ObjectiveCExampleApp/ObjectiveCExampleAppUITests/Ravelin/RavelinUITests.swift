//
//  RavelinUITests.swift
//  ObjectiveCExampleAppUITests
//
//  Created by Eugene Zhernakov on 30/01/2024.
//  Copyright © 2024 Judopay. All rights reserved.
//

import XCTest

final class RavelinUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        
        app.configureSettings(isRavelinTest: true)
        
        addUIInterruptionMonitor(withDescription: "System Dialog") { (alert) -> Bool in
            alert.buttons["Allow While Using App"].tap()
            return true
        }
    }
    
    func testPreventTransaction() {
        app.configureRavelin(suffix: "7")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        assertNoRequestToJudoAPI(app)
    }
    
    func testReviewWithChallengeTransaction() {
        app.configureRavelin(suffix: "25")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertRequestBody(app, cri: TestData.Ravelin.CHALLENGE_PREFERRED, sca: TestData.Ravelin.LOW_VALUE)
    }
    
    func testAllowNoPreferenceTransaction() {
        app.configureRavelin(suffix: "19")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        assertRequestBody(app, cri: TestData.Ravelin.NO_PREFERENCE, sca: TestData.Ravelin.TRA)
    }
    
    func testReviewNoChallengeTransaction() {
        app.configureRavelin(suffix: "24")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        assertRequestBody(app, cri: TestData.Ravelin.NO_CHALLENGE, sca: TestData.Ravelin.LOW_VALUE)
    }
}
