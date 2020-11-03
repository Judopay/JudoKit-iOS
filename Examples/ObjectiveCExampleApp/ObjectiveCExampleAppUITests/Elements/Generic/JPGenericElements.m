//
//  JPGenericElements.m
//  ObjectiveCExampleAppUITests
//
//  Created by Mihai Petrenco on 11/3/20.
//  Copyright © 2020 Judopay. All rights reserved.
//

#import "JPGenericElements.h"

@implementation JPGenericElements

+ (XCUIElement *)backButton {
    XCUIApplication *application = [XCUIApplication new];
    XCUIElement *navigationBar = application.navigationBars.firstMatch;
    return navigationBar.buttons.firstMatch;
}

@end
