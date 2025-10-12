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

+ (UIFont *)_jp_largeTitle {
    return [UIFont preferredFontForTextStyle:UIFontTextStyleLargeTitle];
}

+ (UIFont *)_jp_title {
    return [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
}

+ (UIFont *)_jp_headline {
    return [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

+ (UIFont *)_jp_headlineLight {
    return [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
}

+ (UIFont *)_jp_body {
    return [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

+ (UIFont *)_jp_bodyBold {
    UIFontDescriptor *descriptor = [[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontDescriptor];
    UIFontDescriptor *boldDescriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    return [UIFont fontWithDescriptor:boldDescriptor size:0];
}

+ (UIFont *)_jp_caption {
    return [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
}

+ (UIFont *)_jp_captionBold {
    UIFontDescriptor *descriptor = [[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1] fontDescriptor];
    UIFontDescriptor *boldDescriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    return [UIFont fontWithDescriptor:boldDescriptor size:0];
}

@end
