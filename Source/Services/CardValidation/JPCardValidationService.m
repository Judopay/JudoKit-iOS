//
//  JPCardValidationService.m
//  JudoKitObjC
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
#import "JPValidationResult.h"
#import "NSError+Additions.h"
#import "NSString+Additions.h"

@interface JPCardValidationService ()

@property (nonatomic, strong) JPValidationResult *lastCardNumberValidationResult;
@property (nonatomic, strong) JPValidationResult *lastExpiryDateValidationResult;
@property (nonatomic, strong) JPValidationResult *lastPostalCodeValidationResult;
@property (nonatomic, strong) NSString *selectedJPBillingCountry;
@end

@implementation JPCardValidationService

#pragma mark - Constants

static int *const kCardNetworkAMEXLength = 15;
static int *const kCardLength = 16;
static int *const kCardHolderNameLength = 3;
static int *const kUKPostalCodeLength = 8;
static int *const kUSAPostalCodeLength = 5;
static int *const kCanadaPostalCodeLength = 7;
static int *const kOtherPostalCodeLength = 8;

#pragma mark - Public Methods

- (void)resetCardValidationResults {
    self.lastCardNumberValidationResult = nil;
    self.lastExpiryDateValidationResult = nil;
    self.lastPostalCodeValidationResult = nil;
}

- (BOOL)isInputSupported:(NSString *)input
    forSupportedNetworks:(CardNetwork)supportedCardNetworks {

    if (input.cardNetwork == CardNetworkUnknown && input.length == 16) {
        return NO;
    }

    if (supportedCardNetworks == CardNetworksAll || input.cardNetwork == CardNetworkUnknown) {
        return YES;
    }

    return input.cardNetwork & supportedCardNetworks;
}

- (JPValidationResult *)validateCardNumberInput:(NSString *)input
                           forSupportedNetworks:(CardNetwork)networks {

    NSError *error;
    NSString *presentationString = [input cardPresentationStringWithAcceptedNetworks:self.acceptedCardNetworks
                                                                               error:&error];

    NSString *trimmedString = [input stringByReplacingOccurrencesOfString:@" "
                                                               withString:@""];

    BOOL isErrorPresent = self.lastCardNumberValidationResult.errorMessage != nil;
    BOOL isAddingCharacter = input.length > self.lastCardNumberValidationResult.formattedInput.length;

    if (isErrorPresent && isAddingCharacter) {
        return self.lastCardNumberValidationResult;
    }

    if (![self isInputSupported:input forSupportedNetworks:networks]) {
        error = [NSError judoUnsupportedCardNetwork:input.cardNetwork];
        self.lastCardNumberValidationResult = [JPValidationResult validationWithResult:NO
                                                                          inputAllowed:YES
                                                                          errorMessage:error.localizedDescription
                                                                        formattedInput:presentationString];
        self.lastCardNumberValidationResult.cardNetwork = input.cardNetwork;
        return self.lastCardNumberValidationResult;
    }

    if (input.cardNetwork == CardNetworkAMEX) {
        if (trimmedString.length > kCardNetworkAMEXLength) {
            return self.lastCardNumberValidationResult;
        }
    }

    if (trimmedString.length > kCardLength) {
        return self.lastCardNumberValidationResult;
    }

    if ([input isCardNumberValid]) {
        self.lastCardNumberValidationResult = [JPValidationResult validationWithResult:YES
                                                                          inputAllowed:YES
                                                                          errorMessage:nil
                                                                        formattedInput:presentationString];

        self.lastCardNumberValidationResult.cardNetwork = input.cardNetwork;
        return self.lastCardNumberValidationResult;
    }

    if (input.cardNetwork == CardNetworkAMEX) {
        if (trimmedString.length == kCardNetworkAMEXLength) {
            error = NSError.judoInvalidCardNumberError;
        }
    }

    if (trimmedString.length == kCardLength) {
        error = NSError.judoInvalidCardNumberError;
    }

    self.lastCardNumberValidationResult = [JPValidationResult validationWithResult:NO
                                                                      inputAllowed:(presentationString != nil)
                                                                      errorMessage:error.localizedDescription
                                                                    formattedInput:presentationString];

    self.lastCardNumberValidationResult.cardNetwork = input.cardNetwork;
    return self.lastCardNumberValidationResult;
}

- (JPValidationResult *)validateCarholderNameInput:(NSString *)input {
    return [JPValidationResult validationWithResult:input.length > kCardHolderNameLength
                                       inputAllowed:YES
                                       errorMessage:nil
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
                                       errorMessage:nil
                                     formattedInput:input];
}

- (JPValidationResult *)validateSecureCodeInput:(NSString *)input {
    NSUInteger securityCodeLength = [JPCardNetwork secureCodeLengthForNetworkType:self.lastCardNumberValidationResult.cardNetwork];
    NSString *formatedInput = [input substringToIndex:MIN(input.length, securityCodeLength)];
    
    return [JPValidationResult validationWithResult:formatedInput.length == securityCodeLength
                                       inputAllowed:formatedInput.length <= securityCodeLength
                                       errorMessage:nil
                                     formattedInput:formatedInput];
}

- (JPValidationResult *)validateCountryInput:(NSString *)input {
    self.selectedJPBillingCountry = input;
    return [JPValidationResult validationWithResult:YES
                                       inputAllowed:YES
                                       errorMessage:nil
                                     formattedInput:input];
}

- (JPValidationResult *)validatePostalCodeInput:(NSString *)input {

    if ([self.selectedJPBillingCountry isEqualToString:@"country_usa".localized]) {
        return [self validateUSAPostalCodeInput:input];
    }

    if ([self.selectedJPBillingCountry isEqualToString:@"country_uk".localized]) {
        return [self validateUKPostalCodeInput:input];
    }

    if ([self.selectedJPBillingCountry isEqualToString:@"country_canada".localized]) {
        return [self validateCanadaPostalCodeInput:input];
    }

    if ([self.selectedJPBillingCountry isEqualToString:@"country_other".localized]) {
        return [self validateOtherPostalCodeInput:input];
    }

    return [JPValidationResult validationWithResult:NO
                                       inputAllowed:NO
                                       errorMessage:nil
                                     formattedInput:input];
}

#pragma mark - Getters

- (NSArray *)acceptedCardNetworks {
    return @[
        @(CardNetworkVisa),
        @(CardNetworkAMEX),
        @(CardNetworkMasterCard),
        @(CardNetworkMaestro),
        @(CardNetworkDiscover),
        @(CardNetworkJCB),
        @(CardNetworkDinersClub),
        @(CardNetworkChinaUnionPay),
    ];
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
    NSString *errorMessage = isValidInput ? nil : @"invalid_expiry_date_value".localized;

    self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                      inputAllowed:YES
                                                                      errorMessage:errorMessage
                                                                    formattedInput:input];
    return self.lastExpiryDateValidationResult;
}

- (BOOL)shouldRejectInput:(NSString *)input {
    BOOL isErrorPresent = self.lastExpiryDateValidationResult.errorMessage != nil;
    BOOL isAddingCharacter = input.length > self.lastExpiryDateValidationResult.formattedInput.length;
    return isErrorPresent && isAddingCharacter;
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
    NSString *errorMessage = isValidInput ? nil : @"invalid_expiry_date_value".localized;
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
    NSString *errorMessage = isValid ? nil : @"invalid_expiry_date_value".localized;

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

    int currentMonth = currentDateComponents[0].intValue;
    int currentYear = currentDateComponents[1].intValue;

    int inputMonth = inputDateComponents[0].intValue;
    int inputYear = inputDateComponents[1].intValue;

    if (inputYear < currentYear) {
        self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                          inputAllowed:YES
                                                                          errorMessage:@"check_expiry_date".localized
                                                                        formattedInput:input];
        return self.lastExpiryDateValidationResult;
    }

    if (inputYear == currentYear && inputMonth < currentMonth) {
        self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:NO
                                                                          inputAllowed:YES
                                                                          errorMessage:@"check_expiry_date".localized
                                                                        formattedInput:input];
        return self.lastExpiryDateValidationResult;
    }

    self.lastExpiryDateValidationResult = [JPValidationResult validationWithResult:YES
                                                                      inputAllowed:YES
                                                                      errorMessage:nil
                                                                    formattedInput:input];
    return self.lastExpiryDateValidationResult;
}

- (JPValidationResult *)validateUKPostalCodeInput:(NSString *)input {

    if (input.length > kUKPostalCodeLength) {
        return self.lastPostalCodeValidationResult;
    }

    NSString *const kUKRegexString = @"(GIR 0AA)|((([A-Z-[QVX]][0-9][0-9]?)|(([A-Z-[QVX]][A-Z-[IJZ]][0-9][0-9]?)|(([A-Z-[QVX‌​]][0-9][A-HJKSTUW])|([A-Z-[QVX]][A-Z-[IJZ]][0-9][ABEHMNPRVWXY]))))\\s?[0-9][A-Z-[C‌​IKMOV]]{2})";

    NSRegularExpression *ukRegex = [NSRegularExpression regularExpressionWithPattern:kUKRegexString
                                                                             options:NSRegularExpressionAnchorsMatchLines
                                                                               error:nil];
    BOOL isValid = [ukRegex numberOfMatchesInString:input.uppercaseString
                                            options:NSMatchingWithoutAnchoringBounds
                                              range:NSMakeRange(0, input.uppercaseString.length)] > 0;

    NSString *errorMessage = (input.length == kUKPostalCodeLength && !isValid) ? @"invalid_postcode".localized : nil;

    self.lastPostalCodeValidationResult = [JPValidationResult validationWithResult:isValid
                                                                      inputAllowed:input.length <= kUKPostalCodeLength
                                                                      errorMessage:errorMessage
                                                                    formattedInput:input.uppercaseString];
    return self.lastPostalCodeValidationResult;
}

- (JPValidationResult *)validateUSAPostalCodeInput:(NSString *)input {

    if (input.length > kUSAPostalCodeLength) {
        return self.lastPostalCodeValidationResult;
    }

    NSString *const kUSARegexString = @"(^\\d{5}$)|(^\\d{5}-\\d{4}$)";

    NSRegularExpression *usaRegex = [NSRegularExpression regularExpressionWithPattern:kUSARegexString
                                                                              options:NSRegularExpressionAnchorsMatchLines
                                                                                error:nil];

    BOOL isValid = [usaRegex numberOfMatchesInString:input.uppercaseString
                                             options:NSMatchingWithoutAnchoringBounds
                                               range:NSMakeRange(0, input.uppercaseString.length)] > 0;

    NSString *errorMessage = (input.length == kUSAPostalCodeLength && !isValid) ? @"invalid_zip_code".localized : nil;

    self.lastPostalCodeValidationResult = [JPValidationResult validationWithResult:isValid
                                                                      inputAllowed:input.length <= kUSAPostalCodeLength
                                                                      errorMessage:errorMessage
                                                                    formattedInput:input.uppercaseString];
    return self.lastPostalCodeValidationResult;
}

- (JPValidationResult *)validateCanadaPostalCodeInput:(NSString *)input {

    if (input.length > kCanadaPostalCodeLength) {
        return self.lastPostalCodeValidationResult;
    }

    NSString *const kCanadaRegexString = @"[ABCEGHJKLMNPRSTVXY][0-9][ABCEGHJKLMNPRSTVWXYZ][0-9][ABCEGHJKLMNPRSTVWXYZ][\\s][0-9]";
    NSRegularExpression *canadaRegex = [NSRegularExpression regularExpressionWithPattern:kCanadaRegexString
                                                                                 options:NSRegularExpressionAnchorsMatchLines
                                                                                   error:nil];

    BOOL isValid = [canadaRegex numberOfMatchesInString:input.uppercaseString
                                                options:NSMatchingWithoutAnchoringBounds
                                                  range:NSMakeRange(0, input.uppercaseString.length)] > 0;

    NSString *errorMessage = (input.length == kCanadaPostalCodeLength && !isValid) ? @"invalid_postcode".localized : nil;

    self.lastPostalCodeValidationResult = [JPValidationResult validationWithResult:isValid
                                                                      inputAllowed:input.length <= kCanadaPostalCodeLength
                                                                      errorMessage:errorMessage
                                                                    formattedInput:input.uppercaseString];

    return self.lastPostalCodeValidationResult;
}

- (JPValidationResult *)validateOtherPostalCodeInput:(NSString *)input {
    self.lastPostalCodeValidationResult = [JPValidationResult validationWithResult:YES
                                                                      inputAllowed:input.length <= kOtherPostalCodeLength
                                                                      errorMessage:nil
                                                                    formattedInput:input.uppercaseString];
    return self.lastPostalCodeValidationResult;
}

- (NSString *)selectedJPBillingCountry {
    if (!_selectedJPBillingCountry) {
        _selectedJPBillingCountry = @"country_uk".localized;
    }
    return _selectedJPBillingCountry;
}

@end
