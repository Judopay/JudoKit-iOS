//
//  FunctionsHelpersTest.swift
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

class FunctionsHelpersTest: XCTestCase {
    
    /*
     * GIVEN: global func for getting aspect ratio
     *
     * WHEN: based on simulator
     *
     * THEN: should be no nil and bigger then zero
     */
    func test_getWidthAspectRatio_WhenSimulator_ShouldBeNonZero() {
        let sutAspect = getWidthAspectRatio()
        XCTAssertNotNil(sutAspect)
        XCTAssertTrue(sutAspect > 0)
    }
    
    /*
     * GIVEN: global func for getting user agent
     *
     * WHEN: based on simulator
     *
     * THEN: should be no nil
     */
    func test_getUserAgent_WhenSimulator_ShouldBeNonZero() {
        let sutUserAgent = getUserAgent()
        XCTAssertNotNil(sutUserAgent)
    }
    
    /*
     * GIVEN: global func for getting ip adress
     *
     * WHEN: based on simulator
     *
     * THEN: should be no nil
     */
    func test_getIPAddress_WhenSimulator_ShouldBeNonZero() {
        let sutIPAddress = getIPAddress()
        XCTAssertNotNil(sutIPAddress)
    }
}
