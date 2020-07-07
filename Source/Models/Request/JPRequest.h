#import <Foundation/Foundation.h>

@class JPPrimaryAccountDetails, JPAddress, JPConfiguration, JPCard;

@interface JPRequest : NSObject

@property (nonatomic, strong, nullable) NSString *amount;
@property (nonatomic, strong, nullable) NSString *currency;
@property (nonatomic, strong, nullable) NSString *judoId;
@property (nonatomic, strong, nullable) NSString *cardNumber;
@property (nonatomic, strong, nullable) NSString *cv2;
@property (nonatomic, strong, nullable) NSString *expiryDate;
@property (nonatomic, strong, nullable) NSString *startDate;
@property (nonatomic, strong, nullable) NSString *issueNumber;
@property (nonatomic, strong, nullable) NSString *saveCardOnly;
@property (nonatomic, strong, nullable) NSString *emailAddress;
@property (nonatomic, strong, nullable) NSString *mobileNumber;
@property (nonatomic, strong, nullable) JPAddress *cardAddress;
@property (nonatomic, strong, nullable) NSString *yourPaymentReference;
@property (nonatomic, strong, nullable) NSString *yourConsumerReference;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *yourPaymentMetaData;
@property (nonatomic, strong, nullable) JPPrimaryAccountDetails *primaryAccountDetails;

- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration;
- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration andCardDetails:(nonnull JPCard *)card;

@end
