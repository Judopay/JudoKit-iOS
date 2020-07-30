//
//  JPCardCustomizationPresenterTest.swift
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

class JPCardCustomizationPresenterTest: XCTestCase {
    
    var sut: JPCardCustomizationPresenterImpl! = nil
    let controller = JPCardCustomizationViewMock()
    let interactor = JPCardCustomizationInteractorMock()
    let router = JPCardCustomizationRouterMock()
    
    override func setUp() {
        super.setUp()
        sut = JPCardCustomizationPresenterImpl()
        sut.view = controller
        sut.interactor = interactor
        sut.router = router
    }
    
    /*
     * GIVEN: Prepare model for UI
     *
     * WHEN: updating card
     *
     * THEN: should call view for new UI
     */
    func test_PrepareViewModel_WhenCardUpdated_CallViewForUpdate() {
        sut.prepareViewModel()
        XCTAssertTrue(controller.viewUpdated)
    }
    
    /*
     * GIVEN: User tap back button
     *
     * THEN: should call router method
     */
    func test_HandleBackButtonTap_WhenUserTapBack_ShouldCallRouter() {
        sut.handleBackButtonTap()
        XCTAssertTrue(router.navigateBackCalled)
    }
    
    /*
     * GIVEN: Change pattern type for card
     *
     * WHEN: updating card pattern - .blue
     *
     * THEN: should call update view with new card pattern
     */
    func test_HandlePatternSelectionWithType_WhenChangedStyle_ShouldUpdateModelForUi() {
        sut.handlePatternSelection(with: .blue)
        let patternModels = (controller.viewModelsSUT[2] as! JPCardCustomizationPatternPickerModel).patternModels
        let blueSelected = patternModels.filter{$0.pattern.type == .blue}.first!.isSelected
        
        XCTAssertTrue(blueSelected)
    }
    
    /*
     * GIVEN: Change card title input
     *
     * WHEN: updating card title with "new input"
     *
     * THEN: should call update view with new card title
     */
    func test_HandleCardInputFieldChangeWithInput_WhenChangedInput_ShouldUpdateCardTtitle() {
        sut.handleCardInputFieldChange(withInput: "new input")
        let patternModels = (controller.viewModelsSUT[1] as! JPCardCustomizationHeaderModel).cardTitle
        
        XCTAssertEqual(patternModels, "new input")
    }
    
    /*
     * GIVEN: user tap cancel
     *
     * THEN: should call router and navigate back
     */
    func test_HandleCancelEvent_WhenTapCancel_ShouldNavigateBack() {
        sut.handleCancelEvent()
        XCTAssertTrue(router.navigateBackCalled)
    }
    
    /*
     * GIVEN: user tap on save
     *
     * THEN: should save in interactor and call router naviagte back
     */
    func test_HandleSaveEvent_WhenTapSave_ShouldNavigateBackAndSave() {
        sut.handleSaveEvent()
        XCTAssertTrue(router.navigateBackCalled)
        XCTAssertTrue(interactor.updateStoredCard)        
    }
    
    /*
     * GIVEN: Toggle default card
     *
     * WHEN: current default change status
     *
     * THEN: should call update view with default
     */
    func test_HandleToggleDefaultCardEvent_WhenToggleDefault_ShouldUpdateViewWithOpositDefault() {
        sut.prepareViewModel()
        let initialDefault = (controller.viewModelsSUT[4] as! JPCardCustomizationIsDefaultModel).isDefault
        sut.handleToggleDefaultCardEvent()
        let sutDefault = (controller.viewModelsSUT[4] as! JPCardCustomizationIsDefaultModel).isDefault
        
        XCTAssertEqual(initialDefault, !sutDefault)

    }
    
}
