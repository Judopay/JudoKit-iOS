//
//  JPDsCertificatesResponseTests.swift
//  JudoKit_iOSTests
//
//  Copyright (c) 2026 Alternative Payments Ltd
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

class JPDsCertificatesResponseTests: XCTestCase {

    // MARK: - Helpers

    private func validEntryDict() -> [String: Any] {
        [
            "dsId": "A000000003",
            "dsName": "Visa",
            "dsCertificate": "base64cert==",
            "rootCertificates": ["rootcert=="],
            "keyId": "key-id-123",
            "validUntil": "2099-01-01T00:00:00Z"
        ]
    }

    private func validDict(schemaVersion: String = "1.0") -> [String: Any] {
        [
            "schemaVersion": schemaVersion,
            "publishedAt": "2025-01-01T00:00:00Z",
            "entries": [validEntryDict()]
        ]
    }

    // MARK: - responseFromDictionary:

    /*
     * GIVEN: a valid dictionary with schemaVersion, publishedAt and entries
     *
     * WHEN: responseFromDictionary: is called
     *
     * THEN: a populated response is returned
     */
    func test_responseFromDictionary_WithValidDict_ReturnsPopulatedResponse() {
        let response = JPDsCertificatesResponse.response(fromDictionary: validDict())
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.schemaVersion, "1.0")
        XCTAssertEqual(response?.publishedAt, "2025-01-01T00:00:00Z")
        XCTAssertEqual(response?.entries.count, 1)
        XCTAssertEqual(response?.entries.first?.dsId, "A000000003")
    }

    /*
     * GIVEN: a dictionary containing entries that cannot be parsed (missing required fields)
     *
     * WHEN: responseFromDictionary: is called
     *
     * THEN: the invalid entries are silently skipped
     */
    func test_responseFromDictionary_WithInvalidEntries_SkipsBadEntries() {
        let dict: [String: Any] = [
            "schemaVersion": "1.0",
            "entries": [["dsId": "missing-cert-and-keyid"]]
        ]
        let response = JPDsCertificatesResponse.response(fromDictionary: dict)
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.entries.count, 0)
    }

    /*
     * GIVEN: a dictionary without publishedAt
     *
     * WHEN: responseFromDictionary: is called
     *
     * THEN: response is returned with nil publishedAt
     */
    func test_responseFromDictionary_WithoutPublishedAt_ReturnsResponseWithNilPublishedAt() {
        var dict = validDict()
        dict.removeValue(forKey: "publishedAt")
        let response = JPDsCertificatesResponse.response(fromDictionary: dict)
        XCTAssertNotNil(response)
        XCTAssertNil(response?.publishedAt)
    }

    // MARK: - hasCompatibleSchemaVersion

    /*
     * GIVEN: a response with schema version "1.0"
     *
     * WHEN: hasCompatibleSchemaVersion is called
     *
     * THEN: returns true
     */
    func test_hasCompatibleSchemaVersion_With1_0_ReturnsTrue() {
        let response = JPDsCertificatesResponse.response(fromDictionary: validDict(schemaVersion: "1.0"))!
        XCTAssertTrue(response.hasCompatibleSchemaVersion())
    }

    /*
     * GIVEN: a response with schema version "1.5" (minor bump)
     *
     * WHEN: hasCompatibleSchemaVersion is called
     *
     * THEN: returns true (same major version)
     */
    func test_hasCompatibleSchemaVersion_With1_5_ReturnsTrue() {
        let response = JPDsCertificatesResponse.response(fromDictionary: validDict(schemaVersion: "1.5"))!
        XCTAssertTrue(response.hasCompatibleSchemaVersion())
    }

    /*
     * GIVEN: a response with schema version "2.0"
     *
     * WHEN: hasCompatibleSchemaVersion is called
     *
     * THEN: returns false (incompatible major version)
     */
    func test_hasCompatibleSchemaVersion_With2_0_ReturnsFalse() {
        let response = JPDsCertificatesResponse.response(fromDictionary: validDict(schemaVersion: "2.0"))!
        XCTAssertFalse(response.hasCompatibleSchemaVersion())
    }

    /*
     * GIVEN: a response with schema version "0.9"
     *
     * WHEN: hasCompatibleSchemaVersion is called
     *
     * THEN: returns false (major version is 0, not 1)
     */
    func test_hasCompatibleSchemaVersion_With0_9_ReturnsFalse() {
        let response = JPDsCertificatesResponse.response(fromDictionary: validDict(schemaVersion: "0.9"))!
        XCTAssertFalse(response.hasCompatibleSchemaVersion())
    }

    /*
     * GIVEN: a response with an empty schema version string
     *
     * WHEN: hasCompatibleSchemaVersion is called
     *
     * THEN: returns false
     */
    func test_hasCompatibleSchemaVersion_WithEmptyVersion_ReturnsFalse() {
        let response = JPDsCertificatesResponse.response(fromDictionary: validDict(schemaVersion: ""))!
        XCTAssertFalse(response.hasCompatibleSchemaVersion())
    }
}
