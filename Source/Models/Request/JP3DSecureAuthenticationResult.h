#import <Foundation/Foundation.h>

@interface JP3DSecureAuthenticationResult : NSObject

@property (nonatomic, strong, nonnull) NSString *md;
@property (nonatomic, strong, nonnull) NSString *paRes;

- (nonnull instancetype)initWithPaRes:(nonnull NSString *)paRes andMd:(nonnull NSString *)md;

@end
