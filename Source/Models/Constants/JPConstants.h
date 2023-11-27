//
//  Constants.h
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

#ifndef JPConstants_h
#define JPConstants_h

#import <Foundation/Foundation.h>

static NSString *const kJudoKitName = @"JudoKit_iOS";
static NSString *const kJudoKitVersion = @"3.2.8";

/* Patterns */
static NSString *const kDefaultPattern = @"XXXX XXXX XXXX XXXX";
static NSString *const kVISAPattern = @"XXXX XXXX XXXX XXXX";
static NSString *const kAMEXPattern = @"XXXX XXXXXX XXXXX";
static NSString *const kDinersClubPattern = @"XXXX XXXXXX XXXX";

static NSString *const kMonthYearDateFormat = @"MM/yy";
static NSString *const kCurrencyEuro = @"EUR";
static NSString *const kCurrencyPounds = @"GBP";
static NSString *const kFailureReasonUserAbort = @"USER_ABORT";

static NSUInteger const kSecurityCodeLengthAmex = 4;
static NSUInteger const kSecurityCodeLengthDefault = 3;

static NSString *const kSecurityCodePlaceholderhAmex = @"CID";
static NSString *const kSecurityCodePlaceholderhVisa = @"CVV2";
static NSString *const kSecurityCodePlaceholderhMasterCard = @"CVC2";
static NSString *const kSecurityCodePlaceholderhChinaUnionPay = @"CVN2";
static NSString *const kSecurityCodePlaceholderhJCB = @"CAV2";
static NSString *const kSecurityCodePlaceholderDefault = @"CVV";

static int const kJPCountryNumericCodeUK = 826;
static int const kJPCountryNumericCodeUSA = 840;
static int const kJPCountryNumericCodeCanada = 124;

static NSString *const kJudoErrorDomain = @"com.judo.error";

static int const kMaximumLengthForConsumerReference = 40;

static int const kMaxAMEXCardLength = 15;
static int const kMaxDinersClubCardLength = 14;
static int const kMaxDefaultCardLength = 16;

// MARK:Postal Codes
static NSString *const kMaskForCanadaPostCode = @"XXX XXX";
static int const kCanadaPostalCodeMaxLength = 7;
static int const kCanadaPostalCodeMinLength = 6;
static int const kUKPostalCodeMaxLength = 8;
static int const kUKPostalCodeMinLength = 5;
static int const kUSAPostalCodeMaxLength = 10;
static int const kUSAPostalCodeMinLength = 5;
static int const kOtherPostalCodeMinLength = 1;
static int const kOtherPostalCodeMaxLength = 16;

static NSString *const kRegExJudoId = @"^(([0-9]{9})|([0-9]{3}-[0-9]{3}-[0-9]{3})|([0-9]{6}))?$";

static NSString *const kRegExVisaPAN = @"^4\\d{0,15}";
static NSString *const kRegExMasterCardPAN = @"^(5[1-5]\\d{0,2}|22[2-9]\\d{0,1}|2[3-7]\\d{0,2})\\d{0,12}";
static NSString *const kRegExMaestroPAN = @"^(?:5[0678]\\d{0,2}|6304|67\\d{0,2})\\d{0,12}";
static NSString *const kRegExAmexPAN = @"^3[47]\\d{0,13}";
static NSString *const kRegExDiscoverPAN = @"^(?:6011|65\\d{0,2}|64[4-9]\\d?)\\d{0,12}";
static NSString *const kRegExDinersClubPAN = @"^3(?:0([0-5]|9)|[689]\\d?)\\d{0,11}";
static NSString *const kRegExJCBPAN = @"^(?:35\\d{0,2})\\d{0,12}";
static NSString *const kRegExUnionPayPAN = @"^(62|81)\\d{0,14}";

static NSString *const kRegExCardholderName = @"^[A-Za-z.\\-'\\s?]+$";
static NSString *const kRegExCity = @"^[A-Za-z.'\\- ]+$";
static NSString *const kRegExMobileNumber = @"^.{10,}$";
static NSString *const kRegExAddressLine = @"^[a-zA-Z0-9,./'\\- ]+$";

static NSString *const kRegExUSPostCode = @"^(\\d{5}(?:-\\d{4})?)$";
static NSString *const kRegExGBPostCode = @"^[A-Z]{1,2}[0-9][A-Z0-9]? ?[0-9][A-Z]{2}$";
static NSString *const kRegExCAPostCode = @"^(?!.*[DFIOQU])[A-VXY][0-9][A-Z] ?[0-9][A-Z][0-9]$";
static NSString *const kRegExOtherPostCode = @"^[A-Z0-9 -]{1,16}$";

// Default 3DS 2.0 maximum timeout value
static int const kDefaultThreeDSTwoMaxTimeout = 60;

// Default 3DS 2.0 protocol message version
static NSString *const kThreeDSTwoMessageVersionTwoDotTwo = @"2.2.0";

static NSString *const kAlpha2CodeCanada = @"CA";
static NSString *const kAlpha2CodeUSA = @"US";
static NSString *const kAlpha2CodeUK = @"GB";

static NSString *const kJudoBaseURL = @"https://api.judopay.com/";
static NSString *const kJudoSandboxBaseURL = @"https://api-sandbox.judopay.com/";

static NSString *const kContentTypeJSON = @"application/json";
static NSString *const kHeaderFieldContentType = @"Content-Type";
static NSString *const kHeaderFieldAccept = @"Accept";

static NSString *const kMethodGET = @"GET";
static NSString *const kMethodPOST = @"POST";
static NSString *const kMethodPUT = @"PUT";

static NSString *const kCRINoPreference = @"noPreference";
static NSString *const kCRINoChallenge = @"noChallenge";
static NSString *const kCRIChallengePreferred = @"challengePreferred";
static NSString *const kCRIChallengeAsMandate = @"challengeAsMandate";

static NSString *const kSCAExemptionLowValue = @"lowValue";
static NSString *const kSCAExemptionSecureCorporate = @"secureCorporate";
static NSString *const kSCAExemptionTrustedBeneficiary = @"trustedBeneficiary";
static NSString *const kSCAExemptionTransactionRiskAnalysis = @"transactionRiskAnalysis";

static NSString *const kHeaderFieldPaymentSession = @"Payment-Session";
static NSString *const kHeaderFieldAuthorization = @"Authorization";

#endif /* JPConstants_h */
