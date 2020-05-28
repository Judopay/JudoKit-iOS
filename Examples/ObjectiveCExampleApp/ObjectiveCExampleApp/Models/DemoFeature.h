#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DemoFeatureType) {
    DemoFeatureTypePayment,
    DemoFeatureTypePreAuth,
    DemoFeatureTypeCreateCardToken,
    DemoFeatureTypeSaveCard,
    DemoFeatureTypeCheckCard,
    DemoFeatureTypeApplePayPayment,
    DemoFeatureTypeApplePayPreAuth,
    DemoFeatureTypePaymentMethods,
    DemoFeatureTypePreAuthMethods,
    DemoFeatureTypeServerToServer,
    DemoFeatureTypePBBA,
};

@interface DemoFeature : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, assign) DemoFeatureType type;

+ (instancetype)featureWithType:(DemoFeatureType)type
                          title:(NSString *)title
                        details:(NSString *)details;

+ (NSArray <DemoFeature *> *)defaultFeatures;

@end

NS_ASSUME_NONNULL_END
