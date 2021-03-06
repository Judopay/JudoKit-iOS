//
//  JPTagHandlers.m
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

#import "JPTagHandlers.h"
#import "JPMainElements.h"
#import "JPSettingsElements.h"
#import "JPGenericElements.h"
#import "XCUIElement+Additions.h"
#import "JPUITestConfiguration.h"
#import "JPHelpers.h"

#pragma mark - Basic authorization configuration

void handleRequireConfig(NSString *judoID, NSString *token, NSString *secret) {
    [JPMainElements.settingsButton tap];

    [JPSettingsElements.judoIDTextField clearAndEnterText:judoID];

    [JPSettingsElements.sessionAuthenticationSwitch switchOff];
    [JPSettingsElements.basicAuthenticationSwitch switchOn];

    [JPSettingsElements.basicTokenTextField clearAndEnterText:token];
    [JPSettingsElements.basicSecretTextField clearAndEnterText:secret];

    [JPGenericElements.backButton tap];
}

void handleRequireNon3DSConfig(JPUITestConfiguration *configuration) {
    handleRequireConfig(configuration.judoID,
                        configuration.token,
                        configuration.secret);
}

void handleRequire3DSConfig(JPUITestConfiguration *configuration) {
    handleRequireConfig(configuration.judoID,
                        configuration.threeDSToken,
                        configuration.threeDSSecret);
}

#pragma mark - Card network configuration

void handleRequireAllCardNetworks() {
    [JPMainElements.settingsButton tap];

    NSArray *switches = @[
        JPSettingsElements.visaSwitch,
        JPSettingsElements.masterCardSwitch,
        JPSettingsElements.maestroSwitch,
        JPSettingsElements.amexSwitch,
        JPSettingsElements.chinaUnionPaySwitch,
        JPSettingsElements.jcbSwitch,
        JPSettingsElements.discoverSwitch,
        JPSettingsElements.dinersClubSwitch
    ];
    
    toggleOnSwitches(switches);

    [JPGenericElements.backButton tap];
}

#pragma mark - AVS configuration

void handleRequireAVS() {
    [JPMainElements.settingsButton tap];

    [JPSettingsElements.avsSwitch swipeUpToElement];
    [JPSettingsElements.avsSwitch switchOn];

    [JPGenericElements.backButton tap];
}

#pragma mark - Transaction button amount configuration

void handleRequireButtonAmount() {
    [JPMainElements.settingsButton tap];

    [JPSettingsElements.buttonAmountSwitch swipeUpToElement];
    [JPSettingsElements.buttonAmountSwitch switchOn];

    [JPGenericElements.backButton tap];
}

#pragma mark - Payment method configuration

void handleRequireCardPaymentMethod() {
    [JPMainElements.settingsButton tap];

    [JPSettingsElements.cardPaymentMethodSwitch swipeUpToElement];
    [JPSettingsElements.cardPaymentMethodSwitch switchOn];

    [JPGenericElements.backButton tap];
}

void handleRequireIDEALPaymentMethod() {
    [JPMainElements.settingsButton tap];

    [JPSettingsElements.iDEALPaymentMethodSwitch swipeUpToElement];
    [JPSettingsElements.iDEALPaymentMethodSwitch switchOn];

    [JPGenericElements.backButton tap];
}

void handleRequireApplePayPaymentMethod() {
    [JPMainElements.settingsButton tap];

    [JPSettingsElements.applePayPaymentMethodSwitch swipeUpToElement];
    [JPSettingsElements.applePayPaymentMethodSwitch switchOn];

    [JPGenericElements.backButton tap];
}

void handleRequirePBBAPaymentMethod() {
    [JPMainElements.settingsButton tap];

    [JPSettingsElements.pbbaPaymentMethodSwitch swipeUpToElement];
    [JPSettingsElements.pbbaPaymentMethodSwitch switchOn];

    [JPGenericElements.backButton tap];
}

void handleRequireAllPaymentMethods() {
    [JPMainElements.settingsButton tap];

    [JPSettingsElements.cardPaymentMethodSwitch swipeUpToElement];
    [JPSettingsElements.cardPaymentMethodSwitch switchOn];

    [JPSettingsElements.iDEALPaymentMethodSwitch swipeUpToElement];
    [JPSettingsElements.iDEALPaymentMethodSwitch switchOn];

    [JPSettingsElements.applePayPaymentMethodSwitch swipeUpToElement];
    [JPSettingsElements.applePayPaymentMethodSwitch switchOn];

    [JPSettingsElements.pbbaPaymentMethodSwitch swipeUpToElement];
    [JPSettingsElements.pbbaPaymentMethodSwitch switchOn];

    [JPGenericElements.backButton tap];
}

#pragma mark - Currency configuration

void switchToCurrency(NSString *currency) {
    XCUIElement *cell = [XCUIElement cellWithStaticText:currency];
    [cell tap];
}

void handleRequireCurrencyGBP() {
    [JPMainElements.settingsButton tap];

    [JPSettingsElements.currencyCell swipeUpToElement];
    [JPSettingsElements.currencyCell tap];

    switchToCurrency(@"GBP");

    [JPGenericElements.backButton tap];
    [JPGenericElements.backButton tap];
}

void handleRequireCurrencyEUR() {
    [JPMainElements.settingsButton tap];

    [JPSettingsElements.currencyCell swipeUpToElement];
    [JPSettingsElements.currencyCell tap];

    switchToCurrency(@"EUR");

    [JPGenericElements.backButton tap];
    [JPGenericElements.backButton tap];
}
