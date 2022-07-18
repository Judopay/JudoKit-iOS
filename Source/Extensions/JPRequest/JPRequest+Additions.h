#import "JPCard.h"
#import "JPRequest.h"
#import <Foundation/Foundation.h>

@interface JPRequest (Additions)

- (void)_jp_setCardDetails:(nonnull JPCard *)card;
- (void)_jp_setConfigurationDetails:(nonnull JPConfiguration *)configuration;

@end
