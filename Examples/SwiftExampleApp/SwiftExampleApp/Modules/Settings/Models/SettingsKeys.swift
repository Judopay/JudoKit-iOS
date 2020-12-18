//
//  SettingsKeys.swift
//  SwiftExampleApp
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

import Foundation

// MARK: - API credentials section keys

let kSandboxedKey = "is_sandboxed"
let kJudoIdKey = "judo_id"

// MARK: - Authorization section keys

let kIsTokenAndSecretOnKey = "is_token_and_secret_on"
let kIsPaymentSessionOnKey = "is_payment_session_on"

let kTokenKey = "token"
let kSecretKey = "secret"

let kSessionTokenKey = "session_token"
let kPaymentSessionKey = "payment_session"

// MARK: - Reference section keys
let kPaymentReferenceKey = "payment_reference"
let kConsumerReferenceKey = "consumer_reference"

// MARK: - Amount section keys

let kAmountKey = "amount"
let kCurrencyKey = "currency"

// MARK: - Apple Pay section keys

let kMerchantIdKey = "apple_pay_merchant_id"

// MARK: - Supported card networks section keys

let kVisaEnabledKey = "is_card_network_visa_enabled"
let kMasterCardEnabledKey = "is_card_network_master_card_enabled"
let kMaestroEnabledKey = "is_card_network_maestro_enabled"
let kAMEXEnabledKey = "is_card_network_amex_enabled"
let kChinaUnionPayEnabledKey = "is_card_network_china_union_pay_enabled"
let kJCBEnabledKey = "is_card_network_jcb_enabled"
let kDiscoverEnabledKey = "is_card_network_discover_enabled"
let kDinersClubEnabledKey = "is_card_network_diners_club_enabled"
let kPbbaPaymentMethodEnabledKey = "is_payment_method_pbba_enabled"

// MARK: - Payment methods section keys

let kCardPaymentMethodEnabledKey = "is_payment_method_card_enabled"
let kiDEALPaymentMethodEnabledKey = "is_payment_method_ideal_enabled"
let kApplePayPaymentMethodEnabledKey = "is_payment_method_apple_pay_enabled"

// MARK: - Others section keys

let kAVSEnabledKey = "is_avs_enabled"
let kShouldPaymentMethodsDisplayAmount = "should_payment_methods_display_amount"
let kShouldPaymentButtonDisplayAmount = "should_payment_button_display_amount"
let kShouldPaymentMethodsVerifySecurityCode = "should_ask_security_code"
