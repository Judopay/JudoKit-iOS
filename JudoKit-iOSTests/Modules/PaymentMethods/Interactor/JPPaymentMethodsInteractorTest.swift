//
//  JPPaymentMethodsInteractorTest.swift
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

class JPPaymentMethodsInteractorTest: XCTestCase {
    var sut: JPPaymentMethodsInteractor!
    let configuration = JPConfiguration(judoID: "judoId", amount: JPAmount("123", currency: "GBP"), reference: JPReference(consumerReference: "consumerReference"))
    
    override func setUp() {
        super.setUp()
        configuration.supportedCardNetworks = [.visa, .masterCard, .AMEX]
        let service = JPTransactionServiceStub()
        sut = JPPaymentMethodsInteractorImpl(mode: .serverToServer, configuration: configuration, transactionService: service, completion: nil)
    }
    
    func testServerToServer()  {
        let completion: JPCompletionBlock = { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
        }
        sut.paymentTransaction(withToken: "", andCompletion: completion)
    }
    
    func testServerToServerApple()  {
        let completion: JPCompletionBlock = { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
        }
        sut.startApplePay(completion: completion)
    }
    
    func testGetAmount() {
        let amount = sut.getAmount()
        XCTAssertEqual(amount.amount, "123")
        XCTAssertEqual(amount.currency, "GBP")
    }
    
    func testStoredCards_WhenRemovingAllCards_ShouldGetEmptyList() {
        JPCardStorage.sharedInstance()?.deleteCardDetails()
        let cards = sut.getStoredCardDetails()
        XCTAssertEqual(cards.count, 0)
    }
    
    func testStoredCards_WhenAddingNewCards_ShouldAppearInList() {
        JPCardStorage.sharedInstance()?.deleteCardDetails()
        let card = JPStoredCardDetails(lastFour: "4444", expiryDate: "24/24", cardNetwork: .AMEX, cardToken: "cardToken4")
        JPCardStorage.sharedInstance()?.add(card)
        
        let cards = sut.getStoredCardDetails()
        XCTAssertEqual(cards.count, 1)
    }
    
    /*
     * GIVEN: Calculating all payment methods
     *
     * WHEN: config object are seted up with GBP currency
     *
     * THEN: count of methods should 2: cards and apple pay
     */
    func testGetPaymentMethods_WhenPoundsCurrency_ShouldExcludeIdealPayment() {
        let methods = sut.getPaymentMethods()
        XCTAssertEqual(methods.count, 2)
    }
    
    /*
     * GIVEN: Calculating all payment methods
     *
     * WHEN: config object are seted up with EUR currency
     *
     * THEN: count of methods should 3: cards, apple ideal
     */
    func testGetPaymentMethods_WhenEURisCurrency_ShouldAddiDealPayment() {
        configuration.amount = JPAmount("123", currency: "EUR")
        let methods = sut.getPaymentMethods()
        XCTAssertEqual(methods.count, 3)
    }
    
    //card with isDefault parameter true should be at first index of card list.
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
}
