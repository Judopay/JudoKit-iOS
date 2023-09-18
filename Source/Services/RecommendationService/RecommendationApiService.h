//
//  RecommendationApiService.h
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

#import "Typedefs.h"
#import <Foundation/Foundation.h>

@protocol JPAuthorization;

@class RecommendationRequest;

@interface RecommendationApiService : NSObject

// Todo: Confirm with Stefan whether it's okay for recommendation (to use JPAuthorization)
// (and abstract it into base class if so).
/**
 * A reference to one of the JPAuthorization instances which defines either a basic or a session authorization
 */
@property (nonatomic, strong, nonnull) id<JPAuthorization> authorization;

/**
 * Designated initializer that creates an instance of RecommendationApiSession based on the authorization type provided
 *
 * @param authorization - can be either a JPBasicAuthorization or a JPSessionAuthorization instance
 *
 * @returns a configured instance of RecommendationApiSession
 */
- (nonnull instancetype)initWithAuthorization:(nonnull id<JPAuthorization>)authorization;

/**
 * A method that invokes the recommendation call
 *
 * @param request - an instance of RecommendationRequest describing the recommendation request
 * @param completion - the completion block that contains the optional JPResponse or JPError
 */
// Todo: pointer issue
// Todo: JPCompletionBlock
- (void)invokeRecommendationRequest:(nonnull RecommendationRequest *)request
               andRecommendationUrl:(NSString *)recommendationUrl
                      andCompletion:(nullable JPCompletionBlock)completion;


@end
