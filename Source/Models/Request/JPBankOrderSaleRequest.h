#import <Foundation/Foundation.h>

@interface JPBankOrderSaleRequest : NSObject

@property(nonatomic, strong, nullable) NSNumber *amount;
@property(nonatomic, strong, nullable) NSString *siteId;
@property(nonatomic, strong, nullable) NSString *bic;
@property(nonatomic, strong, nullable) NSString *currency;
@property(nonatomic, strong, nullable) NSString *country;
@property(nonatomic, strong, nullable) NSString *paymentMethod;
@property(nonatomic, strong, nullable) NSString *emailAddress;
@property(nonatomic, strong, nullable) NSString *mobileNumber;
@property(nonatomic, strong, nullable) NSString *accountHolderName;
@property(nonatomic, strong, nullable) NSString *appearsOnStatement;
@property(nonatomic, strong, nullable) NSString *merchantRedirectUrl;
@property(nonatomic, strong, nullable) NSString *merchantPaymentReference;
@property(nonatomic, strong, nullable) NSString *merchantConsumerReference;
@property(nonatomic, strong, nullable) NSDictionary <NSString *, NSString *> *paymentMetadata;

@end
