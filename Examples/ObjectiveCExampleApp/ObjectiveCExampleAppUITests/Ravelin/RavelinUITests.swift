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
        
        app.configureSettings(isRavelinTest: true, isIdealTest: false)
        
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
    
    func testAllowChallengeAsMandateTransaction() {
        app.configureRavelin(suffix: "18")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertRequestBody(app, cri: TestData.Ravelin.CHALLENGE_MANDATE, sca: TestData.Ravelin.LOW_VALUE)
    }
    
    func testWithoutSendingCRITransaction() {
        app.configureRavelin(suffix: "35")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        assertRequestBody(app, cri: TestData.Ravelin.CHALLENGE_MANDATE, sca: TestData.Ravelin.LOW_VALUE, criShouldExist: false)
    }
    
    func testWithoutSendingSCATransaction() {
        app.configureRavelin(suffix: "60")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        assertRequestBody(app, cri: TestData.Ravelin.NO_CHALLENGE, sca: TestData.Ravelin.TRA, scaShouldExist: false)
    }
    
    func testWithoutSendingSCAAndCRITransaction() {
        app.configureRavelin(suffix: "71")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertRequestBody(app, cri: TestData.Ravelin.NO_CHALLENGE, sca: TestData.Ravelin.TRA, criShouldExist: false, scaShouldExist: false)
    }
    
    func testUsingSDKConfigTransaction() {
        app.configureRavelin(suffix: "78")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertRequestBody(app, cri: TestData.Ravelin.NO_CHALLENGE, sca: TestData.Ravelin.TRA, criShouldExist: false, scaShouldExist: false)
    }
    
    func testPreventWithEmptyObjectTransaction() {
        app.configureRavelin(suffix: "67")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        assertNoRequestToJudoAPI(app)
    }
    
    func testHaltTransactionUponErrorSwitch() {
        app.configureRavelin(suffix: "5")
        app.ravelinTestSetup()
        app.settingsButton?.tap()
        app.haltTransactionSwitch?.tap()
        app.backButton?.tap()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        assertNoRequestToJudoAPI(app)
    }
}
