//
//  JPThreeDSecureTwo.h
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

#import <Foundation/Foundation.h>
#import "ScaExemption.h"

@class JPConfiguration, JP3DSAuthenticationRequestParameters;

@interface JPDeviceRenderOptions : NSObject
@property (nonatomic, strong, nonnull) NSString *sdkInterface;
@property (nonatomic, strong, nonnull) NSArray<NSString *> *sdkUiType;
@end

@interface JPEphemeralPublicKey : NSObject

@property (nonatomic, strong, nonnull) NSString *kty;
@property (nonatomic, strong, nonnull) NSString *crv;
@property (nonatomic, strong, nonnull) NSString *x;
@property (nonatomic, strong, nonnull) NSString *y;

- (nonnull instancetype)initWithString:(nonnull NSString *)key;

@end

@interface JPSDKParameters : NSObject

@property (nonatomic, strong, nonnull) NSString *applicationId;
@property (nonatomic, strong, nonnull) NSString *encodedData;
@property (nonatomic, strong, nonnull) NSNumber *maxTimeout;
@property (nonatomic, strong, nonnull) NSString *referenceNumber;
@property (nonatomic, strong, nonnull) NSString *transactionId;
@property (nonatomic, strong, nonnull) JPDeviceRenderOptions *deviceRenderOptions;
@property (nonatomic, strong, nonnull) JPEphemeralPublicKey *ephemeral_public_key;

- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration
           andAuthenticationRequestParameters:(nonnull JP3DSAuthenticationRequestParameters *)params;
@end

@interface JPThreeDSecureTwo : NSObject

@property (nonatomic, strong, nonnull) NSString *challengeRequestIndicator;
@property (nonatomic, strong, nonnull) NSString *scaExemption;
@property (nonatomic, strong, nonnull) JPSDKParameters *sdk;
@property (nonatomic, strong, nonnull) NSString *authenticationSource;
@property (nonatomic, strong, nonnull) NSString *softDeclineReceiptId;

- (nonnull instancetype)initWithConfiguration:(JPConfiguration *)configuration
              authenticationRequestParameters:(JP3DSAuthenticationRequestParameters *)params
                   recommendationScaExemption:(ScaExemption)recommendationScaExemption
      recommendationChallengeRequestIndicator:(NSString *)recommendationChallengeRequestIndicator;

@end
