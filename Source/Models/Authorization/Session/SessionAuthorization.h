#import <Foundation/Foundation.h>
#import "../Authorization.h"

@interface SessionAuthorization : NSObject <Authorization>

- (instancetype)initWithToken:(NSString *)token andPaymentSession:(NSString *)session;
+ (instancetype)authorizationWithToken:(NSString *)token andPaymentSession:(NSString *)session;

@end