#import <JudoKit_iOS/JudoKit_iOS.h>
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
                                                         error:nil]; //TODO: handle this error
    }
    return self;
}

@end

@implementation JPApplePayPayment

- (instancetype)initWithPayment:(PKPayment *)payment {
    if (self = [super init]) {
        _token = [[JPApplePayPaymentToken alloc] initWithPaymentToken:payment.token];
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
    CNPostalAddress *postalAddress = billingContact.postalAddress;

    if (billingContact.emailAddress != nil) {
        self.emailAddress = billingContact.emailAddress;
    }

    if (billingContact.phoneNumber != nil) {
        self.mobileNumber = billingContact.phoneNumber.stringValue;
    }

    // TODO: billingContact.postalAddress.ISOCountryCode - alpha2 to numeric code
    self.cardAddress = [[JPAddress alloc] initWithLine1:postalAddress.street
                                                  line2:postalAddress.city
                                                  line3:postalAddress.postalCode
                                                   town:postalAddress.city
                                            countryCode:@(-1)
                                               postCode:postalAddress.postalCode];
}

@end
