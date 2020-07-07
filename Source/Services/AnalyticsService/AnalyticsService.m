//
//  AnalyticsService.h
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

#import "AnalyticsService.h"

@interface AnalyticsServiceImp ()
@property (strong, nonatomic) NSMutableArray <AnalyticsEvent *> *events;
@property (nonatomic, weak) id<JPMerchantAnalytics> _Nullable analyticsDelegate;
@end

@implementation AnalyticsServiceImp

- (void)addEventWithType:(JPAnalyticType)type {
    AnalyticsEvent * event = [AnalyticsEvent new];
    switch (type) {
        case JPAnalyticTypeOpenPaymentMethod:
            event.eventName = @"open payment";
        case JPAnalyticTypeOther:
            event.eventName = @"other";
    }
    [self.events addObject:event];
    [self sendAnalytics];
    
    /*
     1. add event to userdefaults stack
     2. check number of events in userdefaults stack
     3. if >=10, call sendAnalytics method
     */
}

- (void)sendAnalytics {
    [self.analyticsDelegate pushAnalyticsAnalytics:self.events];
    // remove from userdefaults stack all events
}

- (void)setDelegate:(id<JPMerchantAnalytics>)analyticsService {
    self.analyticsDelegate = analyticsService;
}

@end
