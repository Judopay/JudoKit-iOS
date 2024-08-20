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
    
    func testIncompleteResponseID1() {
        app.configureRavelin(suffix: "1")
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
    
    func testIncompleteResponseID2() {
        app.configureRavelin(suffix: "2")
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
    
    func testIncompleteResponseID3() {
        app.configureRavelin(suffix: "3")
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
    
    func testIncompleteResponseID4() {
        app.configureRavelin(suffix: "4")
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
    
    func testIncompleteResponseID5() {
        app.configureRavelin(suffix: "5")
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
    
    func testIncompleteResponseID6() {
        app.configureRavelin(suffix: "6")
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
    
    func testAllFieldsProvidedResponseID7() {
        app.configureRavelin(suffix: "7")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        assertResultObjectNotDisplayed(app)
    }
    
    func testAllFieldsProvidedResponseID8() {
        app.configureRavelin(suffix: "8")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        assertResultObjectNotDisplayed(app)
    }
    
    func testAllFieldsProvidedResponseID9() {
        app.configureRavelin(suffix: "9")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        assertResultObjectNotDisplayed(app)
    }
    
    func testAllFieldsProvidedResponseID10() {
        app.configureRavelin(suffix: "10")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        assertResultObjectNotDisplayed(app)
    }
    
    func testAllFieldsProvidedResponseID11() {
        app.configureRavelin(suffix: "11")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        assertResultObjectNotDisplayed(app)
    }
    
    func testAllFieldsProvidedResponseID12() {
        app.configureRavelin(suffix: "12")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        assertResultObjectNotDisplayed(app)
    }
    
    func testAllFieldsProvidedResponseID13() {
        app.configureRavelin(suffix: "13")
        app.ravelinTestSetup()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        assertResultObjectNotDisplayed(app)
    }
}
