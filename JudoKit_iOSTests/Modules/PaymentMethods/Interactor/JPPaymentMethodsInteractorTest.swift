//
//  JPPaymentMethodsInteractorTest.swift
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

class JPPaymentMethodsInteractorTest: XCTestCase {
    var sut: JPPaymentMethodsInteractor!
    let configuration = JPConfiguration(judoID: "judoId", amount: JPAmount("123", currency: "GBP"), reference: JPReference(consumerReference: "consumerReference"))
    
    override func setUp() {
        super.setUp()
        configuration.supportedCardNetworks = [.visa, .masterCard, .AMEX]
        let service = JPTransactionServiceStub()
        sut = JPPaymentMethodsInteractorImpl(mode: .serverToServer, configuration: configuration, transactionService: service, completion: nil)
    }
    
    /*
     * GIVEN: User is calling payment type with server to server mode
     *
     * THEN: should call and return not nil response
     */
    func test_ServerToServer_WhenCallingPayment_ShouldReturnNotNilResponse()  {
        let completion: JPCompletionBlock = { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
        }
        sut.paymentTransaction(withToken: "", andSecurityCode: nil, andCompletion: completion)
    }
    
    /*
     * GIVEN: User is calling apple pay with server to server mode
     *
     * THEN: should call and return not nil response
     */
    func test_ServerToServerApple_WhenCallingApplePay_ShouldReturnNotNilResponse()  {
        let completion: JPCompletionBlock = { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
        }
        sut.startApplePay(completion: completion)
    }
    
    /*
     * GIVEN: Set up ammount in config object
     *
     * WHEN: getting ammount in interactor
     *
     * THEN: should return the same currency and ammount as in config model
     */
    func test_GetAmount_WhenIsSettepUp_ShouldReturnSame() {
        let amount = sut.getAmount()
        XCTAssertEqual(amount.amount, "123")
        XCTAssertEqual(amount.currency, "GBP")
    }
    
    /*
     * GIVEN: Pbba method is not available
     *
     * WHEN: getting index of pbba method
     *
     * THEN: should return -1
     */
    func test_IndexOfPBBAMethod_WhenIsSettepUp_ShouldReturnSame() {
        let index = sut.indexOfPBBAMethod()
        XCTAssertEqual(index, NSNotFound)
    }
    
    /*
     * GIVEN: remove all cards from store
     *
     * WHEN: checking all cards
     *
     * THEN: should be empty list of cards
     */
    func test_StoredCards_WhenRemovingAllCards_ShouldGetEmptyList() {
        JPCardStorage.sharedInstance()?.deleteCardDetails()
        let cards = sut.getStoredCardDetails()
        XCTAssertEqual(cards.count, 0)
    }
    
    /*
     * GIVEN: remove all cards from store
     *
     * WHEN: adding one card in store
     *
     * THEN: in store should be presented only one card
     */
    func test_StoredCards_WhenAddingNewCards_ShouldAppearInList() {
        JPCardStorage.sharedInstance()?.deleteCardDetails()
        let card = JPStoredCardDetails(lastFour: "4444", expiryDate: "24/24", cardNetwork: .AMEX, cardToken: "cardToken4")
        JPCardStorage.sharedInstance()?.add(card)
        
        let cards = sut.getStoredCardDetails()
        XCTAssertEqual(cards.count, 1)
    }
    
    /*
     * GIVEN: Calculating all payment methods
     *
     * WHEN: amount currency is GBP
     *
     * THEN: count of methods should 2: cards and apple pay
     */
    func test_GetPaymentMethods_WhenPoundsCurrency_ShouldExcludeIdealPayment() {
        let methods = sut.getPaymentMethods()
        XCTAssertEqual(methods.count, 2)
    }
    
    /*
     * GIVEN: Calculating all payment methods
     *
     * WHEN: amount currency is EUR
     *
     * THEN: count of methods should 3: cards, apple ideal
     */
    func test_GetPaymentMethods_WhenEURisCurrency_ShouldAddiDealPayment() {
        configuration.amount = JPAmount("123", currency: "EUR")
        let methods = sut.getPaymentMethods()
        XCTAssertEqual(methods.count, 3)
    }
    
    /*
     * GIVEN: We need to order cards
     *
     * WHEN: we have in store more then 1 card
     *
     * THEN: card with isDefault parameter = true should be at first index of card list
     */
    func testOrderCards_WhenCardIsDefault_ShouldPlaceOnFirstIndex() {
        JPCardStorage.sharedInstance()?.deleteCardDetails()
        let card = JPStoredCardDetails(lastFour: "4444", expiryDate: "24/24", cardNetwork: .AMEX, cardToken: "cardToken4")
        let defaultCard = JPStoredCardDetails(lastFour: "4444", expiryDate: "24/24", cardNetwork: .AMEX, cardToken: "cardToken4")
        defaultCard?.isDefault = true
        JPCardStorage.sharedInstance()?.add(card)
        JPCardStorage.sharedInstance()?.add(defaultCard)
        
        sut.orderCards()
        let cards = sut.getStoredCardDetails()
        XCTAssertTrue((cards[0] as JPStoredCardDetails).isDefault)
    }
    
    /*
     * GIVEN: remove all cards from store
     *
     * WHEN: checking all cards
     *
     * THEN: should be empty list of cards
     */
    func test_DeleteCardWithIndex_WhenRemoving_ShouldCountCardsRight() {
        let initialCount = JPCardStorage.sharedInstance()?.fetchStoredCardDetails().count
        let card = JPStoredCardDetails(lastFour: "4444", expiryDate: "24/24", cardNetwork: .AMEX, cardToken: "cardToken4")
        JPCardStorage.sharedInstance()?.add(card)
        sut.deleteCard(with: 0)
        let countAfterRemoving = JPCardStorage.sharedInstance()?.fetchStoredCardDetails().count
        
        XCTAssertEqual(initialCount, countAfterRemoving)
    }
    
    /*
     * GIVEN: check for apple pay
     *
     * WHEN: testing on simulator
     *
     * THEN: should return false
     */
    func test_IsApplePaySetUp_WhenSimulator_ShouldReturnFalse() {
        XCTAssertFalse(sut.isApplePaySetUp())
    }
    
    /*
     * GIVEN: Add a card
     *
     * WHEN: set last card selected
     *
     * THEN: should return true for isLastUsed
     */
    func test_SetLastUsedCardAtIndex_WhenAddingCard_SetLastUsed() {
        let card = JPStoredCardDetails(lastFour: "4444", expiryDate: "24/24", cardNetwork: .AMEX, cardToken: "cardToken4")
        JPCardStorage.sharedInstance()?.add(card)
        sut.setLastUsedCardAt(0)
        XCTAssertTrue((JPCardStorage.sharedInstance()!.fetchStoredCardDetails()[0] as! JPStoredCardDetails).isLastUsed)
    }
    
    /*
     * GIVEN: Get a list of ideal banks
     *
     * WHEN: there are stored in interactor
     *
     * THEN: should return 12 banks
     */
    func test_GetIDEALBankTypes_WhenGettingBanks_ShouldReturnRightNumber() {
        let array = sut.getIDEALBankTypes()
        XCTAssertEqual(array.count, 12)
    }
    
    /*
     * GIVEN: Set default card
     *
     * WHEN: adding card to JPCardStorage
     *
     * THEN: should return isDefault true
     */
    func test_SetCardAsDefaultAtIndex_WhenAddingCard_ShouldSaveIsDefault() {
        let card = JPStoredCardDetails(lastFour: "4444", expiryDate: "24/24", cardNetwork: .AMEX, cardToken: "cardToken4")
        JPCardStorage.sharedInstance()?.add(card)
        sut.setCardAsDefaultAt(0)
        XCTAssertTrue((JPCardStorage.sharedInstance()!.fetchStoredCardDetails()[0] as! JPStoredCardDetails).isDefault)
    }
    
    /*
     * GIVEN: Set card as selected
     *
     * WHEN: adding card to JPCardStorage
     *
     * THEN: should isSelected true
     */
    func test_SetCardAsSelectedAtIndex_WhenAddingCard_ShouldSaveisSelected() {
        let card = JPStoredCardDetails(lastFour: "4444", expiryDate: "24/24", cardNetwork: .AMEX, cardToken: "cardToken4")
        JPCardStorage.sharedInstance()?.add(card)
        sut.setCardAsSelectedAt(0)
        XCTAssertTrue((JPCardStorage.sharedInstance()!.fetchStoredCardDetails()[0] as! JPStoredCardDetails).isSelected)
    }
    
    /*
     * GIVEN: Selected card at index
     *
     * WHEN: adding card to JPCardStorage
     *
     * THEN: should isSelected true
     */
    func test_SelectCardAtIndex() {
        let card = JPStoredCardDetails(lastFour: "4444", expiryDate: "24/24", cardNetwork: .AMEX, cardToken: "cardToken4")
        JPCardStorage.sharedInstance()?.add(card)
        sut.selectCard(at: 0)
        XCTAssertTrue((JPCardStorage.sharedInstance()!.fetchStoredCardDetails()[0] as! JPStoredCardDetails).isSelected)
    }
}
