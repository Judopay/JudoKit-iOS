//
//  JPRecommendationData.m
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

#import "JPRecommendationData.h"
#import "JPTransactionOptimisation.h"
#import "NSString+Additions.h"

static NSString *const kActionKey = @"action";
static NSString *const kTransactionOptimisationKey = @"transactionOptimisation";

static NSString *const kAllow = @"ALLOW";
static NSString *const kReview = @"REVIEW";
static NSString *const kPrevent = @"PREVENT";

@implementation JPRecommendationData

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self populateWithDictionary:dictionary];
    }
    return self;
}

- (void)populateWithDictionary:(NSDictionary *)dictionary {
    self.action = [self recommendationActionFromDictionary:dictionary];
    self.transactionOptimisation = [[JPTransactionOptimisation alloc] initWithDictionary:dictionary[kTransactionOptimisationKey]];
}

- (JPRecommendationAction)recommendationActionFromDictionary:(NSDictionary *)dictionary {
    NSString *actionString = dictionary[kActionKey];

    if ([actionString _jp_isEqualIgnoringCaseToString:kAllow]) {
        return JPRecommendationActionAllow;
    }

    if ([actionString _jp_isEqualIgnoringCaseToString:kReview]) {
        return JPRecommendationActionReview;
    }

    if ([actionString _jp_isEqualIgnoringCaseToString:kPrevent]) {
        return JPRecommendationActionPrevent;
    }

    return JPRecommendationActionUnknown;
}

- (BOOL)isValid {
    return self.action != JPRecommendationActionUnknown && self.transactionOptimisation.isValid;
}

@end
