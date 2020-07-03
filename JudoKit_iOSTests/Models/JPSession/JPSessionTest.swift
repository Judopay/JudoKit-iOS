//
//  JPSessionTest.swift
//  JudoKit_iOSTests
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import XCTest
@testable import JudoKit_iOS

class JPSessionTest: XCTestCase {
    
    /*
     * GIVEN: Creating JPSession designated init
     *
     * WHEN: populating with auth_header and not sandbox
     *
     * THEN: should create correct fields in JPSession object
     */
    func test_JPSession_WhenNotSandBox_ShouldCreateObject() {
        let session = JPSession(authorizationHeader: "auth_header")
        XCTAssertEqual(session.authorizationHeader, "auth_header")
        XCTAssertEqual(session.baseURL, "https://api.judopay.com/")
        XCTAssertFalse(session.uiClientMode)
        XCTAssertFalse(session.sandboxed)
    }
    
    /*
     * GIVEN: Creating JPSession designated init
     *
     * WHEN: populating with dictionary and sandbox
     *
     * THEN: should create correct fields in JPSession object
     */
    func test_JPSession_WhenSandBox_ShouldCreateObject() {
        let session = JPSession(authorizationHeader: "auth_header")
        session.sandboxed = true
        XCTAssertEqual(session.baseURL, "https://api-sandbox.judopay.com/")
        XCTAssertTrue(session.sandboxed)
    }
    
    /*
     * GIVEN: Creating JPSession class init
     *
     * WHEN: populating with dictionary
     *
     * THEN: should create correct fields in JPSession object
     */
    func test_JPSession_WhenClassInitAndNotSandBox_ShouldReturnObject() {
        let session = JPSession.init(authorizationHeader: "auth_header")
        XCTAssertEqual(session.authorizationHeader, "auth_header")
        XCTAssertEqual(session.baseURL, "https://api.judopay.com/")
        XCTAssertFalse(session.uiClientMode)
        XCTAssertFalse(session.sandboxed)
    }
}
