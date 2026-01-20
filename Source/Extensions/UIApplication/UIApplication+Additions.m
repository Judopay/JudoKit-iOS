//
//  UIApplication+Additions.m
//  JudoKit_iOS
//
//  Copyright (c) 2019 Alternative Payments Ltd
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

#import "UIApplication+Additions.h"

@implementation UIApplication (Additions)

+ (BOOL)_jp_isCurrentDeviceJailbroken {
    return [NSFileManager.defaultManager fileExistsAtPath:@"/private/var/lib/apt/"];
}

+ (UIViewController *)_jp_topMostViewController {
    UIWindow *keyWindow = nil;

    if (@available(iOS 13.0, *)) {
        // Find the active foreground scene with a key window
        NSPredicate *applicationWindowScenesPredicate = [NSPredicate predicateWithFormat:@"class == %@ AND session.role == %@", UIWindowScene.class, UIWindowSceneSessionRoleApplication];
        NSPredicate *foregroundActiveMatchingScenesPredicate = [NSPredicate predicateWithFormat:@"activationState == %d", UISceneActivationStateForegroundActive];
        NSPredicate *keyWindowPredicate = [NSPredicate predicateWithFormat:@"isKeyWindow == YES"];

        NSSet<UIWindowScene *> *applicationWindowScenes = (NSSet<UIWindowScene *> *)[UIApplication.sharedApplication.connectedScenes filteredSetUsingPredicate:applicationWindowScenesPredicate];
        NSSet<UIWindowScene *> *foregroundActiveMatchingScenes = [applicationWindowScenes filteredSetUsingPredicate:foregroundActiveMatchingScenesPredicate];
        // When host app is moving from background to foreground and atempts to present a view controller at the same time,
        // the foregroundActiveMatchingScenes will be empty since the activationState of the scene will be UISceneActivationStateBackground,
        // so we fallback to applicationWindowScenes to attempt to find a key window to present the view controller on.
        NSSet<UIWindowScene *> *scenes = foregroundActiveMatchingScenes.count > 0 ? foregroundActiveMatchingScenes : applicationWindowScenes;

        for (UIWindowScene *windowScene in scenes) {
            NSArray<UIWindow *> *keyWindows = [windowScene.windows filteredArrayUsingPredicate:keyWindowPredicate];
            if (keyWindows.count > 0) {
                keyWindow = keyWindows.firstObject;
                break;
            }
        }
    } else {
        keyWindow = UIApplication.sharedApplication.keyWindow;
    }

    UIViewController *rootViewController = keyWindow.rootViewController;
    return [self _jp_visibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)_jp_visibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:UINavigationController.class]) {
        return [self _jp_visibleViewControllerFrom:[((UINavigationController *)vc) visibleViewController]];
    } else if ([vc isKindOfClass:UITabBarController.class]) {
        return [self _jp_visibleViewControllerFrom:[((UITabBarController *)vc) selectedViewController]];
    } else if ([vc isKindOfClass:UISplitViewController.class]) {
        return [self _jp_visibleViewControllerFrom:[((UISplitViewController *)vc) viewControllers].lastObject];
    } else if (vc.presentedViewController) {
        return [self _jp_visibleViewControllerFrom:vc.presentedViewController];
    } else {
        return vc;
    }
}
@end
