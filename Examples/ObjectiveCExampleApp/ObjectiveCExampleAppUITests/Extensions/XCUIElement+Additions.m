//
//  XCUIElement+Additions.m
//  ObjectiveCExampleAppUITests
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

#import "XCUIElement+Additions.h"

@implementation XCUIElement (Additions)

+ (XCUIElement *)cellWithStaticText:(NSString *)staticText {
    XCUIApplication *application = [XCUIApplication new];
    NSString *stringFormat = [NSString stringWithFormat:@"label BEGINSWITH[c] '%@'", staticText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:stringFormat];
    return [application.cells containingPredicate:predicate].firstMatch;
}

- (void)clearAndEnterText:(NSString *)text {

    if (![self.value isKindOfClass:NSString.class]) {
        XCTFail(@"XCUIElement value is not a valid string");
    }

    while (((NSString *)self.value).length != 0) {
        [self doubleTap];
        [self typeText:XCUIKeyboardKeyDelete];
    }

    [self tap];
    [self typeText:text];
}

- (void)swipeUpToElement {
    while (!self.exists && !self.isHittable) {
        XCUIApplication *app = [XCUIApplication new];

        XCUICoordinate *start = [app coordinateWithNormalizedOffset:CGVectorMake(0.5, 0.5)];
        XCUICoordinate *end = [app coordinateWithNormalizedOffset:CGVectorMake(0.5, 0.6)];

        [start pressForDuration:0.1 thenDragToCoordinate:end];
    }
}

- (void)swipeDownToElement {
    while (!self.exists  && !self.isHittable) {
        XCUIApplication *app = [XCUIApplication new];

        XCUICoordinate *start = [app coordinateWithNormalizedOffset:CGVectorMake(0.5, 0.5)];
        XCUICoordinate *end = [app coordinateWithNormalizedOffset:CGVectorMake(0.5, 0.4)];

        [start pressForDuration:0.1 thenDragToCoordinate:end];
    }
}

- (void)switchOn {
    [self shouldSwitchOn:YES];
}

- (void)switchOff {
    [self shouldSwitchOn:NO];
}

- (void)shouldSwitchOn:(BOOL)state {
    NSString *expectedValue = state ? @"0" : @"1";
    if ([self.value isEqualToString:expectedValue]) {
        [self tap];
    }
}

@end
