//
//  JPTagHandlers.m
//  ObjectiveCExampleAppUITests
//
//  Created by Mihai Petrenco on 17.11.2020.
//  Copyright © 2020 Judopay. All rights reserved.
//

#import "JPTagHandlers.h"
#import "JPMainElements.h"
#import "JPSettingsElements.h"
#import "JPGenericElements.h"
#import "XCUIElement+Additions.h"
#import "JPHelpers.h"

NSString *judoId = @"100108620";
NSString *token = @"XFQTtOV37sEw5k4E";
NSString *secret = @"dc5ad09eff27a0af576c30922e48197a36720d0f8fe1c53142525077a23f9d10";

@implementation JPTagHandlers

+ (void)handleRequireNon3DSConfig {

    [JPMainElements.settingsButton tap];

    [JPSettingsElements.judoIDTextField clearAndEnterText:judoId];

    [JPSettingsElements.sessionAuthenticationSwitch switchOff];
    [JPSettingsElements.basicAuthenticationSwitch switchOn];

    [JPSettingsElements.basicTokenTextField clearAndEnterText:token];
    [JPSettingsElements.basicSecretTextField clearAndEnterText:secret];

    [JPGenericElements.backButton tap];
}

+ (void)handleRequireAllCardNetworks {
    [JPMainElements.settingsButton tap];

    [JPHelpers toggleOnSwitches:@[
        JPSettingsElements.visaSwitch,
        JPSettingsElements.masterCardSwitch,
        JPSettingsElements.maestroSwitch,
        JPSettingsElements.amexSwitch,
        JPSettingsElements.chinaUnionPaySwitch,
        JPSettingsElements.jcbSwitch,
        JPSettingsElements.discoverSwitch,
        JPSettingsElements.dinersClubSwitch
    ]];

    [JPGenericElements.backButton tap];
}

+ (void)handleRequireAVS {
    [JPMainElements.settingsButton tap];

    [JPSettingsElements.avsSwitch swipeUpToElement];
    [JPSettingsElements.avsSwitch switchOn];

    [JPGenericElements.backButton tap];
}

+ (void)handleRequireButtonAmount {
    [JPMainElements.settingsButton tap];

    [JPSettingsElements.buttonAmountSwitch swipeUpToElement];
    [JPSettingsElements.buttonAmountSwitch switchOn];

    [JPGenericElements.backButton tap];
}

@end
