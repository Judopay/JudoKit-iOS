//
//  NSBundleAdditionsTests.swift
//  JudoKit-iOSTests
//
//  Copyright (c) 2020 Alternative Payments Ltd
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

class NSBundleAdditionsTests: XCTestCase {
    
    /*
    * GIVEN: accesing bundle
    *
    * THEN: should return non nill bundle path
    */
    
    func test_frameworkBundle() {
        let bundle = Bundle.framework()
        XCTAssertNotNil(bundle)
    }
    
    func test_iconsBundle() {
        let bundle = Bundle.icons()
        XCTAssertNotNil(bundle)
    }
    
    func test_resourcesBundle() {
        let bundle = Bundle.resources()
        XCTAssertNotNil(bundle)
    }
}
