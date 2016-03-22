//
//  HintLabel.h
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

#import <UIKit/UIKit.h>

@class JPTheme;

/**
 *  Label that sits below the payment entry form, showing alerts and hints
 */
@interface HintLabel : UILabel

/**
 *  The hint text if a hint is being shown
 */
@property (nonatomic, strong) NSAttributedString *hintText;

/**
 *  The alert text if an alert occured
 */
@property (nonatomic, strong) NSAttributedString *alertText;

/**
 *  will return true if any of the texts is set
 */
@property (nonatomic, assign, readonly) BOOL isActive;

/**
 *  the current theme
 */
@property (nonatomic, strong) JPTheme *theme;


/**
 *  Makes the hint text visible in case there is no alert text occupying the space
 *
 *  @param hint The hint text string to show
 */
- (void)showHint:(NSString *)hint;

/**
 *  Hide the currently visible hint text and show the alert text if available
 */
- (void)hideHint;


/**
 *  Makes the alert text visible and overrides the hint text if it has been previously set and visible at the current time
 *
 *  @param alert The alert text string to show
 */
- (void)showAlert:(NSString *)alert;

/**
 *  Hide the currently visible alert text and show the hint text if available
 */
- (void)hideAlert;

@end
