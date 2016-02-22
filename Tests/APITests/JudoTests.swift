//
//  JudoTests.swift
//  JudoTests
//
//  Copyright (c) 2016 Alternative Payments Ltd
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
import JudoKitObjC

let token = "823Eja2fEM6E9NAE"
let secret = "382df6f458294f49f02f073e8f356f8983e2460631ea1b4c8ed4c3ee502dcbe6"

let strippedJudoID = "100407196"

class JudoTests: XCTestCase {
    
    let judo = JudoKit(token: token, secret: secret)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testJudoSandboxMode() {
        judo.apiSession.sandboxed = false
        XCTAssertEqual(judo.apiSession.endpoint, "https://gw1.judopay.com/")
        judo.apiSession.sandboxed = true
        XCTAssertEqual(judo.apiSession.endpoint, "https://gw1.judopay-sandbox.com/")
    }
    
}
