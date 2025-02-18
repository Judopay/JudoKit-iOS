//
//  JPTransactionInteractor.m
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

#import "JPTransactionInteractor.h"
#import "JPAddress.h"
#import "JPAmount.h"
#import "JPCard.h"
#import "JPCardPattern.h"
#import "JPCardStorage.h"
#import "JPCardTransactionDetails.h"
#import "JPCardTransactionService.h"
#import "JPCardValidationService.h"
#import "JPConfiguration+Additions.h"
#import "JPConfiguration.h"
#import "JPCountry.h"
#import "JPError+Additions.h"
#import "JPPresentationMode.h"
#import "JPResponse.h"
#import "JPStoredCardDetails.h"
#import "JPUIConfiguration.h"
#import "JPValidationResult.h"
#import "NSNumberFormatter+Additions.h"
#import "NSString+Additions.h"

@interface JPTransactionInteractorImpl ()

@property (nonatomic, strong) JPCardValidationService *cardValidationService;
@property (nonatomic, strong) JPCardTransactionService *transactionService;
@property (nonatomic, assign) JPTransactionType transactionType;
@property (nonatomic, assign) JPPresentationMode presentationMode;
@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, strong) JPCardTransactionDetails *transactionDetails;
@property (nonatomic, strong) JPCompletionBlock completionHandler;
@property (nonatomic, strong) NSMutableArray *storedErrors;

@end

@implementation JPTransactionInteractorImpl

#pragma mark - Initializers

- (instancetype)initWithCardValidationService:(JPCardValidationService *)cardValidationService
                           transactionService:(JPCardTransactionService *)transactionService
                              transactionType:(JPTransactionType)type
                             presentationMode:(JPPresentationMode)mode
                                configuration:(JPConfiguration *)configuration
                           transactionDetails:(JPCardTransactionDetails *)details
                                   completion:(JPCompletionBlock)completion {

    if (self = [super init]) {
        _cardValidationService = cardValidationService;
        _transactionService = transactionService;
        _transactionType = type;
        _presentationMode = mode;
        _configuration = configuration;
        _transactionDetails = details;
        _completionHandler = completion;
    }
    return self;
}

#pragma mark - Interactor Protocol Methods

- (JPPresentationMode)presentationMode {
    // Billing info screen should not be presented in case of a `Save Card`
    if (self.transactionType == JPTransactionTypeSaveCard) {
        return JPPresentationModeCardInfo;
    }
    return _presentationMode;
}

- (JPCardNetworkType)cardNetworkType {
    if (self.transactionDetails) {
        return self.transactionDetails.cardType;
    }
    return JPCardNetworkTypeVisa;
}

- (JPCardTransactionDetails *)getConfiguredCardTransactionDetails {
    return _transactionDetails;
}

- (JPAddress *)getConfiguredCardAddress {
    return self.configuration.cardAddress;
}

- (JPTheme *)getConfiguredTheme {
    return self.configuration.uiConfiguration.theme;
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
    if (self.configuration.uiConfiguration.shouldPaymentButtonDisplayAmount) {
        JPAmount *amount = self.configuration.amount;
        NSString *formattedAmount = [NSNumberFormatter _jp_formattedAmount:amount.amount
                                                          withCurrencyCode:amount.currency];
#pragma warning disable S5281
        return [NSString stringWithFormat:@"jp_pay_amount"._jp_localized, formattedAmount];
#pragma warning restore S5281
    }

    return @"jp_pay_now"._jp_localized;
}

- (void)sendTransactionWithDetails:(JPCardTransactionDetails *)details
                 completionHandler:(JPCompletionBlock)completionHandler {
    switch (self.transactionType) {
        case JPTransactionTypePayment:
            [self.transactionService invokePaymentWithDetails:details andCompletion:completionHandler];
            break;

        case JPTransactionTypePreAuth:
            [self.transactionService invokePreAuthPaymentWithDetails:details andCompletion:completionHandler];
            break;

        case JPTransactionTypeSaveCard:
            [self.transactionService invokeSaveCardWithDetails:details andCompletion:completionHandler];
            break;

        case JPTransactionTypeCheckCard:
            [self.transactionService invokeCheckCardWithDetails:details andCompletion:completionHandler];
            break;

        case JPTransactionTypeRegisterCard:
            [self.transactionService invokeRegisterCardWithDetails:details andCompletion:completionHandler];
            break;

        default:
            break;
    }
}

- (void)sendTokenTransactionWithDetails:(JPCardTransactionDetails *)details completionHandler:(JPCompletionBlock)completionHandler {
    switch (self.transactionType) {
        case JPTransactionTypePayment:
            [self.transactionService invokeTokenPaymentWithDetails:details andCompletion:completionHandler];
            break;

        case JPTransactionTypePreAuth:
            [self.transactionService invokePreAuthTokenPaymentWithDetails:details andCompletion:completionHandler];
            break;

        default:
            break;
    }
}

- (void)completeTransactionWithResponse:(JPResponse *)response error:(JPError *)error {
    if (!self.completionHandler)
        return;

    if (error.code == JPError.userDidCancelError.code) {
        error.details = self.storedErrors;
    }

    self.completionHandler(response, error);
}

- (void)storeError:(NSError *)error {
    [self.storedErrors addObject:error];
}

- (void)resetCardValidationResults {
    [self.cardValidationService resetCardValidationResults];
}

- (NSArray<JPCountry *> *)getFilteredCountriesBySearchString:(NSString *)searchString {
    NSArray *countries = [[JPCountryList defaultCountryList] countries];
    if (!searchString || searchString.length == 0) {
        return countries ? countries : @[];
    }
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.name beginswith[c] %@", searchString];
    return [countries filteredArrayUsingPredicate:bPredicate];
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

- (JPValidationResult *)validateSecureCodeInput:(NSString *)input trimIfTooLong:(BOOL)trim {
    return [self.cardValidationService validateSecureCodeInput:input trimIfTooLong:trim];
}

- (JPValidationResult *)validateCountryInput:(NSString *)input {
    return [self.cardValidationService validateCountryInput:input];
}

- (JPValidationResult *)validatePostalCodeInput:(NSString *)input {
    return [self.cardValidationService validatePostalCodeInput:input];
}

- (JPValidationResult *)validateBillingEmailInput:(NSString *)input {
    return [self.cardValidationService validateBillingEmailInput:input];
}

- (JPValidationResult *)validateBillingCountryInput:(NSString *)input {
    return [self.cardValidationService validateBillingCountryInput:input];
}

- (JPValidationResult *)validateBillingAdministrativeDivisionInput:(NSString *)input {
    return [self.cardValidationService validateBillingAdministrativeDivisionInput:input];
}

- (JPValidationResult *)validateBillingPhoneInput:(NSString *)input {
    return [self.cardValidationService validateBillingPhoneInput:input];
}

- (JPValidationResult *)validateBillingPhoneCodeInput:(NSString *)input {
    return [self.cardValidationService validateBillingPhoneCodeInput:input];
}

- (JPValidationResult *)validateBillingAddressLineInput:(NSString *)input {
    return [self.cardValidationService validateBillingAddressLineInput:input];
}

- (JPValidationResult *)validateBillingCity:(NSString *)input {
    return [self.cardValidationService validateBillingCityInput:input];
}

- (JPValidationResult *)validateBillingPostalCodeInput:(NSString *)input {
    return [self.cardValidationService validateBillingPostalCodeInput:input];
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
