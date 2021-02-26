//
//  JPApplePayTypes.h
//  JudoKit_iOS
//
//  Copyright (c) 2020 Alternative Payments Ltd
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

#import <Foundation/Foundation.h>

/**
 * Lists the available merchant capabilities.
 * Default is MerchantCapability3DS.
 */
typedef NS_ENUM(NSUInteger, JPMerchantCapability) {
    JPMerchantCapabilityThreeDS,
    JPMerchantCapabilityEMV,
    JPMerchantCapabilityCredit,
    JPMerchantCapabilityDebit
};

/**
 * Lists the available payment summary item types.
 * Default is JPPaymentSummaryItemTypeFinal.
 */
typedef NS_ENUM(NSUInteger, JPPaymentSummaryItemType) {
    JPPaymentSummaryItemTypeFinal,
    JPPaymentSummaryItemTypePending
};

/**
 * Lists the available payment shipping types.
 * Default is ShippingTypeShipping.
 */
typedef NS_ENUM(NSUInteger, JPPaymentShippingType) {
    JPShippingTypeShipping,
    JPShippingTypeDelivery,
    JPShippingTypeStorePickup,
    JPShippingTypeServicePickup
};

/**
 * Lists the available contact fields required for ApplePay
 */
typedef NS_OPTIONS(NSUInteger, JPContactField) {
    JPContactFieldNone = 0,
    JPContactFieldPostalAddress = 1 << 0,
    JPContactFieldPhone = 1 << 1,
    JPContactFieldEmail = 1 << 2,
    JPContactFieldName = 1 << 3,
    JPContactFieldAll = (JPContactFieldPostalAddress | JPContactFieldPhone | JPContactFieldEmail | JPContactFieldName)
};

/**
 * Lists the available options for the returned contact info after the transaction.
 * Default is ReturnedInfoBillingContacts.
 */
typedef NS_OPTIONS(NSUInteger, JPReturnedInfo) {
    JPReturnedInfoNone = 0,
    JPReturnedInfoBillingContacts = 1 << 0,
    JPReturnedInfoShippingContacts = 1 << 1,
    JPReturnedInfoAll = (JPReturnedInfoBillingContacts | JPReturnedInfoShippingContacts)
};
