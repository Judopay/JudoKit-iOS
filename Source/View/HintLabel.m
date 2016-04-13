//
//  HintLabel.m
//  JudoKitObjC
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

#import "HintLabel.h"

#import "JPTheme.h"

@implementation HintLabel

- (BOOL)isActive {
    return self.alertText.length > 0 || self.hintText.length > 0;
}

- (void)showHint:(NSString *)hint {
    self.hintText = [[NSAttributedString alloc] initWithString:hint attributes:@{NSForegroundColorAttributeName:self.theme.judoTextColor}];
    if (self.alertText == nil) {
        [self addAnimation];
        
        self.attributedText = self.hintText;
    }
}

- (void)showAlert:(NSString *)alert {
    [self addAnimation];
    
    self.alertText = [[NSAttributedString alloc] initWithString:alert attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    self.attributedText = self.alertText;
}

- (void)hideHint {
    [self addAnimation];
    
    self.hintText = nil;
    self.attributedText = self.alertText;
}

- (void)hideAlert {
    [self addAnimation];
    
    self.alertText = nil;
    self.attributedText = self.alertText;
}

- (void)addAnimation {
    CATransition *transition = [CATransition new];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.duration = .5f;
    [self.layer addAnimation:transition forKey:@"kCATransitionFade"];
}

@end
