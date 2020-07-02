#import "JPRegisterCardRequest.h"
#import "JPConstants.h"

@implementation JPRegisterCardRequest

- (NSString *)amount {
    if (!super.amount) {
        return @"0.01";
    }

    return super.amount;
}

- (NSString *)currency {
    if (!super.currency) {
        return kCurrencyPounds;
    }

    return super.currency;
}

@end