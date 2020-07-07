#import <Foundation/Foundation.h>

@protocol JPAuthorization;

@interface JPSessionConfiguration : NSObject

@property (nonatomic, strong, nonnull) id<JPAuthorization> authorization;
@property (nonatomic, readonly, nonnull) NSURL *apiBaseURL;
@property (nonatomic, assign) BOOL isSandboxed;

- (nonnull instancetype)initWithAuthorization:(nonnull id<JPAuthorization>)authorization;
+ (nonnull instancetype)configurationWithAuthorization:(nonnull id<JPAuthorization>)authorization;

@end
