//
//  JPThreeDSecureTwo.m
//  JudoKit_iOS
//
//  Copyright (c) 2022 Alternative Payments Ltd
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

#import "JPThreeDSecureTwo.h"
#import "JPConfiguration.h"
#import <Judo3DS2_iOS/JP3DSAuthenticationRequestParameters.h>

@implementation JPDeviceRenderOptions

- (instancetype)init {
    if (self = [super init]) {
        _sdkInterface = @"BOTH";
        _sdkUiType = @[@"TEXT", @"SINGLE_SELECT", @"MULTI_SELECT", @"OOB", @"HTML_OTHER"];
    }
    
    return self;
}

@end

@implementation JPEphemeralPublicKey

- (instancetype)initWithString:(NSString *)key {
    if (self = [super init]) {
        NSError *error = nil;
        NSData *data = [key dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];

        if (!error && json) {
            _kty = json[@"kty"];
            _crv = json[@"crv"];
            _x = json[@"x"];
            _y = json[@"y"];
        }
    }
    
    return self;
}

@end

@implementation JPSDKParameters

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration
   andAuthenticationRequestParameters:(JP3DSAuthenticationRequestParameters *)params {
    if (self = [super init]) {
        _applicationId = params.sdkAppID;
        _encodedData = params.deviceData;
        _referenceNumber = params.sdkReferenceNumber;
        _transactionId = params.sdkTransactionID;
        _maxTimeout = @(configuration.threeDSTwoMaxTimeout > 0 ? configuration.threeDSTwoMaxTimeout : 30);
        _deviceRenderOptions = [JPDeviceRenderOptions new];
        _ephemeral_public_key = [[JPEphemeralPublicKey alloc] initWithString:params.sdkEphemeralPublicKey];
    }
    return self;
}

@end

@implementation JPThreeDSecureTwo

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration
   andAuthenticationRequestParameters:(JP3DSAuthenticationRequestParameters *)params {
    if (self = [super init]) {
        _challengeRequestIndicator = configuration.challengeRequestIndicator;
        _scaExemption = configuration.scaExemption;
        _authenticationSource = @"MOBILE_SDK";
        _sdk = [[JPSDKParameters alloc] initWithConfiguration:configuration
                           andAuthenticationRequestParameters:params];
    }
    
    return self;
}

@end
