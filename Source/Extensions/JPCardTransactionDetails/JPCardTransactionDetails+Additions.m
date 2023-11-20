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
#import "JPCardTransactionDetailsOverrides.h"
#import "JPCheckCardRequest.h"
#import "JPConfiguration.h"
#import "JPConstants.h"
#import "JPPaymentRequest.h"
#import "JPPreAuthRequest.h"
#import "JPPreAuthTokenRequest.h"
#import "JPRegisterCardRequest.h"
#import "JPSaveCardRequest.h"
#import "JPThreeDSecureTwo.h"
#import "JPTokenRequest.h"
#import "NSString+Additions.h"

#import <Judo3DS2_iOS/Judo3DS2_iOS.h>

@implementation JPCardTransactionDetails (Additions)

- (JPPaymentRequest *)toPaymentRequestWithConfiguration:(JPConfiguration *)configuration
                                         andTransaction:(JP3DSTransaction *)transaction {
    JPPaymentRequest *request = [[JPPaymentRequest alloc] initWithConfiguration:configuration];
    [self populateWithCardDetailsRequest:request usingConfiguration:configuration andTransaction:transaction];
    return request;
}

- (JPPreAuthRequest *)toPreAuthPaymentRequestWithConfiguration:(JPConfiguration *)configuration
                                                andTransaction:(JP3DSTransaction *)transaction {
    JPPreAuthRequest *request = [[JPPreAuthRequest alloc] initWithConfiguration:configuration];
    [self populateWithCardDetailsRequest:request usingConfiguration:configuration andTransaction:transaction];
    return request;
}

- (JPTokenRequest *)toTokenRequestWithConfiguration:(JPConfiguration *)configuration
                                     andTransaction:(JP3DSTransaction *)transaction {
    JPTokenRequest *request = [[JPTokenRequest alloc] initWithConfiguration:configuration];
    [self populateWithCardTokenDetailsRequest:request usingConfiguration:configuration andTransaction:transaction];
    return request;
}

- (JPPreAuthTokenRequest *)toPreAuthTokenRequestWithConfiguration:(JPConfiguration *)configuration
                                                   andTransaction:(JP3DSTransaction *)transaction {
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

#pragma mark - Overrides support

- (JPPaymentRequest *)toPaymentRequestWithConfiguration:(JPConfiguration *)configuration
                                              overrides:(JPCardTransactionDetailsOverrides *)overrides
                                         andTransaction:(JP3DSTransaction *)transaction {
    JPPaymentRequest *request = [self toPaymentRequestWithConfiguration:configuration
                                                         andTransaction:transaction];
    [self populateRequest:request withOverrides:overrides];
    return request;
}

- (JPPreAuthRequest *)toPreAuthPaymentRequestWithConfiguration:(JPConfiguration *)configuration
                                                     overrides:(JPCardTransactionDetailsOverrides *)overrides
                                                andTransaction:(JP3DSTransaction *)transaction {
    JPPreAuthRequest *request = [self toPreAuthPaymentRequestWithConfiguration:configuration
                                                                andTransaction:transaction];
    [self populateRequest:request withOverrides:overrides];
    return request;
}

- (JPTokenRequest *)toTokenRequestWithConfiguration:(JPConfiguration *)configuration
                                          overrides:(JPCardTransactionDetailsOverrides *)overrides
                                     andTransaction:(JP3DSTransaction *)transaction {
    JPTokenRequest *request = [self toTokenRequestWithConfiguration:configuration
                                                     andTransaction:transaction];
    [self populateRequest:request withOverrides:overrides];
    return request;
}

- (JPPreAuthTokenRequest *)toPreAuthTokenRequestWithConfiguration:(JPConfiguration *)configuration
                                                        overrides:(JPCardTransactionDetailsOverrides *)overrides
                                                   andTransaction:(JP3DSTransaction *)transaction {
    JPPreAuthTokenRequest *request = [self toPreAuthTokenRequestWithConfiguration:configuration
                                                                   andTransaction:transaction];
    [self populateRequest:request withOverrides:overrides];
    return request;
}

- (JPRegisterCardRequest *)toRegisterCardRequestWithConfiguration:(JPConfiguration *)configuration
                                                        overrides:(JPCardTransactionDetailsOverrides *)overrides
                                                   andTransaction:(JP3DSTransaction *)transaction {
    JPRegisterCardRequest *request = [self toRegisterCardRequestWithConfiguration:configuration
                                                                   andTransaction:transaction];
    [self populateRequest:request withOverrides:overrides];
    return request;
}

- (JPCheckCardRequest *)toCheckCardRequestWithConfiguration:(JPConfiguration *)configuration
                                                  overrides:(JPCardTransactionDetailsOverrides *)overrides
                                             andTransaction:(JP3DSTransaction *)transaction {
    JPCheckCardRequest *request = [self toCheckCardRequestWithConfiguration:configuration
                                                             andTransaction:transaction];
    [self populateRequest:request withOverrides:overrides];
    return request;
}

- (void)populateRequest:(JPRequest *)request withOverrides:(JPCardTransactionDetailsOverrides *)overrides {
    if (overrides.softDeclineReceiptId._jp_isNotNullOrEmpty) {
        request.threeDSecure.softDeclineReceiptId = overrides.softDeclineReceiptId;
    }

    if (overrides.challengeRequestIndicator._jp_isNotNullOrEmpty) {
        request.threeDSecure.challengeRequestIndicator = overrides.challengeRequestIndicator;
    }

    if (overrides.scaExemption._jp_isNotNullOrEmpty) {
        request.threeDSecure.scaExemption = overrides.scaExemption;
    }
}

- (void)populateWithCardTokenDetailsRequest:(JPTokenRequest *)request
                         usingConfiguration:(JPConfiguration *)configuration
                             andTransaction:(JP3DSTransaction *)transaction {
    request.endDate = self.endDate;
    request.cardLastFour = self.cardLastFour;
    request.cardToken = self.cardToken;
    request.cardType = @(self.cardType);
    request.initialRecurringPayment = configuration.isInitialRecurringPayment;
    request.cv2 = self.securityCode;
    request.cardHolderName = self.cardholderName;
    request.phoneCountryCode = self.phoneCountryCode;
    request.mobileNumber = self.mobileNumber;
    [self configurePhoneDetails:request];
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
    request.cv2 = self.securityCode;
    request.cardHolderName = self.cardholderName;
    request.phoneCountryCode = self.phoneCountryCode;
    request.mobileNumber = self.mobileNumber;
    [self configurePhoneDetails:request];
    request.emailAddress = self.emailAddress;
    request.cardAddress = self.billingAddress;

    JP3DSAuthenticationRequestParameters *params = [transaction getAuthenticationRequestParameters];

    request.threeDSecure = [[JPThreeDSecureTwo alloc] initWithConfiguration:configuration
                                         andAuthenticationRequestParameters:params];
}

- (void)configurePhoneDetails:(JPRequest *)request {

    // PAPI will only allow dial codes length 3 or less.
    // Therefore logic has been added to re format dial codes of length 4 (which are always
    // of format: 1(XXX)), when sending to BE.
    //
    // For example, when: dialCode = "1(345)", mobileNumber = "123456"
    // The following is sent to BE: phoneCountryCode = "1", mobileNumber = "3451234567"

    NSString *filteredMobileNumber = [request.mobileNumber stringByTrimmingCharactersInSet:NSCharacterSet.decimalDigitCharacterSet.invertedSet];
    NSString *filteredPhoneCountryCode = [request.phoneCountryCode stringByTrimmingCharactersInSet:NSCharacterSet.decimalDigitCharacterSet.invertedSet];

    if (filteredMobileNumber != nil && filteredPhoneCountryCode != nil && filteredPhoneCountryCode.length > 3) {
        NSString *code = [filteredPhoneCountryCode substringToIndex:1];
        NSString *rest = [filteredPhoneCountryCode substringFromIndex:1];

        request.phoneCountryCode = code;
        request.mobileNumber = [rest stringByAppendingString:filteredMobileNumber];
    }
}

- (NSString *)directoryServerIdInSandboxEnv:(BOOL)isSandboxed {
    NSString *dsServerID = isSandboxed ? @"F000000000" : @"unknown-id";

    switch (self.cardType) {
        case JPCardNetworkTypeVisa:
            dsServerID = isSandboxed ? @"F055545342" : @"A000000003";
            break;
        case JPCardNetworkTypeMasterCard:
        case JPCardNetworkTypeMaestro:
            dsServerID = isSandboxed ? @"F155545342" : @"A000000004";
            break;
        case JPCardNetworkTypeAMEX:
            dsServerID = @"A000000025";
            break;
        default:
            break;
    }

    return dsServerID;
}

@end
