//
//  AppDelegate.m
//  ObjectiveCExampleApp
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

#import "AppDelegate.h"
#import "MainViewController.h"
#import "Settings.h"
#import "SettingsImporter.h"

@import JudoKit_iOS;

// Launch argument holding a settings JSON, base64 encoded, to import at launch. Lets UI tests set up
// the app in one step, e.g. `xcrun simctl launch <device> com.judo.JudoPayDemoObjC -importSettings
// <base64 JSON>`.
static NSString *const kImportSettingsArgument = @"importSettings";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Load settings defaults
    [self registerDefaultsFromSettingsBundle];
    [self importSettingsFromLaunchArguments];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return true;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options API_AVAILABLE(ios(13.0)) {
    UISceneConfiguration *configuration = [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
    return configuration;
}

- (void)importSettingsFromLaunchArguments {
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    // "-importSettings <value>" on the launch command line lands in the argument domain, which lasts
    // for this launch only.
    NSString *encoded = [defaults volatileDomainForName:NSArgumentDomain][kImportSettingsArgument];
    if (![encoded isKindOfClass:NSString.class] || encoded.length == 0) {
        return;
    }

    NSData *data = [[NSData alloc] initWithBase64EncodedString:encoded
                                                       options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *json = data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil;
    if (!json) {
        NSLog(@"SettingsImport: Settings import failed: invalid base64");
        return;
    }

    NSError *error = nil;
    if ([SettingsImporter importSettings:json intoDefaults:defaults error:&error]) {
        NSLog(@"SettingsImport: Settings imported");
    } else {
        NSLog(@"SettingsImport: Settings import failed: %@", error.localizedDescription);
    }
}

- (void)registerDefaultsFromSettingsBundle {
    NSString *settingsBundle = [NSBundle.mainBundle pathForResource:@"Settings" ofType:@"bundle"];

    if (!settingsBundle) {
        return;
    }

    NSArray *settingFiles = @[ @"Root.plist", @"ThreeDSSDKUICustomisation.plist", @"ApplePaySettings.plist" ];
    NSMutableArray *preferences = [NSMutableArray new];

    for (NSString *fileName in settingFiles) {
        NSString *stringsPath = [settingsBundle stringByAppendingPathComponent:fileName];
        NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:stringsPath];
        [preferences addObjectsFromArray:settings[@"PreferenceSpecifiers"]];
    }

    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:preferences.count];

    for (NSDictionary *preference in preferences) {
        NSString *key = preference[@"Key"];
        if (!key) {
            continue;
        }

        if ([preference.allKeys containsObject:@"DefaultValue"]) {
            defaultsToRegister[key] = preference[@"DefaultValue"];
        }
    }

    [NSUserDefaults.standardUserDefaults registerDefaults:defaultsToRegister];
}

@end
