//
//  JPApplePayService.m
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

#import "JPApplePayService.h"
#import "JPApiService.h"
#import "JPApplePayConfiguration.h"
#import "JPApplePayRequest.h"
#import "JPApplePayWrappers.h"
#import "JPCardDetails.h"
#import "JPConfiguration.h"
#import "JPConsumer.h"
#import "JPContactInformation.h"
#import "JPError+Additions.h"
#import "JPFormatters.h"
#import "JPPostalAddress.h"
#import "JPPreAuthApplePayRequest.h"
#import "JPReference.h"
#import "JPResponse.h"

@interface JPApplePayService ()
@property (nonatomic, assign) JPTransactionMode transactionMode;
@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, strong) JPApiService *apiService;
@end

@implementation JPApplePayService

#pragma mark - Initializers

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration
                        andApiService:(JPApiService *)apiService {
    if (self = [super init]) {
        self.configuration = configuration;
        self.apiService = apiService;
    }
    return self;
}

#pragma mark - Public methods

+ (bool)isApplePaySupported {
    return PKPaymentAuthorizationController.canMakePayments;
}

- (bool)isApplePaySetUp {
    NSArray *paymentNetworks = [JPApplePayWrappers pkPaymentNetworksForConfiguration:self.configuration];
    return [PKPaymentAuthorizationController canMakePaymentsUsingNetworks:paymentNetworks];
}

- (void)processApplePayment:(PKPayment *)payment
         forTransactionMode:(JPTransactionMode)transactionMode
             withCompletion:(JPCompletionBlock)completion {

    if (transactionMode == JPTransactionModeServerToServer) {
        [self processServerToServer:completion payment:payment];
        return;
    }

    __weak typeof(self) weakSelf = self;

    JPCompletionBlock resultBlock = ^(JPResponse *response, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;

        if (error || response == nil) {
            completion(response, (JPError *)error);
            return;
        }

        JPReturnedInfo returnedContactInfo = strongSelf.configuration.applePayConfiguration.returnedContactInfo;

        if (returnedContactInfo & JPReturnedInfoBillingContacts) {
            response.billingInfo = [strongSelf contactInformationFromPaymentContact:payment.billingContact];
        }

        if (returnedContactInfo & JPReturnedInfoShippingContacts) {
            response.shippingInfo = [strongSelf contactInformationFromPaymentContact:payment.shippingContact];
        }

        completion(response, (JPError *)error);
    };

    if (transactionMode == JPTransactionModePreAuth) {
        JPPreAuthApplePayRequest *request = [[JPPreAuthApplePayRequest alloc] initWithConfiguration:self.configuration
                                                                                         andPayment:payment];
        [self.apiService invokePreAuthApplePayPaymentWithRequest:request andCompletion:resultBlock];
    } else {
        JPApplePayRequest *request = [[JPApplePayRequest alloc] initWithConfiguration:self.configuration
                                                                           andPayment:payment];
        [self.apiService invokeApplePayPaymentWithRequest:request andCompletion:resultBlock];
    }
}

#pragma mark - Helper methods

- (nullable JPContactInformation *)contactInformationFromPaymentContact:(nullable PKContact *)contact {

    if (!contact)
        return nil;

    JPPostalAddress *postalAddress = [[JPPostalAddress alloc] initWithStreet:contact.postalAddress.street
                                                                        city:contact.postalAddress.city
                                                                       state:contact.postalAddress.state
                                                                  postalCode:contact.postalAddress.postalCode
                                                                     country:contact.postalAddress.country
                                                                     isoCode:contact.postalAddress.ISOCountryCode
                                                       subAdministrativeArea:contact.postalAddress.subAdministrativeArea
                                                                 sublocality:contact.postalAddress.subLocality];

    return [[JPContactInformation alloc] initWithEmailAddress:contact.emailAddress
                                                         name:contact.name
                                                  phoneNumber:contact.phoneNumber.stringValue
                                                postalAddress:postalAddress];
}

- (void)processServerToServer:(JPCompletionBlock)completion payment:(PKPayment *)payment {
    completion([self buildResponse:payment], nil);
}

- (JPResponse *)buildResponse:(PKPayment *)payment {
    JPResponse *response = [JPResponse new];
    response.judoId = self.configuration.judoId;
    response.paymentReference = self.configuration.reference.paymentReference;
    response.createdAt = [[JPFormatters.sharedInstance rfc3339DateFormatter] stringFromDate:NSDate.date];
    response.consumer = [JPConsumer new];
    response.consumer.consumerReference = self.configuration.reference.consumerReference;
    response.amount = self.configuration.amount;
    response.cardDetails = [JPCardDetails new];
    response.cardDetails.cardToken = payment.token.transactionIdentifier;
    response.cardDetails.cardScheme = payment.token.paymentMethod.network;
    return response;
}

@end
