//
//  JPTransactionInteractorTest.swift
//  JudoKit_iOSTests
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
    let transactionService = JPCardTransactionService()
    
    override func setUp() {
        super.setUp()
        let amount = JPAmount("0.01", currency: "USD")
        configuration = JPConfiguration(judoID: "judoId", amount: amount, reference: reference)
        configuration.cardAddress = JPAddress()
        configuration.supportedCardNetworks = [.visa, .masterCard, .AMEX, .dinersClub]
        
        let completion: JPCompletionBlock = { (response, error) in
        }
        sut = JPTransactionInteractorImpl(cardValidationService: validationService,
                                          transactionService: transactionService,
                                          transactionType: .payment,
                                          cardDetailsMode: .default,
                                          configuration: configuration,
                                          cardNetwork: .all,
                                          completion: completion)
    }
    
    /*
     * GIVEN: generate pay button title
     *
     * WHEN: shouldPaymentButtonDisplayAmount in config object is false
     *
     * THEN: result should be raw title
     */
    func test_generatePayButtonTitle_WhenFalse_ShouldBeRawTitle() {
        let result = sut.generatePayButtonTitle()
        XCTAssertEqual(result, "Pay Now")
    }
    
    /*
     * GIVEN: generate pay button title with securityCode mode
     *
     * WHEN: shouldPaymentButtonDisplayAmount in config object is false
     *
     * THEN: result should be raw title
     */
    func test_generatePayButtonTitleSecurityCodeMode_WhenFalse_ShouldBeRawTitle() {
        let result = sut.generatePayButtonTitle()
        XCTAssertEqual(result, "Pay Now")
    }
    
    /*
     * GIVEN: generate pay button title
     *
     * WHEN: shouldPaymentButtonDisplayAmount in config object is true
     *
     * THEN: result should be composed from pay + currency + amount
     */
    func test_generatePayButtonTitle_WhenTrue_ShouldFormatAndReturnValid() {
        configuration.uiConfiguration.shouldPaymentButtonDisplayAmount = true
        let result = sut.generatePayButtonTitle()
        XCTAssertEqual(result, "Pay $0.01")
    }
    
    /*
     * GIVEN: validate card number(Visa)
     *
     * WHEN: input is a Mastercard and Luhn algorithm valid number
     *
     * THEN: result should be VALID and formatted
     */
    func test_validateCardNumberInput_WhenLuhnValidVisa_ShouldFormatAndReturnValid() {
        let result = sut.validateCardNumberInput("4929939187355598")
        XCTAssertEqual(result.formattedInput, "4929 9391 8735 5598")
        XCTAssertTrue(result.isValid)
    }
    /*
     * GIVEN: validate card number(Visa)
     *
     * WHEN: user input Mastercard with incorrect Luhn
     *
     * THEN: result isValid should be false
     */
    func test_validateCardNumberInput_WhenLuhnValidVisa_ShouldReturnInValid() {
        let result = sut.validateCardNumberInput("4129939187355598")
        XCTAssertFalse(result.isValid)
    }
    
    /*
     * GIVEN: validate card number
     *
     * WHEN: user input some special characters
     *
     * THEN: result isValid should be false
     */
    func test_validateCardNumberInput_WhenSpecialCharacters_ShouldReturnInValid() {
        let result = sut.validateCardNumberInput("41299391873555+!")
        XCTAssertFalse(result.isValid)
    }
    
    /*
     * GIVEN: validate card number(Master)
     *
     * WHEN: input is a Mastercard and Luhn algorithm valid number
     *
     * THEN: result isValid should be true
     */
    func test_validateCardNumberInput_WhenLuhnValidMaster_ShouldReturnValid() {
        let result = sut.validateCardNumberInput("5454422955385717")
        XCTAssertTrue(result.isValid)
    }
    
    /*
     * GIVEN: validate card number(Mastercard)
     *
     * WHEN: user input Mastercard with incorrect Luhn and complete number lenght
     *
     * THEN: result isValid should be true
     */
    func test_validateCardNumberInput_WhenLuhnInvalidMaster_ShouldReturnInValid() {
        let result = sut.validateCardNumberInput("5454452295585717")
        XCTAssertFalse(result.isValid)
    }
    
    /*
     * GIVEN: validate card number(Amex)
     *
     * WHEN: user input Amex with valid Luhn and complete number length
     *
     * THEN: result should be valid and formatted
     */
    func test_validateCardNumberInput_WhenLuhnValidAmex_ShouldFormatAndReturnValid() {
        let result = sut.validateCardNumberInput("348570250878868")
        XCTAssertEqual(result.formattedInput, "3485 702508 78868")
        XCTAssertTrue(result.isValid)
    }
    
    /*
     * GIVEN: validate card number(Diner)
     *
     * WHEN: user input Diner type with valid Luhn and complete number length
     *
     * THEN: result should be valid and formatted
     */
    func test_validateCardNumberInput_WhenLuhnValidDiner_ShouldFormatAndReturnValid() {
        let result = sut.validateCardNumberInput("30260943491310")
        XCTAssertEqual(result.formattedInput, "3026 094349 1310")
        XCTAssertTrue(result.isValid)
    }
    
    /*
     * GIVEN: validate card number(Amex)
     *
     * WHEN: user input Amex with valid Luhn
     *
     * THEN: result should be valid
     */
    func test_ValidateCardNumberInput_WhenLuhnValid_ShouldReturnLuhnValidAmex() {
        let result = sut.validateCardNumberInput("348570250872868")
        XCTAssertFalse(result.isValid)
    }
    
    /*
     * GIVEN: validate card number
     *
     * WHEN: user input card type Amex
     *
     * THEN: should format Amex based on regex
     */
    func test_ValidateCardNumberInput_WhenAmexValid_ShouldFormateAmex() {
        let result = sut.validateCardNumberInput("34857025087")
        XCTAssertEqual(result.formattedInput, "3485 702508 7")
    }
    
    /*
     * GIVEN: validate card number
     *
     * WHEN: user input card number more character
     *
     * THEN: should format card number based on regex and substring it
     */
    func test_ValidateCardNumberInput_WhenInputIsToLong_ShouldFormatInput() {
        let result = sut.validateCardNumberInput("4929939187355598111")
        XCTAssertEqual(result.formattedInput, "4929 9391 8735 5598")
    }
    
    /*
     * GIVEN: validate card number
     *
     * WHEN: user input card number
     *
     * THEN: should format card number based on regex
     */
    func test_ValidateCardNumberInput_WhenInputIsLong_ShouldFormatInput() {
        let result = sut.validateCardNumberInput("492993918")
        XCTAssertEqual(result.formattedInput, "4929 9391 8")
    }
    
    /*
     * GIVEN: validate card number
     *
     * WHEN: user input (one character starts visa)
     *
     * THEN: should recognize card network visa
     */
    func test_ValidateCardNumberInput_WhenInputIsVisa_ShouldRecognizeVisa() {
        let result = sut.validateCardNumberInput("4")
        XCTAssertEqual(result.cardNetwork, .visa)
    }
    
    /*
     * GIVEN: validate card number
     *
     * WHEN: user input (one character, unknown)
     *
     * THEN: should recognize card network unKnownType
     */
    func test_ValidateCardNumberInput_WhenInputIsUnkwon_ShouldRecognizeUnknown() {
        let result = sut.validateCardNumberInput("3")
        let unKnownType = JPCardNetworkType(rawValue: 0)
        XCTAssertEqual(result.cardNetwork, unKnownType)
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
        XCTAssertEqual(result.cardNetwork, .masterCard)
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
        XCTAssertEqual(result.cardNetwork, .AMEX)
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
        XCTAssertEqual(result.cardNetwork, .discover)
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
        XCTAssertEqual(result.cardNetwork, .JCB)
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
        XCTAssertEqual(result.cardNetwork, .dinersClub)
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
        XCTAssertEqual(result.cardNetwork, .maestro)
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
        XCTAssertEqual(result.cardNetwork, .chinaUnionPay)
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
        XCTAssertEqual(result.cardNetwork, .dinersClub)
        result = sut.validateCardNumberInput("62")
        XCTAssertEqual(result.cardNetwork, .chinaUnionPay)
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
        XCTAssertFalse(result.isValid)
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
        let cardNetworkString = JPCardNetwork.name(of: result.cardNetwork)
        XCTAssertEqual(result.errorMessage!,  "\(cardNetworkString!) is not supported")
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
        XCTAssertEqual(result.errorMessage!,  "Invalid card number")
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
        XCTAssertEqual(result.formattedInput!,  "123")
    }
    
    /*
     * GIVEN: check secure code for visa
     *
     * WHEN: right lenght of secure code
     *
     * THEN: isInputAllowed should be true
     */
    func test_ValidateSecureCodeInput_WhenCorrectLenght_ShouldBeValid() {
        let result = sut.validateSecureCodeInput("123")
        XCTAssertTrue(result.isInputAllowed)
    }
    
    /*
     * GIVEN: check secure code for visa
     *
     * WHEN: is less then minimum
     *
     * THEN: should return false
     */
    func test_validateSecureCodeInput_WhenLessThenMinimum_ShouldNotBeValid() {
        let result = sut.validateSecureCodeInput("12")
        XCTAssertTrue(result.isInputAllowed)
        XCTAssertFalse(result.isValid)
    }
    
    /*
     * GIVEN: check for avs
     *
     * WHEN: is enabled in configs
     *
     * THEN: should return true
     */
    func test_IsAVSEnabled_WhenIsEnabledInconfig_ShouldBeTrue() {
        self.configuration.uiConfiguration.isAVSEnabled = true
        XCTAssertTrue(sut.isAVSEnabled())
    }
    
    /*
     * GIVEN: check for avs
     *
     * WHEN: is disabled in configs
     *
     * THEN: should return false, there's no exception thrown
     */
    func test_IsAVSEnabled_WhenIsDisabledInconfig_ShouldBeFalse() {
        self.configuration.uiConfiguration.isAVSEnabled = false
        XCTAssertFalse(sut.isAVSEnabled())
    }
    
    /*
     * GIVEN: getting card Address type
     *
     * WHEN: setted up in config object
     *
     * THEN: should return cardAddress
     */
    func test_GetConfiguredCardAddress_WhenIsSettedUp_ShouldReturnNonNil() {
        let cardAddress = sut.getConfiguredCardAddress()
        XCTAssertNotNil(cardAddress)
    }
    
    /*
     * GIVEN: getting camera permission
     *
     * WHEN: on simulator, test
     *
     * THEN: should be authorized
     */
    func test_HandleCameraPermissionsWithCompletion_WhenInTest_ShouldBeAuthorized() {
        sut.handleCameraPermissions { (auth) in
            XCTAssertEqual(auth, .authorized)
        }
    }
    
    /*
     * GIVEN: getting countries from interactor
     *
     * WHEN: we have 235 countries that we support
     *
     * THEN: should be returned 235 countries
     */
    func test_GetSelectableCountryNames_WhenCountriesArrayHardcodedInteractor_ShouldReturnTheSame() {
        let countries = sut.getFilteredCountries(bySearch: nil)
        XCTAssertEqual(countries.count, 235)
    }
    
    /*
     * GIVEN: opening 3ds error controller
     *
     * THEN: controller should be non nil
     */
    func test_Handle3DSecureTransactionFromError_WhenCalling_3dsControllerShouldBeNonNill(){
        let controller = JP3DSViewController()
        XCTAssertNotNil(controller)
    }
    
    /*
     * GIVEN: calling transaction
     *
     * WHEN: before saved an error
     *
     * THEN: should add to response error, savedError from storeError
     */
    func test_completeTransactionWithResponse() {
        let savedEerror = NSError(domain: "domain", code: 111, userInfo: nil)
        sut.storeError(savedEerror)
        
        let error = JPError(domain: "domain", code: JPError.userDidCancelError().code, userInfo: nil)
        sut.completeTransaction(with: JPResponse(), error: error)
        XCTAssertNotNil(error)
        XCTAssertEqual(error.details!.count, 1)
    }
    
    /*
     * GIVEN: interactor validate card holder
     *
     * WHEN: name is valid
     *
     * THEN: should return valid result
     */
    func test_ValidateCarholderNameInput_WhenNameIsValid_ShouldReturnValidResponse() {
        let result = sut.validateCardholderNameInput("Alex ABC")
        XCTAssertTrue(result.isInputAllowed)
        XCTAssertTrue(result.isValid)
    }
    
    /*
     * GIVEN: interactor validate Expiry Date
     *
     * WHEN: Date is expired
     *
     * THEN: result isValid should be false
     */
    func test_ValidateExpiryDateInput_WhenDateIsExpired_ShouldReturnInValidEResult() {
        let result = sut.validateExpiryDateInput("12/06")
        XCTAssertTrue(result.isInputAllowed)
        XCTAssertFalse(result.isValid)
    }
    
    /*
     * GIVEN: interactor validate Country
     *
     * WHEN: selected country is supported
     *
     * THEN: result isValid should be true
     */
    func test_ValidateCountryInput_WhenCountryUSAIsSupported_ShouldReturnValidResult() {
        let result = sut.validateCountryInput("USA")
        XCTAssertTrue(result.isInputAllowed)
        XCTAssertTrue(result.isValid)
    }
    
    /*
     * GIVEN: interactor validate postal code
     *
     * WHEN: selected country is UK, and code is valid
     *
     * THEN: should return valid result
     */
    func test_ValidatePostalCodeInput_WhenIsUk_ShouldBeValid() {
        let result = sut.validatePostalCodeInput("EC1A 1BB")
        XCTAssertTrue(result.isValid)
    }
    
    /*
     * GIVEN: complete Transaction With Response
     *
     * WHEN: injecting error and JPResponse
     *
     * THEN: should send transaction
     */
    func test_completeTransactionWithResponse_WhenNoComplection() {
        let sut = JPTransactionInteractorImpl(cardValidationService: validationService,
                                              transactionService: transactionService,
                                              transactionType: .payment,
                                              cardDetailsMode: .default,
                                              configuration: configuration,
                                              cardNetwork: .all,
                                              completion: { _, _ in })
        
        let error = JPError(domain: "domain", code: JPError.userDidCancelError().code, userInfo: nil)
        
        sut.completeTransaction(with: JPResponse(), error: error)
    }
    
    /*
     * GIVEN: update Keychain With CardModel
     *
     * WHEN: valid card model
     *
     * THEN: should save card model to JPCardStorage
     */
    func test_updateKeychainWithCardModel_WhenAddedCard_ShouldSaveLocal() {
        let model = JPTransactionViewModel()
        let cardNumber = JPTransactionNumberInputViewModel(type: .cardNumber)
        cardNumber.text = "1111111111111111"
        
        let expery = JPTransactionInputFieldViewModel(type: .cardExpiryDate)
        expery.text = "expiry"
        
        model.cardNumberViewModel = cardNumber
        model.expiryDateViewModel = expery
        
        sut.updateKeychain(withCardModel: model, andToken: "token")
        let card = JPCardStorage.sharedInstance()?.fetchStoredCardDetails()?.lastObject as! JPStoredCardDetails
        XCTAssertEqual(card.expiryDate, "expiry")
        XCTAssertEqual(card.cardLastFour, "1111")
    }
    
    /*
     * GIVEN: reset CardValidation Results
     *
     * WHEN: calling reset
     *
     * THEN: should reset all validation
     */
    func test_resetCardValidationResults() {
        sut.resetCardValidationResults()
    }
    
    /*
     * GIVEN: validate card number(Master)
     *
     * WHEN: when supportedCardNetworks is empty
     *
     * THEN: result isValid should be true
     */
    func test_validateCardNumberInput_WhenNoSupportedNetworksInConfig_ShouldReturnValid() {
        configuration.supportedCardNetworks = []
        let result = sut.validateCardNumberInput("5454422955385717")
        XCTAssertTrue(result.isValid)
    }
    
    /*
     * GIVEN: update Keychain With CardModel
     *
     * WHEN: visa card model
     *
     * THEN: should save card model to JPCardStorage with visa card title
     */
    func test_updateKeychainWithCardModel_WhenAddedCardVisa_ShouldSaveLocalRightTitle() {
        let model = JPTransactionViewModel()
        let cardNumberModel = JPTransactionNumberInputViewModel()
        cardNumberModel.cardNetwork = .visa
        model.cardNumberViewModel = cardNumberModel
        
        sut.updateKeychain(withCardModel: model, andToken: "token")
        let card = JPCardStorage.sharedInstance()?.fetchStoredCardDetails()?.lastObject as! JPStoredCardDetails
        XCTAssertEqual(card.cardTitle, "My VISA Card")
    }
    
    /*
     * GIVEN: update Keychain With CardModel
     *
     * WHEN: AMEX card model
     *
     * THEN: should save card model to JPCardStorage with AMEX card title
     */
    func test_updateKeychainWithCardModel_WhenAddedCardAMEX_ShouldSaveLocalRightTitle() {
        let model = JPTransactionViewModel()
        let cardNumberModel = JPTransactionNumberInputViewModel()
        cardNumberModel.cardNetwork = .AMEX
        model.cardNumberViewModel = cardNumberModel
        
        sut.updateKeychain(withCardModel: model, andToken: "token")
        let card = JPCardStorage.sharedInstance()?.fetchStoredCardDetails()?.lastObject as! JPStoredCardDetails
        XCTAssertEqual(card.cardTitle, "My American Express Card")
    }
    
    /*
     * GIVEN: update Keychain With CardModel
     *
     * WHEN: Maestro card model
     *
     * THEN: should save card model to JPCardStorage with Maestro: card title
     */
    func test_updateKeychainWithCardModel_WhenAddedCardMaestro_ShouldSaveLocalRightTitle() {
        let model = JPTransactionViewModel()
        let cardNumberModel = JPTransactionNumberInputViewModel()
        cardNumberModel.cardNetwork = .maestro
        model.cardNumberViewModel = cardNumberModel
        
        sut.updateKeychain(withCardModel: model, andToken: "token")
        let card = JPCardStorage.sharedInstance()?.fetchStoredCardDetails()?.lastObject as! JPStoredCardDetails
        XCTAssertEqual(card.cardTitle, "My Maestro Card")
    }
    
    /*
     * GIVEN: update Keychain With CardModel
     *
     * WHEN: masterCard card model
     *
     * THEN: should save card model to JPCardStorage with masterCard card title
     */
    func test_updateKeychainWithCardModel_WhenAddedCardMasterCard_ShouldSaveLocalRightTitle() {
        let model = JPTransactionViewModel()
        let cardNumberModel = JPTransactionNumberInputViewModel()
        cardNumberModel.cardNetwork = .masterCard
        model.cardNumberViewModel = cardNumberModel
        
        sut.updateKeychain(withCardModel: model, andToken: "token")
        let card = JPCardStorage.sharedInstance()?.fetchStoredCardDetails()?.lastObject as! JPStoredCardDetails
        XCTAssertEqual(card.cardTitle, "My MasterCard Card")
    }
    
    /*
     * GIVEN: update Keychain With CardModel
     *
     * WHEN: chinaUnionPay card model
     *
     * THEN: should save card model to JPCardStorage with chinaUnionPay card title
     */
    func test_updateKeychainWithCardModel_WhenAddedCardChinaUnionPay_ShouldSaveLocalRightTitle() {
        let model = JPTransactionViewModel()
        let cardNumberModel = JPTransactionNumberInputViewModel()
        cardNumberModel.cardNetwork = .chinaUnionPay
        model.cardNumberViewModel = cardNumberModel
        
        sut.updateKeychain(withCardModel: model, andToken: "token")
        let card = JPCardStorage.sharedInstance()?.fetchStoredCardDetails()?.lastObject as! JPStoredCardDetails
        XCTAssertEqual(card.cardTitle, "My China Union Pay Card")
    }
    
    /*
     * GIVEN: update Keychain With CardModel
     *
     * WHEN: JCB card model
     *
     * THEN: should save card model to JPCardStorage with JCB card title
     */
    func test_updateKeychainWithCardModel_WhenAddedCardJCB_ShouldSaveLocalRightTitle() {
        let model = JPTransactionViewModel()
        let cardNumberModel = JPTransactionNumberInputViewModel()
        cardNumberModel.cardNetwork = .JCB
        model.cardNumberViewModel = cardNumberModel
        
        sut.updateKeychain(withCardModel: model, andToken: "token")
        let card = JPCardStorage.sharedInstance()?.fetchStoredCardDetails()?.lastObject as! JPStoredCardDetails
        XCTAssertEqual(card.cardTitle, "My JCB Card")
    }
    
    /*
     * GIVEN: update Keychain With CardModel
     *
     * WHEN: discover card model
     *
     * THEN: should save card model to JPCardStorage with discover card title
     */
    func test_updateKeychainWithCardModel_WhenAddedCardDiscover_ShouldSaveLocalRightTitle() {
        let model = JPTransactionViewModel()
        let cardNumberModel = JPTransactionNumberInputViewModel()
        cardNumberModel.cardNetwork = .discover
        model.cardNumberViewModel = cardNumberModel
        
        sut.updateKeychain(withCardModel: model, andToken: "token")
        let card = JPCardStorage.sharedInstance()?.fetchStoredCardDetails()?.lastObject as! JPStoredCardDetails
        XCTAssertEqual(card.cardTitle, "My Discover Card")
    }
    
    /*
     * GIVEN: update Keychain With CardModel
     *
     * WHEN: dinersClub card model
     *
     * THEN: should save card model to JPCardStorage with dinersClub card title
     */
    func test_updateKeychainWithCardModel_WhenAddedCardDinersClub_ShouldSaveLocalRightTitle() {
        let model = JPTransactionViewModel()
        let cardNumberModel = JPTransactionNumberInputViewModel()
        cardNumberModel.cardNetwork = .dinersClub
        model.cardNumberViewModel = cardNumberModel
        
        sut.updateKeychain(withCardModel: model, andToken: "token")
        let card = JPCardStorage.sharedInstance()?.fetchStoredCardDetails()?.lastObject as! JPStoredCardDetails
        XCTAssertEqual(card.cardTitle, "My Dinners Club Card")
    }
    
}
