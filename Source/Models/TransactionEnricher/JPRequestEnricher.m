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

#import <CoreLocation/CoreLocation.h>
#import <DeviceDNA/DeviceDNA.h>

#import "Functions.h"
#import "JPBrowser.h"
#import "JPConstants.h"
#import "JPConsumerDevice.h"
#import "JPEnhancedPaymentDetail.h"
#import "JPSDKInfo.h"
#import "JPThreeDSecure.h"

static NSString *const kClientDetailsKey = @"clientDetails";
static NSString *const kEnhancedPaymentDetailKey = @"EnhancedPaymentDetail";

@interface JPRequestEnricher () <CLLocationManagerDelegate>

@property (nonatomic, strong) DeviceDNA *deviceDNA;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *lastKnownLocation;

@end

@implementation JPRequestEnricher

#pragma mark - Initializers

- (instancetype)init {

    if (self = [super init]) {
        [self requestLocation];
        _deviceDNA = [DeviceDNA new];
    }
    return self;
}

#pragma mark - Setup methods

- (void)requestLocation {
    if (self.shouldRequestLocation) {
        [self.locationManager requestLocation];
    }
}

#pragma mark - Public methods

- (void)enrichRequestParameters:(nullable NSDictionary *)dictionary
                 withCompletion:(nonnull JPEnricherCompletionBlock)completion {
    __weak typeof(self) weakSelf = self;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        __strong typeof(self) strongSelf = weakSelf;

        [strongSelf.deviceDNA getDeviceSignals:^(NSDictionary *device, NSError *__unused error) {
            JPEnhancedPaymentDetail *detail = [strongSelf buildEnhancedPaymentDetail];
            NSMutableDictionary *enrichedRequest = [NSMutableDictionary dictionaryWithDictionary:dictionary];
            enrichedRequest[kEnhancedPaymentDetailKey] = [detail _jp_toDictionary];
            enrichedRequest[kClientDetailsKey] = device;

            dispatch_async(dispatch_get_main_queue(), ^{
                completion([NSDictionary dictionaryWithDictionary:enrichedRequest]);
            });
        }];
    });
}

#pragma mark - Helper methods

- (JPEnhancedPaymentDetail *)buildEnhancedPaymentDetail {
    JPThreeDSecure *threeDSecure = [JPThreeDSecure secureWithBrowser:[JPBrowser new]];
    JPConsumerDevice *consumerDevice = [JPConsumerDevice deviceWithThreeDSecure:threeDSecure];
    JPSDKInfo *sdkInfo = [JPSDKInfo infoWithVersion:kJudoKitVersion
                                               name:kJudoKitName];
    return [JPEnhancedPaymentDetail detailWithSdkInfo:sdkInfo
                                       consumerDevice:consumerDevice];
}

#pragma mark - Getters

- (BOOL)isAuthorizationGranted {
    switch (CLLocationManager.authorizationStatus) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return YES;

        default:
            return NO;
    }
}

- (BOOL)shouldRequestLocation {
    BOOL areLocationServicesEnabled = CLLocationManager.locationServicesEnabled;
    return areLocationServicesEnabled && self.isAuthorizationGranted;
}

#pragma mark - Lazy properties

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (CLLocation *)lastKnownLocation {
    if (!_lastKnownLocation) {
        _lastKnownLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
    }
    return _lastKnownLocation;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {

    if (locations.count > 0) {
        self.lastKnownLocation = locations.lastObject;
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    // Location fetch failed, do nothing :(
}

@end
