//
//  Helpers.swift
//  ObjectiveCExampleAppUITests
//
//  Created by Eugene Zhernakov on 18/10/2023.
//  Copyright © 2023 Judopay. All rights reserved.
//

import Foundation
import XCTest

func assertResultObject(_ app: XCUIApplication, _ type: String, _ message: String, _ result: String) {
    let tableView = app.tables[Selectors.Other.resultsTable]
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
    XCTAssert(completeButton.waitForExistence(timeout: 30))
        
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

func openWormholy(_ app: XCUIApplication) {
    app.wormholyButton?.tap()
}

func assertRequestBody(_ app: XCUIApplication, cri: String, sca: String, criShouldExist: Bool = true, scaShouldExist: Bool = true) {
    openRequestBodyContents(app)
    
    let challengeRequestIndicator = app.textViews.matching(NSPredicate(format: "value CONTAINS[cd] %@", cri)).firstMatch
    if criShouldExist {
        XCTAssertTrue(challengeRequestIndicator.exists, "Expected challengeRequestIndicator to exist, but it does not.")
    } else {
        XCTAssertFalse(challengeRequestIndicator.exists, "Expected challengeRequestIndicator to NOT exist, but it does.")
    }

    let scaExemption = app.textViews.matching(NSPredicate(format: "value CONTAINS[cd] %@", sca)).firstMatch
    if scaShouldExist {
        XCTAssertTrue(scaExemption.exists, "Expected scaExemption to exist, but it does not.")
    } else {
        XCTAssertFalse(scaExemption.exists, "Expected scaExemption to NOT exist, but it does.")
    }
}



func typeIntoSearchField(_ app: XCUIApplication, query: String) {
    let searchField = app.searchFields.firstMatch
    if searchField.exists {
        searchField.tap()
        searchField.typeText(query)
    } else {
        print("Search field not found.")
    }
    
    let doneButton = app.keyboards.buttons["Done"]
    
    if doneButton.exists {
        doneButton.tap()
    } else {
        print("Done button not found on keyboard.")
    }
}

func openRequestBodyContents(_ app: XCUIApplication) {
    let tableView = app.tables[Selectors.Other.resultsTable]
    XCTAssert(tableView.waitForExistence(timeout: 10))
    
    app.dismissLabel?.tap()
    openWormholy(app)
    
    let collectionView = XCUIApplication().collectionViews.firstMatch
    XCTAssert(collectionView.waitForExistence(timeout: 10))
    
    collectionView.swipeUp()
    app.paymentRequestLabel?.tap()
    app.viewRequestBodyLabel?.tap()
    app.searchButton?.tap()
    typeIntoSearchField(app, query: Selectors.Other.requestBodySearchTerm)
}

func assertNoRequestToJudoAPI(_ app: XCUIApplication) {
    openWormholy(app)
    guard let paymentRequestLabel = app.paymentRequestLabel else {
        return
    }
    XCTAssertFalse(paymentRequestLabel.exists)
}
