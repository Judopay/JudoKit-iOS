#import "JPTokenRequest.h"

@implementation JPTokenRequest

- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration
                                 andCardToken:(nonnull NSString *)cardToken {
    if (self = [super initWithConfiguration:configuration]) {
        _cardToken = cardToken;
    }
    return self;
}

@end
