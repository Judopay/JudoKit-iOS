//
//  JPCardValidationServiceTest.swift
//  JudoKitObjCTests
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
@testable import JudoKitObjC

class JPCardValidationServiceTest: XCTestCase {
    var configuration: JPConfiguration! = nil
    let validationService = JPCardValidationService()
    var interactor: JPTransactionInteractor! = nil
    lazy var reference = JPReference(consumerReference: "consumerReference")
    
    override func setUp() {
        let amount = JPAmount("0.01", currency: "GBR")
        configuration = JPConfiguration(judoID: "judoId", amount: amount, reference: reference)
        configuration.supportedCardNetworks = [.networkVisa, .networkMasterCard, .networkAMEX, .networkDinersClub]
        
        interactor = JPTransactionInteractorImpl(cardValidationService: validationService, transactionService: nil, configuration:configuration, completion: nil)
    }
    
    func testLuhnValideVisa() {
        let result = interactor.validateCardNumberInput("4929939187355598")
        XCTAssertEqual(result!.formattedInput, "4929 9391 8735 5598")
        XCTAssertTrue(result!.isValid)
    }
    
    func testLuhnInValideVisa() {
        let result = interactor.validateCardNumberInput("4129939187355598")
        XCTAssertFalse(result!.isValid)
    }
    
    func testLuhnValideMaster() {
        let result = interactor.validateCardNumberInput("5454422955385717")
        XCTAssertTrue(result!.isValid)
    }
    
    func testLuhnInValideMaster() {
        let result = interactor.validateCardNumberInput("5454452295585717")
        XCTAssertFalse(result!.isValid)
    }
    
    func testLuhnValideAmex() {
        let result = interactor.validateCardNumberInput("348570250878868")
        XCTAssertEqual(result!.formattedInput, "3485 702508 78868")
        XCTAssertTrue(result!.isValid)
    }
    
    func testForValidDiner() {
        let result = interactor.validateCardNumberInput("30260943491310")
        XCTAssertEqual(result!.formattedInput, "3026 094349 1310")
        XCTAssertTrue(result!.isValid)
    }
    
    func testLuhnInValideAmex() {
        let result = interactor.validateCardNumberInput("348570250872868")
        XCTAssertFalse(result!.isValid)
    }
    
    func testFormatedIncompleteLenghtAmex() {
        let result = interactor.validateCardNumberInput("34857025087")
        XCTAssertEqual(result!.formattedInput, "3485 702508 7")
    }
    
    func testBiggerFormatedMaximumLenghtVisa() {
        let result = interactor.validateCardNumberInput("4929939187355598111")
        XCTAssertEqual(result!.formattedInput, "4929 9391 8735 5598")
    }
    
    func testFormatedIncompleteLenghtVisa() {
        let result = interactor.validateCardNumberInput("492993918")
        XCTAssertEqual(result!.formattedInput, "4929 9391 8")
    }
    
    func testForTypeRecognizeVisa() {
        let result = interactor.validateCardNumberInput("4")
        XCTAssertEqual(result!.cardNetwork, .networkVisa)
    }
    
    func testForTypeRecognizeUnknown() {
        let result = interactor.validateCardNumberInput("3")
        let unKnownType = CardNetwork(rawValue: 0)
        XCTAssertEqual(result!.cardNetwork, unKnownType)
    }
    
    func testForTypeRecognizeMaster() {
        let result = interactor.validateCardNumberInput("52")
        XCTAssertEqual(result!.cardNetwork, .networkMasterCard)
    }
    
    func testForTypeRecognizeAmex() {
        let result = interactor.validateCardNumberInput("34")
        XCTAssertEqual(result!.cardNetwork, .networkAMEX)
    }
    
    func testForTypeRecognizeDiscover() {
        let result = interactor.validateCardNumberInput("65")
        XCTAssertEqual(result!.cardNetwork, .networkDiscover)
    }
    
    func testForTypeRecognizeJCB() {
        let result = interactor.validateCardNumberInput("3528")
        XCTAssertEqual(result!.cardNetwork, .networkJCB)
    }
    
    func testForTypeRecognizeDiners() {
        let result = interactor.validateCardNumberInput("36")
        XCTAssertEqual(result!.cardNetwork, .networkDinersClub)
    }
    
    func testForTypeRecognizeMaestro() {
        let result = interactor.validateCardNumberInput("5018")
        XCTAssertEqual(result!.cardNetwork, .networkMaestro)
    }
    
    func testForTypeRecognizeChina() {
        let result = interactor.validateCardNumberInput("62")
        XCTAssertEqual(result!.cardNetwork, .networkChinaUnionPay)
    }
    
    func testForChangingType() {
        var result = interactor.validateCardNumberInput("36")
        XCTAssertEqual(result!.cardNetwork, .networkDinersClub)
        result = interactor.validateCardNumberInput("62")
        XCTAssertEqual(result!.cardNetwork, .networkChinaUnionPay)
    }
    
    func testUnsuportedTypeFromConfig() {
        configuration.supportedCardNetworks = [.networkVisa]
        let result = interactor.validateCardNumberInput("30260943491310")
        XCTAssertFalse(result!.isValid)
    }
}
