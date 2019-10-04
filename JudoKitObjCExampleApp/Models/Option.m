#import "Option.h"

@implementation Option
+ (instancetype)optionWithType:(OptionType)type
                         title:(NSString *)title
                       details:(NSString *)details {
    Option *option  = [Option new];
    option.type = type;
    option.title = title;
    option.details = details;
    return option;
}

+ (NSArray <Option *> *)defaultOptions {
    return @[
        [Option optionWithType:OptionTypePayment title:@"Payment" details:@"with default settings"],
        [Option optionWithType:OptionTypePreAuth title:@"PreAuth" details: @"to reserve funds on a card"],
        [Option optionWithType:OptionTypeCreateCardToken title:@"Register card" details: @"to be stored for future transactions"],
        [Option optionWithType:OptionTypeSaveCard title:@"Save card" details: @"to be stored for future transactions"],
        [Option optionWithType:OptionTypeRepeatPayment title:@"Token payment" details: @"with a stored card token"],
        [Option optionWithType:OptionTypeTokenPreAuth title:@"Token preAuth" details: @"with a stored card token"],
        [Option optionWithType:OptionTypeApplePayPayment title:@"Apple Pay payment" details: @"with a wallet card"],
        [Option optionWithType:OptionTypeApplePayPreAuth title:@"Apple Pay preAuth" details: @"with a wallet card"],
        [Option optionWithType:OptionTypePaymentMethods title: @"Payment Method" details: @"with default payment methods"],
        [Option optionWithType:OptionTypeStandaloneApplePayButton title: @"Apple Pay Button" details: @"Standalone ApplePay Button"]
    ];
}
@end
