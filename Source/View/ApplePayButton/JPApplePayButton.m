//
//  JPApplePayButton.m
//  CocoaDebug
//
//  Created by Mihai Petrenco on 12/29/20.
//

#import "JPApplePayButton.h"

@implementation JPApplePayButton

+ (instancetype)buttonWithType:(JPApplePayButtonType)buttonType
                         style:(JPApplePayButtonStyle)buttonStyle {
    
    return [[JPApplePayButton alloc] initWithType:buttonType
                                            style:buttonStyle];
}

- (instancetype)initWithType:(JPApplePayButtonType)buttonType
                       style:(JPApplePayButtonStyle)buttonStyle API_AVAILABLE(ios(9.0)) {

    return [self initWithPaymentButtonType:buttonType
                        paymentButtonStyle:buttonStyle];
}

@end
