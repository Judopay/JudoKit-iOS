//
//  JPConsumerDeviceTest.swift
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

class JPConsumerDeviceTest: XCTestCase {
    let secure = JPThreeDSecure(browser: JPBrowser())
    
    /*
     * GIVEN: Creating JPConsumerDevice designated init
     *
     * WHEN: all fields are valid
     *
     * THEN: should create correct fields in JPConsumerDevice object
     */
    func test_InitWithIpAddress_WhenDesignatedInit_ShouldCreateObject() {
        let sut = JPConsumerDevice(threeDSecure: secure)
        XCTAssertEqual(sut.threeDSecure, secure)
    }
    
    /*
     * GIVEN: Creating JPConsumerDevice class init
     *
     * WHEN: all fields are valid
     *
     * THEN: should create correct fields in JPConsumerDevice object
     */
    func test_deviceWithIpAddress_WhenDesignatedInit_ShouldCreateObject() {
        let sut = JPConsumerDevice.init(threeDSecure: secure)
        XCTAssertEqual(sut.threeDSecure, secure)
    }
    
    /*
     * GIVEN: Creating dictionary from JPConsumerDevice object
     *
     * WHEN: all fields are valid
     *
     * THEN: should create dictionary from fields
     */
    func test_ToDictionary_WhenDesignatedInit_ShouldCreateDictionaryFromObject() {
        let sut = JPConsumerDevice.init(threeDSecure: secure)
        let dic = sut._jp_toDictionary() as NSDictionary
        XCTAssertEqual(dic.object(forKey: "ThreeDSecure") as! NSDictionary, secure._jp_toDictionary() as NSDictionary)
    }
}
