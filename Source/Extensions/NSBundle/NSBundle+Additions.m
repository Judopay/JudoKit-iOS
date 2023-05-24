//
//  NSBundle+Additions.m
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

#import "JudoKit.h"
#import "NSBundle+Additions.h"

static NSString *const kBundleName = @"JudoKit_iOS.bundle";
static NSString *const kSPMBundleName = @"JudoKit_iOS_JudoKit_iOS.bundle";

NSBundle *_jp_SPMBundle() {

#ifdef SWIFTPM_MODULE_BUNDLE
    return SWIFTPM_MODULE_BUNDLE;
#endif

    NSBundle *mainBundle = NSBundle.mainBundle;
    NSBundle *classBundle = [NSBundle bundleForClass:JudoKit.class];

    NSArray<NSURL *> *candidates = @[
        mainBundle.resourceURL,
        classBundle.resourceURL,
        mainBundle.bundleURL
    ];

    for (NSURL *candiate in candidates) {
        NSURL *bundlePath = [candiate URLByAppendingPathComponent:kSPMBundleName];
        NSBundle *bundle;

        if (bundlePath) {
            bundle = [NSBundle bundleWithURL:bundlePath];
        }

        if (bundle) {
            return bundle;
        }
    }

    return nil;
}

NSBundle *_jp_searchForBundle(NSString *bundlePath) {
    NSArray<NSString *> *candidates = @[
        [bundlePath stringByAppendingPathComponent:kBundleName],
        [bundlePath.stringByDeletingLastPathComponent stringByAppendingPathComponent:kBundleName]
    ];

    for (NSString *candidate in candidates) {
        NSBundle *bundle = [NSBundle bundleWithPath:candidate];

        if (bundle) {
            return bundle;
        }
    }

    return nil;
}

NSBundle *_jp_lookupFrameworkBundle() {
    NSBundle *frameworkBundle = _jp_SPMBundle();

    if (!frameworkBundle) {
        frameworkBundle = [NSBundle bundleWithPath:kBundleName];
    }

    if (!frameworkBundle) {
        NSString *path = [[NSBundle bundleForClass:JudoKit.class] pathForResource:@"JudoKit_iOS" ofType:@"bundle"];
        if (path) {
            frameworkBundle = [NSBundle bundleWithPath:path];
        }
    }

    if (!frameworkBundle) {
        frameworkBundle = [NSBundle bundleForClass:JudoKit.class];
    }

    if (!frameworkBundle) {
        frameworkBundle = NSBundle.mainBundle;
    }

    NSBundle *jpBundle = _jp_searchForBundle(frameworkBundle.bundlePath);

    if (jpBundle) {
        return jpBundle;
    }

    return frameworkBundle;
}

@implementation NSBundle (Additions)

+ (NSBundle *)_jp_frameworkBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = _jp_lookupFrameworkBundle();
    });
    return bundle;
}

+ (NSString *)_jp_appURLScheme {
    NSBundle *bundle = NSBundle.mainBundle;
    NSMutableArray *urlTypes = bundle.infoDictionary[@"CFBundleURLTypes"];
    NSMutableDictionary *urlType = urlTypes.firstObject;
    NSMutableArray *urlSchemes = urlType[@"CFBundleURLSchemes"];
    NSString *urlScheme = urlSchemes.firstObject;
    return urlScheme;
}

@end
