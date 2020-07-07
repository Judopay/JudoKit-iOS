#import "JPSessionAuthorization.h"
#import "Functions.h"

@implementation JPSessionAuthorization {
    NSDictionary<NSString *, NSString *> *_headers;
}

+ (instancetype)authorizationWithToken:(NSString *)token andPaymentSession:(NSString *)session {
    return [[JPSessionAuthorization alloc] initWithToken:token andPaymentSession:session];
}

- (instancetype)initWithToken:(NSString *)token andPaymentSession:(NSString *)session {
    if (self = [super init]) {
        _headers = @{
            @"Authorization" : generateBasicAuthHeader(token, @""),
            @"Payment-Session" : session
        };
    }

    return self;
}

#pragma mark - Authorization

- (NSDictionary<NSString *, NSString *> *)headers {
    return _headers;
}

@end
