//
//  UIFont.m
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

#import "UIFont+Additions.h"

@implementation UIFont (Additions)

+ (UIFont *)largeTitle {
    return [UIFont systemFontOfSize:24.0 weight:UIFontWeightSemibold];
}

+ (UIFont *)title {
    return [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold];
}

+ (UIFont *)headline {
    return [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
}

+ (UIFont *)headlineLight {
    return [UIFont systemFontOfSize:16.0];
}

+ (UIFont *)body {
    return [UIFont systemFontOfSize:14.0];
}

+ (UIFont *)bodyBold {
    return [UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold];
}

+ (UIFont *)caption {
    return [UIFont systemFontOfSize:10.0];
}

+ (UIFont *)captionBold {
    return [UIFont systemFontOfSize:10.0 weight:UIFontWeightSemibold];
}

- (UIFontWeight)weight {
    NSDictionary *traits = [self.fontDescriptor objectForKey:UIFontDescriptorTraitsAttribute];
    NSNumber *weightNumber = traits[UIFontWeightTrait];
    return weightNumber.doubleValue;
}

@end
