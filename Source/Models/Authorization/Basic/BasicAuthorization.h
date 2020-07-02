#import <Foundation/Foundation.h>
#import "../Authorization.h"

@interface BasicAuthorization : NSObject <Authorization>

- (instancetype)initWithToken:(NSString *)token andSecret:(NSString *)secret;
+ (instancetype)authorizationWithToken:(NSString *)token andSecret:(NSString *)secret;

@end