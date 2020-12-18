//
//  JPAfterHandlers.m
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

#import "JPAfterHandlers.h"
#import "JPMainElements.h"
#import "JPSettingsElements.h"
#import "JPGenericElements.h"
#import "JPPaymentMethodsElements.h"
#import "XCUIElement+Additions.h"
#import "JPHelpers.h"

void returnToMainScreen() {
    XCUIApplication *application = [XCUIApplication new];
    XCUIElement *mainScreen = application.otherElements[@"Main View"];
    XCUIElement *cancelButton = application.buttons[@"CANCEL"];

    if (JPPaymentMethodsElements.backButton.exists) {
        [JPPaymentMethodsElements.backButton tap];
    }

    if (cancelButton.exists) {
        [cancelButton tap];
    }

    while (!mainScreen.exists) {
        [JPGenericElements.backButton tap];
    }
}

void swipeAndDeleteCardCell(XCUIElement *cardCell) {
    [cardCell swipeLeft];
    [[XCUIApplication new].buttons[@"Delete"] tap];
    [[XCUIApplication new].alerts.buttons[@"Delete"] tap];
}

void resetStoredCards() {
    [JPMainElements.settingsButton tap];
    [JPSettingsElements.cardPaymentMethodSwitch switchOn];
    [JPGenericElements.backButton tap];

    [JPMainElements.paymentMethodsOption tap];

    XCUIApplication *app = [XCUIApplication new];

    XCUICoordinate *coord = [app coordinateWithNormalizedOffset:CGVectorMake(0.5, 0.6)];
    XCUICoordinate *coord2 = [app coordinateWithNormalizedOffset:CGVectorMake(0.5, 1)];
    [coord pressForDuration:0.1
       thenDragToCoordinate:coord2
               withVelocity:XCUIGestureVelocityFast
        thenHoldForDuration:0];

    while ([app.cells[@"Card List Cell"] exists]) {
        XCUIElement *firstMatch = app.cells[@"Card List Cell"].firstMatch;
        swipeAndDeleteCardCell(firstMatch);
    }

    if ([app.cells[@"Card List Cell [SELECTED]"] exists]) {
        XCUIElement *firstMatch = app.cells[@"Card List Cell [SELECTED]"].firstMatch;
        swipeAndDeleteCardCell(firstMatch);
    }

    if (JPPaymentMethodsElements.backButton.exists) {
        [JPPaymentMethodsElements.backButton tap];
    }
}

void resetSettings() {
    [JPMainElements.settingsButton tap];

    NSArray *switches = @[
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
    ];
    
    toggleOffSwitches(switches);

    [JPGenericElements.backButton tap];
}

void cleanUp() {
    returnToMainScreen();
    resetStoredCards();
    resetSettings();
}
