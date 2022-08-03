//
//  JPUIConfigurationTest.swift
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

class JPUIConfigurationTest: XCTestCase {
    let sut = JPUIConfiguration()
    
    /*
     * GIVEN: object of JPUIConfiguration
     *
     * WHEN: derfault bools for flags
     *
     * THEN: should return right default bools
     */
    func test_Init_WhenDefault_ShouldReturnDefaultBools() {
        XCTAssertFalse(sut.isAVSEnabled)
        XCTAssertFalse(sut.shouldPaymentButtonDisplayAmount)
        XCTAssertTrue(sut.shouldPaymentMethodsDisplayAmount)
        XCTAssertTrue(sut.shouldPaymentMethodsVerifySecurityCode)
    }
    
    /*
     * GIVEN: Creating lazy init JPTheme
     *
     * WHEN: all fields are default
     *
     * THEN: should return right properties
     */
    func test_Theme_WhenLazyInit_ShouldReturnDefaultFields() {
        let theme = sut.theme
        XCTAssertNotNil(theme)
        XCTAssertEqual(theme?.largeTitle, UIFont._jp_largeTitle())
        XCTAssertEqual(theme?.title, UIFont._jp_title())
        XCTAssertEqual(theme?.headline, UIFont._jp_headline())
        XCTAssertEqual(theme?.headlineLight, UIFont._jp_headlineLight())
        XCTAssertEqual(theme?.body, UIFont._jp_body())
        XCTAssertEqual(theme?.bodyBold, UIFont._jp_bodyBold())
        XCTAssertEqual(theme?.caption, UIFont._jp_caption())
        XCTAssertEqual(theme?.captionBold, UIFont._jp_captionBold())
        XCTAssertEqual(theme?.jpBlackColor, UIColor._jp_black())
        XCTAssertEqual(theme?.jpDarkGrayColor, UIColor._jp_darkGray())
        XCTAssertEqual(theme?.jpGrayColor, UIColor._jp_gray())
        XCTAssertEqual(theme?.jpLightGrayColor, UIColor._jp_lightGray())
        XCTAssertEqual(theme?.jpRedColor, UIColor._jp_red())
        XCTAssertEqual(theme?.jpWhiteColor, UIColor._jp_white())
        XCTAssertEqual(theme?.buttonColor, UIColor._jp_black())
        XCTAssertEqual(theme?.buttonTitleColor, UIColor._jp_white())
        XCTAssertEqual(theme?.buttonCornerRadius, 4.0)
    }
    
}
