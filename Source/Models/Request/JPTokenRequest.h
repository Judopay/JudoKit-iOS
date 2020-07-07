#import "JPRequest.h"
#import <Foundation/Foundation.h>

@class JPConfiguration;

@interface JPTokenRequest : JPRequest

@property (nonatomic, strong, nullable) NSString *endDate;
@property (nonatomic, strong, nullable) NSString *cardLastFour;
@property (nonatomic, strong, nullable) NSString *cardToken;
@property (nonatomic, strong, nullable) NSNumber *cardType;

- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration
                                 andCardToken:(nonnull NSString *)cardToken;

@end
