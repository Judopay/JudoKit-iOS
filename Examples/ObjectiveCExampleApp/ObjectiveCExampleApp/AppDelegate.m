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

@import JudoKit_iOS;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Load settings defaults
    [self registerDefaultsFromSettingsBundle];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return true;
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
