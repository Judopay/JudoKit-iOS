#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Settings : NSObject

@property (nonatomic, strong) NSString *currency;
@property (nonatomic, assign) BOOL isAVSEnabled;

+ (instancetype)defaultSettings;

@end

NS_ASSUME_NONNULL_END
