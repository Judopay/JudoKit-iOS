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

    NSString *stringValue = (NSString *)self.value;
    NSString *deletePattern = [@"" stringByPaddingToLength:stringValue.length
                                                withString:XCUIKeyboardKeyDelete
                                           startingAtIndex:0];

    [self tap];
    [self typeText:deletePattern];
    [self typeText:text];
}

@end
