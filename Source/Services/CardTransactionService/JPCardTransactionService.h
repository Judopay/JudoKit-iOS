//
//  JPCardTransactionService.h
//  JudoKit_iOS
//
//  Copyright (c) 2022 Alternative Payments Ltd
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

#import "JPAuthorization.h"
#import "Typedefs.h"
#import <Foundation/Foundation.h>
#import <Judo3DS2_iOS/Judo3DS2_iOS.h>

@class JPConfiguration, JPCardTransactionDetails, JPApiService;

@interface JP3DSChallengeStatusReceiverImpl : NSObject <JP3DSChallengeStatusReceiver>

@property (strong, nonatomic, nonnull) JPApiService *apiService;
@property (strong, nonatomic, nonnull) JPCompletionBlock completion;
@property (strong, nonatomic, nonnull) JPCardTransactionDetails *details;
@property (strong, nonatomic, nonnull) JPResponse *response;

- (nonnull instancetype)initWithApiService:(nonnull JPApiService *)apiService
                                   details:(nonnull JPCardTransactionDetails *)details
                                  response:(nonnull JPResponse *)response
                             andCompletion:(nonnull JPCompletionBlock)completion;

- (void)performComplete3DS2WithChallengeStatus:(NSString *_Nonnull)status;
@end

NSString *_Nonnull buildEventString(NSString *_Nonnull eventType, NSDictionary<NSString *, id> *_Nonnull pairs);

@protocol JPFormattedString <NSObject>
- (NSString *_Nonnull)toFormattedEventString;
@end

@interface JP3DSCompletionEvent (FormattedString) <JPFormattedString>
@end

@interface JP3DSProtocolErrorEvent (FormattedString) <JPFormattedString>
@end

@interface JP3DSRuntimeErrorEvent (FormattedString) <JPFormattedString>
@end

@interface JPCardTransactionService : NSObject

- (nonnull instancetype)initWithAPIService:(nonnull JPApiService *)apiService
                          andConfiguration:(nonnull JPConfiguration *)configuration;

- (nonnull instancetype)initWithAuthorization:(nonnull id<JPAuthorization>)authorization
                                  isSandboxed:(BOOL)sandboxed
                             andConfiguration:(nonnull JPConfiguration *)configuration;

- (void)invokePaymentWithDetails:(nonnull JPCardTransactionDetails *)details
                   andCompletion:(nonnull JPCompletionBlock)completion __attribute__((swift_async(none)));

- (void)invokePreAuthPaymentWithDetails:(nonnull JPCardTransactionDetails *)details
                          andCompletion:(nonnull JPCompletionBlock)completion __attribute__((swift_async(none)));

- (void)invokeTokenPaymentWithDetails:(nonnull JPCardTransactionDetails *)details
                        andCompletion:(nonnull JPCompletionBlock)completion __attribute__((swift_async(none)));

- (void)invokePreAuthTokenPaymentWithDetails:(nonnull JPCardTransactionDetails *)details
                               andCompletion:(nonnull JPCompletionBlock)completion __attribute__((swift_async(none)));

- (void)invokeSaveCardWithDetails:(nonnull JPCardTransactionDetails *)details
                    andCompletion:(nonnull JPCompletionBlock)completion __attribute__((swift_async(none)));

- (void)invokeCheckCardWithDetails:(nonnull JPCardTransactionDetails *)details
                     andCompletion:(nonnull JPCompletionBlock)completion __attribute__((swift_async(none)));

- (void)cleanup;

@end
