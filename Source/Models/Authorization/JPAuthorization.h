#import <Foundation/Foundation.h>

@protocol JPAuthorization <NSObject>
@required
@property (nonatomic, strong, readonly, nonnull) NSDictionary<NSString *, NSString *> *headers;
@end
