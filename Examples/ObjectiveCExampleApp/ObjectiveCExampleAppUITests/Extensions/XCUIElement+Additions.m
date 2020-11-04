//
//  XCUIElement.m
//  ObjectiveCExampleAppUITests
//
//  Created by Mihai Petrenco on 11/3/20.
//  Copyright © 2020 Judopay. All rights reserved.
//

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

@end
