//
//  JPUITestThenSteps.m
//  ObjectiveCExampleAppUITests
//
//  Created by Mihai Petrenco on 11/3/20.
//  Copyright © 2020 Judopay. All rights reserved.
//

#import "JPUITestThenSteps.h"
#import <Cucumberish/Cucumberish.h>

@implementation JPUITestThenSteps

+ (void)setUp {

    Then(@"^the (.*) (?:screen|page|view) should be visible$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *screenName = args[0];
        NSString *screenIdentifier = [NSString stringWithFormat:@"%@ Screen", screenName];

        BOOL isViewVisible = application.otherElements[screenIdentifier].exists;
        BOOL isTableVisible = application.tables[screenIdentifier].exists;

        XCTAssert(isViewVisible || isTableVisible);
    });
}

@end
