//
//  JPTransactionViewModel.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JPCountry, JPState;

typedef NS_ENUM(NSUInteger, JPInputType);
typedef NS_OPTIONS(NSUInteger, JPCardNetworkType);
typedef NS_ENUM(NSUInteger, JPTransactionType);
typedef NS_ENUM(NSUInteger, JPPresentationMode);

#pragma mark - JPTransactionInputFieldViewModel

@interface JPTransactionInputFieldViewModel : NSObject
/**
 * The type of the input field
 */
@property (nonatomic, assign) JPInputType type;

/**
 * The text string of the input field
 */
@property (nonatomic, strong, nullable) NSString *text;

/**
 * The placeholder string of the input field
 */
@property (nonatomic, strong, nullable) NSString *placeholder;

/**
 * The error string of the input field
 */
@property (nonatomic, strong, nullable) NSString *errorText;

@property (nonatomic, assign) BOOL isValid;

@property (nonatomic, assign) BOOL isEnabled;


/**
 * Designated initializer that is configured based on an input type
 *
 * @param inputType - An instance of JPInputType that is used to define the view model
 */
+ (instancetype)viewModelWithType:(JPInputType)inputType;

/**
 * Designated initializer that is configured based on an input type
 *
 * @param inputType - An instance of JPInputType that is used to define the view model
 */
- (instancetype)initWithType:(JPInputType)inputType;

@end

#pragma mark - JPTransactionNumberInputViewModel

@interface JPTransactionNumberInputViewModel : JPTransactionInputFieldViewModel

/**
 * The detected card network of the view model
 */
@property (nonatomic, assign) JPCardNetworkType cardNetwork;

@end

#pragma mark - JPTransactionOptionSelectionInputViewModel

@interface JPTransactionOptionSelectionInputViewModel<__covariant ObjectType> : JPTransactionInputFieldViewModel

/**
 * The options to select from
 */
@property (nonatomic, strong) NSArray<ObjectType> *options;

@end

#pragma mark - JPTransactionButtonViewModel

@interface JPTransactionButtonViewModel : NSObject

/**
 * The title of the button
 */
@property (nonatomic, strong, nullable) NSString *title;

/**
 * A boolean value that indicates if the button is enabled
 */
@property (nonatomic, assign) BOOL isEnabled;

@property (nonatomic, assign) BOOL isLoading;

/**
 * A boolean value that indicates if the button is hidden (ex.: functionality not available on device)
 */
@property (nonatomic, assign) BOOL isHidden;

@end

#pragma mark - JPTransactionScanCardButtonViewModel

@interface JPTransactionScanCardButtonViewModel : JPTransactionButtonViewModel

/**
 * The icon to be shown on the left
 */
@property (nonatomic, strong, nullable) UIImage *iconLeft;

@end

#pragma mark - JPTransactionSecurityMessageViewModel

@interface JPTransactionSecurityMessageViewModel : NSObject

/**
 * The icon to be shown on the left
 */
@property (nonatomic, strong) UIImage *iconLeft;

/**
 * The message text
 */
@property (nonatomic, strong) NSString *message;

@end

#pragma mark - JPTransactionCardDetailsViewModel

@interface JPTransactionCardDetailsViewModel : NSObject

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) JPTransactionButtonViewModel *cancelButtonViewModel;
@property (nonatomic, strong) JPTransactionScanCardButtonViewModel *scanCardButtonViewModel;

@property (nonatomic, strong) JPTransactionNumberInputViewModel *cardNumberViewModel;
@property (nonatomic, strong) JPTransactionInputFieldViewModel *cardholderNameViewModel;
@property (nonatomic, strong) JPTransactionInputFieldViewModel *expiryDateViewModel;
@property (nonatomic, strong) JPTransactionInputFieldViewModel *securityCodeViewModel;
@property (nonatomic, strong) JPTransactionOptionSelectionInputViewModel<JPCountry *> *countryViewModel;
@property (nonatomic, strong) JPTransactionInputFieldViewModel *postalCodeViewModel;

@property (nonatomic, strong) JPTransactionButtonViewModel *submitButtonViewModel;
@property (nonatomic, strong) JPTransactionSecurityMessageViewModel *securityMessageViewModel;

- (BOOL)isValid;

@end

#pragma mark - JPTransactionBillingInformationViewModel

@interface JPTransactionBillingInformationViewModel : NSObject

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) JPTransactionButtonViewModel *cancelButtonViewModel;

@property (nonatomic, strong) JPTransactionInputFieldViewModel *emailViewModel;
@property (nonatomic, strong) JPTransactionOptionSelectionInputViewModel<JPCountry *> *countryViewModel;
@property (nonatomic, strong) JPTransactionOptionSelectionInputViewModel<JPState *> *stateViewModel;
@property (nonatomic, strong) JPTransactionInputFieldViewModel *phoneCodeViewModel;
@property (nonatomic, strong) JPTransactionInputFieldViewModel *phoneViewModel;
@property (nonatomic, strong) JPTransactionInputFieldViewModel *addressLine1ViewModel;
@property (nonatomic, strong) JPTransactionInputFieldViewModel *addressLine2ViewModel;
@property (nonatomic, strong) JPTransactionInputFieldViewModel *addressLine3ViewModel;
@property (nonatomic, strong) JPTransactionInputFieldViewModel *cityViewModel;
@property (nonatomic, strong) JPTransactionInputFieldViewModel *postalCodeViewModel;

@property (nonatomic, strong) JPTransactionButtonViewModel *backButtonViewModel;
@property (nonatomic, strong) JPTransactionButtonViewModel *submitButtonViewModel;
 
- (BOOL)isValid;

@end

#pragma mark - JPTransactionViewModel

@interface JPTransactionViewModel : NSObject

/**
 * A enum parameter that tells the view of JPTransactionType
 */
@property (nonatomic, assign) JPTransactionType type;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) JPTransactionCardDetailsViewModel *cardDetailsViewModel;
@property (nonatomic, strong) JPTransactionBillingInformationViewModel *billingInformationViewModel;

/**
 * A enum parameter to specify the card details mode
 */
@property (nonatomic, assign) JPPresentationMode mode;

- (BOOL)shouldDisplayBillingInformationSection;

- (BOOL)isCardDetailsValid;

- (BOOL)isBillingInformationValid;

@end

NS_ASSUME_NONNULL_END
