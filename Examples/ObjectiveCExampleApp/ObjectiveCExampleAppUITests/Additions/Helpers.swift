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
    
    // Due to GlobalPay environment, sometimes the page does not proceed with a single tap of the Complete button
    while completeButton.exists && retryCount < 2 {
        completeButton.tap()
        retryCount += 1
    }
    
    if !completeButton.exists {
        XCTFail("Failed to tap Complete button after \(retryCount) attempts.")
    }
}
