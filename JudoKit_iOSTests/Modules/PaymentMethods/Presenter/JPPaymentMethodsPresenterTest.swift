//
//  JPPaymentMethodsPresenterTest.swift
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

@testable import JudoKit_iOS
import XCTest

class JPPaymentMethodsPresenterTest: XCTestCase {
    var sut: JPPaymentMethodsPresenterImpl!
    let controller = JPPaymentMethodsViewControllerMock()
    let router = JPPaymentMethodsRouterImplMock()
    let interactor = JPPaymentMethodsInteractorMock()

    lazy var firstStoredCard = JPStoredCardDetails(lastFour: "1111", expiryDate: "11/21", cardNetwork: .visa, cardToken: "cardToken1", cardholderName: "Bob")
    lazy var secondStoredCard = JPStoredCardDetails(
        lastFour: "2222",
        expiryDate: "22/22",
        cardNetwork: .masterCard,
        cardToken: "cardToken2",
        cardholderName: "Bobby")

    override func setUp() {
        super.setUp()
        JPCardStorage.sharedInstance()?.deleteCardDetails()
        sut = JPPaymentMethodsPresenterImpl()
        sut.view = controller
        sut.interactor = interactor
        sut.router = router
    }

    /*
     * GIVEN: updating view with card list
     *
     * WHEN: inserted 2 cards in store
     *
     * THEN: controller should receive 2 cards
     */
    func test_ViewModelNeedsUpdate_WhenTwoCardsInstore_ShouldUpdateControllerWithTwoCards() {
        JPCardStorage.sharedInstance()?.add(firstStoredCard)
        JPCardStorage.sharedInstance()?.add(secondStoredCard)
        sut.viewModelNeedsUpdate()
        XCTAssertTrue(controller.cardsList.count == 2)
    }

    /*
     * GIVEN: updating view with card list
     *
     * WHEN: all cards are removed from store (in setUp() method)
     *
     * THEN: should updated controller with 0 cards
     */
    func test_ViewModelNeedsUpdate_WhenNoCardsAreInStore_ShouldUpdateControllerWithEmptyCardList() {
        sut.viewModelNeedsUpdate()
        XCTAssertTrue(controller.cardsList.isEmpty)
    }

    /*
     * GIVEN: selecting card in JPPaymentMethodsPresenter
     *
     * WHEN: editing mode is on
     *
     * THEN: should send user to card customization screen
     */
    func test_DidSelectCardAtIndexWithEditing_WhenUserCustmizeCard_ShouldPushUserToCustomizationScreen() {
        JPCardStorage.sharedInstance()?.add(firstStoredCard)
        XCTAssertFalse(router.navigateToCardCustomizationModule)
        sut.didSelectCard(at: 0, isEditingMode: true)
        XCTAssertTrue(router.navigateToCardCustomizationModule)
    }

    /*
     * GIVEN: selecting card in JPPaymentMethodsPresenter
     *
     * WHEN: editing mode is off
     *
     * THEN: should call interactor card select and update controller UI with current card
     */
    func test_DidSelectCardAtIndex_WhenCardIsSelectedAtIndex_ShouldUpdateControllerAndInteractor() {
        JPCardStorage.sharedInstance()?.add(firstStoredCard)
        XCTAssertFalse(interactor.cardSelected)
        sut.didSelectCard(at: 0, isEditingMode: false)
        XCTAssertTrue(interactor.cardSelected)
        XCTAssertTrue(controller.cardsList.count == 1)
    }

    /*
     * GIVEN: selecting ideal option, selecting bank in iDeal type. Everything is setuped in interactorMock
     *
     * WHEN: is updated controller UI
     *
     * THEN: should set up given bank in header, check if idealBankModel is not nil in controller
     */
    func test_DidSelectBankAtIndex_WhenSelectingBankForiDeal_ShouldUpdateControllerWithBankDetails() {
        sut.changePaymentMethod(to: 1)
        sut.didSelectBank(at: 0)
        XCTAssertNotNil(controller.idealBankModel)
    }

    /*
     * GIVEN: clicking on back button
     *
     * THEN: should end all conections and dismiss controller
     */
    func test_HandleBackButtonTap_WhenUserClickBackButton_ShouldDismissController() {
        sut.handleBackButtonTap()
        XCTAssertNotNil(interactor.transactionCompleteError)
        XCTAssertEqual(interactor.transactionCompleteError!.localizedDescription, "The transaction was cancelled by the user.")
        XCTAssertTrue(router.dismissController)
    }

    /*
     * GIVEN: clicking in pay button by user
     *
     * WHEN: iDeal is selected payment method
     *
     * THEN: should send user to ideal view controller
     */
    func test_HandlePayButtonTapIdealType_WhenUserClickPayiDeal_ShouldNavigateToIdealController() {
        sut.changePaymentMethod(to: 1) // select ideal payment method, set up in interactor mock
        sut.handlePayButtonTap()
        XCTAssertTrue(router.navigatedToIdealModule)
        XCTAssertTrue(router.dismissController)
    }

    /*
     * GIVEN: clicking in pay button by user
     *
     * WHEN: card is selected payment method
     *
     * THEN: should call router for navigating to token payment module
     */
    func test_HandlePayButtonTapCardType_WhenUserClickPay_ShouldCallInteractor() {
        JPCardStorage.sharedInstance()?.add(firstStoredCard)
        interactor.setCardAsSelectedAt(0)

        sut.handlePayButtonTap()

        XCTAssertTrue(router.navigateToTokenTransactionModule)
    }

    /*
     * GIVEN: clicking in pay button by user
     *
     * WHEN: card is selected payment method and need to ask for cardholder name
     *
     * THEN: should call router for payment method call with CardholderName mode
     */
    func test_HandlePayButtonTapCardType_WhenUserClickPayWithCardholderNameRequired_ShouldNavigateToTransactionModuleWithCardholdernameMode() {
        let config = JPConfiguration()
        config.uiConfiguration.shouldAskForCardholderName = true
        interactor.shouldVerify = true
        interactor.cardDetailsModeValue = .cardholderName
        sut = JPPaymentMethodsPresenterImpl(configuration: config)
        sut.view = controller
        sut.interactor = interactor
        sut.router = router

        sut.handlePayButtonTap()

        XCTAssertTrue(router.navigateToTokenTransactionModule)
    }

    /*
     * GIVEN: clicking in pay button by user
     *
     * WHEN: card is selected payment method and need to ask for CSC and cardholder name
     *
     * THEN: should call router for payment method call with SecurityCodeAndCardholderName mode
     */
    func test_HandlePayButtonTapCardType_WhenUserClickPayWithCSCAndCardholderNameRequired_ShouldNavigateToTransactionModuleWithCSCAndCHNameMode() {
        let config = JPConfiguration()
        config.uiConfiguration.shouldAskForCSC = true
        config.uiConfiguration.shouldAskForCardholderName = true
        interactor.shouldVerify = true
        interactor.cardDetailsModeValue = .securityCodeAndCardholderName
        sut = JPPaymentMethodsPresenterImpl(configuration: config)
        sut.view = controller
        sut.interactor = interactor
        sut.router = router

        sut.handlePayButtonTap()

        XCTAssertTrue(router.navigateToTokenTransactionModule)
    }

    /*
     * GIVEN: Clicking on apple pay
     *
     * THEN: should be called startApplePay method from router
     */
    func test_HandleApplePayButtonTap() {
        JPCardStorage.sharedInstance()?.add(firstStoredCard)
        firstStoredCard?.isSelected = true
        JPCardStorage.sharedInstance()?.add(secondStoredCard)
        sut.handleApplePayButtonTap()

        let view = sut.view as! JPPaymentMethodsViewControllerMock
        let interactor = sut.interactor as! JPPaymentMethodsInteractorMock
        XCTAssertTrue(view.didPresentApplePay)
        XCTAssertTrue(interactor.startApplePay)
    }

    /*
     * GIVEN: Clicking on apple pay
     *
     * WHEN: a network error has occured
     *
     * THEN: interactor's storeError method should not be invoked
     */
    func test_HandleApplePayButtonTap_ShouldNotStoreError() {
        JPCardStorage.sharedInstance()?.add(firstStoredCard)
        firstStoredCard?.isSelected = true
        JPCardStorage.sharedInstance()?.add(secondStoredCard)

        let view = sut.view as! JPPaymentMethodsViewControllerMock
        let interactor = sut.interactor as! JPPaymentMethodsInteractorMock
        interactor.shouldFailWhenProcessApplePayment = true
        view.isPaymentAuthorized = false

        sut.handleApplePayButtonTap()

        XCTAssertTrue(view.didPresentApplePay)
        XCTAssertTrue(interactor.startApplePay)
        XCTAssertFalse(interactor.storeError)
    }

    /*
     * GIVEN: adding 2 cards to store
     *
     * WHEN: remove last one card
     *
     * THEN: should update UI with first card in list (firstStoredCard)
     */
    func test_DeleteCardWithIndex_WhenRemoveCard_ShouldUseFirstCard() {
        JPCardStorage.sharedInstance()?.add(firstStoredCard)
        JPCardStorage.sharedInstance()?.add(secondStoredCard)
        JPCardStorage.sharedInstance()?.setCardAsSelectedAt(0)
        sut.viewModelNeedsUpdate()
        sut.deleteCard(with: 1)
        let cardFromUI = controller.cardsList.first!
        XCTAssertEqual(cardFromUI.cardNumberLastFour, firstStoredCard?.cardLastFour)
    }

    /*
     * GIVEN: When editing card
     *
     * WHEN: for different status
     *
     * THEN: should update UI button translated text in header view
     */
    func test_ChangeHeaderButtonTitle_WhenUserEditCard_ShouldUpdateButtonTitleTitle() {
        JPCardStorage.sharedInstance()?.add(firstStoredCard)
        JPCardStorage.sharedInstance()?.add(secondStoredCard)
        sut.changeHeaderButtonTitle(true)

        let textButtonTrue = (controller.viewModelSut!.items?[1] as! JPPaymentMethodsCardHeaderModel).editButtonTitle
        XCTAssertEqual(textButtonTrue, "DONE")

        sut.changeHeaderButtonTitle(false)
        let textButtonFalse = (controller.viewModelSut!.items?[1] as! JPPaymentMethodsCardHeaderModel).editButtonTitle
        XCTAssertEqual(textButtonFalse, "EDIT")
    }

    /*
     * GIVEN: When user changing payment method
     *
     * WHEN: from ideal type to card
     *
     * THEN: should update UI with right viewmodel type
     */
    func test_ChangePaymentMethodToIndex_WhenUserChangeMethod_ShouldUpdateController() {
        sut.changePaymentMethod(to: 1) // select ideal payment method, set up in interactor mock
        var viewModelType = controller.viewModelSut?.headerModel?.paymentMethodType
        XCTAssertEqual(viewModelType, JPPaymentMethodType.iDeal)

        sut.changePaymentMethod(to: 0) // select card payment method, set up in interactor mock

        viewModelType = controller.viewModelSut?.headerModel?.paymentMethodType
        XCTAssertEqual(viewModelType, JPPaymentMethodType.card)
    }

    /*
     * GIVEN: Adding few cards
     *
     * WHEN: we set last card to be selected
     *
     * THEN: last card should be ydated with isSelected = true
     */
    func test_SetLastAddedCardAsSelected_WhenNoSelection_ShouldSelectLastOne() {
        JPCardStorage.sharedInstance()?.add(firstStoredCard)
        JPCardStorage.sharedInstance()?.add(secondStoredCard)
        sut.setLastAddedCardAsSelected()
        XCTAssertTrue(secondStoredCard!.isSelected)
    }

    /*
     * GIVEN: Adding few cards, and order them
     *
     * WHEN: second card is default
     *
     * THEN: second card should be on first place
     */
    func test_OrderCards_WhenSecondIsDefault_ShouldPlaceToFirstIndex() {
        secondStoredCard?.isDefault = true
        JPCardStorage.sharedInstance()?.add(firstStoredCard)
        JPCardStorage.sharedInstance()?.add(secondStoredCard)
        sut.orderCards()

        let card = (JPCardStorage.sharedInstance()!.fetchStoredCardDetails()!.firstObject! as! JPStoredCardDetails)
        XCTAssertTrue(card.isDefault)
    }

    /*
     * GIVEN: Remove all cards, and save 3 cards with different expiry dates
     *
     * WHEN: each card have different expiry date
     *
     * THEN: should check expiration status right
     */
    func test_ExpirationDateHandling_WhenSaveThreeCards_ShouldCheckTheirExpirationDate() {
        JPCardStorage.sharedInstance()?.deleteCardDetails()
        interactor.saveMockCards()
        sut.viewModelNeedsUpdate()
        XCTAssert(controller.cardsList[0].cardExpirationStatus == .notExpired)
        XCTAssert(controller.cardsList[1].cardExpirationStatus == .expiresSoon)
        XCTAssert(controller.cardsList[2].cardExpirationStatus == .expired)
    }

    /*
     * GIVEN: designated init JPPaymentMethodsPresenterImpl
     *
     * WHEN: injecting config
     *
     * THEN: should return non nil JPPaymentMethodsPresenterImpl object
     */
    func test_InitWithConfiguration_WhenInitWithConfig_ShouldReturnNonNil() {
        let configuration = JPConfiguration(judoID: "judoId",
                                            amount: JPAmount("0.01", currency: "GBR"),
                                            reference: JPReference(consumerReference: "consumerReference"))
        let sut = JPPaymentMethodsPresenterImpl(configuration: configuration)
        XCTAssertNotNil(sut)
    }

    /*
     * GIVEN: updating view with card list
     *
     * WHEN: inserted 2 cards in store, last one selected
     *
     * THEN: router should call navigateToTransactionModule
     */
    func test_ViewModelNeedsUpdate_WhenHandlePayButtonTap_ShouldNavigateToTransaction() {
        JPCardStorage.sharedInstance()?.add(firstStoredCard)
        JPCardStorage.sharedInstance()?.add(secondStoredCard)
        interactor.shouldVerify = true
        sut.setLastAddedCardAsSelected()
        sut.handlePayButtonTap()
        XCTAssertTrue(router.navigateToTokenTransactionModule)
    }
}
