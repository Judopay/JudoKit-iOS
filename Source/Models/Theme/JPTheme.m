//
//  JPTheme.m
//  JudoKit_iOS
//
//  Copyright (c) 2016 Alternative Payments Ltd
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

#import "JPTheme.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation JPTheme

#pragma mark - Fonts

- (UIFont *)largeTitle {
    if (!_largeTitle) {
        _largeTitle = UIFont._jp_largeTitle;
    }
    return _largeTitle;
}

- (UIFont *)title {
    if (!_title) {
        _title = UIFont._jp_title;
    }
    return _title;
}

- (UIFont *)headline {
    if (!_headline) {
        _headline = UIFont._jp_headline;
    }
    return _headline;
}

- (UIFont *)headlineLight {
    if (!_headlineLight) {
        _headlineLight = UIFont._jp_headlineLight;
    }
    return _headlineLight;
}

- (UIFont *)body {
    if (!_body) {
        _body = UIFont._jp_body;
    }
    return _body;
}

- (UIFont *)bodyBold {
    if (!_bodyBold) {
        _bodyBold = UIFont._jp_bodyBold;
    }
    return _bodyBold;
}

- (UIFont *)caption {
    if (!_caption) {
        _caption = UIFont._jp_caption;
    }
    return _caption;
}

- (UIFont *)captionBold {
    if (!_captionBold) {
        _captionBold = UIFont._jp_captionBold;
    }
    return _captionBold;
}

#pragma mark - Colors

- (UIColor *)jpBlackColor {
    if (!_jpBlackColor) {
        _jpBlackColor = UIColor._jp_blackColor;
    }
    return _jpBlackColor;
}

- (UIColor *)jpDarkGrayColor {
    if (!_jpDarkGrayColor) {
        _jpDarkGrayColor = UIColor._jp_darkGrayColor;
    }
    return _jpDarkGrayColor;
}

- (UIColor *)jpGrayColor {
    if (!_jpGrayColor) {
        _jpGrayColor = UIColor._jp_grayColor;
    }
    return _jpGrayColor;
}

- (UIColor *)jpLightGrayColor {
    if (!_jpLightGrayColor) {
        _jpLightGrayColor = UIColor._jp_lightGrayColor;
    }
    return _jpLightGrayColor;
}

- (UIColor *)jpRedColor {
    if (!_jpRedColor) {
        _jpRedColor = UIColor._jp_redColor;
    }
    return _jpRedColor;
}

- (UIColor *)jpWhiteColor {
    if (!_jpWhiteColor) {
        _jpWhiteColor = UIColor._jp_whiteColor;
    }
    return _jpWhiteColor;
}

#pragma mark - Button Configuration

- (UIColor *)buttonColor {
    if (!_buttonColor) {
        _buttonColor = self.jpBlackColor;
    }
    return _buttonColor;
}

- (UIColor *)buttonTitleColor {
    if (!_buttonTitleColor) {
        _buttonTitleColor = self.jpWhiteColor;
    }
    return _buttonTitleColor;
}

- (CGFloat)buttonCornerRadius {
    if (!_buttonCornerRadius) {
        _buttonCornerRadius = 4.0F;
    }
    return _buttonCornerRadius;
}

@end
