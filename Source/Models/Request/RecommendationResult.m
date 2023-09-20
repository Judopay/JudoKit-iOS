//
//  RecommendationResult.m
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

#import "RecommendationResult.h"
#import "ScaExemption.h"

static NSString *const kRecommendationActionAllow = @"ALLOW";
static NSString *const kRecommendationActionReview = @"REVIEW";
static NSString *const kRecommendationActionPrevent = @"PREVENT";

static NSString *const kTransactionOptimisationActionAuthenticate = @"AUTHENTICATE";
static NSString *const kTransactionOptimisationActionAuthorise = @"AUTHORISE";

static NSString *const kScaExemptionLowValue = @"LOW_VALUE";
static NSString *const kScaExemptionTransactionRiskAnalysis = @"TRANSACTION_RISK_ANALYSIS";

@implementation RecommendationResult

#pragma mark - Initializers

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self populateWith:dictionary];
    }
    return self;
}

- (void)populateWith:(NSDictionary *)dictionary {
    NSDictionary * data = dictionary[@"data"];
    NSString * action = data[@"action"];
    NSDictionary * transactionOptimisation = data[@"transactionOptimisation"];
    NSString * transactionOptimisationActionString = transactionOptimisation[@"action"];
    NSString * scaExemptionString = transactionOptimisation[@"exemption"];
    NSString * threeDSChallengePreference = transactionOptimisation[@"threeDSChallengePreference"];
    
    RecommendationAction recommendationAction = [self recommendationActionForString:action];
    TransactionOptimisationAction transactionOptimisationAction = [self transactionOptimisationActionForString:transactionOptimisationActionString];
    ScaExemption scaExemption = [self scaExemptionForString:scaExemptionString];
    self.data = [[RecommendationData alloc] initWithRecommendationAction:recommendationAction
                                           transactionOptimisationAction:transactionOptimisationAction
                                                               exemption:(ScaExemption)scaExemption
                                              threeDSChallengePreference:threeDSChallengePreference];
}

- (RecommendationAction)recommendationActionForString:(NSString *)actionString {
    if ([actionString isEqualToString:kRecommendationActionAllow]) {
        return ALLOW;
    }

    if ([actionString isEqualToString:kRecommendationActionReview]) {
        return REVIEW;
    }
    
    if ([actionString isEqualToString:kRecommendationActionPrevent]) {
        return PREVENT;
    }

    return nil;
}

- (ScaExemption)scaExemptionForString:(NSString *)scaExemptionString {
    if ([scaExemptionString isEqualToString:kScaExemptionLowValue]) {
        return LOW_VALUE;
    }

    if ([scaExemptionString isEqualToString:kScaExemptionTransactionRiskAnalysis]) {
        return TRANSACTION_RISK_ANALYSIS;
    }

    return nil;
}

- (TransactionOptimisationAction)transactionOptimisationActionForString:(NSString *)actionString {
    if ([actionString isEqualToString:kTransactionOptimisationActionAuthenticate]) {
        return AUTHENTICATE;
    }

    if ([actionString isEqualToString:kTransactionOptimisationActionAuthorise]) {
        return AUTHORISE;
    }

    return nil;
}

@end
