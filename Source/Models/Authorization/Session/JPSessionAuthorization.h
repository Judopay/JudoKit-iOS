#import "JPAuthorization.h"
#import <Foundation/Foundation.h>

@interface JPSessionAuthorization : NSObject <JPAuthorization>

- (nonnull instancetype)initWithToken:(nonnull NSString *)token andPaymentSession:(nonnull NSString *)session;
+ (nonnull instancetype)authorizationWithToken:(nonnull NSString *)token andPaymentSession:(nonnull NSString *)session;

@end
