//
//  JPCardTransactionDetailsOverrides.m
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

#import "JPCardTransactionDetailsOverrides.h"
#import "JPConstants.h"
#import "JPRecommendationResponse.h"
#import "JPTransactionOptimisation.h"
#import "NSString+Additions.h"

NSString *stringifyChallengeRequestIndicator(JPRecommendationOptimisationThreeDSChallengePreference preference) {
    switch (preference) {
        case JPRecommendationOptimisationThreeDSChallengePreferenceNoPreference:
            return kCRINoPreference;
        case JPRecommendationOptimisationThreeDSChallengePreferenceNoChallengeRequested:
            return kCRINoChallenge;
        case JPRecommendationOptimisationThreeDSChallengePreferenceChallengeRequested:
            return kCRIChallengePreferred;
        case JPRecommendationOptimisationThreeDSChallengePreferenceChallengeRequestedAsMandate:
            return kCRIChallengeAsMandate;
        default:
            return nil;
    }
}

NSString *stringifySCAExemption(JPRecommendationOptimisationExemption exemption) {
    switch (exemption) {
        case JPRecommendationOptimisationExemptionLowValue:
            return kSCAExemptionLowValue;
        case JPRecommendationOptimisationExemptionTransactionRiskAnalysis:
            return kSCAExemptionTransactionRiskAnalysis;
        default:
            return nil;
    }
}

@implementation JPCardTransactionDetailsOverrides

- (NSString *)challengeRequestIndicator {
    if (!_challengeRequestIndicator && !_softDeclineReceiptId._jp_isNullOrEmpty) {
        return @"";
    }
    return _challengeRequestIndicator;
}

+ (instancetype)overridesWithSoftDeclineReceiptId:(NSString *)receiptId {
    JPCardTransactionDetailsOverrides *overrides = [JPCardTransactionDetailsOverrides new];
    overrides.softDeclineReceiptId = receiptId;
    return overrides;
}

+ (instancetype)overridesWithChallengeRequestIndicator:(NSString *)indicator
                                       andScaExemption:(NSString *)exemption {
    JPCardTransactionDetailsOverrides *overrides = [JPCardTransactionDetailsOverrides new];
    overrides.challengeRequestIndicator = indicator;
    overrides.scaExemption = exemption;
    return overrides;
}

+ (instancetype)overridesWithRecommendationResponse:(JPRecommendationResponse *)response {
    JPTransactionOptimisation *optimisation = response.data.transactionOptimisation;
    NSString *cri = stringifyChallengeRequestIndicator(optimisation.threeDSChallengePreference);
    NSString *excemption = stringifySCAExemption(optimisation.exemption);

    return [JPCardTransactionDetailsOverrides overridesWithChallengeRequestIndicator:cri
                                                                     andScaExemption:excemption];
}

@end
