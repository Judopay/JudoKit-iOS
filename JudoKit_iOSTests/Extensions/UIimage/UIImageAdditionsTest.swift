//
//  UIImageAdditionsTest.swift
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

import Foundation
import XCTest
@testable import JudoKit_iOS

class UIImageAdditionsTest: XCTestCase {
    
    /*
     * GIVEN: UIImage addition
     *
     * WHEN: trying to get headerImage for: .discover type
     *
     * THEN: should return non nil image
     */
    func test_HeaderImage_WhenGettingImageByType_ShouldReturnNonNil() {
        let image = UIImage._jp_headerImage(for: .discover)
        XCTAssertNotNil(image)
    }
    
    /*
     * GIVEN: the [headerImage] method is called from the UIImage extension
     *
     * WHEN: Visa is set as the header type
     *
     * THEN: a valid header image must be returned
     */
    func test_HeaderImage_WhenGettingImageByVisaType_ShouldReturnNonNil() {
        let image = UIImage._jp_headerImage(for: .visa)
        XCTAssertNotNil(image)
    }
    
    /*
     * GIVEN: the [headerImage] method is called from the UIImage extension
     *
     * WHEN: AMEX is set as the header type
     *
     * THEN: a valid header image must be returned
     */
    func test_HeaderImage_WhenGettingImageByAMEXType_ShouldReturnNonNil() {
        let image = UIImage._jp_headerImage(for: .AMEX)
        XCTAssertNotNil(image)
    }
    
    /*
     * GIVEN: the [headerImage] method is called from the UIImage extension
     *
     * WHEN: dinersClub is set as the header type
     *
     * THEN: a valid header image must be returned
     */
    func test_HeaderImage_WhenGettingImageByDinersClubType_ShouldReturnNonNil() {
        let image = UIImage._jp_headerImage(for: .dinersClub)
        XCTAssertNotNil(image)
    }
    
    /*
     * GIVEN: the [headerImage] method is called from the UIImage extension
     *
     * WHEN: JCB is set as the header type
     *
     * THEN: a valid header image must be returned
     */
    func test_HeaderImage_WhenGettingImageByJCBType_ShouldReturnNonNil() {
        let image = UIImage._jp_headerImage(for: .JCB)
        XCTAssertNotNil(image)
    }
    
    /*
     * GIVEN: the [headerImage] method is called from the UIImage extension
     *
     * WHEN: masterCard is set as the header type
     *
     * THEN: a valid header image must be returned
     */
    func test_HeaderImage_WhenGettingImageByMaestroType_ShouldReturnNonNil() {
        let image = UIImage._jp_headerImage(for: .maestro)
        XCTAssertNotNil(image)
    }
    
    /*
     * GIVEN: the [headerImage] method is called from the UIImage extension
     *
     * WHEN: masterCard is set as the header type
     *
     * THEN: a valid header image must be returned
     */
    func test_HeaderImage_WhenGettingImageByMasterCardType_ShouldReturnNonNil() {
        let image = UIImage._jp_headerImage(for: .masterCard)
        XCTAssertNotNil(image)
    }
    
    /*
     * GIVEN: the [headerImage] method is called from the UIImage extension
     *
     * WHEN: chinaUnionPay is set as the header type
     *
     * THEN: a valid header image must be returned
     */
    func test_HeaderImage_WhenGettingImageByChinaUnionPayType_ShouldReturnNonNil() {
        let image = UIImage._jp_headerImage(for: .chinaUnionPay)
        XCTAssertNotNil(image)
    }
    
    /*
     * GIVEN: UIImage addition init
     *
     * WHEN: trying to get image for string name
     *
     * THEN: should return non nil image
     */
    func test_InitImage_WhenIconNameIsValid_ShouldReturnNonNil() {
        let image = UIImage._jp_image(withIconName: "lock-icon")
        XCTAssertNotNil(image)
    }
    
    /*
     * GIVEN: UIImage addition init with card type
     *
     * WHEN: trying to get image for discover card
     *
     * THEN: should return non nil image
     */
    func test_InitImage_WhenTypeIsDiscover_ShouldReturnNonNil() {
        let image = UIImage._jp_image(for: .discover)
        XCTAssertNotNil(image)
    }
    
    /*
     * GIVEN: UIImage addition init with card type
     *
     * WHEN: trying to get header image for type .all
     *
     * THEN: should return nil image
     */
    func test_HeaderImage_WhenTypeAll_ShouldReturnNil() {
        let image = UIImage._jp_headerImage(for: .all)
        XCTAssertEqual(image, nil)
    }
    
    /*
     * GIVEN: UIImage addition init with card type
     *
     * WHEN: trying to init image for type .all
     *
     * THEN: should return nil image
     */
    func test_InitImage_WhenTypeAll_ShouldReturnNil() {
        let image = UIImage._jp_image(for: .all)
        XCTAssertEqual(image, nil)
    }
    
    /*
     * GIVEN: UIImage addition init with card type
     *
     * WHEN: trying to get image for card visa
     *
     * THEN: should return non nil image
     */
    func test_InitImage_WhenTypeVisa_ShouldReturnNonNil() {
        let image = UIImage._jp_image(for: .visa)
        XCTAssertNotNil(image)
    }
}
