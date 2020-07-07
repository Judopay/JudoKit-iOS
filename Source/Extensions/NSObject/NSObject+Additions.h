#import <Foundation/Foundation.h>

@interface NSObject (Additions)

- (nonnull NSDictionary *)toDictionary;
- (nullable NSData *)toJSONObjectData;

@end