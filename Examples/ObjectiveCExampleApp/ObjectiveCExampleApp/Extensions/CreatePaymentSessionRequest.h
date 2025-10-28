#import <Foundation/Foundation.h>

@interface CreatePaymentSessionRequest : NSObject

@property (nonatomic, copy) NSString *judoId;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *yourConsumerReference;
@property (nonatomic, copy) NSString *yourPaymentReference;
@property (nonatomic, assign) BOOL disableNetworkTokenisation;

- (instancetype)initWithJudoId:(NSString *)judoId
                         amount:(NSString *)amount
                       currency:(NSString *)currency
          yourConsumerReference:(NSString *)yourConsumerReference
           yourPaymentReference:(NSString *)yourPaymentReference
     disableNetworkTokenisation:(BOOL)disableNetworkTokenisation;

- (NSDictionary *)dictionaryRepresentation;

@end
