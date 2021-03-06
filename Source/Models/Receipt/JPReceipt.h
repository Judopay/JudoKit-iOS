//
//  JPReceipt.h
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

#import "Typedefs.h"
#import <Foundation/Foundation.h>

@class JPResponse, JPPagination, JPSession;

/**
 *  You can get a copy of the receipt for an individual transaction by creating a Receipt Object and calling `.sendWithCompletion(() -> ())` including the receipt ID for the transaction in the path.
 Alternatively, you can receive a list of all the transactions. By default it will return 10 transactions. These results are returned in time-descending order by default, so it will return the latest 10 transactions.
 */
@interface JPReceipt : NSObject

/**
 *  the receipt ID - nil for a list of all receipts
 */
@property (nonatomic, strong, readonly) NSString *_Nullable receiptId;

/**
 *  Initialization for a Receipt Object, in case you want to use this function, you need to enable it in your judo Dashboard
 *
 *  @param receiptId the receipt ID as a String - if nil, completion function will return a list of all transactions
 *
 *  @return a Receipt Object for reactive usage
 */
- (nonnull instancetype)initWithReceiptId:(nullable NSString *)receiptId;

@end
