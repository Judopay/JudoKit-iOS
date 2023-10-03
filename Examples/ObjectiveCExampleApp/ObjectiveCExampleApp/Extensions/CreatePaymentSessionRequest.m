#import "CreatePaymentSessionRequest.h"

@implementation CreatePaymentSessionRequest

- (instancetype)initWithJudoId:(NSString *)judoId
                         amount:(NSString *)amount
                       currency:(NSString *)currency
          yourConsumerReference:(NSString *)yourConsumerReference
        yourPaymentReference:(NSString *)yourPaymentReference {
    self = [super init];
    if (self) {
        _judoId = judoId;
        _amount = amount;
        _currency = currency;
        _yourConsumerReference = yourConsumerReference;
        _yourPaymentReference = yourPaymentReference;
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"judoId": self.judoId,
        @"amount": self.amount,
        @"currency": self.currency,
        @"yourConsumerReference": self.yourConsumerReference,
        @"yourPaymentReference": self.yourPaymentReference
    };
}

@end
