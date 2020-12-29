//
//  JPApplePayButton.h
//  CocoaDebug
//
//  Created by Mihai Petrenco on 12/29/20.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>

API_AVAILABLE(ios(8.3))
@interface JPApplePayButton : PKPaymentButton

typedef NS_ENUM(NSUInteger, JPApplePayButtonStyle) {
    JPApplePayButtonStyleWhite,
    JPApplePayButtonStyleWhiteOutline,
    JPApplePayButtonStyleBlack,
    JPApplePayButtonStyleAutomatic API_AVAILABLE(ios(14.0))
};

typedef NS_ENUM(NSUInteger, JPApplePayButtonType) {
    JPApplePayButtonTypePlain,
    JPApplePayButtonTypeBuy,
    JPApplePayButtonTypeSetUp,
    JPApplePayButtonTypeInStore,
    JPApplePayButtonTypeDonate,
    JPApplePayButtonTypeCheckout API_AVAILABLE(ios(12.0)),
    JPApplePayButtonTypeBook  API_AVAILABLE(ios(12.0)),
    JPApplePayButtonTypeSubscribe  API_AVAILABLE(ios(12.0)),
    JPApplePayButtonTypeReload  API_AVAILABLE(ios(14.0)),
    JPApplePayButtonTypeAddMoney  API_AVAILABLE(ios(14.0)),
    JPApplePayButtonTypeTopUp  API_AVAILABLE(ios(14.0)),
    JPApplePayButtonTypeOrder  API_AVAILABLE(ios(14.0)),
    JPApplePayButtonTypeRent  API_AVAILABLE(ios(14.0)),
    JPApplePayButtonTypeSupport  API_AVAILABLE(ios(14.0)),
    JPApplePayButtonTypeContribute  API_AVAILABLE(ios(14.0)),
    JPApplePayButtonTypeTip  API_AVAILABLE(ios(14.0)),
};

+ (instancetype)buttonWithType:(JPApplePayButtonType)buttonType
                         style:(JPApplePayButtonStyle)buttonStyle;

- (instancetype)initWithType:(JPApplePayButtonType)buttonType
                       style:(JPApplePayButtonStyle)buttonStyle;

@end

