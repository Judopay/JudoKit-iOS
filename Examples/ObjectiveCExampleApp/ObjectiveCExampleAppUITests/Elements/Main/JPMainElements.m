//
//  JPMainElements.m
//  ObjectiveCExampleAppUITests
//
//  Created by Mihai Petrenco on 11/3/20.
//  Copyright © 2020 Judopay. All rights reserved.
//

#import "JPMainElements.h"

@implementation JPMainElements

+ (XCUIElement *)settingsButton {
    XCUIApplication *application = [XCUIApplication new];
    return application.buttons[@"Settings Button"];
}

@end
