//
//  JPAfterHandlers.m
//  ObjectiveCExampleAppUITests
//
//  Created by Mihai Petrenco on 17.11.2020.
//  Copyright © 2020 Judopay. All rights reserved.
//

#import "JPAfterHandlers.h"
#import "JPMainElements.h"
#import "JPSettingsElements.h"
#import "JPGenericElements.h"
#import "XCUIElement+Additions.h"
#import "JPHelpers.h"

@implementation JPAfterHandlers

+ (void)cleanUp {
    [self returnToMainScreen];
    [self resetStoredCards];
    [self resetSettings];
}

+ (void)returnToMainScreen {
    XCUIApplication *application = [XCUIApplication new];
    XCUIElement *mainScreen = application.otherElements[@"Main Screen"];
    XCUIElement *cancelButton = application.buttons[@"CANCEL"];

    if (cancelButton.exists) {
        [cancelButton tap];
    }

    while (!mainScreen.exists) {
        [JPGenericElements.backButton tap];
    }
}

+ (void)resetStoredCards {
    [JPMainElements.settingsButton tap];
    [JPSettingsElements.cardPaymentMethodSwitch switchOn];
    [JPGenericElements.backButton tap];
    [JPMainElements.paymentMethodsOption tap];


    XCUIApplication *app = [XCUIApplication new];

    while ([app.cells[@"Card List Cell"] exists]) {
        XCUIElement *firstMatch = app.cells[@"Card List Cell"].firstMatch;
        [firstMatch swipeDownToElement];
        [firstMatch swipeLeft];
        [app.buttons[@"Delete"] tap];
        [app.alerts.buttons[@"Delete"] tap];
    }
}

+ (void)resetSettings {
    [JPMainElements.settingsButton tap];

    [JPHelpers toggleOffSwitches:@[
        JPSettingsElements.visaSwitch,
        JPSettingsElements.masterCardSwitch,
        JPSettingsElements.maestroSwitch,
        JPSettingsElements.amexSwitch,
        JPSettingsElements.chinaUnionPaySwitch,
        JPSettingsElements.jcbSwitch,
        JPSettingsElements.discoverSwitch,
        JPSettingsElements.dinersClubSwitch,
        JPSettingsElements.cardPaymentMethodSwitch,
        JPSettingsElements.iDEALPaymentMethodSwitch,
        JPSettingsElements.applePayPaymentMethodSwitch,
        JPSettingsElements.pbbaPaymentMethodSwitch,
        JPSettingsElements.avsSwitch,
        JPSettingsElements.paymentMethodsAmountSwitch,
        JPSettingsElements.buttonAmountSwitch,
        JPSettingsElements.securityCodeSwitch,
    ]];

    [JPGenericElements.backButton tap];
}

@end
