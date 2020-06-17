//
//  JPApplePayService.m
//  JudoKit_iOS
//
//  Copyright (c) 2016 Alternative Payments Ltd
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

#import "JPApplePayService.h"
#import "JPApplePayConfiguration.h"
#import "JPApplePayService.h"
#import "JPApplePayWrappers.h"
#import "JPCardDetails.h"
#import "JPConfiguration.h"
#import "JPConsumer.h"
#import "JPContactInformation.h"
#import "JPError+Additions.h"
#import "JPFormatters.h"
#import "JPPostalAddress.h"
#import "JPReference.h"
#import "JPResponse.h"
#import "JPTransaction.h"
#import "JPTransactionData.h"
#import "JPTransactionService.h"
#import "UIApplication+Additions.h"

@interface JPApplePayService ()
@property (nonatomic, assign) JPTransactionMode transactionMode;
@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, strong) JPTransactionService *transactionService;
@property (nonatomic, strong) JPCompletionBlock completionBlock;
@end

@implementation JPApplePayService

#pragma mark - Initializers

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration
                   transactionService:(JPTransactionService *)transactionService {
    if (self = [super init]) {
        self.configuration = configuration;
        self.transactionService = transactionService;
    }
    return self;
}

#pragma mark - Public method

- (UIViewController *)applePayViewControllerWithMode:(JPTransactionMode)mode
                                          completion:(JPCompletionBlock)completion {
    self.transactionMode = mode;
    self.completionBlock = completion;
    return self.pkPaymentAuthorizationViewController;
}

#pragma mark - Apple Pay setup methods

+ (bool)isApplePaySupported {
    return [PKPaymentAuthorizationController canMakePayments];
}

- (bool)isApplePaySetUp {
    return [PKPaymentAuthorizationController canMakePaymentsUsingNetworks:self.pkPaymentNetworks];
}

#pragma mark - PKPaymentAuthorizationViewController delegate methods

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion {

    if (self.transactionMode == JPTransactionModeServerToServer) {
        [self processServerToServer:self.completionBlock payment:payment];
        return;
    }

    JPTransactionType type = (self.transactionMode == JPTransactionModePreAuth) ? JPTransactionTypePreAuth : JPTransactionTypePayment;
    self.transactionService.transactionType = type;

    JPTransaction *transaction = [self.transactionService transactionWithConfiguration:self.configuration];

    NSError *error;
    [transaction setPkPayment:payment error:&error];

    if (error && self.completionBlock) {
        self.completionBlock(nil, [JPError judoJSONSerializationFailedWithError:error]);
        completion(PKPaymentAuthorizationStatusFailure);
        return;
    }

    __weak typeof(self) weakSelf = self;
    [transaction sendWithCompletion:^(JPResponse *response, NSError *error) {
        if (error || response.items.count == 0) {
            if (weakSelf.completionBlock)
                weakSelf.completionBlock(response, (JPError *)error);
            completion(PKPaymentAuthorizationStatusFailure);
            return;
        }

        if (weakSelf.configuration.applePayConfiguration.returnedContactInfo & JPReturnedInfoBillingContacts) {
            response.billingInfo = [weakSelf contactInformationFromPaymentContact:payment.billingContact];
        }

        if (weakSelf.configuration.applePayConfiguration.returnedContactInfo & JPReturnedInfoShippingContacts) {
            response.shippingInfo = [weakSelf contactInformationFromPaymentContact:payment.shippingContact];
        }

        if (weakSelf.completionBlock)
            weakSelf.completionBlock(response, (JPError *)error);
        completion(PKPaymentAuthorizationStatusSuccess);
    }];
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getters

- (PKPaymentAuthorizationViewController *)pkPaymentAuthorizationViewController {

    PKPaymentAuthorizationViewController *viewController;

    viewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:self.pkPaymentRequest];
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    viewController.delegate = self;

    return viewController;
}

- (PKPaymentRequest *)pkPaymentRequest {

    PKPaymentRequest *paymentRequest = [PKPaymentRequest new];

    paymentRequest.merchantIdentifier = self.configuration.applePayConfiguration.merchantId;
    paymentRequest.countryCode = self.configuration.applePayConfiguration.countryCode;
    paymentRequest.currencyCode = self.configuration.applePayConfiguration.currency;
    paymentRequest.supportedNetworks = self.pkPaymentNetworks;
    paymentRequest.merchantCapabilities = self.pkMerchantCapabilities;
    paymentRequest.shippingType = self.pkShippingType;
    paymentRequest.shippingMethods = self.pkShippingMethods;

    JPContactField requiredShippingContactFields = self.configuration.applePayConfiguration.requiredShippingContactFields;
    JPContactField requiredBillingContactFields = self.configuration.applePayConfiguration.requiredBillingContactFields;

    if (@available(iOS 11.0, *)) {

        NSSet<PKContactField> *pkShippingFields = [self pkContactFieldsFromFields:requiredShippingContactFields];
        NSSet<PKContactField> *pkBillingFields = [self pkContactFieldsFromFields:requiredBillingContactFields];

        paymentRequest.requiredShippingContactFields = pkShippingFields;
        paymentRequest.requiredBillingContactFields = pkBillingFields;

    } else {
        PKAddressField pkShippingFields = [self pkAddressFieldsFromFields:requiredShippingContactFields];
        PKAddressField pkBillingFields = [self pkAddressFieldsFromFields:requiredBillingContactFields];

        paymentRequest.requiredShippingAddressFields = pkShippingFields;
        paymentRequest.requiredBillingAddressFields = pkBillingFields;
    }

    paymentRequest.paymentSummaryItems = self.pkPaymentSummaryItems;

    return paymentRequest;
}

- (PKMerchantCapability)pkMerchantCapabilities {
    switch (self.configuration.applePayConfiguration.merchantCapabilities) {
        case JPMerchantCapability3DS:
            return PKMerchantCapability3DS;
        case JPMerchantCapabilityEMV:
            return PKMerchantCapabilityEMV;
        case JPMerchantCapabilityCredit:
            return PKMerchantCapabilityCredit;
        case JPMerchantCapabilityDebit:
            return PKMerchantCapabilityDebit;
    }
}

- (PKShippingType)pkShippingType {
    switch (self.configuration.applePayConfiguration.shippingType) {
        case JPShippingTypeShipping:
            return PKShippingTypeShipping;
        case JPShippingTypeDelivery:
            return PKShippingTypeDelivery;
        case JPShippingTypeStorePickup:
            return PKShippingTypeStorePickup;
        case JPShippingTypeServicePickup:
            return PKShippingTypeServicePickup;
    }
}

- (NSArray<PKShippingMethod *> *)pkShippingMethods {
    NSMutableArray *pkShippingMethods = [NSMutableArray new];

    for (PaymentShippingMethod *shippingMethod in self.configuration.applePayConfiguration.shippingMethods) {
        PKShippingMethod *pkShippingMethod = [PKShippingMethod new];
        pkShippingMethod.identifier = shippingMethod.identifier;
        pkShippingMethod.detail = shippingMethod.detail;
        pkShippingMethod.label = shippingMethod.label;
        pkShippingMethod.amount = shippingMethod.amount;
        pkShippingMethod.type = [self pkSummaryItemTypeFromType:shippingMethod.type];
        [pkShippingMethods addObject:pkShippingMethod];
    }

    return pkShippingMethods;
}

- (NSArray<PKPaymentSummaryItem *> *)pkPaymentSummaryItems {

    NSMutableArray<PKPaymentSummaryItem *> *pkPaymentSummaryItems = [NSMutableArray new];

    for (JPPaymentSummaryItem *item in self.configuration.applePayConfiguration.paymentSummaryItems) {
        PKPaymentSummaryItemType summaryItemType = [self pkSummaryItemTypeFromType:item.type];
        [pkPaymentSummaryItems addObject:[PKPaymentSummaryItem summaryItemWithLabel:item.label
                                                                             amount:item.amount
                                                                               type:summaryItemType]];
    }

    return pkPaymentSummaryItems;
}

- (NSArray<PKPaymentNetwork> *)pkPaymentNetworks {

    NSMutableArray<PKPaymentNetwork> *pkPaymentNetworks = [[NSMutableArray alloc] init];

    JPCardNetworkType cardNetworks = self.configuration.supportedCardNetworks;

    if (cardNetworks && JPCardNetworkTypeVisa) {
        [pkPaymentNetworks addObject:PKPaymentNetworkVisa];
    }

    if (cardNetworks & JPCardNetworkTypeAMEX) {
        [pkPaymentNetworks addObject:PKPaymentNetworkAmex];
    }

    if (cardNetworks & JPCardNetworkTypeMasterCard) {
        [pkPaymentNetworks addObject:PKPaymentNetworkMasterCard];
    }

    if (cardNetworks & JPCardNetworkTypeMaestro) {
        if (@available(iOS 12.0, *)) {
            [pkPaymentNetworks addObject:PKPaymentNetworkMaestro];
        }
    }

    if (cardNetworks & JPCardNetworkTypeJCB) {
        [pkPaymentNetworks addObject:PKPaymentNetworkJCB];
    }

    if (cardNetworks & JPCardNetworkTypeDiscover) {
        [pkPaymentNetworks addObject:PKPaymentNetworkDiscover];
    }

    if (cardNetworks & JPCardNetworkTypeChinaUnionPay) {
        [pkPaymentNetworks addObject:PKPaymentNetworkChinaUnionPay];
    }

    return pkPaymentNetworks;
}

- (NSSet<PKContactField> *)pkContactFieldsFromFields:(JPContactField)contactFields {

    NSMutableSet *pkContactFields = [NSMutableSet new];

    if (@available(iOS 11.0, *)) {

        if (contactFields & JPContactFieldPostalAddress) {
            [pkContactFields addObject:PKContactFieldPostalAddress];
        }

        if (contactFields & JPContactFieldPhone) {
            [pkContactFields addObject:PKContactFieldPhoneNumber];
        }

        if (contactFields & JPContactFieldEmail) {
            [pkContactFields addObject:PKContactFieldEmailAddress];
        }

        if (contactFields & JPContactFieldName) {
            [pkContactFields addObject:PKContactFieldName];
        }
    }

    return pkContactFields;
}

- (PKPaymentSummaryItemType)pkSummaryItemTypeFromType:(JPPaymentSummaryItemType)type {
    if (type == JPPaymentSummaryItemTypeFinal) {
        return PKPaymentSummaryItemTypeFinal;
    }

    return PKPaymentSummaryItemTypePending;
}

- (PKAddressField)pkAddressFieldsFromFields:(JPContactField)contactFields {
    return (PKAddressField)contactFields;
}

- (nullable JPContactInformation *)contactInformationFromPaymentContact:(nullable PKContact *)contact {

    if (!contact)
        return nil;

    JPPostalAddress *postalAddress = [[JPPostalAddress alloc] initWithSteet:contact.postalAddress.street
                                                                       city:contact.postalAddress.city
                                                                      state:contact.postalAddress.state
                                                                 postalCode:contact.postalAddress.postalCode
                                                                    country:contact.postalAddress.country
                                                                    isoCode:contact.postalAddress.ISOCountryCode
                                                      subAdministrativeArea:contact.postalAddress.subAdministrativeArea
                                                                sublocality:contact.postalAddress.subLocality];

    return [[JPContactInformation alloc] initWithEmailAddress:contact.emailAddress
                                                         name:contact.name
                                                  phoneNumber:contact.phoneNumber.stringValue
                                                postalAddress:postalAddress];
}

- (void)processServerToServer:(JPCompletionBlock)completion payment:(PKPayment *)payment {
    completion([self buildResponse:payment], nil);
}

- (JPResponse *)buildResponse:(PKPayment *)payment {
    JPResponse *response = [JPResponse new];

    JPTransactionData *data = [JPTransactionData new];
    data.judoId = self.configuration.judoId;
    data.paymentReference = self.configuration.reference.paymentReference;
    data.createdAt = [[JPFormatters.sharedInstance rfc3339DateFormatter] stringFromDate:NSDate.date];
    data.consumer = [JPConsumer new];
    data.consumer.consumerReference = self.configuration.reference.consumerReference;
    data.amount = self.configuration.amount;
    data.cardDetails = [JPCardDetails new];

    data.cardDetails.cardToken = payment.token.transactionIdentifier;
    data.cardDetails.cardScheme = payment.token.paymentMethod.network;
    response.items = @[ data ];
    return response;
}

@end
