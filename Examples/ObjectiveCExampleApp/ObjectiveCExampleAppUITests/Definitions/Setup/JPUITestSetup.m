//
//  JPUITestSteps.m
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

    beforeTagged(@[@"require-non-3ds-config"], ^(CCIScenarioDefinition *scenario) {

        // 1. Tap the Settings icon button from the Main screen
        [JPMainElements.settingsButton tap];

        // 2. Clear out the Judo ID textfield and
        [JPSettingsElements.judoIDTextField clearAndEnterText:judoId];

        // 3. Toggle the Session Authorization switch off if needed
        if ([JPSettingsElements.sessionAuthenticationSwitch.value isEqualToString:@"1"]) {
            [JPSettingsElements.sessionAuthenticationSwitch tap];
        }

        // 4. Toggle the Basic Authorization switch on if needed
        if ([JPSettingsElements.basicAuthenticationSwitch.value isEqualToString:@"0"]) {
            [JPSettingsElements.basicAuthenticationSwitch tap];
        }

        // 5. Enter the token/secret credentials
        [JPSettingsElements.basicTokenTextField clearAndEnterText:token];
        [JPSettingsElements.basicSecretTextField clearAndEnterText:secret];

        // 6. Navigate back to the Main screen
        [JPGenericElements.backButton tap];
    });
}

@end
