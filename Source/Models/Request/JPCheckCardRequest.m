#import "JPCheckCardRequest.h"
#import "JPConstants.h"

@implementation JPCheckCardRequest

- (NSString *)amount {
    return @"0.00";
}

- (NSString *)currency {
    return kCurrencyPounds;
}

@end