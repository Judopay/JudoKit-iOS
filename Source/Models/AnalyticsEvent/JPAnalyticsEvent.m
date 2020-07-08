//
//  JPAnalyticsEvent.h
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

#import "JPAnalyticsEvent.h"

@implementation JPAnalyticsEvent

+ (instancetype)name:(NSString *)name {
    JPAnalyticsEvent *event = [JPAnalyticsEvent new];
    event.eventName = name;
    return event;
}

+ (JPAnalyticsEvent *)judoAnalyticsScanCard {
    return [JPAnalyticsEvent name:@"scan_card"];
}

+ (nonnull JPAnalyticsEvent *)judoAnalyticsAVSUsed {
    return [JPAnalyticsEvent name:@"avs_used"];
}

+ (nonnull JPAnalyticsEvent *)judoAnalyticsPaymentSuccess {
    return [JPAnalyticsEvent name:@"payment_success"];
}

+ (nonnull JPAnalyticsEvent *)judoAnalyticsOpenPayments {
    return [JPAnalyticsEvent name:@"open_payments"];
}

+ (nonnull JPAnalyticsEvent *)judoAnalyticsSelectPaymentMethod {
    return [JPAnalyticsEvent name:@"select_payment"];
}

+ (nonnull JPAnalyticsEvent *)judoAnalyticsChangingPaymentMethod {
    return [JPAnalyticsEvent name:@"changing_method"];
}

+ (nonnull JPAnalyticsEvent *)judoAnalyticsClickPay {
    return [JPAnalyticsEvent name:@"click_pay"];
}

+ (nonnull JPAnalyticsEvent *)judoAnalyticsCloseScreen {
    return [JPAnalyticsEvent name:@"close_screen"];
}

+ (nonnull JPAnalyticsEvent *)judoAnalyticsTransactionStatusAdded {
    return [JPAnalyticsEvent name:@"transaction_status_added"];
}

@end
