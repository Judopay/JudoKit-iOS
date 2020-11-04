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

+ (XCUIElement *)visaSwitch {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"Visa"];
    return cell.switches.firstMatch;
}

+ (XCUIElement *)masterCardSwitch {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"Master Card"];
    return cell.switches.firstMatch;
}

+ (XCUIElement *)maestroSwitch {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"Maestro"];
    return cell.switches.firstMatch;
}

+ (XCUIElement *)amexSwitch {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"AMEX"];
    return cell.switches.firstMatch;
}

+ (XCUIElement *)chinaUnionPaySwitch {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"China Union Pay"];
    return cell.switches.firstMatch;
}

+ (XCUIElement *)jcbSwitch {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"JCB"];
    return cell.switches.firstMatch;
}

+ (XCUIElement *)discoverSwitch {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"Discover"];
    return cell.switches.firstMatch;
}

+ (XCUIElement *)dinersClubSwitch {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"Diners Club"];
    return cell.switches.firstMatch;
}

@end
