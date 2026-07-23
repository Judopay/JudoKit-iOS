//
//  JPRequestEnricher.m
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

#import "JPRequestEnricher.h"

#import "JPBrowser.h"
#import "JPConstants.h"
#import "JPConsumerDevice.h"
#import "JPDeviceDetails.h"
#import "JPDeviceDetailsProvider.h"
#import "JPEnhancedPaymentDetail.h"
#import "JPSDKInfo.h"
#import "JPThreeDSecure.h"

static NSString *const kDeviceDetailsKey = @"deviceDetails";
static NSString *const kEnhancedPaymentDetailKey = @"EnhancedPaymentDetail";

@interface JPRequestEnricher ()
@property (nonatomic, strong) JPDeviceDetailsProvider *deviceDetailsProvider;
@end

@implementation JPRequestEnricher

#pragma mark - Initializers

- (instancetype)init {
    if (self = [super init]) {
        _deviceDetailsProvider = [JPDeviceDetailsProvider new];
    }
    return self;
}

#pragma mark - Public methods

- (void)enrichRequestParameters:(NSDictionary *)dictionary
                 withCompletion:(JPEnricherCompletionBlock)completion {
    JPEnhancedPaymentDetail *detail = [self buildEnhancedPaymentDetail];
    JPDeviceDetails *deviceDetails = [self.deviceDetailsProvider deviceDetails];

    NSMutableDictionary *enrichedRequest = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    enrichedRequest[kEnhancedPaymentDetailKey] = [detail _jp_toDictionary];
    enrichedRequest[kDeviceDetailsKey] = [deviceDetails _jp_toDictionary];

    completion([NSDictionary dictionaryWithDictionary:enrichedRequest]);
}

#pragma mark - Helper methods

- (JPEnhancedPaymentDetail *)buildEnhancedPaymentDetail {
    JPThreeDSecure *threeDSecure = [JPThreeDSecure secureWithBrowser:[JPBrowser new]];
    JPConsumerDevice *consumerDevice = [JPConsumerDevice deviceWithThreeDSecure:threeDSecure];
    JPSDKInfo *sdkInfo = [JPSDKInfo infoWithVersion:kJudoKitVersion name:kJudoKitName];
    return [JPEnhancedPaymentDetail detailWithSdkInfo:sdkInfo consumerDevice:consumerDevice];
}

@end
