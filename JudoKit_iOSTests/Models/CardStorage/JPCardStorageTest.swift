//
//  JPCardStorageTest.swift
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

class JPCardStorageTest: XCTestCase {
    
    lazy var firstStoredCard = JPStoredCardDetails(lastFour: "1111", expiryDate: "11/21", cardNetwork: .visa, cardToken: "cardToken1")
    lazy var secondStoredCard = JPStoredCardDetails(lastFour: "2222", expiryDate: "22/22", cardNetwork: .masterCard, cardToken: "cardToken2")
    lazy var thirdStoredCard = JPStoredCardDetails(lastFour: "3333", expiryDate: "23/23", cardNetwork: .JCB, cardToken: "cardToken3")
    lazy var forthStoredCard = JPStoredCardDetails(lastFour: "4444", expiryDate: "24/24", cardNetwork: .AMEX, cardToken: "cardToken4")
    
    override func setUp() {
        super.setUp()
        JPCardStorage.sharedInstance()?.deleteCardDetails()
    }
    
    /*
     * GIVEN: JPCardStorage set card state at given index
     *
     * WHEN: setup default card for index 2
     *
     * THEN: should return thirdStoredCard from method fetchStoredCardDetails
     */
    func test_SetCardAsDefault_WhenSelectDefaultCard_ShouldSetThatCardAtFirstIndex() {
        self.addTestCardsInStorage()
        JPCardStorage.sharedInstance()?.setCardDefaultState(true, at: 2);
        let storedCardsDetails:[JPStoredCardDetails] = JPCardStorage.sharedInstance()?.fetchStoredCardDetails() as! [JPStoredCardDetails]
        let selectedCard = storedCardsDetails[0];
        XCTAssert(selectedCard.cardLastFour == "3333")
        XCTAssert(selectedCard.expiryDate == "23/23")
        XCTAssert(selectedCard.cardNetwork == .JCB)
        XCTAssert(selectedCard.cardToken == "cardToken3")
    }
    
    func addTestCardsInStorage() {
        JPCardStorage.sharedInstance()?.add(firstStoredCard)
        JPCardStorage.sharedInstance()?.add(secondStoredCard)
        JPCardStorage.sharedInstance()?.add(thirdStoredCard)
        JPCardStorage.sharedInstance()?.add(forthStoredCard)
    }
    
    /*
     * GIVEN: JPCardStorage sorting card
     *
     * WHEN: fetching all cards from stack
     *
     * THEN: should place default card to first index
     */
    func test_OrderCards_WhenOneCardIsDefault_WhenOrdering_ShouldPlaceThatCardOnFirstPostition() {
        firstStoredCard?.isDefault = true
        JPCardStorage.sharedInstance()?.add(secondStoredCard)
        JPCardStorage.sharedInstance()?.add(firstStoredCard)
        var cards = JPCardStorage.sharedInstance()?.fetchStoredCardDetails()
        XCTAssertFalse((cards![0] as! JPStoredCardDetails).isDefault)
        
        JPCardStorage.sharedInstance()?.orderCards()
        cards = JPCardStorage.sharedInstance()?.fetchStoredCardDetails()
        XCTAssertTrue((cards![0] as! JPStoredCardDetails).isDefault)
    }
    
    /*
    * GIVEN: JPCardStorage fetching all card (in setUp() we remove all card from store)
    *
    * WHEN: fetching all cards from stack
    *
    * THEN: count of cards should be 0
    */
    func test_DeleteCards_WhenIsSetupRemoveAllCards_ShouldReturnEmptyArray() {
        let cards = JPCardStorage.sharedInstance()?.fetchStoredCardDetails()
        XCTAssert(cards?.count == 0)
    }
    
    /*
       * GIVEN: JPCardStorage remove all cards in store
       *
       * WHEN: before in store was saved few card
       *
       * THEN: after removeing, cards count should be 0
       */
    func test_DeleteCardIndex_WhenRemoveingCardAtIndex_ShouldReturnRightCardsCount() {
        JPCardStorage.sharedInstance()?.add(firstStoredCard)
        JPCardStorage.sharedInstance()?.deleteCard(with: 0)
        let cards = JPCardStorage.sharedInstance()?.fetchStoredCardDetails()
        XCTAssert(cards?.count == 0)
    }
}
