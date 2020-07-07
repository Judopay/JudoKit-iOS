#import "JP3DSecureAuthenticationResult.h"

@implementation JP3DSecureAuthenticationResult

- (nonnull instancetype)initWithPaRes:(nonnull NSString *)paRes andMd:(nonnull NSString *)md {
    if (self = [super init]) {
        _paRes = paRes;
        _md = md;
    }
    return self;
}

@end
