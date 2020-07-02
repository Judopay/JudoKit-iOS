#import "BasicAuthorization.h"
#import "Functions.h"

@implementation BasicAuthorization {
    NSDictionary<NSString *, NSString *> *_headers;
}

+ (instancetype)authorizationWithToken:(NSString *)token andSecret:(NSString *)secret {
    return [[BasicAuthorization alloc] initWithToken:token andSecret:secret];
}

- (instancetype)initWithToken:(NSString *)token andSecret:(NSString *)secret {
    if (self = [super init]) {
        _headers = @{@"Authorization": generateBasicAuthHeader(token, secret)};
    }

    return self;
}

#pragma mark - Authorization

- (NSDictionary<NSString *, NSString *> *)headers {
    return _headers;
}

@end