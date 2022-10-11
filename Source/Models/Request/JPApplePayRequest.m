//
//  JPApplePayPaymentRequest.m
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

#import "JPApplePayRequest.h"
#import "JPAddress.h"
#import "JPCountry.h"
#import "JPState.h"
#import <PassKit/PassKit.h>

@implementation JPApplePayPaymentToken

- (instancetype)initWithPaymentToken:(PKPaymentToken *)token {
    if (self = [super init]) {
        if (token.paymentMethod) {
            _paymentInstrumentName = token.paymentMethod.displayName;
            _paymentNetwork = token.paymentMethod.network;
        }

        _paymentData = [NSJSONSerialization JSONObjectWithData:token.paymentData
                                                       options:NSJSONReadingAllowFragments
                                                         error:nil];
    }
    return self;
}

@end

@implementation JPApplePayBillingContact : NSObject

- (instancetype)initWithContact:(PKContact *_Nonnull)contact {
    if (self = [super init]) {
        CNPostalAddress *address = contact.postalAddress;

        _street = address.street;
        _subLocality = address.subLocality;
        _city = address.city;
        _subAdministrativeArea = address.subAdministrativeArea;
        _state = address.state;
        _postalCode = address.postalCode;
        _country = address.country;
        _ISOCountryCode = address.ISOCountryCode;

        NSPersonNameComponents *name = contact.name;

        _namePrefix = name.namePrefix;
        _givenName = name.givenName;
        _middleName = name.middleName;
        _familyName = name.familyName;
        _nameSuffix = name.nameSuffix;
        _nickname = name.nickname;
    }
    return self;
}

@end

@implementation JPApplePayPayment

- (instancetype)initWithPayment:(PKPayment *)payment {
    if (self = [super init]) {
        _token = [[JPApplePayPaymentToken alloc] initWithPaymentToken:payment.token];

        PKContact *billingContact = payment.billingContact;

        if (billingContact) {
            _billingContact = [[JPApplePayBillingContact alloc] initWithContact:billingContact];
        }
    }
    return self;
}

@end

@implementation JPApplePayRequest

- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration
                                   andPayment:(nonnull PKPayment *)payment {
    if (self = [super initWithConfiguration:configuration]) {
        [self populateApplePayMetadataWithPayment:payment];
    }
    return self;
}

- (void)populateApplePayMetadataWithPayment:(PKPayment *)payment {
    self.pkPayment = [[JPApplePayPayment alloc] initWithPayment:payment];

    PKContact *billingContact = payment.billingContact;

    if (billingContact.emailAddress) {
        self.emailAddress = billingContact.emailAddress;
    }

    if (billingContact.phoneNumber) {
        self.mobileNumber = billingContact.phoneNumber.stringValue;
    }

    if (billingContact.postalAddress) {
        CNPostalAddress *postalAddress = billingContact.postalAddress;
        JPCountry *country = [JPCountry forCountryName:postalAddress.country];
        NSNumber *countryCode = country ? @([country.numericCode intValue]) : nil;
        NSString *state = country ? [JPState forStateName:postalAddress.state andCountryCode:country.alpha2Code].alpha2Code : nil;

        self.cardAddress = [[JPAddress alloc] initWithAddress1:postalAddress.street
                                                      address2:postalAddress.city
                                                      address3:postalAddress.postalCode
                                                          town:postalAddress.city
                                                      postCode:postalAddress.postalCode
                                                   countryCode:countryCode
                                                         state:state];
    }
}

@end
