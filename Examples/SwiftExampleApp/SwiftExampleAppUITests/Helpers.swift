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

func assertBillingInfo(_ app: XCUIApplication, _ countryCode: String, _ town: String, _ addressOne: String, _ addressTwo: String, _ postCode: String) {
    let tableView = app.tables[Selectors.Other.resultsTable]
    XCTAssert(tableView.waitForExistence(timeout: 10))
    tableView.cells.element(boundBy: 16).tap()

    XCTAssertEqual(tableView.cells.element(matching: .cell, identifier: "countryCode").staticTexts.element(boundBy: 1)
        .label, countryCode, "Country code value on result object does not match the expected string")

    XCTAssertEqual(tableView.cells.element(matching: .cell, identifier: "postCode").staticTexts.element(boundBy: 1)
        .label, postCode, "Postcode value on result object does not match the expected string")

    XCTAssertEqual(tableView.cells.element(matching: .cell, identifier: "address1").staticTexts.element(boundBy: 1)
        .label, addressOne, "Address 1 value on result object does not match the expected string")

    XCTAssertEqual(tableView.cells.element(matching: .cell, identifier: "address2").staticTexts.element(boundBy: 1)
        .label, addressTwo, "Address 2 value on result object does not match the expected string")

    XCTAssertEqual(tableView.cells.element(matching: .cell, identifier: "town").staticTexts.element(boundBy: 1)
        .label, town, "City value on result object does not match the expected string")
}

func tapCompleteButton(_ app: XCUIApplication) {
    let completeButton = app.buttons["COMPLETE"]
    XCTAssert(completeButton.waitForExistence(timeout: 10))

    var retryCount = 0

    // Due to GlobalPay environment, sometimes the page does not proceed with a single tap of the Complete button
    while completeButton.exists && retryCount < 5 {
        if completeButton.isHittable {
            completeButton.tap()
        } else {
            print("Complete button is not tappable.")
            sleep(3)
        }
        retryCount += 1
    }
}

func assertResultObjectNotDisplayed(_ app: XCUIApplication) {
    let tableView = app.tables["Results View"]
    XCTAssertFalse(tableView.waitForExistence(timeout: 3))
}
