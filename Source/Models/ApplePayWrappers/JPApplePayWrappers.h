//
//  JPApplePayWrappers.h
//  JudoKit_iOS
//
//  Copyright (c) 2016 Alternative Payments Ltd
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

#import <PassKit/PassKit.h>

@class JPConfiguration;

@interface JPApplePayWrappers : NSObject

/**
 * A method that returns a mapped PKPaymentAuthorizationViewController instance based on the provided JPConfiguration object
 *
 * @param configuration - a JPConfiguration object containing information about the Apple Pay transaction
 *
 * @returns a configured instance of PKPaymentAuthorizationViewController
 */
+ (PKPaymentAuthorizationViewController *)pkPaymentControllerForConfiguration:(JPConfiguration *)configuration;

+ (PKMerchantCapability)pkMerchantCapabilitiesForConfiguration:(JPConfiguration *)configuration;

/**
 * A method that returns an array of Apple Pay supported payment networks based on the ones provided in the JPConfiguration object
 *
 * @param configuration - a JPConfiguration object containing merchant-specified payment networks
 *
 * @returns an array of mapped PKPaymentNetwork instances
 */
+ (NSArray<PKPaymentNetwork> *)pkPaymentNetworksForConfiguration:(JPConfiguration *)configuration;

@end
