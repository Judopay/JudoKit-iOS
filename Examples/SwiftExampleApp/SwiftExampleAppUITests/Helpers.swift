//
//  Helpers.swift
//  SwiftExampleAppUITests
//
//  Created by Eugene Zhernakov on 19/09/2024.
//  Copyright © 2024 Judopay. All rights reserved.
//

import Foundation
import XCTest

func assertResultObject(_ app: XCUIApplication, _ type: String, _ message: String, _ result: String) {
    let tableView = app.tables[Selectors.Other.resultsTable]
    XCTAssert(tableView.waitForExistence(timeout: 10))
    let rawData = app.textWithIdentifier("rawData")
    rawData?.tap()

    let receiptIdCell = app.textWithIdentifier(Selectors.ResultsView.receiptIdValue)
    XCTAssertFalse(receiptIdCell!.label.isEmpty, "ReceiptId is empty")

    let typeCell = app.textWithIdentifier(Selectors.ResultsView.typeValue)
    XCTAssertEqual(typeCell!.label, type, "Type value on result object does not match the expected string")

    let messageCell = app.textWithIdentifier(Selectors.ResultsView.messageValue)
    XCTAssertTrue(messageCell!.label.hasPrefix(message), "Message value on result object does not start with the expected string")

    let resultCell = app.textWithIdentifier(Selectors.ResultsView.resultValue)
    XCTAssertEqual(resultCell!.label, result, "Result value on result object does not match the expected string")
}

func assertBillingInfo(_ app: XCUIApplication, _ town: String, _ addressOne: String, _ addressTwo: String, _ postCode: String) {
    let tableView = app.tables[Selectors.Other.resultsTable]
    XCTAssert(tableView.waitForExistence(timeout: 10))
    let rawData = app.textWithIdentifier("rawData")
    rawData?.tap()

    let billingAddress = app.textWithIdentifier("billingAddress")
    billingAddress?.tap()

//  Commented out until CT-2991 is fixed
//  let countryCodeCell = app.textWithIdentifier(Selectors.ResultsView.countryCodeValue)
//  XCTAssertEqual(countryCodeCell!.label, countryCode, "Country code value on result object does not match the expected string")

    let postCodeCell = app.textWithIdentifier(Selectors.ResultsView.postCodeValue)
    XCTAssertEqual(postCodeCell!.label, postCode, "Postcode value on result object does not match the expected string")

    let adddressOneCell = app.textWithIdentifier(Selectors.ResultsView.addressOneValue)
    XCTAssertEqual(adddressOneCell!.label, addressOne, "Address 1 value on result object does not match the expected string")

    let adddressTwoCell = app.textWithIdentifier(Selectors.ResultsView.addressTwoValue)
    XCTAssertEqual(adddressTwoCell!.label, addressTwo, "Address 2 value on result object does not match the expected string")

    let cityCell = app.textWithIdentifier(Selectors.ResultsView.townValue)
    XCTAssertEqual(cityCell!.label, town, "City value on result object does not match the expected string")
}

func tapCompleteButton(_ app: XCUIApplication) {
    let completeButton = app.buttons["COMPLETE"]
    XCTAssert(completeButton.waitForExistence(timeout: 30))

    sleep(10)

    completeButton.tap()
}

func assertResultObjectNotDisplayed(_ app: XCUIApplication) {
    let tableView = app.tables["Results View"]
    XCTAssertFalse(tableView.waitForExistence(timeout: 3))
}

func validateBillingInfoFields(_ app: XCUIApplication) {
    app.emailField?.tapAndTypeText(Constants.BillingInfo.specialCharacters)
    app.addressLineOne?.tap()
    XCTAssertEqual(app.fieldErrorLabel, Constants.BillingInfo.invalidEmailLabel, Constants.AssertionMessages.emailAddress)
    XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
    app.clearTextFieldByIndex(index: 0)

    app.mobileField?.tapAndTypeText(Constants.BillingInfo.specialCharacters)
    app.emailField?.tap()
    XCTAssertEqual(app.fieldErrorLabel, Constants.BillingInfo.invalidPhoneLabel, Constants.AssertionMessages.phoneNumber)
    XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
    app.clearTextFieldByIndex(index: 6)

    app.addressLineOne?.tapAndTypeText(Constants.BillingInfo.specialCharacters)
    app.emailField?.tap()
    XCTAssertEqual(app.fieldErrorLabel, Constants.BillingInfo.invalidAddressLabel, Constants.AssertionMessages.addressLine)
    XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
    app.clearTextFieldByIndex(index: 2)

    app.cityField?.tapAndTypeText(Constants.BillingInfo.specialCharacters)
    app.emailField?.tap()
    XCTAssertEqual(app.fieldErrorLabel, Constants.BillingInfo.invalidCityLabel, Constants.AssertionMessages.cityInput)
    XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
    app.clearTextFieldByIndex(index: 3)

    app.postCodeField?.tapAndTypeText(Constants.BillingInfo.specialCharacters)
    app.emailField?.tap()
    XCTAssertEqual(app.fieldErrorLabel, Constants.BillingInfo.invalidPostcodeLabel, Constants.AssertionMessages.postCode)
    XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
    app.clearTextFieldByIndex(index: 4)
}

func waitForElementToBeHittable(element: XCUIElement, timeout: TimeInterval = 10) -> Bool {
    return element.waitForExistence(timeout: timeout) && element.isHittable
}

func tapPaymentMethodsPayNowButton(_ app: XCUIApplication) {
    if waitForElementToBeHittable(element: app.payNowButton!) {
        app.payNowButton?.tap()
    } else {
        XCTFail("Pay now button is not hittable")
    }
}
