#import <Foundation/Foundation.h>

@protocol Authorization <NSObject>
@required
@property(nonatomic, strong, readonly, nonnull) NSDictionary<NSString *, NSString *> *headers;
@end