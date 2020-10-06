//
//  JPCardScanPreviewLayer.h
//  JudoKit_iOS
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

#import <UIKit/UIKit.h>
#import "JPCardScanPreviewLayer.h"

@interface JPCardScanPreviewLayer ()
@property (nonatomic, strong) CAShapeLayer *cardLayer;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@end

@implementation JPCardScanPreviewLayer

//-------------------------------------------------
// MARK: - Constants
//-------------------------------------------------

static CGFloat kCardOffset  = 20.0;
static CGFloat kCardRadius  = 10.0;
static CGFloat kStrokeWidth = 3.0;
static CGFloat kCardRatio   = 0.628;
static CGFloat kBackgroundAlpha = 0.8;
static CGFloat kCardAlpha = 0.4;

//-------------------------------------------------
// MARK: - Public methods
//-------------------------------------------------

- (void)setShouldDimCardBackground:(BOOL)shouldDimCardBackground {
    _shouldDimCardBackground = shouldDimCardBackground;
    CGFloat alphaValue = shouldDimCardBackground ? kCardAlpha : 0.0;
    UIColor *fillColor = [UIColor colorWithWhite:0.0 alpha:alphaValue];
    [self.cardLayer setFillColor:fillColor.CGColor];
}

//-------------------------------------------------
// MARK: - Overrides
//-------------------------------------------------

- (void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    [self addSublayer:self.backgroundLayer];
    [self addSublayer:self.cardLayer];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

//-------------------------------------------------
// MARK: - Lazy initializers
//-------------------------------------------------

- (CAShapeLayer *)backgroundLayer {
    if (!_backgroundLayer) {
        UIColor *fillColor = [UIColor colorWithWhite:0.0 alpha:kBackgroundAlpha];

        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, nil, self.frame);
        CGPathAddRoundedRect(path, nil, self.cardRect, kCardRadius, kCardRadius);

        _backgroundLayer = [CAShapeLayer new];

        [_backgroundLayer setPath:path];
        [_backgroundLayer setFillColor:fillColor.CGColor];
        [_backgroundLayer setFillRule:kCAFillRuleEvenOdd];
    }
    return _backgroundLayer;
}

- (CAShapeLayer *)cardLayer {
    if (!_cardLayer) {
        UIColor *fillColor = [UIColor colorWithWhite:0.0 alpha:kCardAlpha];

        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRoundedRect(path, nil, self.cardRect, kCardRadius, kCardRadius);

        _cardLayer = [CAShapeLayer new];

        [_cardLayer setPath:path];
        [_cardLayer setLineWidth:kStrokeWidth];
        [_cardLayer setStrokeColor:UIColor.whiteColor.CGColor];
        [_cardLayer setFillColor:fillColor.CGColor];
    }
    return _cardLayer;
}

//-------------------------------------------------
// MARK: - Helper methods
//-------------------------------------------------

- (CGFloat)screenWidth {
    return UIScreen.mainScreen.bounds.size.width;
}

- (CGFloat)screenHeight {
    return UIScreen.mainScreen.bounds.size.height;
}

- (CGFloat)cardWidth {
    return self.screenWidth - kCardOffset * 2;
}

- (CGFloat)cardHeight {
    return (self.screenWidth - kCardOffset * 2) * kCardRatio;
}

- (CGFloat)cardYOrigin {
    CGFloat cardOffset = self.cardHeight / 2;
    return self.screenHeight / 2 - cardOffset;
}

- (CGRect)cardRect {
    return CGRectMake(kCardOffset,
                      self.cardYOrigin,
                      self.cardWidth,
                      self.cardHeight);
}

@end
