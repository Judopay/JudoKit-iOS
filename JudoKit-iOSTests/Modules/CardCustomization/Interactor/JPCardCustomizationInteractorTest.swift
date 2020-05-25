//
//  JPCardCustomizationInteractorTest.swift
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

class JPCardCustomizationInteractorTest: XCTestCase {
    var sut: JPCardCustomizationInteractor! = nil
    lazy var firstStoredCard = JPStoredCardDetails(lastFour: "1111", expiryDate: "11/21", cardNetwork: .visa, cardToken: "cardToken1")
    lazy var secondStoredCard = JPStoredCardDetails(lastFour: "2222", expiryDate: "22/22", cardNetwork: .masterCard, cardToken: "cardToken2")
    lazy var thirdStoredCard = JPStoredCardDetails(lastFour: "3333", expiryDate: "23/23", cardNetwork: .JCB, cardToken: "cardToken3")
    
    override func setUp() {
        super.setUp()
        sut = JPCardCustomizationInteractorImpl(cardIndex: 0)
        JPCardStorage.sharedInstance()?.add(firstStoredCard)
        JPCardStorage.sharedInstance()?.add(secondStoredCard)
        JPCardStorage.sharedInstance()?.add(thirdStoredCard)
    }
    
    /*
     * GIVEN: Setted up 3 cards in store
     *
     * WHEN: card index initially is 0
     *
     * THEN: should return first card
     */
    func test_CardDetails_WhenThereAre3Card_ShouldReturnRightCardIndexCard() {
        let cardSUT = sut.cardDetails()
        XCTAssertEqual(firstStoredCard?.cardLastFour, cardSUT.cardLastFour)
    }
    
    /*
     * GIVEN: Changing pattern type for card (.blue)
     *
     * WHEN: card index initially is 0
     *
     * THEN: should return right patern type (.blue)
     */
    func test_UpdateStoredCardPatternWithType_WhenSettedUpType_ShouldReturnSameTypeForCurrentCard() {
        sut.updateStoredCardPattern(with: .blue)
        let cardSUT = sut.cardDetails()
        XCTAssertEqual(cardSUT.patternType, .blue)
    }
    
    /*
     * GIVEN: Changing title for card ("new title")
     *
     * WHEN: card index initially is 0
     *
     * THEN: should return new title ("new title")
     */
    func test_UpdateStoredCardTitleWithInput_WhenSettedUpTitle_ShouldReturnSameTitleForCurrentCard() {
        sut.updateStoredCardTitle(withInput: "new title")
        let cardSUT = sut.cardDetails()
        XCTAssertEqual(cardSUT.cardTitle, "new title")
    }
    
    /*
     * GIVEN: Changing default for card (true)
     *
     * WHEN: card index initially is 0
     *
     * THEN: should return right is default parameter (true)
     */
    func test_UpdateStoredCardDefaultWithValue_WhenSetUpDefault_ShouldReturnCardIndexDefaultValue() {
        sut.updateStoredCardDefault(withValue: true)
        let cardSUT = sut.cardDetails()
        XCTAssertTrue(cardSUT.isDefault)
    }
}
