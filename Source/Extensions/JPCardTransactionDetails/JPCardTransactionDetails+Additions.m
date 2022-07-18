//
//  JPCardTransactionDetails+Additions.m
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

#import "JPCardTransactionDetails+Additions.h"
#import <Foundation/Foundation.h>

#import "JPAddress.h"
#import "JPCheckCardRequest.h"
#import "JPConfiguration.h"
#import "JPPaymentRequest.h"
#import "JPRegisterCardRequest.h"
#import "JPSaveCardRequest.h"
#import "JPThreeDSecureTwo.h"
#import "JPTokenRequest.h"

#import <Judo3DS2_iOS/Judo3DS2_iOS.h>

@implementation JPCardTransactionDetails (Additions)

- (JPPaymentRequest *)_jp_toPaymentRequestWithConfiguration:(JPConfiguration *)configuration
                                             andTransaction:(JP3DSTransaction *)transaction {
    JPPaymentRequest *request = [[JPPaymentRequest alloc] initWithConfiguration:configuration];
    request.cardNumber = self.cardNumber;
    request.expiryDate = self.expiryDate;
    request.cv2 = self.secureCode;
    request.cardHolderName = self.cardholderName;
    request.phoneCountryCode = self.phoneCountryCode;
    request.mobileNumber = self.mobileNumber;
    request.emailAddress = self.emailAddress;

    JP3DSAuthenticationRequestParameters *params = [transaction getAuthenticationRequestParameters];

    request.threeDSecure = [[JPThreeDSecureTwo alloc] initWithConfiguration:configuration
                                         andAuthenticationRequestParameters:params];
    return request;
}

- (JPTokenRequest *)_jp_toTokenRequestWithConfiguration:(JPConfiguration *)configuration
                                         andTransaction:(JP3DSTransaction *)transaction {
    JPTokenRequest *request = [[JPTokenRequest alloc] initWithConfiguration:configuration];

    request.endDate = self.endDate;
    request.cardLastFour = self.cardLastFour;
    request.cardToken = self.cardToken;
    request.cardType = @(self.cardType);
    request.cv2 = self.secureCode;
    request.cardHolderName = self.cardholderName;
    request.phoneCountryCode = self.phoneCountryCode;
    request.mobileNumber = self.mobileNumber;
    request.emailAddress = self.emailAddress;

    JP3DSAuthenticationRequestParameters *params = [transaction getAuthenticationRequestParameters];

    request.threeDSecure = [[JPThreeDSecureTwo alloc] initWithConfiguration:configuration
                                         andAuthenticationRequestParameters:params];

    return request;
}

- (JPRegisterCardRequest *)_jp_toRegisterCardRequestWithConfiguration:(JPConfiguration *)configuration
                                                       andTransaction:(JP3DSTransaction *)transaction {
    JPRegisterCardRequest *request = [[JPRegisterCardRequest alloc] initWithConfiguration:configuration];
    request.cardNumber = self.cardNumber;
    request.expiryDate = self.expiryDate;
    request.cv2 = self.secureCode;
    request.cardHolderName = self.cardholderName;
    request.phoneCountryCode = self.phoneCountryCode;
    request.mobileNumber = self.mobileNumber;
    request.emailAddress = self.emailAddress;

    JP3DSAuthenticationRequestParameters *params = [transaction getAuthenticationRequestParameters];

    request.threeDSecure = [[JPThreeDSecureTwo alloc] initWithConfiguration:configuration
                                         andAuthenticationRequestParameters:params];

    return request;
}

- (JPSaveCardRequest *)_jp_toSaveCardRequestWithConfiguration:(JPConfiguration *)configuration
                                               andTransaction:(JP3DSTransaction *)transaction {
    JPSaveCardRequest *request = [[JPSaveCardRequest alloc] initWithConfiguration:configuration];
    request.cardNumber = self.cardNumber;
    request.expiryDate = self.expiryDate;
    request.cv2 = self.secureCode;
    request.cardHolderName = self.cardholderName;
    request.phoneCountryCode = self.phoneCountryCode;
    request.mobileNumber = self.mobileNumber;
    request.emailAddress = self.emailAddress;

    JP3DSAuthenticationRequestParameters *params = [transaction getAuthenticationRequestParameters];

    request.threeDSecure = [[JPThreeDSecureTwo alloc] initWithConfiguration:configuration
                                         andAuthenticationRequestParameters:params];

    return request;
}

- (JPCheckCardRequest *)_jp_toCheckCardRequestWithConfiguration:(JPConfiguration *)configuration
                                                 andTransaction:(JP3DSTransaction *)transaction {
    JPCheckCardRequest *request = [[JPCheckCardRequest alloc] initWithConfiguration:configuration];
    request.cardNumber = self.cardNumber;
    request.expiryDate = self.expiryDate;
    request.cv2 = self.secureCode;
    request.cardHolderName = self.cardholderName;
    request.phoneCountryCode = self.phoneCountryCode;
    request.mobileNumber = self.mobileNumber;
    request.emailAddress = self.emailAddress;

    JP3DSAuthenticationRequestParameters *params = [transaction getAuthenticationRequestParameters];

    request.threeDSecure = [[JPThreeDSecureTwo alloc] initWithConfiguration:configuration
                                         andAuthenticationRequestParameters:params];

    return request;
}

@end
