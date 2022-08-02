#import "JPCard.h"
#import "JPRequest.h"
#import <Foundation/Foundation.h>

@interface JPRequest (Additions)

- (void)setCardDetails:(nonnull JPCard *)card;
- (void)setConfigurationDetails:(nonnull JPConfiguration *)configuration;

@end
