#import "JPBankOrderSaleRequest.h"
#import "JPAmount.h"
#import "JPConfiguration.h"
#import "JPPBBAConfiguration.h"
#import "JPReference.h"

static NSString *const kIDEALAccountHolderName = @"IDEAL Bank";
static NSString *const kIDEALCountry = @"NL";
static NSString *const kPaymentMethodIDEAL = @"IDEAL";

static NSString *const kPbBAAccountHolderName = @"PBBA User";
static NSString *const kPbBACountry = @"GB";
static NSString *const kPaymentMethodPbBA = @"PBBA";
static NSString *const kPbBABIC = @"RABONL2U";

@implementation JPBankOrderSaleRequest

- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration {
    if (self = [super init]) {
        JPAmount *amount = configuration.amount;
        JPReference *reference = configuration.reference;

        _siteId = configuration.siteId;

        _amount = @(amount.amount.doubleValue);
        _currency = amount.currency;

        _merchantPaymentReference = reference.paymentReference;
        _merchantConsumerReference = reference.consumerReference;
        _paymentMetadata = reference.metaData;
    }
    return self;
}

+ (nonnull instancetype)idealRequestWithConfiguration:(nonnull JPConfiguration *)configuration
                                               andBIC:(nonnull NSString *)bic {
    JPBankOrderSaleRequest *request = [[JPBankOrderSaleRequest alloc] initWithConfiguration:configuration];
    request.paymentMethod = kPaymentMethodIDEAL;
    request.country = kIDEALCountry;
    request.accountHolderName = kIDEALAccountHolderName;
    request.bic = bic;
    return request;
}

+ (nonnull instancetype)pbbaRequestWithConfiguration:(nonnull JPConfiguration *)configuration {
    JPPBBAConfiguration *pbbaConfiguration = configuration.pbbaConfiguration;
    NSString *merchantRedirectUrl = pbbaConfiguration.deeplinkScheme ? pbbaConfiguration.deeplinkScheme : @"";

    JPBankOrderSaleRequest *request = [[JPBankOrderSaleRequest alloc] initWithConfiguration:configuration];
    request.paymentMethod = kPaymentMethodPbBA;
    request.country = kPbBACountry;
    request.accountHolderName = kPbBAAccountHolderName;
    request.bic = kPbBABIC;
    request.merchantRedirectUrl = merchantRedirectUrl;

    if (pbbaConfiguration.mobileNumber) {
        request.mobileNumber = pbbaConfiguration.mobileNumber;
    }

    if (pbbaConfiguration.emailAddress) {
        request.emailAddress = pbbaConfiguration.emailAddress;
    }

    if (pbbaConfiguration.appearsOnStatement) {
        request.appearsOnStatement = pbbaConfiguration.appearsOnStatement;
    }

    return request;
}

@end
