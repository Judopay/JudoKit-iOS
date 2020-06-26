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
        XCTAssertEqual(theme?.largeTitle, UIFont.largeTitle())
        XCTAssertEqual(theme?.title, UIFont.title())
        XCTAssertEqual(theme?.headline, UIFont.headline())
        XCTAssertEqual(theme?.headlineLight, UIFont.headlineLight())
        XCTAssertEqual(theme?.body, UIFont.body())
        XCTAssertEqual(theme?.bodyBold, UIFont.bodyBold())
        XCTAssertEqual(theme?.caption, UIFont.caption())
        XCTAssertEqual(theme?.captionBold, UIFont.captionBold())
        XCTAssertEqual(theme?.jpBlackColor, UIColor.jpBlack())
        XCTAssertEqual(theme?.jpDarkGrayColor, UIColor.jpDarkGray())
        XCTAssertEqual(theme?.jpGrayColor, UIColor.jpGray())
        XCTAssertEqual(theme?.jpLightGrayColor, UIColor.jpLightGray())
        XCTAssertEqual(theme?.jpRedColor, UIColor.jpRed())
        XCTAssertEqual(theme?.jpWhiteColor, UIColor.jpWhite())
        XCTAssertEqual(theme?.buttonColor, UIColor.jpBlack())
        XCTAssertEqual(theme?.buttonTitleColor, UIColor.jpWhite())
        XCTAssertEqual(theme?.buttonCornerRadius, 4.0)
    }
    
}
