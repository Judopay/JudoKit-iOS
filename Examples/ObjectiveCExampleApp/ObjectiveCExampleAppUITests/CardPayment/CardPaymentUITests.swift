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
        
        app.configureSettings()
        
        addUIInterruptionMonitor(withDescription: "System Dialog") { (alert) -> Bool in
            alert.buttons["Allow While Using App"].tap()
            return true
        }
    }

    func testOnValidCardDetailsInputSubmitButtonShouldBeEnabled() {
        app.launch()
        
        app.cellWithIdentifier(TestData.PAY_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
    }
    
    func testCancelledTransactionErrorPopupShouldBeDisplayed() {
        app.launch()
        
        app.cellWithIdentifier(TestData.PAY_WITH_CARD_LABEL)?.tap()
        
        app.cancelButton?.tap()
        
        let snackbar = app.buttonWithLabel(TestData.CANCELLED_PAYMENT_TOAST)
        XCTAssert(snackbar!.exists, "Snackbar message not displayed")
    }
    
    func testSuccessfulTransactionReceiptObjectShouldContainRelevantInfo() {
        app.launch()
        
        app.cellWithIdentifier(TestData.PAY_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
    
        tapCompleteButton(app)
        
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testDeclinedTransactionReceiptObjectShouldContainRelevantInfo() {
        app.launch()
        
        app.cellWithIdentifier(TestData.PAY_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: "123")
        
        app.cardDetailsSubmitButton?.tap()
    
        tapCompleteButton(app)
        
        assertResultObject(app, "Payment", "Card declined: CV2 policy", "Declined")
    }

    func testFailedTransactionReceiptObjectShouldContainRelevantInfo() {
        app.launch()
        
        app.cellWithIdentifier(TestData.PAY_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: "4111 1111 1111 1111",
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: "123")
        
        app.cardDetailsSubmitButton?.tap()
    
        tapCompleteButton(app)
        
        assertResultObject(app, "Payment", "The gateway reported an error", "Error")
    }
    
    func testCancel3DS2ChallengeScreenErrorPopupShouldBeDisplayed() {
        app.launch()
        
        app.cellWithIdentifier(TestData.PAY_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        let cancelButton = app.buttons["Cancel"]
        XCTAssert(cancelButton.waitForExistence(timeout: 10))
        
        app.cancelButton3DS2?.tap()
    }
    
    func testSuccessfulPreauthTransactionReceiptObjectContainsRelevantInfo() {
        app.launch()
        
        app.cellWithIdentifier(TestData.PREAUTH_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
    
        tapCompleteButton(app)
        
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testSuccessfulRegisterCardTransactionReceiptObjectContainsRelevantInfo() {
        app.launch()
        
        app.cellWithIdentifier(TestData.REGISTER_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
    
        tapCompleteButton(app)
        
        assertResultObject(app, "Register", "AuthCode: ", "Success")
    }
    
    func testSuccessfulCheckCardTransactionReceiptObjectContainsRelevantInfo() {
        app.launch()
        
        app.cellWithIdentifier(TestData.CHECK_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
    
        tapCompleteButton(app)
        
        assertResultObject(app, "CheckCard", "AuthCode: ", "Success")
    }
    
    func testSuccessfulTokenPaymentReceiptObjectContainsRelevantInfo() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        
        app.launch()
        
        app.cellWithIdentifier(TestData.TOKEN_PAYMENTS_LABEL)?.tap()
        
        app.tokenizeNewCardButton?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        app.tokenPaymentButton?.tap()
        
        app.securityCodeTextField?.tapAndTypeText(TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
    
        tapCompleteButton(app)
        
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testSuccessfulTokenPreauthReceiptObjectContainsRelevantInfo() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        
        app.launch()
        
        app.cellWithIdentifier(TestData.TOKEN_PAYMENTS_LABEL)?.tap()
        
        app.tokenizeNewCardButton?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        app.tokenPreauthButton?.tap()
        
        app.securityCodeTextField?.tapAndTypeText(TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
    
        tapCompleteButton(app)
        
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testSuccessfulFrictionlessPaymentReceiptObjectContainsRelevantInfo() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference"]
        
        app.launch()
        
        app.cellWithIdentifier(TestData.PAY_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: "Frictionless Successful",
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testFrictionlessNoMethodPaymentReceiptObjectContainsRelevantInfo() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference"]
        
        app.launch()
        
        app.cellWithIdentifier(TestData.PAY_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: "Frictionless NoMethod",
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testFrictionlessAuthFailedPaymentReceiptObjectContainsRelevantInfo() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference"]
        
        app.launch()
        
        app.cellWithIdentifier(TestData.PAY_WITH_CARD_LABEL)?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: "Frictionless AuthFailed",
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
    }
    
    func testSuccessfulPaymentMethodsCardPaymentReceiptObjectContainsRelevantInfo() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        
        app.launch()
        
        app.cellWithIdentifier(TestData.PAYMENT_METHODS_LABEL)?.tap()
        
        app.addCard?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        app.payNowButton?.tap()
        
        app.securityCodeTextField?.tapAndTypeText(TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        tapCompleteButton(app)
        
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testSuccessfulPreauthMethodsCardPaymentReceiptObjectContainsRelevantInfo() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        
        app.launch()
        
        app.cellWithIdentifier(TestData.PREAUTH_METHODS_LABEL)?.tap()
        
        app.addCard?.tap()
        
        app.fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        app.payNowButton?.tap()
        
        app.securityCodeTextField?.tapAndTypeText(TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        tapCompleteButton(app)
        
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testRemoveCardOnPaymentMethods() {
        app.launch()
        
        app.cellWithIdentifier(TestData.PAYMENT_METHODS_LABEL)?.tap()
        
        app.addCard?.tap()
        
        app.fillCardSheetDetails(cardNumber: "4222 0000 0122 7408",
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        let newCard = app.staticTexts["Visa Ending 7408 "]
        XCTAssert(newCard.waitForExistence(timeout: 5), "Unable to add a new card")
        
        newCard.swipeLeft()
        
        app.deleteCardButton?.tap()
        
        app.deleteCardButton?.tap()
        
        XCTAssertFalse(newCard.waitForExistence(timeout: 5), "Unable to delete card")
    }
}
