//
//  JPUITestGivenSteps.m
//  ObjectiveCExampleAppUITests
//
//  Created by Mihai Petrenco on 11/3/20.
//  Copyright © 2020 Judopay. All rights reserved.
//

#import "JPUITestGivenSteps.h"
#import <Cucumberish/Cucumberish.h>

@implementation JPUITestGivenSteps

+ (void)setUp {

    Given(@"^I am on the (.*) (?:screen|view|page)$", ^void(NSArray *args, id userInfo) {
        XCUIApplication *application = [XCUIApplication new];
        NSString *screenName = args[0];
        NSString *screenIdentifier = [NSString stringWithFormat:@"%@ Screen", screenName];
        XCTAssert(application.otherElements[screenIdentifier].exists);
    });

}

@end
