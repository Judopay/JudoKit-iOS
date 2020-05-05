#import "Settings.h"

@interface Settings ()
@property (nonatomic, strong) NSUserDefaults* defaults;
@end

@implementation Settings

- (instancetype)initWith: (NSUserDefaults *)defaults {
    if (self = [super init]) {
        _defaults = defaults;
    }
    return self;
}

#pragma mark - API credentials section

- (BOOL)isSandboxed {
    return [self.defaults boolForKey:kSandboxedKey];
}

-(NSString *)judoId {
    return [self.defaults stringForKey:kJudoIdKey];
}

-(NSString *)siteId {
    return [self.defaults stringForKey:kSiteIdKey];
}

-(NSString *)token {
    return [self.defaults stringForKey:kTokenKey];
}

-(NSString *)secret {
    return [self.defaults stringForKey:kSecretKey];
}

#pragma mark - Amount section

- (JPAmount *)amount {
    NSString *amount = [self.defaults stringForKey: kAmountKey];
    NSString *currency = [self.defaults stringForKey: kCurrencyKey];
    return [[JPAmount alloc] initWithAmount:amount currency:currency];
}

#pragma mark - Apple Pay section

- (NSString *)applePayMerchantId {
    return [self.defaults stringForKey:kMerchantIdKey];
}

#pragma mark - Supported card networks section

- (CardNetwork)supportedCardNetworks {
    CardNetwork networks = CardNetworkUnknown;
    
    if ([self.defaults boolForKey:kVisaEnabledKey]) {
        networks |= CardNetworkVisa;
    }
    
    if ([self.defaults boolForKey:kMasterCardEnabledKey]) {
        networks |= CardNetworkMasterCard;
    }
    
    if ([self.defaults boolForKey:kMaestroEnabledKey]) {
        networks |= CardNetworkMaestro;
    }
    
    if ([self.defaults boolForKey:kAMEXEnabledKey]) {
        networks |= CardNetworkAMEX;
    }
    
    if ([self.defaults boolForKey:kChinaUnionPayEnabledKey]) {
        networks |= CardNetworkChinaUnionPay;
    }
    
    if ([self.defaults boolForKey:kJCBEnabledKey]) {
        networks |= CardNetworkJCB;
    }
    
    if ([self.defaults boolForKey:kDiscoverEnabledKey]) {
        networks |= CardNetworkDiscover;
    }
    
    if ([self.defaults boolForKey:kDinersClubEnabledKey]) {
        networks |= CardNetworkDinersClub;
    }
    
    return networks;
}

#pragma mark - Payment methods section

- (NSArray<JPPaymentMethod *> *)paymentMethods {
    NSMutableArray *methods = [NSMutableArray new];
    
    if ([self.defaults boolForKey:kCardPaymentMethodEnabledKey]) {
        [methods addObject:JPPaymentMethod.card];
    }
    
    if ([self.defaults boolForKey:kiDEALPaymentMethodEnabledKey]) {
        [methods addObject:JPPaymentMethod.iDeal];
    }
    
    if ([self.defaults boolForKey:kApplePayPaymentMethodEnabledKey]) {
        [methods addObject:JPPaymentMethod.applePay];
    }
    
    if ([self.defaults boolForKey:kPbbaPaymentMethodEnabledKey]) {
        [methods addObject:JPPaymentMethod.pbba];
    }

    return methods;
}

#pragma mark - Others section keys

- (BOOL)isAVSEnabled {
    return [self.defaults boolForKey:kAVSEnabledKey];
}

- (BOOL)isAmountLabelEnabled {
    return [self.defaults boolForKey:kAmountLabelEnabledKey];
}

@end
