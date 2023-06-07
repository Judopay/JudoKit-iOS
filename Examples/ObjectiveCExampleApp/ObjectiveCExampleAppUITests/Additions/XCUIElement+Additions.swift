//
//  XCUIElement+Additions.swift
//  ObjectiveCExampleAppUITests
//
//  Copyright © 2023 Judopay. All rights reserved.
//

import XCTest

extension XCUIElement {
    
    var hasFocus: Bool { value(forKey: "hasKeyboardFocus") as? Bool ?? false }

    func clearAndTypeText(_ text: String) {
        
        if let myContent = value as? String, myContent.count > 0 {
            doubleTap()
            typeText(XCUIKeyboardKey.delete.rawValue)
        }
        
        tap()
        typeText(text)
    }

    func tapAndTypeText(_ text: String) {
        tap()
        typeText(text)
    }
    
    func waitUntilExists(timeout: TimeInterval = 600, file: StaticString = #file, line: UInt = #line) -> XCUIElement {
        let elementExists = waitForExistence(timeout: timeout)
        
        if elementExists {
            return self
        } else {
            XCTFail("Could not find \(self) before timeout", file: file, line: line)
        }
        
        return self
    }

}
