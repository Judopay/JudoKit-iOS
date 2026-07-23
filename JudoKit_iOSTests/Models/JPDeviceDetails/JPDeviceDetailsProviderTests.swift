//
//  JPDeviceDetailsProviderTests.swift
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

class JPDeviceDetailsProviderTests: XCTestCase {

    private let locale = NSLocale(localeIdentifier: "en_GB")
    private let suiteName = UUID().uuidString
    private var userDefaults: UserDefaults!
    private var sut: JPDeviceDetailsProvider!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: suiteName)!
        sut = JPDeviceDetailsProvider(device: UIDevice.current, locale: locale as Locale, userDefaults: userDefaults)
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    /*
     * GIVEN: device details are requested
     *
     * THEN: kDeviceId is not nil (identifierForVendor is available in simulators and devices)
     */
    func test_KDeviceId_IsNotNil() {
        XCTAssertNotNil(sut.deviceDetails.kDeviceId)
    }

    /*
     * GIVEN: no vDeviceId is stored in UserDefaults
     *
     * WHEN: deviceDetails are requested
     *
     * THEN: a new UUID is generated and persisted
     */
    func test_VDeviceId_GeneratedAndPersistedWhenMissing() {
        let details = sut.deviceDetails

        XCTAssertNotNil(details.vDeviceId)
        XCTAssertNotNil(UUID(uuidString: details.vDeviceId!))
        XCTAssertEqual(userDefaults.string(forKey: "Judo-vDeviceId"), details.vDeviceId)
    }

    /*
     * GIVEN: a vDeviceId is already stored in UserDefaults
     *
     * WHEN: deviceDetails are requested
     *
     * THEN: the stored value is returned
     */
    func test_VDeviceId_ReturnsStoredValue() {
        let storedId = "stored-v-device-id"
        userDefaults.set(storedId, forKey: "Judo-vDeviceId")

        XCTAssertEqual(sut.deviceDetails.vDeviceId, storedId)
    }

    /*
     * GIVEN: deviceDetails are requested twice from the same provider
     *
     * THEN: kDeviceId and vDeviceId return the same value (stable / cached)
     */
    func test_StableValuesAreCached() {
        let first = sut.deviceDetails
        let second = sut.deviceDetails

        XCTAssertEqual(first.kDeviceId, second.kDeviceId)
        XCTAssertEqual(first.vDeviceId, second.vDeviceId)
    }

    /*
     * GIVEN: locale is en_GB
     *
     * THEN: countryCode is the ISO alpha-2 country code "GB"
     */
    func test_CountryCode_IsIsoAlpha2Code() {
        XCTAssertEqual(sut.deviceDetails.countryCode, "GB")
    }

    /*
     * GIVEN: locale is en_GB
     *
     * THEN: cultureLocale is formatted as "language_country"
     */
    func test_CultureLocale_IsLanguageUnderscoreCountry() {
        XCTAssertEqual(sut.deviceDetails.cultureLocale, "en_GB")
    }

    /*
     * GIVEN: device details are requested
     *
     * THEN: os is formatted as "<systemName> <systemVersion>"
     */
    func test_Os_IsFormattedAsPlatformAndVersion() {
        let details = sut.deviceDetails
        let expected = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        XCTAssertEqual(details.os, expected)
    }
}
