//
//  JPCardCustomizationBuilder.h
//  JudoKitObjC
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

#import "JPCardCustomizationViewController.h"
#import "JPTheme.h"
#import <Foundation/Foundation.h>

@protocol JPCardCustomizationBuilder

/**
 * A method that build the Card Customization module based on the selected card index
 *
 * @param index - the index of the selected card in the payment method screen
 * @param theme - a reference to JPTheme used to configure the user interface
 *
 * @returns a configured instance of JPCardCustomizationViewController
 */
+ (JPCardCustomizationViewController *)buildModuleWithCardIndex:(NSUInteger)index
                                                       andTheme:(JPTheme *)theme;

@end

@interface JPCardCustomizationBuilderImpl : NSObject <JPCardCustomizationBuilder>

@end