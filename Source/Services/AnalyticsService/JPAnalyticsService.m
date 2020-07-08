//
//  JPAnalyticsService.h
//  JudoKit_iOS
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

#import "JPAnalyticsService.h"
#import "JPAnalyticsEvent.h"

@interface JPAnalyticsService ()
@property (nonatomic, weak) id<JPAnalyticsServiceDelegate> _Nullable analyticsDelegate;
@end

@implementation JPAnalyticsService

+ (instancetype)sharedInstance {
    static JPAnalyticsService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [JPAnalyticsService new];
    });
    return sharedInstance;
}

- (void)sendEventWithType:(JPAnalyticsEvent *)event {
    [self sendAnalyticsToMerchant: event];
}

- (void)sendAnalyticsToMerchant:(JPAnalyticsEvent *)event {
    [self.analyticsDelegate didReceiveEvent:event];
}

- (void)setDelegate:(id<JPAnalyticsServiceDelegate>)analyticsService {
    self.analyticsDelegate = analyticsService;
}

@end
