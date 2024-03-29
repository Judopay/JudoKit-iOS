//
//  UIStackView+Additions.h
//  JudoKit_iOS
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
//

#import "UIStackView+Additions.h"

@implementation UIStackView (Additions)

+ (UIStackView *)_jp_verticalStackViewWithSpacing:(CGFloat)spacing {
    return [self stackViewWithAxis:UILayoutConstraintAxisVertical andSpacing:spacing];
}

+ (UIStackView *)_jp_horizontalStackViewWithSpacing:(CGFloat)spacing {
    return [self stackViewWithAxis:UILayoutConstraintAxisHorizontal andSpacing:spacing];
}

+ (UIStackView *)stackViewWithAxis:(UILayoutConstraintAxis)axis
                        andSpacing:(CGFloat)spacing {
    UIStackView *stackView = [UIStackView new];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = axis;
    stackView.spacing = spacing;
    return stackView;
}

+ (UIStackView *)_jp_verticalStackViewWithSpacing:(CGFloat)spacing
                              andArrangedSubviews:(NSArray<UIView *> *)views {
    UIStackView *stackView = [UIStackView _jp_verticalStackViewWithSpacing:spacing];
    [stackView _jp_addArrangedSubviews:views];
    return stackView;
}

+ (UIStackView *)_jp_horizontalStackViewWithSpacing:(CGFloat)spacing
                                andArrangedSubviews:(NSArray<UIView *> *)views {
    UIStackView *stackView = [UIStackView _jp_horizontalStackViewWithSpacing:spacing];
    [stackView _jp_addArrangedSubviews:views];
    return stackView;
}

+ (UIStackView *)_jp_horizontalStackViewWithSpacing:(CGFloat)spacing
                                       distribution:(UIStackViewDistribution)distribution
                                andArrangedSubviews:(NSArray<UIView *> *)views {
    UIStackView *stackView = [UIStackView _jp_horizontalStackViewWithSpacing:spacing
                                                         andArrangedSubviews:views];
    stackView.distribution = distribution;
    return stackView;
}

- (void)_jp_addArrangedSubviews:(NSArray<UIView *> *)views {
    for (int i = 0; i < views.count; i++) {
        [self addArrangedSubview:views[i]];
    }
}

- (void)_jp_removeArrangedSubviews {
    for (UIView *view in self.arrangedSubviews) {
        [self removeArrangedSubview:view];
        [view removeFromSuperview];
    }
}

- (void)_jp_replaceArrangedSubview:(nonnull UIView *)oldView
                          withView:(nonnull UIView *)newView {
    if (![self.arrangedSubviews containsObject:oldView]) {
        return;
    }

    NSUInteger index = [self.arrangedSubviews indexOfObject:oldView];
    [self removeArrangedSubview:oldView];
    [oldView removeFromSuperview];

    [self insertArrangedSubview:newView atIndex:index];
}
@end
