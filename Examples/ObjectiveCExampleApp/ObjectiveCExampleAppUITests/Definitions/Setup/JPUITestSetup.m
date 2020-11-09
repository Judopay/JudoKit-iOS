//
//  JPUITestSetup.m
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

#import "JPUITestSetup.h"
#import "JPGenericElements.h"
#import "JPMainElements.h"
#import "JPSettingsElements.h"
#import "XCUIElement+Additions.h"
#import <Cucumberish/Cucumberish.h>

@implementation JPUITestSetup

+ (void)setUp {

    NSString *judoId = @"100108620";
    NSString *token = @"XFQTtOV37sEw5k4E";
    NSString *secret = @"dc5ad09eff27a0af576c30922e48197a36720d0f8fe1c53142525077a23f9d10";

    /**
     * [TAG] require-non-3ds-config
     *
     * A tag that is used to specify that non-3DS credentials (Judo ID, Token & Secret) must be set before the
     * scenario executes.
     */
    beforeTagged(@[@"require-non-3ds-config"], ^(CCIScenarioDefinition *scenario) {

        [JPMainElements.settingsButton tap];

        [JPSettingsElements.judoIDTextField clearAndEnterText:judoId];

        [JPSettingsElements.sessionAuthenticationSwitch switchOff];
        [JPSettingsElements.basicAuthenticationSwitch switchOn];

        [JPSettingsElements.basicTokenTextField clearAndEnterText:token];
        [JPSettingsElements.basicSecretTextField clearAndEnterText:secret];

        [JPGenericElements.backButton tap];
    });

    /**
     * [TAG] require-all-card-networks
     *
     * A tag that is used to specify that all card networks must be accepted before the scenario executes.
     */
    beforeTagged(@[@"require-all-card-networks"], ^(CCIScenarioDefinition *scenario) {

        [JPMainElements.settingsButton tap];

        [JPSettingsElements.visaSwitch switchOn];
        [JPSettingsElements.masterCardSwitch switchOn];
        [JPSettingsElements.maestroSwitch switchOn];
        [JPSettingsElements.amexSwitch switchOn];
        [JPSettingsElements.chinaUnionPaySwitch switchOn];
        [JPSettingsElements.jcbSwitch switchOn];
        [JPSettingsElements.discoverSwitch switchOn];
        [JPSettingsElements.dinersClubSwitch switchOn];

        [JPGenericElements.backButton tap];
    });

    /**
     * [TAG] require-avs-enabled
     *
     * A tag that is used to specify that AVS must be enabled before the scenario executes
     */
    beforeTagged(@[@"require-avs-enabled"], ^(CCIScenarioDefinition *scenario) {

        [JPMainElements.settingsButton tap];

        [JPSettingsElements.avsSwitch swipeUpToElement];
        [JPSettingsElements.avsSwitch switchOn];

        [JPGenericElements.backButton tap];
    });

    /**
     * [TAG] require-avs-disabled
     *
     * A tag that is used to specify that AVS must be disabled before the scenario executes
     */
    beforeTagged(@[@"require-avs-disabled"], ^(CCIScenarioDefinition *scenario) {

        [JPMainElements.settingsButton tap];

        [JPSettingsElements.avsSwitch swipeUpToElement];
        [JPSettingsElements.avsSwitch switchOff];

        [JPGenericElements.backButton tap];
    });

    /**
     * [TAG] require-button-amount-enabled
     *
     * A tag that is used to specify that the amount on the "Submit Transaction" button on the Judo UI widget must be
     * enabled before the scenario executes.
     */
    beforeTagged(@[@"require-button-amount-enabled"], ^(CCIScenarioDefinition *scenario) {

        [JPMainElements.settingsButton tap];

        [JPSettingsElements.buttonAmountSwitch swipeUpToElement];
        [JPSettingsElements.buttonAmountSwitch switchOn];

        [JPGenericElements.backButton tap];
    });

    /**
     * [TAG] require-button-amount-disabled
     *
     * A tag that is used to specify that the amount on the "Submit Transaction" button on the Judo UI widget must be
     * disabled before the scenario executes.
     */
    beforeTagged(@[@"require-button-amount-disabled"], ^(CCIScenarioDefinition *scenario) {

        [JPMainElements.settingsButton tap];

        [JPSettingsElements.buttonAmountSwitch swipeUpToElement];
        [JPSettingsElements.buttonAmountSwitch switchOff];

        [JPGenericElements.backButton tap];
    });

    /**
     * A code block that is going to execute after each transaction. This does the following things:
     * - if there is a 'CANCEL' button visible, it will tap it, thus  returning back to the Main screen.;
     * - if the Main screen is not visible, as in the case of the Receipt page, tap on the navigation back button;
     */
    after(^(CCIScenarioDefinition *scenario) {

        XCUIApplication *application = [XCUIApplication new];
        XCUIElement *mainScreen = application.otherElements[@"Main Screen"];
        XCUIElement *cancelButton = application.buttons[@"CANCEL"];

        if (cancelButton.exists) {
            [cancelButton tap];
        }

        while (!mainScreen.exists) {
            [JPGenericElements.backButton tap];
        }
    });

}

@end
