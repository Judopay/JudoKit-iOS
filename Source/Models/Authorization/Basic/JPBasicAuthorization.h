#import "JPAuthorization.h"
#import <Foundation/Foundation.h>

@interface JPBasicAuthorization : NSObject <JPAuthorization>

- (instancetype)initWithToken:(NSString *)token andSecret:(NSString *)secret;
+ (instancetype)authorizationWithToken:(NSString *)token andSecret:(NSString *)secret;

@end
