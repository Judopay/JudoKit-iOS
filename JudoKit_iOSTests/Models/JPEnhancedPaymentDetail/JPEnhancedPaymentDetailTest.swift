//
//  JPEnhancedPaymentDetailTest.swift
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

class JPEnhancedPaymentDetailTest: XCTestCase {
    let sdkInfo = JPSDKInfo(version: "version", name: "name")
    let client = JPClientDetails(key: "key", value: "value")
    let location = CLLocation(latitude: 0.0, longitude: 0.0)
    let secure = JPThreeDSecure(browser: JPBrowser())
    var consumerDevice: JPConsumerDevice! = nil
    
    override func setUp() {
        super.setUp()
        consumerDevice = JPConsumerDevice(ipAddress: "ip", clientDetails: client, geoLocation: location, threeDSecure: secure)
    }
    
    /*
     * GIVEN: Creating JPEnhancedPaymentDetail designated init
     *
     * WHEN: all fields are valid
     *
     * THEN: should create correct fields in JPEnhancedPaymentDetail object
     */
    func test_InitWithSdkInfo_WhenDesignatedInit_ShouldCreateObject() {
        let sut = JPEnhancedPaymentDetail(sdkInfo: sdkInfo, consumerDevice: consumerDevice)
        XCTAssertEqual(sut.consumerDevice, consumerDevice)
        XCTAssertEqual(sut.sdkInfo, sdkInfo)
    }
    
    /*
     * GIVEN: Creating JPEnhancedPaymentDetail class init
     *
     * WHEN: all fields are valid
     *
     * THEN: should create correct fields in JPEnhancedPaymentDetail object
     */
    func test_DetailWithSdkInfo_WhenClassInit_ShouldCreateObject() {
        let sut = JPEnhancedPaymentDetail.init(sdkInfo: sdkInfo, consumerDevice: consumerDevice)
        XCTAssertEqual(sut.consumerDevice, consumerDevice)
        XCTAssertEqual(sut.sdkInfo, sdkInfo)
    }
    
    /*
     * GIVEN: Creating JPEnhancedPaymentDetail designated init
     *
     * WHEN: all fields are valid
     *
     * THEN: should create correct dictionary from properties
     */
    func test_ToDictionary_WhenDesignatedInit_ShouldCreateDictionaryFromObject() {
        let sut = JPEnhancedPaymentDetail.init(sdkInfo: sdkInfo, consumerDevice: consumerDevice)
        let dic = sut.toDictionary() as NSDictionary
        XCTAssertEqual(dic.object(forKey: "SDK_INFO") as! Dictionary, ["Version":"version", "Name": "name"])
        let consumerDevice = dic.object(forKey: "ConsumerDevice") as! Dictionary<String, Any>
        XCTAssertEqual(consumerDevice["ClientDetails"] as! Dictionary, ["key": "key", "value": "value"])
        XCTAssertEqual(consumerDevice["IpAddress"] as! String, "ip")
        XCTAssertEqual(consumerDevice["PaymentType"] as! String, "ECOMM")
    }
}

