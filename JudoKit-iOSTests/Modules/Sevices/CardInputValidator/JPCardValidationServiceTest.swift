//
//  JPCardValidationServiceTest.swift
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

@testable import JudoKit

class JPCardValidationServiceTest: XCTestCase {
    var configuration: JPConfiguration! = nil
    let validationService = JPCardValidationService()
    var sut: JPTransactionInteractor! = nil
    lazy var reference = JPReference(consumerReference: "consumerReference")
    
    override func setUp() {
        let amount = JPAmount("0.01", currency: "GBR")
        configuration = JPConfiguration(judoID: "judoId", amount: amount, reference: reference)
        configuration.supportedCardNetworks = [.networkVisa, .networkMasterCard, .networkAMEX, .networkDinersClub]
        
        sut = JPTransactionInteractorImpl(cardValidationService: validationService, transactionService: nil, configuration:configuration, completion: nil)
    }
    
    func testLuhnValidVisa() {
        let result = sut.validateCardNumberInput("4929939187355598")
        XCTAssertEqual(result!.formattedInput, "4929 9391 8735 5598")
        XCTAssertTrue(result!.isValid)
    }
    
    func testLuhnInValidVisa() {
        let result = sut.validateCardNumberInput("4129939187355598")
        XCTAssertFalse(result!.isValid)
    }
    
    func testValidCardWithSpecialCharacters() {
        let result = sut.validateCardNumberInput("41299391873555+!")
        XCTAssertFalse(result!.isValid)
    }
    
    func testLuhnValidMaster() {
        let result = sut.validateCardNumberInput("5454422955385717")
        XCTAssertTrue(result!.isValid)
    }
    
    func testLuhnInValidMaster() {
        let result = sut.validateCardNumberInput("5454452295585717")
        XCTAssertFalse(result!.isValid)
    }
    
    func testLuhnValidAmex() {
        let result = sut.validateCardNumberInput("348570250878868")
        XCTAssertEqual(result!.formattedInput, "3485 702508 78868")
        XCTAssertTrue(result!.isValid)
    }
    
    func testForValidDiner() {
        let result = sut.validateCardNumberInput("30260943491310")
        XCTAssertEqual(result!.formattedInput, "3026 094349 1310")
        XCTAssertTrue(result!.isValid)
    }
    
    func testLuhnInValidAmex() {
        let result = sut.validateCardNumberInput("348570250872868")
        XCTAssertFalse(result!.isValid)
    }
    
    func testFormatedIncompleteLenghtAmex() {
        let result = sut.validateCardNumberInput("34857025087")
        XCTAssertEqual(result!.formattedInput, "3485 702508 7")
    }
    
    func testBiggerFormatedMaximumLenghtVisa() {
        let result = sut.validateCardNumberInput("4929939187355598111")
        XCTAssertEqual(result!.formattedInput, "4929 9391 8735 5598")
    }
    
    func testFormatedIncompleteLenghtVisa() {
        let result = sut.validateCardNumberInput("492993918")
        XCTAssertEqual(result!.formattedInput, "4929 9391 8")
    }
    
    func testForTypeRecognizeVisa() {
        let result = sut.validateCardNumberInput("4")
        XCTAssertEqual(result!.cardNetwork, .networkVisa)
    }
    
    func testForTypeRecognizeUnknown() {
        let result = sut.validateCardNumberInput("3")
        let unKnownType = CardNetwork(rawValue: 0)
        XCTAssertEqual(result!.cardNetwork, unKnownType)
    }
    
    func testForTypeRecognizeMaster() {
        let result = sut.validateCardNumberInput("52")
        XCTAssertEqual(result!.cardNetwork, .networkMasterCard)
    }
    
    func testForTypeRecognizeAmex() {
        let result = sut.validateCardNumberInput("34")
        XCTAssertEqual(result!.cardNetwork, .networkAMEX)
    }
    
    func testForTypeRecognizeDiscover() {
        let result = sut.validateCardNumberInput("65")
        XCTAssertEqual(result!.cardNetwork, .networkDiscover)
    }
    
    func testForTypeRecognizeJCB() {
        let result = sut.validateCardNumberInput("3528")
        XCTAssertEqual(result!.cardNetwork, .networkJCB)
    }
    
    func testForTypeRecognizeDiners() {
        let result = sut.validateCardNumberInput("36")
        XCTAssertEqual(result!.cardNetwork, .networkDinersClub)
    }
    
    func testForTypeRecognizeMaestro() {
        let result = sut.validateCardNumberInput("5018")
        XCTAssertEqual(result!.cardNetwork, .networkMaestro)
    }
    
    func testForTypeRecognizeChina() {
        let result = sut.validateCardNumberInput("62")
        XCTAssertEqual(result!.cardNetwork, .networkChinaUnionPay)
    }
    
    func testForChangingType() {
        var result = sut.validateCardNumberInput("36")
        XCTAssertEqual(result!.cardNetwork, .networkDinersClub)
        result = sut.validateCardNumberInput("62")
        XCTAssertEqual(result!.cardNetwork, .networkChinaUnionPay)
    }
    
    func testUnsuportedTypeFromConfig() {
        configuration.supportedCardNetworks = [.networkVisa]
        let result = sut.validateCardNumberInput("30260943491310")
        XCTAssertFalse(result!.isValid)
    }
    
    func testUnsuportedErrorTypeFromConfig() {
        configuration.supportedCardNetworks = [.networkVisa]
        let result = sut.validateCardNumberInput("30260943491310")
        let cardNetworkString = JPCardNetwork.name(of: result!.cardNetwork)
        XCTAssertEqual(result!.errorMessage!,  "\(cardNetworkString!) is not supported")
    }
    
    func testErrorStringForInvalidCardNumber() {
        let result = sut.validateCardNumberInput("4129939187355598")
        XCTAssertEqual(result!.errorMessage!,  "Check card number")
    }
}
