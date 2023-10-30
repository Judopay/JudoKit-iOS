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
#import "ScaExemption.h"

#import <Judo3DS2_iOS/Judo3DS2_iOS.h>

@implementation JPCardTransactionDetails (Additions)

- (JPPaymentRequest *)toPaymentRequestWithConfiguration:(JPConfiguration *)configuration
                                            transaction:(JP3DSTransaction *)transaction
                             recommendationScaExemption:(ScaExemption)recommendationScaExemption
                recommendationChallengeRequestIndicator:(NSString *)recommendationChallengeRequestIndicator {
    JPPaymentRequest *request = [[JPPaymentRequest alloc] initWithConfiguration:configuration];
    [self populateWithCardDetailsRequest:request
                      usingConfiguration:configuration
                             transaction:transaction
              recommendationScaExemption:recommendationScaExemption
  recommendationChallengeRequestIndicator:recommendationChallengeRequestIndicator];
    return request;
}

- (JPTokenRequest *)toTokenRequestWithConfiguration:(JPConfiguration *)configuration
                                     andTransaction:(JP3DSTransaction *)transaction {
    JPTokenRequest *request = [[JPTokenRequest alloc] initWithConfiguration:configuration];
    [self populateWithCardTokenDetailsRequest:request usingConfiguration:configuration andTransaction:transaction];
    return request;
}

- (nonnull JPPreAuthRequest *)toPreAuthPaymentRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                                           transaction:(nonnull JP3DSTransaction *)transaction
                                            recommendationScaExemption:(ScaExemption)recommendationScaExemption
                               recommendationChallengeRequestIndicator:(NSString *)recommendationChallengeRequestIndicator {
    JPPreAuthRequest *request = [[JPPreAuthRequest alloc] initWithConfiguration:configuration];
    [self populateWithCardDetailsRequest:request
                      usingConfiguration:configuration
                             transaction:transaction
              recommendationScaExemption:recommendationScaExemption
  recommendationChallengeRequestIndicator:recommendationChallengeRequestIndicator];
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
    [self populateWithCardDetailsRequest:request
                      usingConfiguration:configuration
                             transaction:transaction
              recommendationScaExemption:UNKNOWN_OR_NOT_PRESENT_EXCEPTION
  recommendationChallengeRequestIndicator:nil];
    return request;
}

- (JPSaveCardRequest *)toSaveCardRequestWithConfiguration:(JPConfiguration *)configuration
                                           andTransaction:(JP3DSTransaction *)transaction {
    JPSaveCardRequest *request = [[JPSaveCardRequest alloc] initWithConfiguration:configuration];
    [self populateWithCardDetailsRequest:request
                      usingConfiguration:configuration
                             transaction:transaction
              recommendationScaExemption:UNKNOWN_OR_NOT_PRESENT_EXCEPTION
  recommendationChallengeRequestIndicator:nil];
    return request;
}

- (JPCheckCardRequest *)toCheckCardRequestWithConfiguration:(JPConfiguration *)configuration
                                                transaction:(JP3DSTransaction *)transaction
                                 recommendationScaExemption:(ScaExemption)recommendationScaExemption
                    recommendationChallengeRequestIndicator:(NSString *)recommendationChallengeRequestIndicator {
    JPCheckCardRequest *request = [[JPCheckCardRequest alloc] initWithConfiguration:configuration];
    [self populateWithCardDetailsRequest:request
                      usingConfiguration:configuration
                             transaction:transaction
              recommendationScaExemption:recommendationScaExemption
  recommendationChallengeRequestIndicator:recommendationChallengeRequestIndicator];
    return request;
}

- (void)populateWithCardTokenDetailsRequest:(JPTokenRequest *)request
                         usingConfiguration:(JPConfiguration *)configuration
                             andTransaction:(JP3DSTransaction *)transaction {
    request.endDate = self.endDate;
    request.cardLastFour = self.cardLastFour;
    request.cardToken = self.cardToken;
    request.cardType = @(self.cardType);
    request.isInitialRecurringPayment = configuration.isInitialRecurringPayment;
    request.cv2 = self.securityCode;
    request.cardHolderName = self.cardholderName;
    request.phoneCountryCode = self.phoneCountryCode;
    request.mobileNumber = self.mobileNumber;
    [self configurePhoneDetails:request];
    request.emailAddress = self.emailAddress;
    request.cardAddress = self.billingAddress;

    JP3DSAuthenticationRequestParameters *params = [transaction getAuthenticationRequestParameters];

    request.threeDSecure = [[JPThreeDSecureTwo alloc] initWithConfiguration:configuration
                                            authenticationRequestParameters:params
                                                 recommendationScaExemption:UNKNOWN_OR_NOT_PRESENT_EXCEPTION
                                    recommendationChallengeRequestIndicator:nil
    ];
}

- (void)populateWithCardDetailsRequest:(JPRequest *)request
                    usingConfiguration:(JPConfiguration *)configuration
                           transaction:(JP3DSTransaction *)transaction
            recommendationScaExemption:(ScaExemption)recommendationScaExemption
recommendationChallengeRequestIndicator:(NSString *)recommendationChallengeRequestIndicator {
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
                                            authenticationRequestParameters:params
                                                 recommendationScaExemption:recommendationScaExemption
                                    recommendationChallengeRequestIndicator:recommendationChallengeRequestIndicator];
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

@end
