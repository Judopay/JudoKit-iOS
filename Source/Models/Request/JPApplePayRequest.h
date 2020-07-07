#import "JPRequest.h"
#import <Foundation/Foundation.h>

@class PKPayment, PKPaymentToken;

@interface JPApplePayPaymentToken : NSObject

@property (nonatomic, strong, nullable) NSString *paymentInstrumentName;
@property (nonatomic, strong, nullable) NSString *paymentNetwork;
@property (nonatomic, strong, nonnull) NSDictionary *paymentData;

- (nonnull instancetype)initWithPaymentToken:(nonnull PKPaymentToken *)token;

@end

@interface JPApplePayPayment : NSObject

@property (nonatomic, strong, nonnull) JPApplePayPaymentToken *token;

- (nonnull instancetype)initWithPayment:(nonnull PKPayment *)payment;

@end

@interface JPApplePayRequest : JPRequest

@property (nonatomic, strong, nullable) JPApplePayPayment *pkPayment;

- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration
                                   andPayment:(nonnull PKPayment *)payment;

@end
