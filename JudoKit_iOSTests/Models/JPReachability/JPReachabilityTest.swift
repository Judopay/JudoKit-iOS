//
//  JPReachabilityTest.swift
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

class JPReachabilityTest: XCTestCase {
    let sut = JPReachability(url: URL(string: "https://github.com/"))
    
    /*
     * GIVEN: JPReachability object under test
     *
     * WHEN: wifi is reacheble
     *
     * THEN: should return true
     */
    func test_isReachableViaWiFi(){
        XCTAssertTrue(sut!.isReachableViaWiFi())
    }
    
    /*
     * GIVEN: JPReachability object under test
     *
     * WHEN: WWAN is not reacheble
     *
     * THEN: should return false
     */
    func test_isReachableViaWWAN(){
        XCTAssertFalse(sut!.isReachableViaWWAN())
    }
    
    /*
     * GIVEN: JPReachability object under test
     *
     * WHEN: connectivity is reacheble
     *
     * THEN: should return false
     */
    func test_isReachable(){
        XCTAssertTrue(sut!.isReachable())
    }
    
    /*
     * GIVEN: JPReachability object under test
     *
     * WHEN: get current status
     *
     * THEN: should be ReachableViaWiFi or ReachableViaWWAN type
     */
    func test_currentReachabilityStatus() {
        let status = sut!.currentReachabilityStatus()
        XCTAssertTrue(status == NetworkStatus.ReachableViaWiFi ||
            status == NetworkStatus.ReachableViaWWAN)
    }
    
    /*
     * GIVEN: JPReachability object under test
     *
     * WHEN: get reachabilityFlags
     *
     * THEN: should be equal with kSCNetworkReachabilityFlagsConnectionRequired (raw value 2)
     */
    func test_reachabilityFlags(){
        XCTAssertEqual(sut!.reachabilityFlags(), SCNetworkReachabilityFlags.init(rawValue: 2))
    }
    
    /*
     * GIVEN: JPReachability object under test
     *
     * WHEN: get current Reachability String
     *
     * THEN: should be equal with WiFi
     */
    func test_currentReachabilityString(){
        XCTAssertEqual(sut!.currentReachabilityString(), "WiFi")
    }
    
    /*
     * GIVEN: JPReachability object under test
     *
     * WHEN: get current Reachability Flags
     *
     * THEN: should be not nil
     */
    func test_currentReachabilityFlags(){
        XCTAssertNotNil(sut!.currentReachabilityFlags())
    }
    
    /*
     * GIVEN: init JPReachability with host name
     *
     * WHEN: valid host name
     *
     * THEN: reachability should be not nil
     */
    func test_reachabilityWithHostname() {
        let reachability = JPReachability(hostName: "host")
        XCTAssertNotNil(reachability)
    }
    
    /*
     * GIVEN: init JPReachability for internet connection
     *
     * THEN: reachability opbject should be not nil
     */
    func test_reachabilityForInternetConnection() {
        let reachability = JPReachability.forInternetConnection()
        XCTAssertNotNil(reachability)
    }
    
    /*
     * GIVEN: init JPReachability for local wifi connection
     *
     * THEN: reachability opbject should be not nil
     */
    func test_reachabilityWithAddress() {
        let reachability = JPReachability.forLocalWiFi()
        XCTAssertNotNil(reachability)
    }
    
    /*
     * GIVEN: init JPReachability with class init with url
     *
     * THEN: reachability opbject should be not nil
     */
    func test_reachabilityWithURL() {
        let reachability = JPReachability.init(url: URL(string: "https://github.com/"))
        XCTAssertNotNil(reachability)
    }
    
    /*
     * GIVEN: check for isConnectionRequired
     *
     * THEN: should be false
     */
    func test_isConnectionRequired() {
        XCTAssertFalse(sut!.isConnectionRequired())
    }
    
    /*
     * GIVEN: check for connectionRequired
     *
     * THEN: should be false
     */
    func test_connectionRequired() {
        XCTAssertFalse(sut!.connectionRequired())
    }
    
    /*
     * GIVEN: check for isConnectionOnDemand
     *
     * THEN: should be false
     */
    func test_isConnectionOnDemand() {
        XCTAssertFalse(sut!.isConnectionOnDemand())
    }
    
    /*
     * GIVEN: check for isInterventionRequired
     *
     * THEN: should be false
     */
    func test_isInterventionRequired() {
        XCTAssertFalse(sut!.isInterventionRequired())
    }
}

