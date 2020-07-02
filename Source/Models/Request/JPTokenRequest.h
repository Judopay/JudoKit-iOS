#import <Foundation/Foundation.h>
#import "JPRequest.h"

@interface JPTokenRequest : JPRequest
@property(nonatomic, strong, nullable) NSString *endDate;
@property(nonatomic, strong, nullable) NSString *cardLastFour;
@property(nonatomic, strong, nullable) NSString *cardToken;
@property(nonatomic, strong, nullable) NSNumber *cardType;
@end
