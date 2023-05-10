//
//  JPCardValidationService.m
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

#import "JPCardValidationService.h"
#import "JPBillingCountry.h"
#import "JPCardNetwork.h"
#import "JPConstants.h"
#import "JPCountry.h"
#import "JPError+Additions.h"
#import "JPState.h"
#import "JPValidationResult.h"
#import "NSString+Additions.h"

@interface JPCardValidationService ()

@property (nonatomic, strong) JPValidationResult *lastExpiryDateValidationResult;
@property (nonatomic, assign) JPBillingCountry selectedAVSCountry;
@property (nonatomic, assign) JPBillingCountry selectedBillingCountry;

@end

@implementation JPCardValidationService

#pragma mark - Constants

static int const kCardHolderNameLength = 4;

#pragma mark - Public Methods

- (void)resetCardValidationResults {
    self.lastCardNumberValidationResult = nil;
    self.lastExpiryDateValidationResult = nil;
}

- (BOOL)isInputSupported:(NSString *)input
    forSupportedNetworks:(JPCardNetworkType)supportedCardNetworks {

    if (input._jp_cardNetwork == JPCardNetworkTypeUnknown && input.length == kMaxDefaultCardLength) {
        return NO;
    }

    if (supportedCardNetworks == JPCardNetworkTypeAll || input._jp_cardNetwork == JPCardNetworkTypeUnknown) {
        return YES;
    }

    return input._jp_cardNetwork & supportedCardNetworks;
}

- (JPValidationResult *)validateCardNumberInput:(NSString *)input
                           forSupportedNetworks:(JPCardNetworkType)networks {
    NSError *error;
    NSString *cardNumber = input._jp_stringByRemovingWhitespaces;
    NSString *cardNetworkPatern = [JPCardNetwork cardPatternForType:cardNumber._jp_cardNetwork];
    NSUInteger maxCardLength = [self maxCardLength:cardNumber._jp_cardNetwork];

    if (cardNumber.length > maxCardLength) {
        cardNumber = [cardNumber substringToIndex:maxCardLength];
    }

    if (cardNumber.length < maxCardLength || !cardNumber._jp_isValidCardNumber) {
        error = JPError.invalidCardNumberError;
    }

    if (![self isInputSupported:cardNumber forSupportedNetworks:networks]) {
        error = [JPError unsupportedCardNetwork:input._jp_cardNetwork];
    }

    cardNumber = [cardNumber _jp_formatWithPattern:cardNetworkPatern];

    BOOL isInputAllowed = [input _jp_stringByRemovingWhitespaces].length <= maxCardLength;

    BOOL isValid = YES;
    NSString *errorMessage;

    if (error) {
        isValid = NO;
        errorMessage = error.localizedDescription;
    }

    self.lastCardNumberValidationResult = [JPValidationResult validationWithResult:isValid
                                                                      inputAllowed:isInputAllowed
                                                                      errorMessage:errorMessage
                                                                    formattedInput:cardNumber];

    self.lastCardNumberValidationResult.cardNetwork = cardNumber._jp_cardNetwork;
    return self.lastCardNumberValidationResult;
}

- (JPValidationResult *)validateCardholderNameInput:(NSString *)input {

    NSString *errorMessage;
    BOOL isValid = YES;

    if (input.length == 0) {
        errorMessage = @"card_holder_name_required"._jp_localized;
        isValid = NO;
    } else if (input.length < kCardHolderNameLength) {
        errorMessage = @"card_holder_name_too_short"._jp_localized;
        isValid = NO;
    } else if (!input._jp_isValidCardholderName) {
        errorMessage = @"card_holder_name_special_chars"._jp_localized;
        isValid = NO;
    }

    return [JPValidationResult validationWithResult:isValid
                                       inputAllowed:YES
                                       errorMessage:errorMessage
                                     formattedInput:input];
}

- (JPValidationResult *)validateExpiryDateInput:(NSString *)input {

    if (input.length == 0) {
        return [self validateNoExpiryDigitInput:input];
    }

    if (input.length == 1) {
        return [self validateFirstExpiryDigitInput:input];
    }

    if (input.length == 2) {
        return [self validateSecondExpiryDigitInput:input];
    }

    if (input.length == 3) {
        return [self validateThirdExpiryDigitInput:input];
    }

    if (input.length == 4) {
        return [self validateFourthExpiryDigitInput:input];
    }

    if (input.length == 5) {
        return [self validateFifthExpiryDigitInput:input];
    }

    return [JPValidationResult validationWithResult:YES
                                       inputAllowed:NO
                                       errorMessage:@"check_expiry_date"._jp_localized
                                     formattedInput:input];
}

- (JPValidationResult *)validateSecureCodeInput:(NSString *)input trimIfTooLong:(BOOL)trim {
    JPCardNetworkType cardNetwork = self.lastCardNumberValidationResult.cardNetwork;
    NSUInteger securityCodeLength = [JPCardNetwork secureCodeLengthForNetworkType:cardNetwork];
    NSString *formatedInput = input;
    if (trim) {
        formatedInput = [input substringToIndex:MIN(input.length, securityCodeLength)];
    }

    BOOL isValid = formatedInput.length == securityCodeLength;
    BOOL isInputAllowed = formatedInput.length <= securityCodeLength;
    NSString *errorMessage;

    if (!isValid) {
        NSString *securityCode = [JPCardNetwork secureCodePlaceholderForNetworkType:cardNetwork];
        NSString *format = @"check_security_code"._jp_localized;
        errorMessage = [NSString stringWithFormat:format, securityCode];
    }

    return [JPValidationResult validationWithResult:isValid
                                       inputAllowed:isInputAllowed
                                       errorMessage:errorMessage
                                     formattedInput:formatedInput];
}

- (JPValidationResult *)validateCountryInput:(NSString *)input {
    self.selectedAVSCountry = [self billingCountryWithName:input];

    return [JPValidationResult validationWithResult:YES
                                       inputAllowed:YES
                                       errorMessage:nil
                                     formattedInput:input];
}

- (JPValidationResult *)validatePostalCodeInput:(NSString *)input {
    return [self validatePostalCodeInput:input country:self.selectedAVSCountry];
}

#pragma mark - Billing Information

- (JPValidationResult *)validateBillingEmailInput:(NSString *)input {
    BOOL isValid = input._jp_isEmail;
    return [JPValidationResult validationWithResult:isValid
                                       inputAllowed:YES
                                       errorMessage:isValid ? nil : @"invalid_email_address"._jp_localized
                                     formattedInput:input];
}

- (JPValidationResult *)validateBillingStateInput:(NSString *)input {
    if (self.selectedBillingCountry == JPBillingCountryUSA) {
        BOOL isValid = [JPState forStateName:input andCountryCode:kAlpha2CodeUSA];
        NSString *errorMessage = isValid ? nil : @"invalid_state_should_not_be_empty"._jp_localized;
        return [JPValidationResult validationWithResult:isValid
                                           inputAllowed:YES
                                           errorMessage:errorMessage
                                         formattedInput:input];
    }

    if (self.selectedBillingCountry == JPBillingCountryCanada) {
        BOOL isValid = [JPState forStateName:input andCountryCode:kAlpha2CodeCanada];
        NSString *errorMessage = isValid ? nil : @"invalid_province_territory_should_not_be_empty"._jp_localized;
        return [JPValidationResult validationWithResult:isValid
                                           inputAllowed:YES
                                           errorMessage:errorMessage
                                         formattedInput:input];
    }

    return [JPValidationResult validationWithResult:YES
                                       inputAllowed:NO
                                       errorMessage:nil
                                     formattedInput:input];
}

- (JPValidationResult *)validateBillingCountryInput:(NSString *)input {
    self.selectedBillingCountry = [self billingCountryWithName:input];

    return [JPValidationResult validationWithResult:YES
                                       inputAllowed:YES
                                       errorMessage:nil
                                     formattedInput:input];
}

- (JPValidationResult *)validateBillingPhoneCodeInput:(NSString *)input {
    BOOL isValid = input._jp_isPhoneCode;
    return [JPValidationResult validationWithResult:isValid
                                       inputAllowed:YES
                                       errorMessage:isValid ? nil : @"invalid_phone_code_value"._jp_localized
                                     formattedInput:input];
}

- (JPValidationResult *)validateBillingPhoneInput:(NSString *)input {
    BOOL isValid = input._jp_isPhoneNumber;
    return [JPValidationResult validationWithResult:isValid
                                       inputAllowed:YES
                                       errorMessage:isValid ? nil : @"invalid_mobile_number"._jp_localized
                                     formattedInput:input];
}

- (JPValidationResult *)validateBillingAddressLineInput:(NSString *)input {
    BOOL isValid = input._jp_isValidAddressLine;
    NSString *errorMessage = isValid ? nil : @"invalid_address"._jp_localized;

    return [JPValidationResult validationWithResult:isValid
                                       inputAllowed:YES
                                       errorMessage:errorMessage
                                     formattedInput:input];
}

- (JPValidationResult *)validateBillingCityInput:(NSString *)input {
    BOOL isValid = input._jp_isValidCity;
    NSString *errorMessage = isValid ? nil : @"invalid_city"._jp_localized;

    return [JPValidationResult validationWithResult:isValid
                                       inputAllowed:YES
                                       errorMessage:errorMessage
                                     formattedInput:input];
}

- (JPValidationResult *)validateBillingPostalCodeInput:(NSString *)input {
    return [self validatePostalCodeInput:input country:self.selectedBillingCountry];
}

#pragma mark - Expiry Date Validation Methods

- (JPValidationResult *)validateNoExpiryDigitInput:(NSString *)input {
    self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                      inputAllowed:YES
                                                                      errorMessage:nil
                                                                    formattedInput:input];
    return self.lastExpiryDateValidationResult;
}

- (JPValidationResult *)validateFirstExpiryDigitInput:(NSString *)input {

    BOOL isValidInput = ([input isEqualToString:@"0"] || [input isEqualToString:@"1"]);
    NSString *errorMessage = isValidInput ? nil : @"check_expiry_date"._jp_localized;

    self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                      inputAllowed:YES
                                                                      errorMessage:errorMessage
                                                                    formattedInput:input];
    return self.lastExpiryDateValidationResult;
}

- (JPValidationResult *)validateSecondExpiryDigitInput:(NSString *)input {

    if ([self shouldRejectInput:input]) {
        return self.lastExpiryDateValidationResult;
    }

    if (input.length < self.lastExpiryDateValidationResult.formattedInput.length) {
        NSString *formattedInput = [input substringToIndex:input.length - 1];
        self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                          inputAllowed:YES
                                                                          errorMessage:nil
                                                                        formattedInput:formattedInput];
        return self.lastExpiryDateValidationResult;
    }

    BOOL isValidInput = (input.intValue > 0 && input.intValue <= 12);

    NSString *formattedInput = [NSString stringWithFormat:@"%@/", input];
    NSString *errorMessage = isValidInput ? nil : @"check_expiry_date"._jp_localized;
    self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                      inputAllowed:YES
                                                                      errorMessage:errorMessage
                                                                    formattedInput:isValidInput ? formattedInput : input];
    return self.lastExpiryDateValidationResult;
}

- (JPValidationResult *)validateThirdExpiryDigitInput:(NSString *)input {

    if ([self shouldRejectInput:input]) {
        return self.lastExpiryDateValidationResult;
    }

    self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                      inputAllowed:YES
                                                                      errorMessage:nil
                                                                    formattedInput:input];
    return self.lastExpiryDateValidationResult;
}

- (JPValidationResult *)validateFourthExpiryDigitInput:(NSString *)input {

    if ([self shouldRejectInput:input]) {
        return self.lastExpiryDateValidationResult;
    }

    NSString *lastDigitString = [input substringFromIndex:input.length - 1];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    int yearFirstDigit = [yearString substringToIndex:1].intValue;

    BOOL isValid = lastDigitString.intValue >= yearFirstDigit && lastDigitString.intValue < yearFirstDigit + 2;
    NSString *errorMessage = isValid ? nil : @"check_expiry_date"._jp_localized;

    self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                      inputAllowed:YES
                                                                      errorMessage:errorMessage
                                                                    formattedInput:input];
    return self.lastExpiryDateValidationResult;
}

- (JPValidationResult *)validateFifthExpiryDigitInput:(NSString *)input {

    if ([self shouldRejectInput:input]) {
        return self.lastExpiryDateValidationResult;
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kMonthYearDateFormat];
    NSString *currentDate = [formatter stringFromDate:NSDate.date];

    NSArray<NSString *> *currentDateComponents = [currentDate componentsSeparatedByString:@"/"];
    NSArray<NSString *> *inputDateComponents = [input componentsSeparatedByString:@"/"];

    int currentMonth = 0;
    int currentYear = 0;
    int inputMonth = 0;
    int inputYear = 0;

    if (currentDateComponents.count == 2) {
        currentMonth = currentDateComponents.firstObject.intValue;
        currentYear = currentDateComponents.lastObject.intValue;
    }

    if (inputDateComponents.count == 2) {
        inputMonth = inputDateComponents.firstObject.intValue;
        inputYear = inputDateComponents.lastObject.intValue;
    }

    if (inputYear < currentYear) {
        self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                          inputAllowed:YES
                                                                          errorMessage:@"check_expiry_date"._jp_localized
                                                                        formattedInput:input];
        return self.lastExpiryDateValidationResult;
    }

    if (inputYear == currentYear && inputMonth < currentMonth) {
        self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                          inputAllowed:YES
                                                                          errorMessage:@"check_expiry_date"._jp_localized
                                                                        formattedInput:input];
        return self.lastExpiryDateValidationResult;
    }

    self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:YES
                                                                      inputAllowed:YES
                                                                      errorMessage:nil
                                                                    formattedInput:input];
    return self.lastExpiryDateValidationResult;
}

- (JPValidationResult *)validatePostalCodeInput:(NSString *)input country:(JPBillingCountry)country {
    BOOL isValid = NO;
    NSUInteger maxLength = [self postCodeMaxLengthForCountry:country];
    NSUInteger minLength = [self postCodeMinLengthForCountry:country];
    NSString *errorString = [self postCodeErrorForCountry:country];

    NSString *postCode = input.uppercaseString;
    NSString *pattern;

    switch (country) {
        case JPBillingCountryCanada:
            pattern = kRegExCAPostCode;
            break;
        case JPBillingCountryUK:
            pattern = kRegExGBPostCode;
            break;
        case JPBillingCountryUSA:
            pattern = kRegExUSPostCode;
            break;
        case JPBillingCountryOther:
            pattern = kRegExOtherPostCode;
            break;
        default:
            break;
    }

    if (pattern) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", pattern];
        isValid = postCode.length >= minLength && postCode.length <= maxLength && [predicate evaluateWithObject:postCode];
    }

    NSString *errorMessage = isValid ? nil : errorString;

    return [JPValidationResult validationWithResult:isValid
                                       inputAllowed:postCode.length <= maxLength
                                       errorMessage:errorMessage
                                     formattedInput:postCode];
}

#pragma mark - Helper methods

- (BOOL)shouldRejectInput:(NSString *)input {
    BOOL isErrorPresent = self.lastExpiryDateValidationResult.errorMessage != nil;
    BOOL isAddingCharacter = input.length > self.lastExpiryDateValidationResult.formattedInput.length;
    return isErrorPresent && isAddingCharacter;
}

- (JPBillingCountry)billingCountryWithName:(NSString *)name {
    JPCountry *country = [JPCountry forCountryName:name];
    
    if (country) {
        return country.toBillingCountry;
    }
    
    return JPBillingCountryOther;
}

- (NSString *)postCodeErrorForCountry:(JPBillingCountry)country {
    if (country == JPBillingCountryUSA) {
        return @"invalid_zip_code"._jp_localized;
    }
    return @"invalid_postcode"._jp_localized;
}

- (NSUInteger)postCodeMaxLengthForCountry:(JPBillingCountry)country {
    switch (country) {
        case JPBillingCountryCanada:
            return kCanadaPostalCodeMaxLength;
        case JPBillingCountryUK:
            return kUKPostalCodeMaxLength;
        case JPBillingCountryUSA:
            return kUSAPostalCodeMaxLength;
        case JPBillingCountryOther:
            return kOtherPostalCodeMaxLength;
        default:
            break;
    }
}

- (NSUInteger)postCodeMinLengthForCountry:(JPBillingCountry)country {
    switch (country) {
        case JPBillingCountryCanada:
            return kCanadaPostalCodeMinLength;
        case JPBillingCountryUK:
            return kUKPostalCodeMinLength;
        case JPBillingCountryUSA:
            return kUSAPostalCodeMinLength;
        case JPBillingCountryOther:
            return kOtherPostalCodeMinLength;
        default:
            break;
    }
}

- (NSUInteger)maxCardLength:(JPCardNetworkType)cardNetwork {
    switch (cardNetwork) {
        case JPCardNetworkTypeAMEX:
            return kMaxAMEXCardLength;
        case JPCardNetworkTypeDinersClub:
            return kMaxDinersClubCardLength;
        default:
            return kMaxDefaultCardLength;
    }
}

@end
