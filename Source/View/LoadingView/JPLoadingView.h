//
//  JPLoadingView.h
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

#import <UIKit/UIKit.h>

@interface JPLoadingView : UIView

/**
 * The optional UILabel that contains the title string
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 * Designated initializer that configures the JPLoadingView instance with an optional title
 *
 * @param title - an optional NSString representing the title label displayed below the activity indicator
 *
 * @returns a configured instance of JPLoadingView
 */
- (instancetype)initWithTitle:(NSString *)title;

/**
 * A method that displays the loading view with an animated activity indicator and an optional title
 */
- (void)startLoading;

/**
 * A method that hides the loading view
 */
- (void)stopLoading;

@end
