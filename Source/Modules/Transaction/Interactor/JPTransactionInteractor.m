//
//  JPTransactionInteractor.m
//  JudoKit-iOS
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

#import "JPTransactionInteractor.h"
#import "JP3DSService.h"
#import "JPAddress.h"
#import "JPAmount.h"
#import "JPCard.h"
#import "JPCardPattern.h"
#import "JPCardStorage.h"
#import "JPCardValidationService.h"
#import "JPConfiguration.h"
#import "JPCountry.h"
#import "JPError+Additions.h"
#import "JPError.h"
#import "JPKeychainService.h"
#import "JPReference.h"
#import "JPResponse.h"
#import "JPSession.h"
#import "JPStoredCardDetails.h"
#import "JPTransaction.h"
#import "JPTransactionService.h"
#import "JPTransactionViewModel.h"
#import "JPUIConfiguration.h"
#import "JPValidationResult.h"
#import "NSString+Additions.h"
#import "JPTransactionViewModel.h"

@interface JPTransactionInteractorImpl ()
@property (nonatomic, strong) JPCompletionBlock completionHandler;
@property (nonatomic, strong) JPCardValidationService *cardValidationService;
@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, strong) JPTransactionService *transactionService;
@property (nonatomic, strong) JP3DSService *threeDSecureService;
@property (nonatomic, strong) NSMutableArray *storedErrors;
@end

@implementation JPTransactionInteractorImpl

#pragma mark - Initializers

- (instancetype)initWithCardValidationService:(JPCardValidationService *)cardValidationService
                           transactionService:(JPTransactionService *)transactionService
                                configuration:(JPConfiguration *)configuration
                                   completion:(JPCompletionBlock)completion {

    if (self = [super init]) {
        self.cardValidationService = cardValidationService;
        self.transactionService = transactionService;
        self.configuration = configuration;
        self.completionHandler = completion;
    }
    return self;
}

#pragma mark - Interactor Protocol Methods

- (BOOL)isAVSEnabled {
    return self.configuration.uiConfiguration.isAVSEnabled;
}

- (JPCardDetailsMode)cardDetailsMode {
    if (self.transactionService.mode == JPCardDetailsModeDefault) {
        return self.configuration.uiConfiguration.isAVSEnabled ? JPCardDetailsModeAVS : JPCardDetailsModeDefault;
    }
    return self.transactionService.mode;
}

- (JPCardNetworkType)cardNetwork {
    return self.transactionService.cardNetwork;
}

- (JPTransactionType)transactionType {
    return self.transactionService.transactionType;
}

- (JPAddress *)getConfiguredCardAddress {
    return self.configuration.cardAddress.copy;
}

- (void)handleCameraPermissionsWithCompletion:(void (^)(AVAuthorizationStatus))completion {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted) {
                                     completion(granted ? AVAuthorizationStatusAuthorized : AVAuthorizationStatusDenied);
                                 }];
    } else {
        completion(status);
    }
}

- (NSString *)generatePayButtonTitle {
    if ((self.configuration.uiConfiguration.shouldPaymentButonDisplayAmount)) {
        JPAmount *amount = self.configuration.amount;
        return [NSString stringWithFormat:@"%@ %@%@", @"pay".localized, amount.currency.toCurrencySymbol, amount.amount];
    }
    return @"pay".localized;
}

- (void)sendTransactionWithCard:(JPCard *)card
              completionHandler:(JPCompletionBlock)completionHandler {

    JPTransaction *transaction = [self.transactionService transactionWithConfiguration:self.configuration];
    transaction.card = card;

    self.threeDSecureService.transaction = transaction;
    [transaction sendWithCompletion:completionHandler];
}

- (void)completeTransactionWithResponse:(JPResponse *)response
                                  error:(JPError *)error {

    if (!self.completionHandler)
        return;

    if (error.code == JPError.judoUserDidCancelError.code) {
        error.details = self.storedErrors;
    }

    self.completionHandler(response, error);
}

- (void)storeError:(NSError *)error {
    [self.storedErrors addObject:error];
}

- (void)updateKeychainWithCardModel:(JPTransactionViewModel *)viewModel andToken:(NSString *)token {

    JPCardNetworkType cardNetwork = viewModel.cardNumberViewModel.cardNetwork;
    NSString *cardNumberString = viewModel.cardNumberViewModel.text;

    NSString *lastFour = [cardNumberString substringFromIndex:cardNumberString.length - 4];
    NSString *expiryDate = viewModel.expiryDateViewModel.text;

    JPStoredCardDetails *storedCardDetails = [JPStoredCardDetails cardDetailsWithLastFour:lastFour
                                                                               expiryDate:expiryDate
                                                                              cardNetwork:cardNetwork
                                                                                cardToken:token];
    storedCardDetails.cardTitle = [self defaultCardTitleForCardNetwork:cardNetwork];
    storedCardDetails.patternType = JPCardPattern.random.type;
    [JPCardStorage.sharedInstance addCardDetails:storedCardDetails];
}

- (NSString *)defaultCardTitleForCardNetwork:(JPCardNetworkType)network {
    switch (network) {
        case JPCardNetworkTypeVisa:
            return @"default_visa_card_title".localized;

        case JPCardNetworkTypeAMEX:
            return @"default_amex_card_title".localized;

        case JPCardNetworkTypeMaestro:
            return @"default_maestro_card_title".localized;

        case JPCardNetworkTypeMasterCard:
            return @"default_mastercard_card_title".localized;

        case JPCardNetworkTypeChinaUnionPay:
            return @"default_chinaunionpay_card_title".localized;

        case JPCardNetworkTypeJCB:
            return @"default_jcb_card_title".localized;

        case JPCardNetworkTypeDiscover:
            return @"default_discover_card_title".localized;

        case JPCardNetworkTypeDinersClub:
            return @"default_dinnersclub_card_title".localized;

        default:
            return @"";
    }
}

- (void)resetCardValidationResults {
    [self.cardValidationService resetCardValidationResults];
}

- (void)handle3DSecureTransactionFromError:(NSError *)error
                                completion:(JPCompletionBlock)completion {
    [self.threeDSecureService invoke3DSecureViewControllerWithError:error
                                                         completion:completion];
}

- (NSArray<NSString *> *)getSelectableCountryNames {
    return @[
        [JPCountry countryWithType:JPCountryTypeUK].name,
        [JPCountry countryWithType:JPCountryTypeUSA].name,
        [JPCountry countryWithType:JPCountryTypeCanada].name,
        [JPCountry countryWithType:JPCountryTypeOther].name,
    ];
}

- (JPValidationResult *)validateCardNumberInput:(NSString *)input {
    return [self.cardValidationService validateCardNumberInput:input
                                          forSupportedNetworks:self.supportedNetworks];
}

- (JPValidationResult *)validateCardholderNameInput:(NSString *)input {
    return [self.cardValidationService validateCardholderNameInput:input];
}

- (JPValidationResult *)validateExpiryDateInput:(NSString *)input {
    return [self.cardValidationService validateExpiryDateInput:input];
}

- (JPValidationResult *)validateSecureCodeInput:(NSString *)input {
    return [self.cardValidationService validateSecureCodeInput:input];
}

- (JPValidationResult *)validateCountryInput:(NSString *)input {
    return [self.cardValidationService validateCountryInput:input];
}

- (JPValidationResult *)validatePostalCodeInput:(NSString *)input {
    return [self.cardValidationService validatePostalCodeInput:input];
}

- (JP3DSService *)threeDSecureService {
    if (!_threeDSecureService) {
        _threeDSecureService = [JP3DSService new];
    }
    return _threeDSecureService;
}

- (JPCardNetworkType)supportedNetworks {
    if (self.configuration.supportedCardNetworks) {
        return self.configuration.supportedCardNetworks;
    }
    return JPCardNetworkTypeVisa | JPCardNetworkTypeAMEX | JPCardNetworkTypeMaestro | JPCardNetworkTypeMasterCard;
}

- (NSMutableArray *)storedErrors {
    if (!_storedErrors) {
        _storedErrors = [NSMutableArray new];
    }
    return _storedErrors;
}

@end
