//
//  JP3DSService.h
//  JudoKitObjC
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

#import "JPSession.h"
#import "JPTransaction.h"
#import <Foundation/Foundation.h>

@interface JP3DSService : NSObject

/**
 * An instance of JPTransaction which will be used to send a 3DS request to the Judo backend
 */
@property (nonatomic, strong) JPTransaction *transaction;

/**
 * A method for invoking the 3D Secure View Controller based on a 3DS Error
 *
 * @param error - an instance of NSError which contains the 3D Secure payload (PaRes, MD, ACS URL, Receipt ID)
 * @param completion - a completion handler with an optional JPResponse / NSError
 */
- (void)invoke3DSecureViewControllerWithError:(NSError *)error
                                   completion:(JudoCompletionBlock)completion;

@end
