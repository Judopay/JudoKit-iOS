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
        XCTAssertEqual(controller.viewModelSut.secureCodeViewModel.placeholder, "CVV")
        XCTAssertEqual(controller.viewModelSut.countryPickerViewModel.placeholder, "Country")
        XCTAssertEqual(controller.viewModelSut.postalCodeInputViewModel.placeholder, "Postcode")
        
        XCTAssertTrue(controller.viewModelSut.shouldDisplayAVSFields)
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
