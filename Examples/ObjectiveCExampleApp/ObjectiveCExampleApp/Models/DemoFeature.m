#import "DemoFeature.h"

static NSString *const kCellIdentifier = @"com.judo.judopaysample.tableviewcellidentifier";

@implementation DemoFeature
+ (instancetype)featureWithType:(DemoFeatureType)type
                          title:(NSString *)title
                        details:(NSString *)details {
    DemoFeature *option = [DemoFeature new];
    option.type = type;
    option.title = title;
    option.details = details;
    option.cellIdentifier = kCellIdentifier;
    return option;
}

+ (NSArray<DemoFeature *> *)defaultFeatures {
    return @[
        [DemoFeature featureWithType:DemoFeatureTypePayment
                               title:@"Pay with card"
                             details:@"by entering card details"],
        [DemoFeature featureWithType:DemoFeatureTypePreAuth
                               title:@"Pre-auth with card"
                             details:@"by entering card details"],
        [DemoFeature featureWithType:DemoFeatureTypeCheckCard
                               title:@"Check card"
                             details:@"to validate a card"],
        [DemoFeature featureWithType:DemoFeatureTypeSaveCard
                               title:@"Save card"
                             details:@"to be stored for future transactions"],
        [DemoFeature featureWithType:DemoFeatureTypeApplePayPayment
                               title:@"Apple Pay payment"
                             details:@"with a wallet card"],
        [DemoFeature featureWithType:DemoFeatureTypeApplePayPreAuth
                               title:@"Apple Pay preAuth"
                             details:@"with a wallet card"],
        [DemoFeature featureWithType:DemoFeatureTypeApplePayStandalone
                               title:@"Standalone Apple Pay buttons"
                             details:@"with all supported types and styles"],
        [DemoFeature featureWithType:DemoFeatureTypePaymentMethods
                               title:@"Payment methods"
                             details:@"with default payment methods"],
        [DemoFeature featureWithType:DemoFeatureTypePreAuthMethods
                               title:@"PreAuth methods"
                             details:@"with default preauth methods"],
        [DemoFeature featureWithType:DemoFeatureTypeServerToServer
                               title:@"Server-to-Server payment methods"
                             details:@"with default Server-to-Server payment methods"],
        [DemoFeature featureWithType:DemoFeatureTokenPayments
                               title:@"Token payments"
                             details:@"with optionally asking for CSC and/or cardholder name"],
        [DemoFeature featureWithType:DemoFeatureNoUIPayments
                               title:@"No-UI transactions"
                             details:@"No-UI transactions using card transaction service"],
        [DemoFeature featureWithType:DemoFeatureGetTransactionDetails
                               title:@"Get transaction details"
                             details:@"Get transaction for receipt ID"],
    ];
}
@end
