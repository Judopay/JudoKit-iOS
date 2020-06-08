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
#import "JPCardStorage.h"
#import "Settings.h"
#import "ExampleAppCredentials.h"
#import "MainViewController.h"

@import CocoaDebug;
@import JudoKit_iOS;

@interface AppDelegate()
@property (nonatomic, assign) BOOL appIsLaunchedFromURL;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Load settings defaults
    [self registerDefaultsFromSettingsBundle];
    
    // Enable debug inspector
    [CocoaDebug enable];
    
    self.appIsLaunchedFromURL = false;
    NSURL *applicationOpenURL = [launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    if (applicationOpenURL) {
        self.appIsLaunchedFromURL = true;
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if (self.appIsLaunchedFromURL) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainViewController *viewController = (MainViewController *)[main instantiateViewControllerWithIdentifier:@"MainViewController"];
        UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        self.window.rootViewController = homeNavigationController;
        [self.window makeKeyAndVisible];
        [viewController openPBBAScreen:url];
    }
    self.appIsLaunchedFromURL = false;
    
    return true;
}

- (void)registerDefaultsFromSettingsBundle {
    NSString *settingsBundle = [NSBundle.mainBundle pathForResource:@"Settings" ofType:@"bundle"];
    
    if(!settingsBundle) {
        return;
    }
    
    NSString *stringsPath = [settingsBundle stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:stringsPath];
    NSArray *preferences = settings[@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:preferences.count];
    
    NSDictionary *secretsMapping = @{
        kJudoIdKey: judoId,
        kSiteIdKey: siteId,
        kTokenKey: token,
        kSecretKey: secret,
        kMerchantIdKey: merchantId,
    };
    
    for(NSDictionary *preference in preferences) {
        NSString *key = preference[@"Key"];
        if (!key) {
            continue;
        }
        
        if([preference.allKeys containsObject:@"DefaultValue"]) {
            defaultsToRegister[key] = preference[@"DefaultValue"];
        } else if ([secretsMapping.allKeys containsObject:key]) {
            defaultsToRegister[key] = secretsMapping[key];
        }
    }
    
    [NSUserDefaults.standardUserDefaults registerDefaults:defaultsToRegister];
}

@end
