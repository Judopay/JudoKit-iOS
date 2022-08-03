//
//  UIColorAdditionsTest.swift
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

class UIColorAdditionsTest: XCTestCase {
    
    /*
     * GIVEN: the [asImage] method is called on an instance of UIColor
     *
     * THEN: the result should be an UIImage representation of that color
     */
    func test_AsImage_WhenInitAColor_ShouldReturnNonNilImage() {
        let color = UIColor.black
        let image = color._jp_asImage()
        XCTAssertNotNil(image)
    }
    
    /*
     * GIVEN: an image is initialized by calling the [fromHex] initializer from the UIImage extension
     *
     * WHEN: the number is a valid white HEX value
     *
     * THEN: the result should be an instance of UIImage with the correct color
     */
    func test_ColorFromHex_WhenInitColor_ShouldReturnRightColor() {
        let sut = UIColor._jp_color(fromHex: 0xFFFFFF)
        let colorWhite = UIColor.white
        XCTAssertTrue(compareColors(c1: sut, c2: colorWhite))
    }
    
    /*
     * GIVEN: an image is initialized by calling the [fromHex] initializer from the UIImage extension
     *
     * WHEN: the number is a valid jpBlack HEX value
     *
     * THEN: the result should be an instance of UIImage with the correct color
     */
    func test_JpBlackColor_WhenInit_ShouldReturnRightColor() {
        let jpBlackColor = UIColor._jp_color(fromHex: 0x262626)
        let sutColor = UIColor._jp_black()
        XCTAssertTrue(compareColors(c1: sutColor, c2: jpBlackColor))
    }
    
    /*
     * GIVEN: an image is initialized by calling the [fromHex] initializer from the UIImage extension
     *
     * WHEN: the number is a valid jpGray HEX value
     *
     * THEN: the result should be an instance of UIImage with the correct color
     */
    func test_JpDarkGrayColor_WhenInit_ShouldReturnRightColor() {
        let jpDarkGrayColor = UIColor._jp_color(fromHex: 0x999999)
        let sutColor = UIColor._jp_darkGray()
        XCTAssertTrue(compareColors(c1: sutColor, c2: jpDarkGrayColor))
    }
    
    /*
     * GIVEN: an image is initialized by calling the [fromHex] initializer from the UIImage extension
     *
     * WHEN: the number is a valid jpGray HEX value
     *
     * THEN: the result should be an instance of UIImage with the correct color
     */
    func test_JpGrayColor_WhenInit_ShouldReturnRightColor() {
        let jpGrayColor = UIColor._jp_color(fromHex: 0xE5E5E5)
        let sutColor = UIColor._jp_gray()
        XCTAssertTrue(compareColors(c1: sutColor, c2: jpGrayColor))
    }
    
    /*
     * GIVEN: an image is initialized by calling the [fromHex] initializer from the UIImage extension
     *
     * WHEN: the number is a valid jpLightGray HEX value
     *
     * THEN: the result should be an instance of UIImage with the correct color
     */
    func test_JpLightGrayColor_WhenInit_ShouldReturnRightColor() {
        let jpLightGrayColor = UIColor._jp_color(fromHex: 0xF6F6F6)
        let sutColor = UIColor._jp_lightGray()
        XCTAssertTrue(compareColors(c1: sutColor, c2: jpLightGrayColor))
    }
    
    /*
     * GIVEN: an image is initialized by calling the [fromHex] initializer from the UIImage extension
     *
     * WHEN: the number is a valid jpRed HEX value
     *
     * THEN: the result should be an instance of UIImage with the correct color
     */
    func test_JpRedColor_WhenInit_ShouldReturnRightColor() {
        let jpRedColor = UIColor._jp_color(fromHex: 0xE21900)
        let sutColor = UIColor._jp_red()
        XCTAssertTrue(compareColors(c1: sutColor, c2: jpRedColor))
    }
    
    /*
     * GIVEN: an image is initialized by calling the [fromHex] initializer from the UIImage extension
     *
     * WHEN: the number is a valid jpWhite HEX value
     *
     * THEN: the result should be an instance of UIImage with the correct color
     */
    func test_JpWhiteColor_WhenInit_ShouldReturnRightColor() {
        let jpWhiteColor = UIColor._jp_color(fromHex: 0xFFFFFF)
        let sutColor = UIColor._jp_white()
        XCTAssertTrue(compareColors(c1: sutColor, c2: jpWhiteColor))
    }
    
    //MARK: method that helps comparing colors.
    func compareColors(c1:UIColor, c2:UIColor) -> Bool{
        var red:CGFloat = 0
        var green:CGFloat  = 0
        var blue:CGFloat = 0
        var alpha:CGFloat  = 0
        c1.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var red2:CGFloat = 0
        var green2:CGFloat  = 0
        var blue2:CGFloat = 0
        var alpha2:CGFloat  = 0
        c2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        return (Int(red*255) == Int(red*255) && Int(green*255) == Int(green2*255) && Int(blue*255) == Int(blue*255) )
    }
}
