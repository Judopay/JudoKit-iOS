//
//  JPPBBAButton.m
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

#import "JPPBBAButton.h"
#import "UIView+Additions.h"

@interface JPPBBAButton () <PBBAButtonDelegate>
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
        [self addSubview: self.pbbaButton];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview: self.pbbaButton];
    }
    return self;
}

- (BOOL)pbbaButtonDidPress:(nonnull PBBAButton *)pbbaButton {
    [self.delegate pbbaButtonDidPress: self];
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
            UIView *firstView = obj.subviews.firstObject;
            NSArray *constraints = @[[firstView.widthAnchor constraintEqualToConstant:self.frame.size.width],
                                     [firstView.heightAnchor constraintEqualToConstant:self.frame.size.height],
                                     [firstView.topAnchor constraintEqualToAnchor:_pbbaButton.topAnchor],
                                     [firstView.bottomAnchor constraintEqualToAnchor:_pbbaButton.bottomAnchor],
                                     [firstView.leadingAnchor constraintEqualToAnchor:_pbbaButton.leadingAnchor],
                                     [firstView.trailingAnchor constraintEqualToAnchor:_pbbaButton.trailingAnchor]];
            [NSLayoutConstraint activateConstraints:constraints];
        }];
        _pbbaButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_pbbaButton setClipsToBounds:YES];
    }
    _pbbaButton.delegate = self;
    return _pbbaButton;
}

@end
