//
//  JPSDK.m
//  JudoKit_iOS
//
//  Copyright (c) 2021 Alternative Payments Ltd
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

#import "JPSDK.h"
#import "JPEphemeralPublicKey.h"
#import "JPDeviceRenderOptions.h"
#import "JPConfiguration.h"
#import <Judo3DS2_iOS/JP3DSAuthenticationRequestParameters.h>
@interface JPSDK ()

@property (nonatomic, nullable, copy) NSString *applicationId;
@property (nonatomic, nullable, copy) NSString *encodedData;
@property (nonatomic, nullable, copy) NSString *maxTimeout;
@property (nonatomic, nullable, copy) NSString *referenceNumber;
@property (nonatomic, nullable, copy) NSString *transactionId;
@property (nonatomic, nullable, strong) JPEphemeralPublicKey *ephemeral_public_key;
@property (nonatomic, nullable, strong) JPDeviceRenderOptions *deviceRenderOptions;

@end

@implementation JPSDK

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration
                           authParams:(JP3DSAuthenticationRequestParameters *)authParams {
    if (self = [super init]) {
        NSData *data = [authParams.sdkEphemeralPublicKey dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * ephemeralPublicKeyDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        _applicationId = authParams.sdkAppID;
        _encodedData = authParams.deviceData;
        _maxTimeout = configuration.threeDSTwoMaxTimeout;
        _referenceNumber = authParams.sdkReferenceNumber;
        _transactionId = authParams.sdkTransactionID;
        _ephemeral_public_key = [[JPEphemeralPublicKey alloc] initWithDictionary:ephemeralPublicKeyDict];
        _deviceRenderOptions = [JPDeviceRenderOptions new];
    }
    return self;
}

@end
