//
//  XCUIElement.h
//  ObjectiveCExampleAppUITests
//
//  Created by Mihai Petrenco on 11/3/20.
//  Copyright © 2020 Judopay. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCUIElement (Additions)

+ (XCUIElement *)cellWithStaticText:(NSString *)staticText;

- (void)clearAndEnterText:(NSString *)text;

@end
