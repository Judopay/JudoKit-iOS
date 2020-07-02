#import "JPSessionConfiguration.h"
#import "Authorization.h"

static NSString *const kJudoBaseURL = @"https://api.judopay.com/";
static NSString *const kJudoSandboxBaseURL = @"https://api-sandbox.judopay.com/";

@implementation JPSessionConfiguration

- (instancetype)initWithAuthorization:(id <Authorization>)authorization {
    self = [super init];
    if (self) {
        self.authorization = authorization;
        self.isSandboxed = NO;
    }

    return self;
}

+ (instancetype)configurationWithAuthorization:(id <Authorization>)authorization {
    return [[JPSessionConfiguration alloc] initWithAuthorization:authorization];
}

- (NSURL *)apiBaseURL {
    NSString *url = kJudoBaseURL;

    if (self.isSandboxed) {
        url = kJudoSandboxBaseURL;
    }

    return [NSURL URLWithString:url];
}

@end