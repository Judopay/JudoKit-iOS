#import "JPAmount.h"
#import "JPConfiguration.h"
#import "JPReference.h"
#import "JPRequest+Additions.h"
#import "JPAddress.h"

@implementation JPRequest (Additions)

- (void)setCardDetails:(nonnull JPCard *)card {
    self.cardNumber = card.cardNumber;
    self.expiryDate = card.expiryDate;
    self.cv2 = card.secureCode;
    self.startDate = card.startDate;
    self.issueNumber = card.issueNumber;
    self.cardHolderName = card.cardholderName;
    
    if (card.cardAddress) {
        self.cardAddress = card.cardAddress;
    }
}

- (void)setConfigurationDetails:(nonnull JPConfiguration *)configuration {
    self.judoId = configuration.judoId;

    self.amount = configuration.amount.amount;
    self.currency = configuration.amount.currency;

    self.yourPaymentReference = configuration.reference.paymentReference;
    self.yourConsumerReference = configuration.reference.consumerReference;
    self.yourPaymentMetaData = configuration.reference.metaData;

    self.primaryAccountDetails = configuration.primaryAccountDetails;
    self.cardAddress = configuration.cardAddress;
    self.phoneCountryCode = [configuration.cardAddress.countryCode stringValue];
}

@end
