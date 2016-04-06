//
//  JudoTestCase.swift
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
@testable import JudoKitObjC

let token = "<#YOUR TOKEN#>"
let secret = "<#YOUR SECRET#>"

class JudoTestCase: XCTestCase {
    
    let myJudoID = "100963875"
    
    let judo = JudoKit(token: token, secret: secret)
    
    let validVisaTestCard = JPCard(cardNumber: "4976000000003436", expiryDate: "12/20", secureCode: "452")
    let declinedVisaTestCard = JPCard(cardNumber: "4221690000004963", expiryDate: "12/20", secureCode: "125")
    
    let oneGBPAmount = JPAmount(amount: "1.00", currency: "GBP")
    let invalidAmount = JPAmount(amount: "", currency: "GBP")
    let invalidCurrencyAmount = JPAmount(amount: "1.00", currency: "")
    
    let validReference = JPReference(consumerReference: "consumer reference")
    
    let invalidReference = JPReference(consumerReference: "")
    
    override func setUp() {
        super.setUp()
        judo.apiSession.sandboxed = true
    }
    
    override func tearDown() {
        judo.apiSession.sandboxed = false
        super.tearDown()
    }
    
}
