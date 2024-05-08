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
        app.configureRavelin(action: TestData.Ravelin.ALLOW, toa: TestData.Ravelin.AUTHORISE, exemption: TestData.Ravelin.LOW_VALUE, challenge: TestData.Ravelin.NO_PREFERENCE)
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testPaymentReviewAuthenticateTRAChallenge() {
        app.configureRavelin(action: TestData.Ravelin.REVIEW, toa: TestData.Ravelin.AUTHENTICATE, exemption: TestData.Ravelin.TRA, challenge: TestData.Ravelin.CHALLENGE_REQUESTED)
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testPaymentPreventAuthoriseLowValueChallengeAsMandate() {
        app.configureRavelin(action: TestData.Ravelin.PREVENT, toa: TestData.Ravelin.AUTHORISE, exemption: TestData.Ravelin.LOW_VALUE, challenge: TestData.Ravelin.NO_PREFERENCE)
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        assertResultObjectNotDisplayed(app)
    }

    func testPaymentAllowAuthenticateTRANoChallenge() {
        app.configureRavelin(action: TestData.Ravelin.ALLOW, toa: TestData.Ravelin.AUTHENTICATE, exemption: TestData.Ravelin.TRA, challenge: TestData.Ravelin.NO_CHALLENGE)
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testPaymentPreventAuthenticateTRANoPreference() {
        app.configureRavelin(action: TestData.Ravelin.PREVENT, toa: TestData.Ravelin.AUTHENTICATE, exemption: TestData.Ravelin.TRA, challenge: TestData.Ravelin.NO_PREFERENCE)
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        assertResultObjectNotDisplayed(app)
    }

    func testPreAuthReviewAuthoriseLowValueChallengeAsMandate() {
        app.configureRavelin(action: TestData.Ravelin.REVIEW, toa: TestData.Ravelin.AUTHORISE, exemption: TestData.Ravelin.LOW_VALUE, challenge: TestData.Ravelin.CHALLENGE_MANDATE)
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.preAuthWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testPreAuthAllowAuthoriseTRANoChallenge() {
        app.configureRavelin(action: TestData.Ravelin.ALLOW, toa: TestData.Ravelin.AUTHORISE, exemption: TestData.Ravelin.TRA, challenge: TestData.Ravelin.NO_CHALLENGE)
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.preAuthWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testPreAuthPreventAuthenticateLowValueNoChallenge() {
        app.configureRavelin(action: TestData.Ravelin.PREVENT, toa: TestData.Ravelin.AUTHENTICATE, exemption: TestData.Ravelin.LOW_VALUE, challenge: TestData.Ravelin.NO_CHALLENGE)
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.preAuthWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        assertResultObjectNotDisplayed(app)
    }
    
    func testPreAuthReviewAuthoriseTRANoPreference() {
        app.configureRavelin(action: TestData.Ravelin.REVIEW, toa: TestData.Ravelin.AUTHORISE, exemption: TestData.Ravelin.TRA, challenge: TestData.Ravelin.NO_PREFERENCE)
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.preAuthWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testPreAuthAllowAuthenticateLowValueChallenge() {
        app.configureRavelin(action: TestData.Ravelin.ALLOW, toa: TestData.Ravelin.AUTHENTICATE, exemption: TestData.Ravelin.LOW_VALUE, challenge: TestData.Ravelin.CHALLENGE_REQUESTED)
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.preAuthWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testCheckCardAllowAuthoriseTRAChallengeAsMandate() {
        app.configureRavelin(action: TestData.Ravelin.ALLOW, toa: TestData.Ravelin.AUTHORISE, exemption: TestData.Ravelin.TRA, challenge: TestData.Ravelin.CHALLENGE_MANDATE)
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.checkCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "CheckCard", "AuthCode: ", "Success")
    }
    
    func testCheckCardReviewAuthenticateTRANoChallenge() {
        app.configureRavelin(action: TestData.Ravelin.REVIEW, toa: TestData.Ravelin.AUTHENTICATE, exemption: TestData.Ravelin.TRA, challenge: TestData.Ravelin.NO_CHALLENGE)
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.checkCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        // Backend overrides CRI to Challenge as Mandate
        tapCompleteButton(app)
        assertResultObject(app, "CheckCard", "AuthCode: ", "Success")
    }
    
    func testCheckCardPreventAuthenticateLowValueChallenge() {
        app.configureRavelin(action: TestData.Ravelin.PREVENT, toa: TestData.Ravelin.AUTHENTICATE, exemption: TestData.Ravelin.LOW_VALUE, challenge: TestData.Ravelin.CHALLENGE_REQUESTED)
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.checkCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        assertResultObjectNotDisplayed(app)
    }
    
    func testCheckCardAllowAuthenticateLowValueNoPreference() {
        app.configureRavelin(action: TestData.Ravelin.ALLOW, toa: TestData.Ravelin.AUTHENTICATE, exemption: TestData.Ravelin.LOW_VALUE, challenge: TestData.Ravelin.NO_PREFERENCE)
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.checkCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        // Backend overrides CRI to Challenge as Mandate
        tapCompleteButton(app)
        assertResultObject(app, "CheckCard", "AuthCode: ", "Success")
    }
    
    func testCheckCardReviewAuthoriseLowValueChallenge() {
        app.configureRavelin(action: TestData.Ravelin.REVIEW, toa: TestData.Ravelin.AUTHORISE, exemption: TestData.Ravelin.LOW_VALUE, challenge: TestData.Ravelin.CHALLENGE_REQUESTED)
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.checkCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "CheckCard", "AuthCode: ", "Success")
    }
}
