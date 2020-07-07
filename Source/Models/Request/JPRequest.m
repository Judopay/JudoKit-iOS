#import "JPRequest.h"
#import "JPConfiguration.h"
#import "JPRequest+Additions.h"

@implementation JPRequest

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration {
    if (self = [super init]) {
        [self setConfigurationDetails:configuration];
    }
    return self;
}

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration andCardDetails:(JPCard *)card {
    if (self = [super init]) {
        [self setConfigurationDetails:configuration];
        [self setCardDetails:card];
    }
    return self;
}

@end
