//
//  JPSettingsElements.h
//  ObjectiveCExampleAppUITests
//
//  Created by Mihai Petrenco on 11/3/20.
//  Copyright © 2020 Judopay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@interface JPSettingsElements : NSObject

+ (XCUIElement *)judoIDTextField;
+ (XCUIElement *)basicAuthenticationSwitch;
+ (XCUIElement *)sessionAuthenticationSwitch;
+ (XCUIElement *)basicTokenTextField;
+ (XCUIElement *)basicSecretTextField;

@end

