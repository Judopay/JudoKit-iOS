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

/* Patterns */
static NSString *kDefaultPattern = @"XXXX XXXX XXXX XXXX";
static NSString *kVISAPattern = @"XXXX XXXX XXXX XXXX";
static NSString *kAMEXPattern = @"XXXX XXXXXX XXXXX";
static NSString *kDinersClubPattern = @"XXXX XXXXXX XXXX";

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
static int const kCanadaPostalCodeLength = 7;
static int const kUKPostalCodeMaxLength = 8;
static int const kUKPostalCodeMinLength = 6;
static int const kUSAPostalCodeMaxLength = 10;
static int const kUSAPostalCodeMinLength = 5;

static int const kOtherPostalCodeLength = 8;

static NSString *const kRegExJudoId = @"^(([0-9]{9})|([0-9]{3}-[0-9]{3}-[0-9]{3})|([0-9]{6}))?$";

static NSString *const kRegExVisaPAN = @"^4\\d{0,15}";
static NSString *const kRegExMasterCardPAN = @"^(5[1-5]\\d{0,2}|22[2-9]\\d{0,1}|2[3-7]\\d{0,2})\\d{0,12}";
static NSString *const kRegExMaestroPAN = @"^(?:5[0678]\\d{0,2}|6304|67\\d{0,2})\\d{0,12}";
static NSString *const kRegExAmexPAN = @"^3[47]\\d{0,13}";
static NSString *const kRegExDiscoverPAN = @"^(?:6011|65\\d{0,2}|64[4-9]\\d?)\\d{0,12}";
static NSString *const kRegExDinersClubPAN = @"^3(?:0([0-5]|9)|[689]\\d?)\\d{0,11}";
static NSString *const kRegExJCBPAN = @"^(?:35\\d{0,2})\\d{0,12}";
static NSString *const kRegExUnionPayPAN = @"^(62|81)\\d{0,14}";

static NSString *const kRegExCardholderName = @"^[A-Za-z ]+$";
static NSString *const kRegExCity = @"^[A-Za-z.'\\- ]+$";
static NSString *const kRegExMobileNumber = @"^.{10,}$";
static NSString *const kRegExAddressLine = @"^[a-zA-Z0-9,./'\\- ]+$";

static NSString *const kRegExUSPostCode = @"(^\\d{5}$)|(^\\d{5}-\\d{4}$)";
static NSString *const kRegExGBPostCode = @"(GIR 0AA)|((([A-Z-[QVX]][0-9][0-9]?)|(([A-Z-[QVX]][A-Z-[IJZ]][0-9][0-9]?)|(([A-Z-[QVX‌​]][0-9][A-HJKSTUW])|([A-Z-[QVX]][A-Z-[IJZ]][0-9][ABEHMNPRVWXY]))))\\s?[0-9][A-Z-[C‌​IKMOV]]{2})";
static NSString *const kRegExCAPostCode = @"[ABCEGHJKLMNPRSTVXY][0-9][ABCEGHJKLMNPRSTVWXYZ][0-9][ABCEGHJKLMNPRSTVWXYZ][0-9]";

// Default 3DS 2.0 maximum timeout value
static int const kDefaultThreeDSTwoMaxTimeout = 60;

// Default 3DS 2.0 protocol message version
static NSString *const kThreeDSTwoMessageVersionTwoDotTwo = @"2.2.0";

#endif /* JPConstants_h */
