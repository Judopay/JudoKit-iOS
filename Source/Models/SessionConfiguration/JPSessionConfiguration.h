#import <Foundation/Foundation.h>

@protocol Authorization;

@interface JPSessionConfiguration : NSObject

@property (nonatomic, strong, nonnull) id <Authorization> authorization;
@property(nonatomic, readonly, nonnull) NSURL *apiBaseURL;
@property(nonatomic, assign) BOOL isSandboxed;

- (nonnull instancetype)initWithAuthorization:(nonnull id <Authorization>)authorization;
+ (nonnull instancetype)configurationWithAuthorization:(nonnull id <Authorization>)authorization;

@end