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
        XCTAssertEqual(controller.viewModelSut.countryPickerViewModel.placeholder, "Country")
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
     * GIVEN: User taps on transaction
     *
     * WHEN: card model is valid
     *
     * THEN: should invoke interactor.trasactionSent
     */
    func test_HandleTransactionButtonTap_WhenUserTap_ShouldCallInteractor() {
        sut.handleTransactionButtonTap()
        XCTAssertTrue(interactor.trasactionSent)
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
     * THEN: should recieve same field in View
     */
    func test_updateViewModelWithScanCardResult_WhenRecieveFields_ShouldBeSameInViewModel() {
        let scanResult = PayCardsRecognizerResult()
        scanResult.recognizedNumber = "4445"
        scanResult.recognizedHolderName = "Alex"
        scanResult.recognizedExpireDateYear = "20"
        scanResult.recognizedExpireDateMonth = "10"
        sut.updateViewModel(withScanCardResult: scanResult)
        
        XCTAssertEqual(controller.viewModelSut.cardNumberViewModel.text, "4445")
        XCTAssertEqual(controller.viewModelSut.cardholderNameViewModel.text, "Alex")
        XCTAssertEqual(controller.viewModelSut.expiryDateViewModel.text, "10/20")
    }
}
