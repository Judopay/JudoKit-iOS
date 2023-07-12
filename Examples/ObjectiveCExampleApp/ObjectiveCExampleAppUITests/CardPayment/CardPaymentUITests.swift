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
        
        //TODO: Assert the toast message
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
        
        assertResultObject(app, "Payment", "3D secure authorisation declined", "Declined")
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
        
        //TODO: Assert the toast message
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
        
        //TODO: Assert the toast message
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
}

func assertResultObject(_ app: XCUIApplication, _ type: String, _ message: String, _ result: String) {
    let tableView = app.tables["Results View"]
    XCTAssert(tableView.waitForExistence(timeout: 10))
    let rawData = tableView.cells.element(boundBy: 15)
    rawData.tap()

    let receiptIdCell = tableView.cells.element(matching: .cell, identifier: "receiptId")
    let receiptIdValue = receiptIdCell.staticTexts.element(boundBy: 1).label
    XCTAssert(!receiptIdValue.isEmpty, "ReceiptId is empty")
    
    let typeCell = tableView.cells.element(matching: .cell, identifier: "type")
    let typeValue = typeCell.staticTexts.element(boundBy: 1).label
    XCTAssertEqual(typeValue, type, "Type value on result object does not match the expected string")

    let messageCell = tableView.cells.element(matching: .cell, identifier: "message")
    let messageValue = messageCell.staticTexts.element(boundBy: 1).label
    XCTAssertTrue(messageValue.hasPrefix(message), "Message value on result object does not start with the expected string")

    let resultCell = tableView.cells.element(matching: .cell, identifier: "result")
    let resultValue = resultCell.staticTexts.element(boundBy: 1).label
    XCTAssertEqual(resultValue, result, "Result value on result object does not match the expected string")
}

func tapCompleteButton(_ app: XCUIApplication) {
    let completeButton = app.buttons["COMPLETE"]
    XCTAssert(completeButton.waitForExistence(timeout: 10))
        
    var retryCount = 0
    
    while completeButton.exists && retryCount < 2 {
        completeButton.tap()
        retryCount += 1
    }
    
    if !completeButton.exists {
        XCTFail("Failed to tap Complete button after \(retryCount) attempts.")
    }
}
