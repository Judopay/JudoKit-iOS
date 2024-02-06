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
    
    func testPaymentAllowAuthoriseLowValueNoPreference() {
        app.configureRavelin(action: TestData.ALLOW, toa: TestData.AUTHORISE, exemption: TestData.LOW_VALUE, challenge: TestData.NO_PREFERENCE)

        app.ravelinTestSetup()
        
        app.cellWithIdentifier(TestData.PAY_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testPaymentReviewAuthenticateTRAChallenge() {
        app.configureRavelin(action: TestData.REVIEW, toa: TestData.AUTHENTICATE, exemption: TestData.TRA, challenge: TestData.CHALLENGE_REQUESTED)

        app.ravelinTestSetup()
        
        app.cellWithIdentifier(TestData.PAY_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testPaymentPreventAuthoriseLowValueChallengeAsMandate() {
        app.configureRavelin(action: TestData.PREVENT, toa: TestData.AUTHORISE, exemption: TestData.LOW_VALUE, challenge: TestData.NO_PREFERENCE)

        app.ravelinTestSetup()
        
        app.cellWithIdentifier(TestData.PAY_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        assertResultObjectNotDisplayed(app)
    }

    func testPaymentAllowAuthenticateTRANoChallenge() {
        app.configureRavelin(action: TestData.ALLOW, toa: TestData.AUTHENTICATE, exemption: TestData.TRA, challenge: TestData.NO_CHALLENGE)

        app.ravelinTestSetup()
        
        app.cellWithIdentifier(TestData.PAY_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testPaymentPreventAuthenticateTRANoPreference() {
        app.configureRavelin(action: TestData.PREVENT, toa: TestData.AUTHENTICATE, exemption: TestData.TRA, challenge: TestData.NO_PREFERENCE)

        app.ravelinTestSetup()
        
        app.cellWithIdentifier(TestData.PAY_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        assertResultObjectNotDisplayed(app)
    }

    func testPreAuthReviewAuthoriseLowValueChallengeAsMandate() {
        app.configureRavelin(action: TestData.REVIEW, toa: TestData.AUTHORISE, exemption: TestData.LOW_VALUE, challenge: TestData.CHALLENGE_MANDATE)

        app.ravelinTestSetup()
        
        app.cellWithIdentifier(TestData.PREAUTH_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testPreAuthAllowAuthoriseTRANoChallenge() {
        app.configureRavelin(action: TestData.ALLOW, toa: TestData.AUTHORISE, exemption: TestData.TRA, challenge: TestData.NO_CHALLENGE)
        
        app.ravelinTestSetup()
        
        app.cellWithIdentifier(TestData.PREAUTH_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testPreAuthPreventAuthenticateLowValueNoChallenge() {
        app.configureRavelin(action: TestData.PREVENT, toa: TestData.AUTHENTICATE, exemption: TestData.LOW_VALUE, challenge: TestData.NO_CHALLENGE)
        
        app.ravelinTestSetup()
        
        app.cellWithIdentifier(TestData.PREAUTH_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        assertResultObjectNotDisplayed(app)
    }
    
    func testPreAuthReviewAuthoriseTRANoPreference() {
        app.configureRavelin(action: TestData.REVIEW, toa: TestData.AUTHORISE, exemption: TestData.TRA, challenge: TestData.NO_PREFERENCE)
        
        app.ravelinTestSetup()
        
        app.cellWithIdentifier(TestData.PREAUTH_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testPreAuthAllowAuthenticateLowValueChallenge() {
        app.configureRavelin(action: TestData.ALLOW, toa: TestData.AUTHENTICATE, exemption: TestData.LOW_VALUE, challenge: TestData.CHALLENGE_REQUESTED)
        
        app.ravelinTestSetup()
        
        app.cellWithIdentifier(TestData.PREAUTH_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testCheckCardAllowAuthoriseTRAChallengeAsMandate() {
        app.configureRavelin(action: TestData.ALLOW, toa: TestData.AUTHORISE, exemption: TestData.TRA, challenge: TestData.CHALLENGE_MANDATE)
        
        app.ravelinTestSetup()
        
        app.cellWithIdentifier(TestData.CHECK_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        
        assertResultObject(app, "CheckCard", "AuthCode: ", "Success")
    }
    
    func testCheckCardReviewAuthenticateTRANoChallenge() {
        app.configureRavelin(action: TestData.REVIEW, toa: TestData.AUTHENTICATE, exemption: TestData.TRA, challenge: TestData.NO_CHALLENGE)
        
        app.ravelinTestSetup()
        
        app.cellWithIdentifier(TestData.CHECK_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        // Backend overrides CRI to Challenge as Mandate
        tapCompleteButton(app)
        
        assertResultObject(app, "CheckCard", "AuthCode: ", "Success")
    }
    
    func testCheckCardPreventAuthenticateLowValueChallenge() {
        app.configureRavelin(action: TestData.PREVENT, toa: TestData.AUTHENTICATE, exemption: TestData.LOW_VALUE, challenge: TestData.CHALLENGE_REQUESTED)
        
        app.ravelinTestSetup()
        
        app.cellWithIdentifier(TestData.CHECK_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()

        assertResultObjectNotDisplayed(app)
    }
    
    func testCheckCardAllowAuthenticateLowValueNoPreference() {
        app.configureRavelin(action: TestData.ALLOW, toa: TestData.AUTHENTICATE, exemption: TestData.LOW_VALUE, challenge: TestData.NO_PREFERENCE)
        
        app.ravelinTestSetup()
        
        app.cellWithIdentifier(TestData.CHECK_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        // Backend overrides CRI to Challenge as Mandate
        tapCompleteButton(app)
        
        assertResultObject(app, "CheckCard", "AuthCode: ", "Success")
    }
    
    func testCheckCardReviewAuthoriseLowValueChallenge() {
        app.configureRavelin(action: TestData.REVIEW, toa: TestData.AUTHORISE, exemption: TestData.LOW_VALUE, challenge: TestData.CHALLENGE_REQUESTED)
        
        app.ravelinTestSetup()
        
        app.cellWithIdentifier(TestData.CHECK_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        
        assertResultObject(app, "CheckCard", "AuthCode: ", "Success")
    }
}
