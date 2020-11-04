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

+ (XCUIElement *)visaSwitch;

+ (XCUIElement *)masterCardSwitch;

+ (XCUIElement *)maestroSwitch;

+ (XCUIElement *)amexSwitch;

+ (XCUIElement *)chinaUnionPaySwitch;

+ (XCUIElement *)jcbSwitch;

+ (XCUIElement *)discoverSwitch;

+ (XCUIElement *)dinersClubSwitch;

@end

