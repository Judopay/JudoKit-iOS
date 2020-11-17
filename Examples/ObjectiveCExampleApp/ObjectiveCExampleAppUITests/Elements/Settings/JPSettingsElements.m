//
//  JPSettingsElements.m
//  ObjectiveCExampleAppUITests
//
//  Copyright (c) 2020 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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

+ (XCUIElement *)cardPaymentMethodSwitch {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"Card"];
    return cell.switches.firstMatch;
}

+ (XCUIElement *)iDEALPaymentMethodSwitch {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"iDeal"];
    return cell.switches.firstMatch;
}

+ (XCUIElement *)applePayPaymentMethodSwitch {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"Apple Pay"];
    return cell.switches.firstMatch;
}

+ (XCUIElement *)pbbaPaymentMethodSwitch {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"PBBA"];
    return cell.switches.firstMatch;
}

+ (XCUIElement *)avsSwitch {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"Address Verification Service"];
    return cell.switches.firstMatch;
}

+ (XCUIElement *)buttonAmountSwitch {
    XCUIElement *cell = [XCUIElement cellWithStaticText:@"Display amount label in Payment Button"];
    return cell.switches.firstMatch;
}

@end
