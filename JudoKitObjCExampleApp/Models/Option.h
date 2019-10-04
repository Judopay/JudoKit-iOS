#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, OptionType) {
    OptionTypePayment,
    OptionTypePreAuth,
    OptionTypeCreateCardToken,
    OptionTypeSaveCard,
    OptionTypeRepeatPayment,
    OptionTypeTokenPreAuth,
    OptionTypeApplePayPayment,
    OptionTypeApplePayPreAuth,
    OptionTypePaymentMethods,
    OptionTypeStandaloneApplePayButton
};

@interface Option : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, assign) OptionType type;

+ (instancetype)optionWithType:(OptionType)type
                         title:(NSString *)title
                       details:(NSString *)details;

+ (NSArray <Option *> *)defaultOptions;

@end

NS_ASSUME_NONNULL_END
