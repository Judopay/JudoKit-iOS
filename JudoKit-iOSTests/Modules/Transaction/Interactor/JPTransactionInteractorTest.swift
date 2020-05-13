//
//  JPTransactionInteractorTest.swift
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

class JPTransactionInteractorTest: XCTestCase {
    var configuration: JPConfiguration! = nil
    let validationService = JPCardValidationService()
    var sut: JPTransactionInteractor! = nil
    lazy var reference = JPReference(consumerReference: "consumerReference")
    
    override func setUp() {
        let amount = JPAmount("0.01", currency: "GBR")
        configuration = JPConfiguration(judoID: "judoId", amount: amount, reference: reference)
        configuration.supportedCardNetworks = [.visa, .masterCard, .AMEX, .dinersClub]
        
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
        XCTAssertEqual(result!.cardNetwork, .visa)
    }
    
    func testForTypeRecognizeUnknown() {
        let result = sut.validateCardNumberInput("3")
        let unKnownType = JPCardNetworkType(rawValue: 0)
        XCTAssertEqual(result!.cardNetwork, unKnownType)
    }
    
    /*
    * GIVEN: check input number
    *
    * WHEN: user input (52 - masterCard)
    *
    * THEN: should return card network masterCard
    */
    func test_ValidateCardNumberInput_WhenInputIsMasterCard_ShouldReturnMasterCard() {
        let result = sut.validateCardNumberInput("52")
        XCTAssertEqual(result!.cardNetwork, .masterCard)
    }
    
    /*
    * GIVEN: check input number
    *
    * WHEN: user input (34 - AMEX)
    *
    * THEN: should return card network AMEX
    */
    func test_ValidateCardNumberInput_WhenInputIsAMEX_ShouldReturnAMEX() {
        let result = sut.validateCardNumberInput("34")
        XCTAssertEqual(result!.cardNetwork, .AMEX)
    }
    
    /*
     * GIVEN: check input number
     *
     * WHEN: user input (65 - discover)
     *
     * THEN: should return card network discover
     */
    func test_ValidateCardNumberInput_WhenInputIsDiscover_ShouldReturnDiscover() {
        let result = sut.validateCardNumberInput("65")
        XCTAssertEqual(result!.cardNetwork, .discover)
    }
    
    /*
     * GIVEN: check input number
     *
     * WHEN: user input (3528 - JCB)
     *
     * THEN: should return card network JCB
     */
    func test_ValidateCardNumberInput_WhenInputIsJCB_ShouldReturnJCB() {
        let result = sut.validateCardNumberInput("3528")
        XCTAssertEqual(result!.cardNetwork, .JCB)
    }
    
    /*
     * GIVEN: check input number
     *
     * WHEN: user input (36 - dinersClub)
     *
     * THEN: should return card network dinersClub
     */
    func test_ValidateCardNumberInput_WhenInputIsDinersClub_ShouldReturnDinersClub() {
        let result = sut.validateCardNumberInput("36")
        XCTAssertEqual(result!.cardNetwork, .dinersClub)
    }
    
    /*
     * GIVEN: check input number
     *
     * WHEN: user input (5018 - maestro)
     *
     * THEN: should return card network maestro
     */
    func test_ValidateCardNumberInput_WhenInputIsMaestro_ShouldReturnMaestro() {
        let result = sut.validateCardNumberInput("5018")
        XCTAssertEqual(result!.cardNetwork, .maestro)
    }
    
    /*
     * GIVEN: check input number
     *
     * WHEN: user input (62 - chinaUnionPay)
     *
     * THEN: should return card network chinaUnionPay
     */
    func test_ValidateCardNumberInput_WhenInputIsChinaPay_ShouldReturnChinaPay() {
        let result = sut.validateCardNumberInput("62")
        XCTAssertEqual(result!.cardNetwork, .chinaUnionPay)
    }
    
    /*
     * GIVEN: check input number
     *
     * WHEN: user changed input for another card type (36 - dinersClub, 62 - chinaUnionPay)
     *
     * THEN: should change card network in result
     */
    func test_ValidateCardNumberInput_WhenChangeInput_ShouldChangeResultType() {
        var result = sut.validateCardNumberInput("36")
        XCTAssertEqual(result!.cardNetwork, .dinersClub)
        result = sut.validateCardNumberInput("62")
        XCTAssertEqual(result!.cardNetwork, .chinaUnionPay)
    }
    
    /*
     * GIVEN: validate card number for visa type
     *
     * WHEN: card number is for other type of card
     *
     * THEN: should return invalid result
     */
    func test_ValidateCardNumberInput_WhenSupportedCardVisaAndInputNotVisa_ShouldReturnUnsuportedType() {
        configuration.supportedCardNetworks = [.visa]
        let result = sut.validateCardNumberInput("30260943491310")
        XCTAssertFalse(result!.isValid)
    }
    
    /*
     * GIVEN: validate card number
     *
     * WHEN: card is not supported
     *
     * THEN: should return error in result
     */
    func test_ValidateCardNumberInput_WhenInputCardIsNotSupporteed_ShowUnsuportedErrorTypeFromConfig() {
        configuration.supportedCardNetworks = [.visa]
        let result = sut.validateCardNumberInput("30260943491310")
        let cardNetworkString = JPCardNetwork.name(of: result!.cardNetwork)
        XCTAssertEqual(result!.errorMessage!,  "\(cardNetworkString!) is not supported")
    }
    
    /*
     * GIVEN: validate card number
     *
     * WHEN: invalid card number
     *
     * THEN: should return right localized error message
     */
    func test_ValidateCardNumberInput_WhenIsInvalidCard_ShouldReturnErrorStringForInvalidCardNumber() {
        let result = sut.validateCardNumberInput("4129939187355598")
        XCTAssertEqual(result!.errorMessage!,  "Check card number")
    }
    
    /*
     * GIVEN: check secure code for visa
     *
     * WHEN: more then maximum lenght in secure code
     *
     * THEN: should format secure code and subscript code
     */
    func test_ValidateSecureCodeInput_WhenMoreThenMax_ShouldSubscriptCode() {
        let result = sut.validateSecureCodeInput("1234")
        XCTAssertEqual(result!.formattedInput!,  "123")
    }
    
    /*
     * GIVEN: check secure code for visa
     *
     * WHEN: right lenght of secure code
     *
     * THEN: should throw valid result
     */
    func test_ValidateSecureCodeInput_WhenCorrectLenght_ShouldBeValid() {
        let result = sut.validateSecureCodeInput("123")
        XCTAssertTrue(result!.isInputAllowed)
    }
    
    /*
     * GIVEN: check secure code for visa
     *
     * WHEN: is less then minimum
     *
     * THEN: should throw that code is not valid
     */
    func test_validateSecureCodeInput_WhenLessThenMinimum_ShouldNotBeValid() {
        let result = sut.validateSecureCodeInput("12")
        XCTAssertTrue(result!.isInputAllowed)
        XCTAssertFalse(result!.isValid)
    }
}
