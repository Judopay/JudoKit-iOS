//
//  JPUIConfiguration.h
//  JudoKit-iOS
//
//  Copyright (c) 2020 Alternative Payments Ltd
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

#import <Foundation/Foundation.h>

@class JPTheme;

@interface JPUIConfiguration : NSObject

/**
 * A boolean property that defines if the amount should be displayed on the payment method screen
 */
@property (nonatomic, assign) BOOL shouldPaymentMethodsDisplayAmount;

/**
 * A boolean property that defines if the amount should be displayed on the transaction screen
 */
@property (nonatomic, assign) BOOL shouldPaymentButtonDisplayAmount;

/**
 * A boolean property that defines if the SDK should verify security code when paying with card token
 */
@property (nonatomic, assign) BOOL shouldPaymentMethodsVerifySecurityCode;

/**
 * A boolean property that defines if AVS should be enabled during the payment flow
 */
@property (nonatomic, assign) BOOL isAVSEnabled;

/**
 * A reference to the JPTheme object that customizes the user interface
 */
@property (nonatomic, strong) JPTheme *theme;

@end
