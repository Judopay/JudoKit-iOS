//
//  JPDsCertificateRepositoryTests.swift
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

class JPDsCertificateRepositoryTests: XCTestCase {

    private let cacheKey = "judokit_ds_certs_v1"
    private let testBaseURL = URL(string: "https://cdn.judopay-sandbox.com")!
    private var sut: JPDsCertificateRepository!

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: cacheKey)
        HTTPStubs.setEnabled(true)
    }

    override func tearDown() {
        HTTPStubs.removeAllStubs()
        UserDefaults.standard.removeObject(forKey: cacheKey)
        sut = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func makeEntryDict(dsId: String = "A000000003",
                               validUntil: String? = "2099-01-01T00:00:00Z") -> [String: Any] {
        var dict: [String: Any] = [
            "dsId": dsId,
            "dsName": "Visa",
            "dsCertificate": "base64cert==",
            "rootCertificates": ["rootcert=="],
            "keyId": "key-id-123"
        ]
        if let v = validUntil { dict["validUntil"] = v }
        return dict
    }

    private func makeCache(dsId: String = "A000000003",
                           validUntil: String? = "2099-01-01T00:00:00Z") -> JPDsCertificatesCache {
        let entry = JPDsCertificateEntry.entry(fromDictionary: makeEntryDict(dsId: dsId, validUntil: validUntil))!
        let cache = JPDsCertificatesCache()
        cache.etag = "test-etag"
        cache.fetchedAt = Date().timeIntervalSince1970
        cache.maxAge = 86400
        cache.entries = [entry]
        return cache
    }

    private func seedAndCreateRepository(cache: JPDsCertificatesCache? = nil) -> JPDsCertificateRepository {
        if let cache = cache {
            JPDsCertificatesCacheStore.sharedInstance().save(cache)
        }
        return JPDsCertificateRepository(baseURL: testBaseURL)
    }

    private func cdnResponseData(schemaVersion: String = "1.0") -> Data {
        let dict: [String: Any] = [
            "schemaVersion": schemaVersion,
            "publishedAt": "2025-01-01T00:00:00Z",
            "entries": [makeEntryDict()]
        ]
        return try! JSONSerialization.data(withJSONObject: dict)
    }

    // MARK: - cachedEntryForDsId:

    /*
     * GIVEN: the cache is empty (nothing persisted in NSUserDefaults)
     *
     * WHEN: cachedEntryForDsId: is called
     *
     * THEN: returns nil
     */
    func test_cachedEntry_WithEmptyCache_ReturnsNil() {
        sut = seedAndCreateRepository()
        XCTAssertNil(sut.cachedEntry(forDsId: "A000000003"))
    }

    /*
     * GIVEN: the cache has a Visa entry (dsId = A000000003)
     *
     * WHEN: cachedEntryForDsId: is called with a different dsId
     *
     * THEN: returns nil
     */
    func test_cachedEntry_WithUnknownDsId_ReturnsNil() {
        sut = seedAndCreateRepository(cache: makeCache(dsId: "A000000003"))
        XCTAssertNil(sut.cachedEntry(forDsId: "A000000004"))
    }

    /*
     * GIVEN: the cache contains an entry that expired in 2020
     *
     * WHEN: cachedEntryForDsId: is called
     *
     * THEN: returns nil
     */
    func test_cachedEntry_WithExpiredEntry_ReturnsNil() {
        sut = seedAndCreateRepository(cache: makeCache(validUntil: "2020-01-01T00:00:00Z"))
        XCTAssertNil(sut.cachedEntry(forDsId: "A000000003"))
    }

    /*
     * GIVEN: the cache contains a valid entry expiring in 2099
     *
     * WHEN: cachedEntryForDsId: is called with the matching dsId
     *
     * THEN: returns the entry
     */
    func test_cachedEntry_WithValidEntry_ReturnsEntry() {
        sut = seedAndCreateRepository(cache: makeCache(validUntil: "2099-01-01T00:00:00Z"))
        XCTAssertNotNil(sut.cachedEntry(forDsId: "A000000003"))
    }

    /*
     * GIVEN: the cache contains an entry with no validUntil
     *
     * WHEN: cachedEntryForDsId: is called
     *
     * THEN: returns the entry (no expiry = always valid)
     */
    func test_cachedEntry_WithNoExpiryEntry_ReturnsEntry() {
        sut = seedAndCreateRepository(cache: makeCache(validUntil: nil))
        XCTAssertNotNil(sut.cachedEntry(forDsId: "A000000003"))
    }

    // MARK: - prefetch

    /*
     * GIVEN: the CDN returns a 200 response with a valid payload
     *
     * WHEN: prefetch is called
     *
     * THEN: the CDN endpoint is contacted
     */
    func test_prefetch_CDNReturns200_ContactsCDNEndpoint() {
        sut = seedAndCreateRepository()
        let networkCalled = expectation(description: "CDN endpoint called")

        HTTPStubs.stubRequests(passingTest: { request in
            return request.url?.absoluteString.contains("ds-certs") == true
        }, withStubResponse: { _ in
            networkCalled.fulfill()
            return HTTPStubsResponse(data: self.cdnResponseData(),
                                     statusCode: 200,
                                     headers: ["Content-Type": "application/json"])
        })

        sut.prefetch()
        waitForExpectations(timeout: 5)
    }

    /*
     * GIVEN: the CDN returns a 304 Not Modified response
     *
     * WHEN: prefetch is called
     *
     * THEN: the CDN is contacted and the call completes without crashing
     */
    func test_prefetch_CDNReturns304_CompletesWithoutCrash() {
        sut = seedAndCreateRepository(cache: makeCache())
        let networkCalled = expectation(description: "CDN endpoint called")

        HTTPStubs.stubRequests(passingTest: { request in
            return request.url?.absoluteString.contains("ds-certs") == true
        }, withStubResponse: { _ in
            networkCalled.fulfill()
            return HTTPStubsResponse(data: Data(), statusCode: 304, headers: nil)
        })

        sut.prefetch()
        waitForExpectations(timeout: 5)
    }

    /*
     * GIVEN: the CDN returns a 500 error response
     *
     * WHEN: prefetch is called
     *
     * THEN: the error is swallowed and the call does not crash
     */
    func test_prefetch_CDNReturns500_DoesNotCrash() {
        sut = seedAndCreateRepository()
        let networkCalled = expectation(description: "CDN endpoint called")

        HTTPStubs.stubRequests(passingTest: { request in
            return request.url?.absoluteString.contains("ds-certs") == true
        }, withStubResponse: { _ in
            networkCalled.fulfill()
            return HTTPStubsResponse(data: Data(), statusCode: 500, headers: nil)
        })

        sut.prefetch()
        waitForExpectations(timeout: 5)
    }

    /*
     * GIVEN: a network timeout occurs
     *
     * WHEN: prefetch is called
     *
     * THEN: the error is swallowed and the call does not crash
     */
    func test_prefetch_NetworkTimeout_DoesNotCrash() {
        sut = seedAndCreateRepository()
        let networkCalled = expectation(description: "CDN endpoint called")

        HTTPStubs.stubRequests(passingTest: { request in
            return request.url?.absoluteString.contains("ds-certs") == true
        }, withStubResponse: { _ in
            networkCalled.fulfill()
            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut)
            return HTTPStubsResponse(error: error)
        })

        sut.prefetch()
        waitForExpectations(timeout: 5)
    }

    /*
     * GIVEN: the CDN returns a 200 response with an unsupported schema version
     *
     * WHEN: prefetch is called
     *
     * THEN: the CDN is contacted and the call completes without crashing
     */
    func test_prefetch_UnsupportedSchemaVersion_DoesNotCrash() {
        sut = seedAndCreateRepository()
        let networkCalled = expectation(description: "CDN endpoint called")

        HTTPStubs.stubRequests(passingTest: { request in
            return request.url?.absoluteString.contains("ds-certs") == true
        }, withStubResponse: { _ in
            networkCalled.fulfill()
            return HTTPStubsResponse(data: self.cdnResponseData(schemaVersion: "10.0"),
                                     statusCode: 200,
                                     headers: ["Content-Type": "application/json"])
        })

        sut.prefetch()
        waitForExpectations(timeout: 5)
    }
}
