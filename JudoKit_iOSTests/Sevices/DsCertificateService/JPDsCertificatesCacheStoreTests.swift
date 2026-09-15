//
//  JPDsCertificatesCacheStoreTests.swift
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

class JPDsCertificatesCacheTests: XCTestCase {

    // MARK: - Helpers

    private func makeEntry(validUntil: String? = "2099-01-01T00:00:00Z") -> JPDsCertificateEntry {
        var dict: [String: Any] = [
            "dsId": "A000000003",
            "dsName": "Visa",
            "dsCertificate": "base64cert==",
            "rootCertificates": ["rootcert=="],
            "keyId": "key-id-123"
        ]
        if let v = validUntil { dict["validUntil"] = v }
        return JPDsCertificateEntry.entry(fromDictionary: dict)!
    }

    private func makeCache(fetchedAt: TimeInterval = Date().timeIntervalSince1970,
                           maxAge: TimeInterval = 86400,
                           entries: [JPDsCertificateEntry] = []) -> JPDsCertificatesCache {
        let cache = JPDsCertificatesCache()
        cache.fetchedAt = fetchedAt
        cache.maxAge = maxAge
        cache.entries = entries
        return cache
    }

    // MARK: - isFreshForDate:

    /*
     * GIVEN: a cache fetched moments ago with a 24-hour maxAge
     *
     * WHEN: isFreshForDate: is called with the current date
     *
     * THEN: returns true
     */
    func test_isFreshForDate_WithRecentlyFetchedCache_ReturnsTrue() {
        let cache = makeCache(fetchedAt: Date().timeIntervalSince1970, maxAge: 86400)
        XCTAssertTrue(cache.isFresh(for: Date()))
    }

    /*
     * GIVEN: a cache fetched 2 days ago with a 24-hour maxAge
     *
     * WHEN: isFreshForDate: is called with the current date
     *
     * THEN: returns false
     */
    func test_isFreshForDate_WithStaleFetch_ReturnsFalse() {
        let twoDaysAgo = Date().timeIntervalSince1970 - (2 * 86400)
        let cache = makeCache(fetchedAt: twoDaysAgo, maxAge: 86400)
        XCTAssertFalse(cache.isFresh(for: Date()))
    }

    // MARK: - hasNearExpiryEntryForDate:threshold:

    /*
     * GIVEN: a cache with no entries
     *
     * WHEN: hasNearExpiryEntryForDate:threshold: is called
     *
     * THEN: returns false
     */
    func test_hasNearExpiryEntry_WithNoEntries_ReturnsFalse() {
        XCTAssertFalse(makeCache(entries: []).hasNearExpiryEntry(for: Date(), threshold: 7 * 86400))
    }

    /*
     * GIVEN: a cache where all entries expire in 2099
     *
     * WHEN: hasNearExpiryEntryForDate:threshold: is called with a 7-day threshold
     *
     * THEN: returns false
     */
    func test_hasNearExpiryEntry_WithDistantExpiry_ReturnsFalse() {
        let cache = makeCache(entries: [makeEntry(validUntil: "2099-01-01T00:00:00Z")])
        XCTAssertFalse(cache.hasNearExpiryEntry(for: Date(), threshold: 7 * 86400))
    }

    /*
     * GIVEN: a cache containing an entry that expires in 1 day
     *
     * WHEN: hasNearExpiryEntryForDate:threshold: is called with a 7-day threshold
     *
     * THEN: returns true
     */
    func test_hasNearExpiryEntry_WithImminentExpiry_ReturnsTrue() {
        let oneDayFromNow = Date().addingTimeInterval(86400)
        let validUntil = ISO8601DateFormatter().string(from: oneDayFromNow)
        let cache = makeCache(entries: [makeEntry(validUntil: validUntil)])
        XCTAssertTrue(cache.hasNearExpiryEntry(for: Date(), threshold: 7 * 86400))
    }
}

class JPDsCertificatesCacheStoreTests: XCTestCase {

    private let cacheKey = "judokit_ds_certs_v1"
    private let suiteName = "com.judopay.judokit.dscerts"
    private var suiteDefaults: UserDefaults!
    private var sut: JPDsCertificatesCacheStore!

    override func setUp() {
        super.setUp()
        suiteDefaults = UserDefaults(suiteName: suiteName)
        suiteDefaults.removeObject(forKey: cacheKey)
        sut = JPDsCertificatesCacheStore.sharedInstance()
    }

    override func tearDown() {
        suiteDefaults.removeObject(forKey: cacheKey)
        suiteDefaults = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func makeCache() -> JPDsCertificatesCache {
        let entryDict: [String: Any] = [
            "dsId": "A000000003",
            "dsName": "Visa",
            "dsCertificate": "base64cert==",
            "rootCertificates": ["rootcert=="],
            "keyId": "key-id-123",
            "validUntil": "2099-01-01T00:00:00Z"
        ]
        let cache = JPDsCertificatesCache()
        cache.etag = "v2025-03-01-abc123"
        cache.lastModified = "Tue, 01 Mar 2025 00:00:00 GMT"
        cache.fetchedAt = 1_000_000
        cache.maxAge = 86400
        cache.entries = [JPDsCertificateEntry.entry(fromDictionary: entryDict)!]
        return cache
    }

    // MARK: - load

    /*
     * GIVEN: no data is stored in NSUserDefaults
     *
     * WHEN: load is called
     *
     * THEN: returns nil
     */
    func test_load_WithNoStoredData_ReturnsNil() {
        XCTAssertNil(sut.load())
    }

    /*
     * GIVEN: corrupt JSON is stored in NSUserDefaults
     *
     * WHEN: load is called
     *
     * THEN: returns nil without crashing
     */
    func test_load_WithCorruptData_ReturnsNil() {
        let corrupt = "not-valid-json{{{{".data(using: .utf8)!
        suiteDefaults.set(corrupt, forKey: cacheKey)
        XCTAssertNil(sut.load())
    }

    // MARK: - save + load (round-trip)

    /*
     * GIVEN: a JPDsCertificatesCache is persisted via save:
     *
     * WHEN: load is called
     *
     * THEN: returns a cache with equal field values
     */
    func test_saveAndLoad_RoundTrip_PreservesAllFields() {
        let original = makeCache()
        sut.save(original)

        let restored = sut.load()
        XCTAssertNotNil(restored)
        XCTAssertEqual(restored?.etag, original.etag)
        XCTAssertEqual(restored?.lastModified, original.lastModified)
        XCTAssertEqual(restored?.fetchedAt, original.fetchedAt)
        XCTAssertEqual(restored?.maxAge, original.maxAge)
        XCTAssertEqual(restored?.entries.count, original.entries.count)
        XCTAssertEqual(restored?.entries.first?.dsId, original.entries.first?.dsId)
    }

    /*
     * GIVEN: a cache has already been saved
     *
     * WHEN: save is called with a new cache
     *
     * THEN: load returns the latest saved cache
     */
    func test_save_OverwritesPreviousCache() {
        sut.save(makeCache())

        let updated = JPDsCertificatesCache()
        updated.etag = "new-etag"
        updated.fetchedAt = 9_999_999
        updated.maxAge = 3600
        updated.entries = []
        sut.save(updated)

        let restored = sut.load()
        XCTAssertEqual(restored?.etag, "new-etag")
        XCTAssertEqual(restored?.fetchedAt, 9_999_999)
    }
}
