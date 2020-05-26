//
//  JPPBBAButton.m
//  JudoKit-iOS
//
//  Copyright (c) 2019 Alternative Payments Ltd
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

#import "JPPBBAButton.h"
#import "UIView+Additions.h"

@interface JPPBBAButton ()
@property (nonatomic, strong) PBBAButton *pbbaButton;
@end

@implementation JPPBBAButton

#pragma mark - Initializers

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self addSubview: self.pbbaButton];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (BOOL)pbbaButtonDidPress:(nonnull PBBAButton *)pbbaButton {
    self.pbbaDidPress();
    return true;
}

- (PBBAButton *)pbbaButton {
    if (!_pbbaButton) {
        _pbbaButton = [PBBAButton new];
        [_pbbaButton.subviews.firstObject.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:UILabel.class] || [obj isKindOfClass:UIButton.class]) {
                [obj removeFromSuperview];
                return;
            }
            [obj.subviews.firstObject.widthAnchor constraintEqualToConstant:self.frame.size.width].active = YES;
            [obj.subviews.firstObject.heightAnchor constraintEqualToConstant:self.frame.size.height].active = YES;
            [obj.subviews.firstObject.topAnchor constraintEqualToAnchor:_pbbaButton.topAnchor].active = YES;
            [obj.subviews.firstObject.bottomAnchor constraintEqualToAnchor:_pbbaButton.bottomAnchor].active = YES;
            [obj.subviews.firstObject.leadingAnchor constraintEqualToAnchor:_pbbaButton.leadingAnchor].active = YES;
            [obj.subviews.firstObject.trailingAnchor constraintEqualToAnchor:_pbbaButton.trailingAnchor].active = YES;
        }];
        _pbbaButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_pbbaButton setClipsToBounds:YES];
    }
    _pbbaButton.delegate = self;
    return _pbbaButton;
}

@end
