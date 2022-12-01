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
#import "JPPreAuthRequest.h"
#import "JPPreAuthTokenRequest.h"
#import "JPRegisterCardRequest.h"
#import "JPSaveCardRequest.h"
#import "JPThreeDSecureTwo.h"
#import "JPTokenRequest.h"

#import <Judo3DS2_iOS/Judo3DS2_iOS.h>

@implementation JPCardTransactionDetails (Additions)

- (JPPaymentRequest *)toPaymentRequestWithConfiguration:(JPConfiguration *)configuration
                                         andTransaction:(JP3DSTransaction *)transaction {
    JPPaymentRequest *request = [[JPPaymentRequest alloc] initWithConfiguration:configuration];
    [self populateWithCardDetailsRequest:request usingConfiguration:configuration andTransaction:transaction];
    return request;
}

- (JPTokenRequest *)toTokenRequestWithConfiguration:(JPConfiguration *)configuration
                                     andTransaction:(JP3DSTransaction *)transaction {
    JPTokenRequest *request = [[JPTokenRequest alloc] initWithConfiguration:configuration];
    [self populateWithCardTokenDetailsRequest:request usingConfiguration:configuration andTransaction:transaction];
    return request;
}

- (nonnull JPPreAuthRequest *)toPreAuthPaymentRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                               andTransaction:(nonnull JP3DSTransaction *)transaction {
    JPPreAuthRequest *request = [[JPPreAuthRequest alloc] initWithConfiguration:configuration];
    [self populateWithCardDetailsRequest:request usingConfiguration:configuration andTransaction:transaction];
    return request;
}

- (nonnull JPPreAuthTokenRequest *)toPreAuthTokenRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                           andTransaction:(nonnull JP3DSTransaction *)transaction {
    JPPreAuthTokenRequest *request = [[JPPreAuthTokenRequest alloc] initWithConfiguration:configuration];
    [self populateWithCardTokenDetailsRequest:request usingConfiguration:configuration andTransaction:transaction];
    return request;
}

- (JPRegisterCardRequest *)toRegisterCardRequestWithConfiguration:(JPConfiguration *)configuration
                                                   andTransaction:(JP3DSTransaction *)transaction {
    JPRegisterCardRequest *request = [[JPRegisterCardRequest alloc] initWithConfiguration:configuration];
    [self populateWithCardDetailsRequest:request usingConfiguration:configuration andTransaction:transaction];
    return request;
}

- (JPSaveCardRequest *)toSaveCardRequestWithConfiguration:(JPConfiguration *)configuration
                                           andTransaction:(JP3DSTransaction *)transaction {
    JPSaveCardRequest *request = [[JPSaveCardRequest alloc] initWithConfiguration:configuration];
    [self populateWithCardDetailsRequest:request usingConfiguration:configuration andTransaction:transaction];
    return request;
}

- (JPCheckCardRequest *)toCheckCardRequestWithConfiguration:(JPConfiguration *)configuration
                                             andTransaction:(JP3DSTransaction *)transaction {
    JPCheckCardRequest *request = [[JPCheckCardRequest alloc] initWithConfiguration:configuration];
    [self populateWithCardDetailsRequest:request usingConfiguration:configuration andTransaction:transaction];
    return request;
}

- (void)populateWithCardTokenDetailsRequest:(JPTokenRequest *)request
                         usingConfiguration:(JPConfiguration *)configuration
                             andTransaction:(JP3DSTransaction *)transaction {
    request.endDate = self.endDate;
    request.cardLastFour = self.cardLastFour;
    request.cardToken = self.cardToken;
    request.cardType = @(self.cardType);
    request.cv2 = self.secureCode;
    request.cardHolderName = self.cardholderName;
    request.phoneCountryCode = self.phoneCountryCode;
    request.mobileNumber = self.mobileNumber;
    request.emailAddress = self.emailAddress;
    request.cardAddress = self.billingAddress;

    JP3DSAuthenticationRequestParameters *params = [transaction getAuthenticationRequestParameters];

    request.threeDSecure = [[JPThreeDSecureTwo alloc] initWithConfiguration:configuration
                                         andAuthenticationRequestParameters:params];
}

- (void)populateWithCardDetailsRequest:(JPRequest *)request
                    usingConfiguration:(JPConfiguration *)configuration
                        andTransaction:(JP3DSTransaction *)transaction {
    request.cardNumber = self.cardNumber;
    request.expiryDate = self.expiryDate;
    request.cv2 = self.secureCode;
    request.cardHolderName = self.cardholderName;
    request.phoneCountryCode = self.phoneCountryCode;
    request.mobileNumber = self.mobileNumber;
    request.emailAddress = self.emailAddress;
    request.cardAddress = self.billingAddress;

    JP3DSAuthenticationRequestParameters *params = [transaction getAuthenticationRequestParameters];

    request.threeDSecure = [[JPThreeDSecureTwo alloc] initWithConfiguration:configuration
                                         andAuthenticationRequestParameters:params];
}

@end
