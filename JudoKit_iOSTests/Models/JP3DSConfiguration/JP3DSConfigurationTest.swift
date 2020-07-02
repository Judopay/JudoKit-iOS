//
//  JP3DSConfigurationTest.swift
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

class JP3DSConfigurationTest: XCTestCase {
    let error = NSError(domain: "Domain", code: 444, userInfo: ["md": "mdValue",
                                                                "paReq":"paReqValue",
                                                                "receiptId":"receiptId",
                                                                "acsUrl":"acsUrl"])
    
    /*
     * GIVEN: Creating JP3DSConfiguration with NSError designated init
     *
     * WHEN: userInfo include all fields
     *
     * THEN: should create correct fields in JP3DSConfiguration object
     */
    func test_InitWithError_WhenObjectIsInnitializedWithError_ShouldPopulateFields() {
        let sut3DSConfig = JP3DSConfiguration(error: error)
        XCTAssertEqual(sut3DSConfig.acsURL, URL(string:"acsUrl"))
        XCTAssertEqual(sut3DSConfig.mdValue, "mdValue")
        XCTAssertEqual(sut3DSConfig.receiptId, "receiptId")
        XCTAssertEqual(sut3DSConfig.receiptId, "receiptId")
    }
    
    /*
     * GIVEN: Creating JP3DSConfiguration with NSError class init
     *
     * WHEN: userInfo include all fields
     *
     * THEN: should create correct fields in JP3DSConfiguration object
     */
    func test_InitWithError_WhenObjectIsInnitializedWithErrorClassInit_ShouldPopulateFields() {
        let sut3DSConfig = JP3DSConfiguration.init(error: error)
        XCTAssertEqual(sut3DSConfig.acsURL, URL(string:"acsUrl"))
        XCTAssertEqual(sut3DSConfig.mdValue, "mdValue")
        XCTAssertEqual(sut3DSConfig.receiptId, "receiptId")
        XCTAssertEqual(sut3DSConfig.receiptId, "receiptId")
    }
}
