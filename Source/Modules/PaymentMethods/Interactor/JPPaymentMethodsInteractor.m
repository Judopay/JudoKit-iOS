//
//  JPPaymentMethodsInteractor.m
//  JudoKit_iOS
//
//  Copyright (c) 2019 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "JPPaymentMethodsInteractor.h"
#import "JP3DSConfiguration.h"
#import "JPAmount.h"
#import "JPApiService.h"
#import "JPApplePayConfiguration.h"
#import "JPApplePayService.h"
#import "JPCardDetails.h"
#import "JPCardNetwork.h"
#import "JPCardPattern.h"
#import "JPCardStorage.h"
#import "JPCardTransactionDetails.h"
#import "JPCardTransactionService.h"
#import "JPConfiguration.h"
#import "JPConstants.h"
#import "JPConsumer.h"
#import "JPError+Additions.h"
#import "JPFormatters.h"
#import "JPPaymentMethod.h"
#import "JPPresentationMode.h"
#import "JPReference.h"
#import "JPResponse.h"
#import "JPStoredCardDetails.h"
#import "JPTokenRequest.h"
#import "JPUIConfiguration.h"
#import "NSBundle+Additions.h"
#import "NSString+Additions.h"
#import "UIApplication+Additions.h"

@interface JPPaymentMethodsInteractorImpl ()
@property (nonatomic, assign) JPTransactionMode transactionMode;
@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, strong) JPCompletionBlock completionHandler;
@property (nonatomic, strong) NSArray<JPPaymentMethod *> *paymentMethods;
@property (nonatomic, strong) NSMutableArray<NSError *> *storedErrors;

@property (nonatomic, strong) JPApplePayService *applePayService;
@property (nonatomic, strong) JPApiService *apiService;
@property (nonatomic, strong) JPCardTransactionService *transactionService;

@end

@implementation JPPaymentMethodsInteractorImpl

#pragma mark - Initializers

- (instancetype)initWithMode:(JPTransactionMode)mode
               configuration:(JPConfiguration *)configuration
                  apiService:(JPApiService *)apiService
                  completion:(JPCompletionBlock)completion {

    if (self = [super init]) {
        _transactionMode = mode;
        _configuration = configuration;
        _apiService = apiService;
        _completionHandler = completion;
        _paymentMethods = configuration.paymentMethods;

        [JPCardStorage.sharedInstance orderCards];
    }
    return self;
}

#pragma mark - Get stored cards

- (NSArray<JPStoredCardDetails *> *)getStoredCardDetails {
    return [JPCardStorage.sharedInstance fetchStoredCardDetails];
}

#pragma mark - Select card at index

- (void)selectCardAtIndex:(NSUInteger)index {

    NSArray<JPStoredCardDetails *> *storedCardDetails;
    storedCardDetails = [JPCardStorage.sharedInstance fetchStoredCardDetails];

    for (JPStoredCardDetails *cardDetails in storedCardDetails) {
        cardDetails.isSelected = NO;
    }
    storedCardDetails[index].isSelected = YES;
    [JPCardStorage.sharedInstance deleteCardDetails];

    for (JPStoredCardDetails *cardDetails in storedCardDetails) {
        [JPCardStorage.sharedInstance addCardDetails:cardDetails];
    }
}

#pragma mark - Set card at index as default

- (void)setCardAsDefaultAtIndex:(NSInteger)index {
    [JPCardStorage.sharedInstance setCardDefaultState:YES atIndex:index];
}

#pragma mark - Set card as selected at index

- (void)setCardAsSelectedAtIndex:(NSUInteger)index {
    [JPCardStorage.sharedInstance setCardAsSelectedAtIndex:index];
}

#pragma mark - Order cards

- (void)orderCards {
    [JPCardStorage.sharedInstance orderCards];
}

#pragma mark - Set card last card used to maek a successfull payment at index

- (void)setLastUsedCardAtIndex:(NSUInteger)index {
    [JPCardStorage.sharedInstance setLastUsedCardAtIndex:index];
}

#pragma mark - Get JPAmount

- (JPAmount *)getAmount {
    return self.configuration.amount;
}

- (JPTransactionMode)configuredTransactionMode {
    return self.transactionMode;
}

#pragma mark - Get payment methods

- (NSArray<JPPaymentMethod *> *)getPaymentMethods {
    NSMutableArray *defaultPaymentMethods;
    defaultPaymentMethods = [NSMutableArray arrayWithArray:@[ JPPaymentMethod.card ]];

    if (JPApplePayService.isApplePaySupported) {
        [defaultPaymentMethods addObject:JPPaymentMethod.applePay];
    } else {
        [self removePaymentMethodWithType:JPPaymentMethodTypeApplePay];
    }

    return (self.paymentMethods.count != 0) ? self.paymentMethods : defaultPaymentMethods;
}

#pragma mark - Remove Apple Pay from payment methods

- (void)removePaymentMethodWithType:(JPPaymentMethodType)type {
    if (self.paymentMethods.count == 0)
        return;

    NSMutableArray *tempArray = [self.paymentMethods mutableCopy];

    for (JPPaymentMethod *method in self.paymentMethods) {
        if (method.type == type) {
            [tempArray removeObject:method];
        }
    }

    self.paymentMethods = tempArray;
}

#pragma mark - Payment transaction

- (void)processServerToServerCardPayment:(JPCompletionBlock)completion {
    completion([self buildResponse], nil);
}

#pragma mark - Apple Pay payment

- (void)processApplePaymentWithCompletion:(JPCompletionBlock)completion {
    [self.applePayService processPaymentWithConfiguration:self.configuration
                                          transactionMode:self.transactionMode
                                            andCompletion:completion];
}

#pragma mark - Delete card at index

- (void)deleteCardWithIndex:(NSUInteger)index {
    [JPCardStorage.sharedInstance deleteCardWithIndex:index];
}

#pragma mark - Is Apple Pay ready

- (bool)isApplePaySetUp {
    return [JPApplePayService canMakePaymentsUsingConfiguration:self.configuration];
}

- (JPApplePayService *)applePayService {
    if (!_applePayService && self.configuration.applePayConfiguration) {
        _applePayService = [[JPApplePayService alloc] initWithApiService:self.apiService];
    }
    return _applePayService;
}

- (JPCardTransactionService *)transactionService {
    if (!_transactionService) {
        _transactionService = [[JPCardTransactionService alloc] initWithAPIService:self.apiService
                                                                  andConfiguration:self.configuration];
    }
    return _transactionService;
}

- (JPStoredCardDetails *)selectedCard {
    for (JPStoredCardDetails *card in [self getStoredCardDetails]) {
        if (card.isSelected) {
            return card;
        }
    }
    return nil;
}

- (JPResponse *)buildResponse {
    JPResponse *response = [JPResponse new];
    response.judoId = self.configuration.judoId;
    response.paymentReference = self.configuration.reference.paymentReference;
    response.createdAt = [[JPFormatters.sharedInstance rfc3339DateFormatter] stringFromDate:NSDate.date];
    response.consumer = [JPConsumer new];
    response.consumer.consumerReference = self.configuration.reference.consumerReference;
    response.amount = self.configuration.amount;
    response.cardDetails = [JPCardDetails new];

    JPStoredCardDetails *selectedCard = self.selectedCard;
    response.cardDetails.cardLastFour = selectedCard.cardLastFour;
    response.cardDetails.cardToken = selectedCard.cardToken;
    response.cardDetails.cardNetwork = selectedCard.cardNetwork;
    response.cardDetails.cardScheme = [JPCardNetwork nameOfCardNetwork:selectedCard.cardNetwork];

    return response;
}

- (void)storeError:(NSError *)error {
    [self.storedErrors addObject:error];
}

- (void)completeTransactionWithResponse:(JPResponse *)response andError:(JPError *)error {
    if (!self.completionHandler)
        return;

    if (error.code == JPError.userDidCancelError.code) {
        error.details = self.storedErrors;
    }

    self.completionHandler(response, error);
}

- (NSMutableArray *)storedErrors {
    if (!_storedErrors) {
        _storedErrors = [NSMutableArray new];
    }
    return _storedErrors;
}

- (void)updateKeychainWithCardDetails:(JPCardDetails *)details {
    JPCardNetworkType cardNetwork = details.cardNetwork;
    NSString *lastFour = details.cardLastFour;
    NSString *expiryDate = details.formattedExpiryDate;
    NSString *cardholderName = details.cardHolderName;
    NSString *token = details.cardToken;

    JPStoredCardDetails *storedCardDetails = [JPStoredCardDetails cardDetailsWithLastFour:lastFour
                                                                               expiryDate:expiryDate
                                                                              cardNetwork:cardNetwork
                                                                                cardToken:token
                                                                           cardHolderName:cardholderName];
    storedCardDetails.cardTitle = [self defaultCardTitleForCardNetwork:cardNetwork];
    storedCardDetails.patternType = JPCardPattern.random.type;
    [JPCardStorage.sharedInstance addCardDetails:storedCardDetails];
}

- (NSString *)defaultCardTitleForCardNetwork:(JPCardNetworkType)network {
    switch (network) {
        case JPCardNetworkTypeVisa:
            return @"jp_default_visa_card_title"._jp_localized;

        case JPCardNetworkTypeAMEX:
            return @"jp_default_amex_card_title"._jp_localized;

        case JPCardNetworkTypeMaestro:
            return @"jp_default_maestro_card_title"._jp_localized;

        case JPCardNetworkTypeMasterCard:
            return @"jp_default_mastercard_card_title"._jp_localized;

        case JPCardNetworkTypeChinaUnionPay:
            return @"jp_default_chinaunionpay_card_title"._jp_localized;

        case JPCardNetworkTypeJCB:
            return @"jp_default_jcb_card_title"._jp_localized;

        case JPCardNetworkTypeDiscover:
            return @"jp_default_discover_card_title"._jp_localized;

        case JPCardNetworkTypeDinersClub:
            return @"jp_default_dinersclub_card_title"._jp_localized;

        default:
            return @"";
    }
}

@end
