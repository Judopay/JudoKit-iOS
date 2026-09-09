//
//  JPDsCertificateEntryTests.swift
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

class JPDsCertificateEntryTests: XCTestCase {

    // MARK: - Helpers

    private func makeValidDict(overrides: [String: Any] = [:]) -> [String: Any] {
        var dict: [String: Any] = [
            "dsId": "A000000003",
            "dsName": "Visa",
            "dsCertificate": "base64cert==",
            "rootCertificates": ["rootcert=="],
            "keyId": "747da056-476c-4296-a7c4-7e853e235ef0",
            "validUntil": "2099-01-01T00:00:00Z"
        ]
        overrides.forEach { dict[$0.key] = $0.value }
        return dict
    }

    private func makeEntry(validUntil: String? = "2099-01-01T00:00:00Z") -> JPDsCertificateEntry {
        var dict = makeValidDict()
        if let v = validUntil { dict["validUntil"] = v } else { dict.removeValue(forKey: "validUntil") }
        return JPDsCertificateEntry.entry(fromDictionary: dict)!
    }

    // MARK: - entryFromDictionary:

    /*
     * GIVEN: a dictionary containing all required fields
     *
     * WHEN: entryFromDictionary: is called
     *
     * THEN: a fully populated entry is returned
     */
    func test_entryFromDictionary_WithAllRequiredFields_ReturnsPopulatedEntry() {
        let entry = JPDsCertificateEntry.entry(fromDictionary: makeValidDict())
        XCTAssertNotNil(entry)
        XCTAssertEqual(entry?.dsId, "A000000003")
        XCTAssertEqual(entry?.dsName, "Visa")
        XCTAssertEqual(entry?.dsCertificate, "base64cert==")
        XCTAssertEqual(entry?.keyId, "747da056-476c-4296-a7c4-7e853e235ef0")
        XCTAssertEqual(entry?.validUntil, "2099-01-01T00:00:00Z")
        XCTAssertEqual(entry?.rootCertificates, ["rootcert=="])
    }

    /*
     * GIVEN: a dictionary missing the required dsId field
     *
     * WHEN: entryFromDictionary: is called
     *
     * THEN: nil is returned
     */
    func test_entryFromDictionary_MissingDsId_ReturnsNil() {
        var dict = makeValidDict()
        dict.removeValue(forKey: "dsId")
        XCTAssertNil(JPDsCertificateEntry.entry(fromDictionary: dict))
    }

    /*
     * GIVEN: a dictionary missing the required dsCertificate field
     *
     * WHEN: entryFromDictionary: is called
     *
     * THEN: nil is returned
     */
    func test_entryFromDictionary_MissingDsCertificate_ReturnsNil() {
        var dict = makeValidDict()
        dict.removeValue(forKey: "dsCertificate")
        XCTAssertNil(JPDsCertificateEntry.entry(fromDictionary: dict))
    }

    /*
     * GIVEN: a dictionary missing the required keyId field
     *
     * WHEN: entryFromDictionary: is called
     *
     * THEN: nil is returned
     */
    func test_entryFromDictionary_MissingKeyId_ReturnsNil() {
        var dict = makeValidDict()
        dict.removeValue(forKey: "keyId")
        XCTAssertNil(JPDsCertificateEntry.entry(fromDictionary: dict))
    }

    /*
     * GIVEN: a dictionary without rootCertificates
     *
     * WHEN: entryFromDictionary: is called
     *
     * THEN: entry is returned with an empty rootCertificates array
     */
    func test_entryFromDictionary_WithoutRootCertificates_DefaultsToEmptyArray() {
        var dict = makeValidDict()
        dict.removeValue(forKey: "rootCertificates")
        let entry = JPDsCertificateEntry.entry(fromDictionary: dict)
        XCTAssertNotNil(entry)
        XCTAssertEqual(entry?.rootCertificates, [])
    }

    /*
     * GIVEN: a dictionary without validUntil
     *
     * WHEN: entryFromDictionary: is called
     *
     * THEN: entry is returned with nil validUntil
     */
    func test_entryFromDictionary_WithoutValidUntil_ReturnsEntryWithNilExpiry() {
        var dict = makeValidDict()
        dict.removeValue(forKey: "validUntil")
        let entry = JPDsCertificateEntry.entry(fromDictionary: dict)
        XCTAssertNotNil(entry)
        XCTAssertNil(entry?.validUntil)
    }

    // MARK: - toDictionary

    /*
     * GIVEN: a valid JPDsCertificateEntry
     *
     * WHEN: toDictionary is called and the result passed back to entryFromDictionary:
     *
     * THEN: all fields survive the round-trip
     */
    func test_toDictionary_RoundTrip_PreservesAllFields() {
        let original = JPDsCertificateEntry.entry(fromDictionary: makeValidDict())!
        let restored = JPDsCertificateEntry.entry(fromDictionary: original.toDictionary())
        XCTAssertNotNil(restored)
        XCTAssertEqual(restored?.dsId, original.dsId)
        XCTAssertEqual(restored?.dsName, original.dsName)
        XCTAssertEqual(restored?.dsCertificate, original.dsCertificate)
        XCTAssertEqual(restored?.keyId, original.keyId)
        XCTAssertEqual(restored?.validUntil, original.validUntil)
        XCTAssertEqual(restored?.rootCertificates, original.rootCertificates)
    }

    // MARK: - isNotExpiredForDate:

    /*
     * GIVEN: an entry with no validUntil
     *
     * WHEN: isNotExpiredForDate: is called
     *
     * THEN: returns true (no expiry means it never expires)
     */
    func test_isNotExpiredForDate_WithNoValidUntil_ReturnsTrue() {
        XCTAssertTrue(makeEntry(validUntil: nil).isNotExpired(for: Date()))
    }

    /*
     * GIVEN: an entry whose validUntil is in 2099
     *
     * WHEN: isNotExpiredForDate: is called with the current date
     *
     * THEN: returns true
     */
    func test_isNotExpiredForDate_WithFutureExpiry_ReturnsTrue() {
        XCTAssertTrue(makeEntry(validUntil: "2099-01-01T00:00:00Z").isNotExpired(for: Date()))
    }

    /*
     * GIVEN: an entry whose validUntil is in the past
     *
     * WHEN: isNotExpiredForDate: is called with the current date
     *
     * THEN: returns false
     */
    func test_isNotExpiredForDate_WithPastExpiry_ReturnsFalse() {
        XCTAssertFalse(makeEntry(validUntil: "2020-01-01T00:00:00Z").isNotExpired(for: Date()))
    }

    /*
     * GIVEN: an entry with an unparseable validUntil string
     *
     * WHEN: isNotExpiredForDate: is called
     *
     * THEN: returns true (unparseable date is treated as no expiry)
     */
    func test_isNotExpiredForDate_WithUnparseableValidUntil_ReturnsTrue() {
        XCTAssertTrue(makeEntry(validUntil: "not-a-date").isNotExpired(for: Date()))
    }

    // MARK: - isNearExpiryForDate:threshold:

    /*
     * GIVEN: an entry with no validUntil
     *
     * WHEN: isNearExpiryForDate:threshold: is called
     *
     * THEN: returns false
     */
    func test_isNearExpiryForDate_WithNoValidUntil_ReturnsFalse() {
        XCTAssertFalse(makeEntry(validUntil: nil).isNearExpiry(for: Date(), threshold: 7 * 24 * 60 * 60))
    }

    /*
     * GIVEN: an entry expiring in 1 day and a 7-day threshold
     *
     * WHEN: isNearExpiryForDate:threshold: is called
     *
     * THEN: returns true
     */
    func test_isNearExpiryForDate_ExpiresInOneDay_WithSevenDayThreshold_ReturnsTrue() {
        let oneDayFromNow = Date().addingTimeInterval(24 * 60 * 60)
        let validUntil = ISO8601DateFormatter().string(from: oneDayFromNow)
        XCTAssertTrue(makeEntry(validUntil: validUntil).isNearExpiry(for: Date(), threshold: 7 * 24 * 60 * 60))
    }

    /*
     * GIVEN: an entry expiring in 2099 and a 7-day threshold
     *
     * WHEN: isNearExpiryForDate:threshold: is called
     *
     * THEN: returns false
     */
    func test_isNearExpiryForDate_ExpiresIn2099_WithSevenDayThreshold_ReturnsFalse() {
        XCTAssertFalse(makeEntry(validUntil: "2099-01-01T00:00:00Z").isNearExpiry(for: Date(), threshold: 7 * 24 * 60 * 60))
    }

    /*
     * GIVEN: an entry with an unparseable validUntil string
     *
     * WHEN: isNearExpiryForDate:threshold: is called
     *
     * THEN: returns false
     */
    func test_isNearExpiryForDate_WithUnparseableValidUntil_ReturnsFalse() {
        XCTAssertFalse(makeEntry(validUntil: "not-a-date").isNearExpiry(for: Date(), threshold: 7 * 24 * 60 * 60))
    }
}
