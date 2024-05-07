//
//  JPTransactionOptimisation.m
//  JudoKit_iOS
//
//  Copyright (c) 2023 Alternative Payments Ltd
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

#import "JPTransactionOptimisation.h"
#import "NSString+Additions.h"

static NSString *const kAuthenticate = @"AUTHENTICATE";
static NSString *const kAuthorise = @"AUTHORISE";

static NSString *const kLowValue = @"LOW_VALUE";
static NSString *const kTransactionRiskAnalysis = @"TRANSACTION_RISK_ANALYSIS";

static NSString *const kNoPreference = @"NO_PREFERENCE";
static NSString *const kNoChallengeRequested = @"NO_CHALLENGE_REQUESTED";
static NSString *const kChallengeRequested = @"CHALLENGE_REQUESTED";
static NSString *const kChallengeRequestedAsMandate = @"CHALLENGE_REQUESTED_AS_MANDATE";

static NSString *const kActionKey = @"action";
static NSString *const kExemptionKey = @"exemption";
static NSString *const kThreeDSChallengePreferenceKey = @"threeDSChallengePreference";

@implementation JPTransactionOptimisation

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self populateWithDictionary:dictionary];
    }
    return self;
}

- (void)populateWithDictionary:(NSDictionary *)dictionary {
    self.exemption = [self exemptionFromDictionary:dictionary];
    self.threeDSChallengePreference = [self threeDSChallengePreferenceFromDictionary:dictionary];
}

- (JPRecommendationOptimisationExemption)exemptionFromDictionary:(NSDictionary *)dictionary {
    NSString *exemptionString = [dictionary objectForKey:kExemptionKey];

    BOOL isValidString = exemptionString && [exemptionString isKindOfClass:NSString.class];

    if (!isValidString) {
        return -1;
    }

    if ([exemptionString _jp_isEqualIgnoringCaseToString:kLowValue]) {
        return JPRecommendationOptimisationExemptionLowValue;
    }

    if ([exemptionString _jp_isEqualIgnoringCaseToString:kTransactionRiskAnalysis]) {
        return JPRecommendationOptimisationExemptionTransactionRiskAnalysis;
    }

    return JPRecommendationOptimisationExemptionUnknown;
}

- (JPRecommendationOptimisationThreeDSChallengePreference)threeDSChallengePreferenceFromDictionary:(NSDictionary *)dictionary {
    NSString *preferenceString = [dictionary objectForKey:kThreeDSChallengePreferenceKey];

    BOOL isValidString = preferenceString && [preferenceString isKindOfClass:NSString.class];

    if (!isValidString) {
        return -1;
    }

    if ([preferenceString _jp_isEqualIgnoringCaseToString:kNoPreference]) {
        return JPRecommendationOptimisationThreeDSChallengePreferenceNoPreference;
    }

    if ([preferenceString _jp_isEqualIgnoringCaseToString:kNoChallengeRequested]) {
        return JPRecommendationOptimisationThreeDSChallengePreferenceNoChallengeRequested;
    }

    if ([preferenceString _jp_isEqualIgnoringCaseToString:kChallengeRequested]) {
        return JPRecommendationOptimisationThreeDSChallengePreferenceChallengeRequested;
    }

    if ([preferenceString _jp_isEqualIgnoringCaseToString:kChallengeRequestedAsMandate]) {
        return JPRecommendationOptimisationThreeDSChallengePreferenceChallengeRequestedAsMandate;
    }

    return JPRecommendationOptimisationThreeDSChallengePreferenceUnknown;
}

- (BOOL)isValid {
    return self.exemption != JPRecommendationOptimisationExemptionUnknown && self.threeDSChallengePreference != JPRecommendationOptimisationThreeDSChallengePreferenceUnknown;
}

@end
