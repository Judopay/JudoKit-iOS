//
//  JPSettingsElements.m
//  ObjectiveCExampleAppUITests
//
//  Created by Mihai Petrenco on 11/3/20.
//  Copyright © 2020 Judopay. All rights reserved.
//

#import "JPSettingsElements.h"
#import "XCUIElement+Additions.h"

@implementation JPSettingsElements

+ (XCUIElement *)judoIDTextField {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"Judo ID"];
    return cell.textFields.firstMatch;
}

+ (XCUIElement *)basicAuthenticationSwitch {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"Using token and secret"];
    return cell.switches.firstMatch;
}

+ (XCUIElement *)sessionAuthenticationSwitch {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"Using payment session"];
    return cell.switches.firstMatch;
}

+ (XCUIElement *)basicTokenTextField {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"Token"];
    return cell.textFields.firstMatch;
}

+ (XCUIElement *)basicSecretTextField {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"Secret"];
    return cell.textFields.firstMatch;
}

@end
