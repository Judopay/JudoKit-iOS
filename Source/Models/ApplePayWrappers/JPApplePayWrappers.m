//
//  JPApplePayWrappers.m
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

#import "JPApplePayWrappers.h"
#import "JPApplePayConfiguration.h"
#import "JPApplePayTypes.h"
#import "JPConfiguration.h"

@implementation JPApplePayWrappers

+ (PKPaymentAuthorizationViewController *)pkPaymentControllerForConfiguration:(JPConfiguration *)configuration {

    PKPaymentAuthorizationViewController *viewController;

    PKPaymentRequest *request = [self pkPaymentRequestForConfiguration:configuration];
    viewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;

    return viewController;
}

+ (PKPaymentRequest *)pkPaymentRequestForConfiguration:(JPConfiguration *)configuration {
    JPApplePayConfiguration *applePayConfiguration = configuration.applePayConfiguration;
    PKPaymentRequest *paymentRequest = [PKPaymentRequest new];

    if (@available(iOS 16.0, *) && applePayConfiguration.recurringPaymentRequest != nil) {
        paymentRequest.recurringPaymentRequest = applePayConfiguration.recurringPaymentRequest.toPKRecurringPaymentRequest;
    }

    paymentRequest.merchantIdentifier = applePayConfiguration.merchantId;
    paymentRequest.countryCode = applePayConfiguration.countryCode;
    paymentRequest.currencyCode = applePayConfiguration.currency;
    paymentRequest.supportedNetworks = [self pkPaymentNetworksForConfiguration:configuration];
    paymentRequest.merchantCapabilities = [self pkMerchantCapabilitiesForConfiguration:configuration];
    paymentRequest.shippingType = [self pkShippingTypeForConfiguration:configuration];
    paymentRequest.shippingMethods = [self pkShippingMethodsForConfiguration:configuration];
    JPContactField requiredShippingContactFields = applePayConfiguration.requiredShippingContactFields;
    JPContactField requiredBillingContactFields = applePayConfiguration.requiredBillingContactFields;
    NSSet<PKContactField> *pkShippingFields = [self pkContactFieldsFromFields:requiredShippingContactFields];
    NSSet<PKContactField> *pkBillingFields = [self pkContactFieldsFromFields:requiredBillingContactFields];
    paymentRequest.requiredShippingContactFields = pkShippingFields;
    paymentRequest.requiredBillingContactFields = pkBillingFields;
    paymentRequest.paymentSummaryItems = [self pkPaymentSummaryItemsForConfiguration:configuration];

    return paymentRequest;
}

+ (PKMerchantCapability)pkMerchantCapabilitiesForConfiguration:(JPConfiguration *)configuration {
    switch (configuration.applePayConfiguration.merchantCapabilities) {
        case JPMerchantCapabilityThreeDS:
            return PKMerchantCapability3DS;
        case JPMerchantCapabilityEMV:
            return PKMerchantCapabilityEMV;
        case JPMerchantCapabilityCredit:
            return PKMerchantCapabilityCredit;
        case JPMerchantCapabilityDebit:
            return PKMerchantCapabilityDebit;
    }
}

+ (PKShippingType)pkShippingTypeForConfiguration:(JPConfiguration *)configuration {
    switch (configuration.applePayConfiguration.shippingType) {
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

+ (NSArray<PKShippingMethod *> *)pkShippingMethodsForConfiguration:(JPConfiguration *)configuration {
    NSMutableArray *pkShippingMethods = [NSMutableArray new];

    for (JPPaymentShippingMethod *shippingMethod in configuration.applePayConfiguration.shippingMethods) {
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

+ (NSArray<PKPaymentSummaryItem *> *)pkPaymentSummaryItemsForConfiguration:(JPConfiguration *)configuration {

    NSMutableArray<PKPaymentSummaryItem *> *pkPaymentSummaryItems = [NSMutableArray new];

    for (JPPaymentSummaryItem *item in configuration.applePayConfiguration.paymentSummaryItems) {
        PKPaymentSummaryItemType summaryItemType = [self pkSummaryItemTypeFromType:item.type];
        [pkPaymentSummaryItems addObject:[PKPaymentSummaryItem summaryItemWithLabel:item.label
                                                                             amount:item.amount
                                                                               type:summaryItemType]];
    }

    return pkPaymentSummaryItems;
}

+ (NSArray<PKPaymentNetwork> *)pkPaymentNetworksForConfiguration:(JPConfiguration *)configuration {

    NSMutableArray<PKPaymentNetwork> *pkPaymentNetworks = [NSMutableArray new];

    JPCardNetworkType cardNetworks = configuration.applePayConfiguration.supportedCardNetworks;

    if (cardNetworks & JPCardNetworkTypeVisa) {
        [pkPaymentNetworks addObject:PKPaymentNetworkVisa];
    }

    if (cardNetworks & JPCardNetworkTypeMasterCard) {
        [pkPaymentNetworks addObject:PKPaymentNetworkMasterCard];
    }

    if (cardNetworks & JPCardNetworkTypeAMEX) {
        [pkPaymentNetworks addObject:PKPaymentNetworkAmex];
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

+ (NSSet<PKContactField> *)pkContactFieldsFromFields:(JPContactField)contactFields {

    NSMutableSet *pkContactFields = [NSMutableSet new];

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

    return pkContactFields;
}

+ (PKPaymentSummaryItemType)pkSummaryItemTypeFromType:(JPPaymentSummaryItemType)type {
    if (type == JPPaymentSummaryItemTypeFinal) {
        return PKPaymentSummaryItemTypeFinal;
    }

    return PKPaymentSummaryItemTypePending;
}

@end
