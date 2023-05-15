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

let kIsAddressOnKey = "is_address_enabled"
let kIsPrimaryAccountDetailsOnKey = "is_primary_account_details_enabled"

let kAddressLine1Key = "address_line_1"
let kAddressLine2Key = "address_line_2"
let kAddressLine3Key = "address_line_3"
let kAddressTownKey = "address_town"
let kAddressPostCodeKey = "address_post_code"
let kAddressCountryCodeKey = "address_country_code"
let kAddressStateKey = "address_state"
let kAddressPhoneCountryCodeKey = "address_phone_country_code"
let kAddressMobileNumberKey = "address_mobile_number"
let kAddressEmailAddressKey = "address_email_address"

let kPrimaryAccountNameKey = "primary_account_name"
let kPrimaryAccountAccountNumberKey = "primary_account_account_number"
let kPrimaryAccountDateOfBirthKey = "primary_account_date_of_birth"
let kPrimaryAccountPostCodeKey = "primary_account_post_code"

// MARK: - 3DS 2.0 section keys

let kShouldAskForBillingInformationKey = "should_ask_for_billing_information"
let kChallengeRequestIndicatorKey = "challenge_request_indicator"
let kScaExemptionKey = "sca_exemption"
let kThreeDsTwoMaxTimeoutKey = "three_ds_two_max_timeout"
let kConnectTimeoutKey = "connect_timeout"
let kReadTimeoutKey = "read_timeout"
let kWriteTimeoutKey = "write_timeout"
let kThreeDSTwoMessageVersionKey = "three_ds_two_message_version"

let kIsThreeDSUICustomisationEnabledKey = "three_ds_is_ui_customisation_enabled"

let kThreeDSToolbarTextFontNameKey = "three_ds_toolbar_text_font_name"
let kThreeDSToolbarTextColorKey = "three_ds_toolbar_text_color"
let kThreeDSToolbarTextFontSizeKey = "three_ds_toolbar_text_font_size"
let kThreeDSToolbarBackgroundColorKey = "three_ds_toolbar_background_color"
let kThreeDSToolbarHeaderTextKey = "three_ds_toolbar_header_text"
let kThreeDSToolbarButtonTextKey = "three_ds_toolbar_button_text"

let kThreeDSLabelTextFontNameKey = "three_ds_label_text_font_name"
let kThreeDSLabelTextColorKey = "three_ds_label_text_color"
let kThreeDSLabelTextFontSizeKey = "three_ds_label_text_font_size"
let kThreeDSLabelHeadingTextFontNameKey = "three_ds_label_heading_text_font_name"
let kThreeDSLabelHeadingTextColorKey = "three_ds_label_heading_text_color"
let kThreeDSLabelHeadingTextFontSizeKey = "three_ds_label_heading_text_font_size"

let kThreeDSTextBoxTextFontNameKey = "three_ds_text_box_text_font_name"
let kThreeDSTextBoxTextColorKey = "three_ds_text_box_text_color"
let kThreeDSTextBoxTextFontSizeKey = "three_ds_text_box_text_font_size"
let kThreeDSTextBoxBorderWidthKey = "three_ds_text_box_border_width"
let kThreeDSTextBoxBorderColorKey = "three_ds_text_box_border_color"
let kThreeDSTextBoxCornerRadiusKey = "three_ds_text_box_corner_radius"

let kThreeDSSubmitButtonTextFontNameKey = "three_ds_submit_button_text_font_name"
let kThreeDSSubmitButtonTextColorKey = "three_ds_submit_button_text_color"
let kThreeDSSubmitButtonTextFontSizeKey = "three_ds_submit_button_text_font_size"
let kThreeDSSubmitButtonBackgroundColorKey = "three_ds_submit_button_background_color"
let kThreeDSSubmitButtonCornerRadiusKey = "three_ds_submit_button_corner_radius"

let kThreeDSNextButtonTextFontNameKey = "three_ds_next_button_text_font_name"
let kThreeDSNextButtonTextColorKey = "three_ds_next_button_text_color"
let kThreeDSNextButtonTextFontSizeKey = "three_ds_next_button_text_font_size"
let kThreeDSNextButtonBackgroundColorKey = "three_ds_next_button_background_color"
let kThreeDSNextButtonCornerRadiusKey = "three_ds_next_button_corner_radius"

let kThreeDSContinueButtonTextFontNameKey = "three_ds_continue_button_text_font_name"
let kThreeDSContinueButtonTextColorKey = "three_ds_continue_button_text_color"
let kThreeDSContinueButtonTextFontSizeKey = "three_ds_continue_button_text_font_size"
let kThreeDSContinueButtonBackgroundColorKey = "three_ds_continue_button_background_color"
let kThreeDSContinueButtonCornerRadiusKey = "three_ds_continue_button_corner_radius"

let kThreeDSCancelButtonTextFontNameKey = "three_ds_cancel_button_text_font_name"
let kThreeDSCancelButtonTextColorKey = "three_ds_cancel_button_text_color"
let kThreeDSCancelButtonTextFontSizeKey = "three_ds_cancel_button_text_font_size"
let kThreeDSCancelButtonBackgroundColorKey = "three_ds_cancel_button_background_color"
let kThreeDSCancelButtonCornerRadiusKey = "three_ds_cancel_button_corner_radius"

let kThreeDSResendButtonTextFontNameKey = "three_ds_resend_button_text_font_name"
let kThreeDSResendButtonTextColorKey = "three_ds_resend_button_text_color"
let kThreeDSResendButtonTextFontSizeKey = "three_ds_resend_button_text_font_size"
let kThreeDSResendButtonBackgroundColorKey = "three_ds_resend_button_background_color"
let kThreeDSResendButtonCornerRadiusKey = "three_ds_resend_button_corner_radius"

// MARK: - Reference section keys

let kPaymentReferenceKey = "payment_reference"
let kConsumerReferenceKey = "consumer_reference"

// MARK: - Amount section keys

let kAmountKey = "amount"
let kCurrencyKey = "currency"

// MARK: - Apple Pay section keys

let kMerchantIdKey = "apple_pay_merchant_id"

let kIsApplePayBillingContactInfoRequired = "is_apple_pay_billing_contact_info_required"
let kIsApplePayShippingContactInfoRequired = "is_apple_pay_shipping_contact_info_required"

let kIsBillingContactFieldPostalAddressRequiredKey = "is_billing_contact_field_postal_address_required"
let kIsBillingContactFieldPhoneRequiredKey = "is_billing_contact_field_phone_required"
let kIsBillingContactFieldEmailRequiredKey = "is_billing_contact_field_email_required"
let kIsBillingContactFieldNameRequiredKey = "is_billing_contact_field_name_required"

let kIsShippingContactFieldPostalAddressRequiredKey = "is_shipping_contact_field_postal_address_required"
let kIsShippingContactFieldPhoneRequiredKey = "is_shipping_contact_field_phone_required"
let kIsShippingContactFieldEmailRequiredKey = "is_shipping_contact_field_email_required"
let kIsShippingContactFieldNameRequiredKey = "is_shipping_contact_field_name_required"

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
let kIsInitialRecurringPaymentKey = "is_initial_recurring_payment"
let kIsDelayedAuthorisationOnKey = "is_delayed_authorisation_on"
let kShouldAskForCSCKey = "should_ask_for_csc"
let kShouldAskForCardholderNameKey = "should_ask_for_cardholder_name"
