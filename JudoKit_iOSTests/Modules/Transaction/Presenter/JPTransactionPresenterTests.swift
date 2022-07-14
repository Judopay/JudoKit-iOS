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

class JPTransactionPresenterTests: XCTestCase {
    var sut: JPTransactionPresenterImpl! = nil
    let controller = JPTransactionViewMock()
    let interactor = JPTransactionInteractorMock()
    let router = JPTransactionRouterMock()
    
    override func setUp() {
        super.setUp()
        sut = JPTransactionPresenterImpl()
        sut.view = controller
        sut.interactor = interactor
        sut.router = router
    }
    
    /*
     * GIVEN: creating view model for card view
     *
     * WHEN: getting data from interactor mock
     *
     * THEN: should fill all parameters in view model
     */
    func test_PrepareInitialViewModel_whenPreparingModelForUI() {
        sut.prepareInitialViewModel()
        XCTAssertEqual(controller.viewModelSut.cardNumberViewModel.placeholder, "Card Number")
        XCTAssertEqual(controller.viewModelSut.cardholderNameViewModel.placeholder, "Cardholder Name")
        XCTAssertEqual(controller.viewModelSut.expiryDateViewModel.placeholder, "MM/YY")
        XCTAssertEqual(controller.viewModelSut.secureCodeViewModel.placeholder, "CVV2")
        XCTAssertEqual(controller.viewModelSut.countryPickerViewModel.placeholder, "country")
        XCTAssertEqual(controller.viewModelSut.postalCodeInputViewModel.placeholder, "Postcode")
        
        XCTAssertFalse(controller.viewModelSut.addCardButtonViewModel.isEnabled)
    }
    
    /*
     * GIVEN: handleInputChange is invoked
     *
     * WHEN: type is card Number
     *
     * THEN: should fill card number in viewmodel
     */
    func test_handleInputChange_WhenTypeIsCard_ShouldUpdateViewModelWithCardNumber() {
        sut.handleInputChange("4444", for: .cardNumber)
        XCTAssertEqual(controller.viewModelSut.cardNumberViewModel.text, "4444")
    }
    
    /*
     * GIVEN: handleInputChange is invoked
     *
     * WHEN: type is card card Expiry Date
     *
     * THEN: should fill expiry Date ViewModel
     */
    func test_handleInputChange_WhenTypeIsCardExpiryDate_ShouldUpdateViewModelWithCardNumber() {
        sut.handleInputChange("10/20", for: .cardExpiryDate)
        XCTAssertEqual(controller.viewModelSut.expiryDateViewModel.text, "10/20")
    }
    
    /*
     * GIVEN: handleInputChange is invoked
     *
     * WHEN: type is secure
     *
     * THEN: should fill card secure Code ViewModel
     */
    func test_handleInputChange_WhenTypeIsSecure_ShouldUpdateViewModelWithCardNumber() {
        sut.handleInputChange("123", for: .cardSecureCode)
        XCTAssertEqual(controller.viewModelSut.secureCodeViewModel.text, "123")
    }
    
    /*
     * GIVEN: handleInputChange is invoked
     *
     * WHEN: type is card holder Name
     *
     * THEN: should fill card holder Name ViewModel
     */
    func test_handleInputChange_WhenTypeIsCardholderName_ShouldUpdateViewModelWithCardNumber() {
        sut.handleInputChange("name", for: .cardholderName)
        XCTAssertEqual(controller.viewModelSut.cardholderNameViewModel.text, "name")
    }
    
    /*
     * GIVEN: handleInputChange is invoked
     *
     * WHEN: type is card Country
     *
     * THEN: should fill country Picker ViewModel
     */
    func test_handleInputChange_WhenTypeIsCardCountry_ShouldUpdateViewModelWithCardNumber() {
        sut.handleInputChange("UK", for: .cardCountry)
        XCTAssertEqual(controller.viewModelSut.countryPickerViewModel.text, "UK")
    }
    
    /*
     * GIVEN: handleInputChange is invoked
     *
     * WHEN: type is card Postal Code
     *
     * THEN: should fill postal Code Input ViewModel
     */
    func test_handleInputChange_WhenTypeIsCardPostalCode_ShouldUpdateViewModelWithCardNumber() {
        sut.handleInputChange("1001", for: .cardPostalCode)
        XCTAssertEqual(controller.viewModelSut.postalCodeInputViewModel.text, "1001")
    }
    
    /*
     * GIVEN: User taps on scan
     *
     * THEN: showedCameraAlert should be invoked
     */
    func test_HandleScanCardButtonTap_WhenScanCard_ShouldShowAlertInView() {
        sut.handleScanCardButtonTap()
        XCTAssertTrue(controller.showedCameraAlert)
    }
    
    /*
     * GIVEN: User taps on cancel
     *
     * THEN: completeTransaction on interactor instance should be invoked
     */
    func test_HandleCancelButtonTap_WhenCancel_ShouldCallInteractor() {
        sut.handleCancelButtonTap()
        XCTAssertTrue(interactor.completeTransaction)
    }
    
    /*
     * GIVEN: Send scan result to view
     *
     * WHEN: scan result is populated with fields
     *
     * THEN: should receive same field in View
     */
    func test_updateViewModelWithScanCardResult_WhenRecieveFields_ShouldBeSameInViewModel() {
        sut.updateViewModel(withCardNumber: "4445", andExpiryDate: "10/20")
        XCTAssertEqual(controller.viewModelSut.cardNumberViewModel.text, "4445")
        XCTAssertEqual(controller.viewModelSut.expiryDateViewModel.text, "10/20")
    }
    
    /*
     * GIVEN: User taps on transaction
     *
     * WHEN: card model is valid, init jperror
     *
     * THEN: should invoke interactor.trasactionSent and send error to view
     */
    func test_HandleTransactionButtonTap_WhenUserTapAndError_ShouldCallInteractor() {
        interactor.testSendTransaction = .error
        sut.handleTransactionButtonTap()
        XCTAssertTrue(interactor.trasactionSent)
        XCTAssertEqual(controller.error.localizedDescription, "The operation couldn’t be completed. (Domain test error 123.)")
    }
    
    /*
     * GIVEN: User taps on transaction
     *
     * WHEN: card model is valid, mock valid response
     *
     * THEN: should invoke interactor.trasactionSent and dismiss view
     */
    func test_HandleTransactionButtonTap_WhenUserTapAnValid_ShouldCallInteractor() {
        interactor.type = .payment
        interactor.testSendTransaction = .validData
        sut.handleTransactionButtonTap()
        XCTAssertTrue(interactor.trasactionSent)
        XCTAssertTrue(router.dimissController)
    }
    
    /*
     * GIVEN: User taps on transaction
     *
     * WHEN: card model is valid and 3dsError
     *
     * THEN: should invoke interactor.trasactionSent
     */
    func test_HandleTransactionButtonTap_WhenUserTapAnThreeDSError_ShouldCallInteractor() {
        interactor.testSendTransaction = .threedDSError
        sut.handleTransactionButtonTap()
        XCTAssertTrue(interactor.trasactionSent)
    }
    
    /*
     * GIVEN: creating view model for card view
     *
     * WHEN: getting data from interactor mock for saveCard
     *
     * THEN: should fill correct pay button title
     */
    func test_PrepareInitialViewModel_WhenPreparingModel_ShouldSetRightButtonTitle() {
        interactor.type = .saveCard
        sut.prepareInitialViewModel()
        XCTAssertEqual(controller.viewModelSut.addCardButtonViewModel.title, "SAVE CARD")
    }
    
    /*
     * GIVEN: creating view model for card view
     *
     * WHEN: getting data from interactor mock for preAuth
     *
     * THEN: should fill correct pay button title
     */
    func test_PrepareInitialViewModel_WhenPreparingModelForPreAuth_ShouldSetRightButtonTitle() {
        interactor.type = .preAuth
        sut.prepareInitialViewModel()
        XCTAssertEqual(controller.viewModelSut.addCardButtonViewModel.title, "PAY")
    }
    
    /*
     * GIVEN: creating view model for card view
     *
     * WHEN: getting data from interactor mock for checkCard
     *
     * THEN: should fill correct pay button title
     */
    func test_PrepareInitialViewModel_WhenPreparingModelForCheckCard_ShouldSetRightButtonTitle() {
        interactor.type = .checkCard
        sut.prepareInitialViewModel()
        XCTAssertEqual(controller.viewModelSut.addCardButtonViewModel.title, "CHECK CARD")
    }
    
    /*
     * GIVEN: handleInputChange is invoked
     *
     * WHEN: securityCode is securityCode mode, invalid input
     *
     * THEN: should return false isEnabled
     */
    func test_handleInputChange_WhenTypeSecurityCode_ShouldEnableAddCard() {
        interactor.mode = .securityCode
        sut.handleInputChange("4444", for: .cardNumber)
        XCTAssertFalse(controller.viewModelSut.addCardButtonViewModel.isEnabled)
    }
    
    /*
     * GIVEN: handleInputChange is invoked
     *
     * WHEN: AVS is securityCode mode, invalid input
     *
     * THEN: should return false isEnabled
     */
    func test_handleInputChange_WhenAVSMode_ShouldEnableAddCard() {
        interactor.mode = .AVS
        sut.handleInputChange("4444", for: .cardNumber)
        XCTAssertFalse(controller.viewModelSut.addCardButtonViewModel.isEnabled)
    }
}
