//
//  CardPaymentUITests.swift
//  ObjectiveCExampleAppUITests
//
//  Copyright © 2023 Judopay. All rights reserved.
//

import XCTest

final class CardPaymentUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    func fillCardSheetDetails(cardNumber: String, cardHolder: String, expiryDate: String, securityCode: String) {
        app.cardNumberTextField?.tapAndTypeText(cardNumber)
        app.cardholderTextField?.tapAndTypeText(cardHolder)
        app.expiryDateTextField?.tapAndTypeText(expiryDate)
        app.securityCodeTextField?.tapAndTypeText(securityCode)
    }

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app = XCUIApplication()
        
        app.configureSettings()
    }

    func testOnValidCardDetailsInputSubmitButtonShouldBeEnabled() {
        app.launch()
        
        app.cellWithIdentifier(TestData.PAY_WITH_CARD_LABEL)?.tap()
        
        fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
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
        
        fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
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
        
        fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
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
        
        fillCardSheetDetails(cardNumber: "4111 1111 1111 1111",
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
        
        fillCardSheetDetails(cardNumber: TestData.CARD_NUMBER,
                             cardHolder: TestData.CARDHOLDER_NAME,
                             expiryDate: TestData.CARD_EXPIRY,
                             securityCode: TestData.CARD_SECURITY_CODE)
        
        app.cardDetailsSubmitButton?.tap()
        
        let cancelButton = app.buttons["Cancel"]
        XCTAssert(cancelButton.waitForExistence(timeout: 10))
        
        app.cancelButton3DS2?.tap()
        
        //TODO: Assert the toast message
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
    
    completeButton.tap()
    completeButton.tap()
}
