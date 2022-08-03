//
//  UIView+Additions.m
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

#import "UIView+Additions.h"

@implementation UIView (Additions)

- (void)_jp_roundCorners:(UIRectCorner)corners withRadius:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:corners
                                                     cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *mask = [CAShapeLayer new];
    mask.path = path.CGPath;
    self.layer.mask = mask;
}

- (void)_jp_setBorderWithColor:(UIColor *)color
                         width:(CGFloat)width
               andCornerRadius:(CGFloat)cornerRadius {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = cornerRadius;
}

- (void)_jp_pinToView:(UIView *)view withPadding:(CGFloat)padding {
    NSArray *constraints = @[
        [self.topAnchor constraintEqualToAnchor:view.topAnchor
                                       constant:padding],
        [self.bottomAnchor constraintEqualToAnchor:view.bottomAnchor
                                          constant:-padding],
        [self.leadingAnchor constraintEqualToAnchor:view.leadingAnchor
                                           constant:padding],
        [self.trailingAnchor constraintEqualToAnchor:view.trailingAnchor
                                            constant:-padding]
    ];

    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)_jp_pinToAnchors:(JPAnchorType)anchors forView:(UIView *)view {
    [self _jp_pinToAnchors:anchors forView:view withPadding:0.0];
}

- (void)_jp_pinToAnchors:(JPAnchorType)anchors forView:(UIView *)view withPadding:(CGFloat)padding {

    if (anchors & JPAnchorTypeTop) {
        [self.topAnchor constraintEqualToAnchor:view.topAnchor
                                       constant:padding]
            .active = YES;
    }

    if (anchors & JPAnchorTypeBottom) {
        [self.bottomAnchor constraintEqualToAnchor:view.bottomAnchor
                                          constant:-padding]
            .active = YES;
    }

    if (anchors & JPAnchorTypeLeading) {
        [self.leadingAnchor constraintEqualToAnchor:view.leadingAnchor
                                           constant:padding]
            .active = YES;
    }

    if (anchors & JPAnchorTypeTrailing) {
        [self.trailingAnchor constraintEqualToAnchor:view.trailingAnchor
                                            constant:-padding]
            .active = YES;
    }
}

- (void)_jp_removeAllSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (NSLayoutAnchor<NSLayoutYAxisAnchor *> *)_jp_safeTopAnchor {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaLayoutGuide.topAnchor;
    }
    return self.topAnchor;
}

- (NSLayoutAnchor<NSLayoutXAxisAnchor *> *)_jp_safeLeftAnchor {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaLayoutGuide.leftAnchor;
    }
    return self.leftAnchor;
}

- (NSLayoutAnchor<NSLayoutXAxisAnchor *> *)_jp_safeRightAnchor {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaLayoutGuide.rightAnchor;
    }
    return self.rightAnchor;
}

- (NSLayoutAnchor<NSLayoutYAxisAnchor *> *)_jp_safeBottomAnchor {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaLayoutGuide.bottomAnchor;
    }
    return self.bottomAnchor;
}

@end
