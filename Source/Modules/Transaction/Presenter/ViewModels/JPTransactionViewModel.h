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

#import "JPCardDetailsMode.h"
#import "JPCardNetwork.h"
#import "JPInputType.h"
#import "JPTransactionType.h"
#import <Foundation/Foundation.h>

#pragma mark - JPTransactionInputFieldViewModel

@interface JPTransactionInputFieldViewModel : NSObject
/**
 * The type of the input field
 */
@property (nonatomic, assign) JPInputType type;

/**
 * Designated initializer that is configured based on an input type
 *
 * @param inputType - An instance of JPInputType that is used to define the view model
 */
+ (instancetype _Nonnull)viewModelWithType:(JPInputType)inputType;

/**
 * Designated initializer that is configured based on an input type
 *
 * @param inputType - An instance of JPInputType that is used to define the view model
 */
- (instancetype _Nonnull)initWithType:(JPInputType)inputType;

/**
 * The text string of the input field
 */
@property (nonatomic, strong) NSString *_Nullable text;

/**
 * The placeholder string of the input field
 */
@property (nonatomic, strong) NSString *_Nonnull placeholder;

/**
 * The error string of the input field
 */
@property (nonatomic, strong) NSString *_Nullable errorText;

@end

#pragma mark - JPTransactionNumberInputViewModel

@interface JPTransactionNumberInputViewModel : JPTransactionInputFieldViewModel

/**
 * The detected card network of the view model
 */
@property (nonatomic, assign) JPCardNetworkType cardNetwork;

@end

#pragma mark - JPTransactionButtonViewModel

@interface JPTransactionButtonViewModel : NSObject

/**
 * The title of the button
 */
@property (nonatomic, strong) NSString *_Nullable title;

/**
 * A boolean value that indicates if the button is enabled
 */
@property (nonatomic, assign) BOOL isEnabled;

@end

#pragma mark - JPTransactionPickerViewModel

@interface JPTransactionPickerViewModel : JPTransactionInputFieldViewModel

@end

#pragma mark - JPTransactionScanButtonViewModel

#pragma mark - JPTransactionViewModel

@interface JPTransactionViewModel : NSObject

/**
 * A enum parameter that tells the view of JPTransactionType
 */
@property (nonatomic, assign) JPTransactionType type;

/**
 * A enum parameter to specify the card details mode
 */
@property (nonatomic, assign) JPCardDetailsMode mode;

/**
 * An array of JPCountries that act as picker titles
 */
@property (nonatomic, strong) NSArray *_Nonnull pickerCountries;

/**
 * The JPTransactionInputFieldViewModel for the card number input field
 */
@property (nonatomic, strong) JPTransactionNumberInputViewModel *_Nonnull cardNumberViewModel;

/**
 * The JPTransactionInputFieldViewModel for the cardholder name input field
 */
@property (nonatomic, strong) JPTransactionInputFieldViewModel *_Nonnull cardholderNameViewModel;

/**
 * The JPTransactionInputFieldViewModel for the cardholder name email field
 */
@property (nonatomic, strong) JPTransactionInputFieldViewModel *_Nonnull cardholderEmailViewModel;

/**
 * The JPTransactionInputFieldViewModel for the cardholder name phone number field
 */
@property (nonatomic, strong) JPTransactionInputFieldViewModel *_Nonnull cardholderPhoneViewModel;

/**
 * The JPTransactionInputFieldViewModel for the cardholder name phone number field
 */
@property (nonatomic, strong) JPTransactionInputFieldViewModel *_Nonnull cardholderCityViewModel;

/**
 * The JPTransactionInputFieldViewModel for the cardholder adress line 1 input field
 */
@property (nonatomic, strong) JPTransactionInputFieldViewModel *_Nonnull cardholderAddressLine1ViewModel;

/**
 * The JPTransactionInputFieldViewModel for the cardholder adress line 2 input field
 */
@property (nonatomic, strong) JPTransactionInputFieldViewModel *_Nonnull cardholderAddressLine2ViewModel;

/**
 * The JPTransactionInputFieldViewModel for the cardholder adress line 3 input field
 */
@property (nonatomic, strong) JPTransactionInputFieldViewModel *_Nonnull cardholderAddressLine3ViewModel;

/**
 * The JPTransactionInputFieldViewModel for the cardholder phone code field
 */
@property (nonatomic, strong) JPTransactionInputFieldViewModel *_Nonnull cardholderPhoneCodeViewModel;

/**
 * The JPTransactionInputFieldViewModel for the expiry date input field
 */
@property (nonatomic, strong) JPTransactionInputFieldViewModel *_Nonnull expiryDateViewModel;

/**
 * The JPTransactionInputFieldViewModel for the secure code input field
 */
@property (nonatomic, strong) JPTransactionInputFieldViewModel *_Nonnull secureCodeViewModel;

/**
 * The JPTransactionPickerViewModel for the country picker
 */
@property (nonatomic, strong) JPTransactionInputFieldViewModel *_Nonnull countryPickerViewModel;

/**
 * The JPTransactionInputFieldViewModel for the postal code input field
 */
@property (nonatomic, strong) JPTransactionInputFieldViewModel *_Nonnull postalCodeInputViewModel;

/**
 * The JPTransactionButtonViewModel for the add card button
 */
@property (nonatomic, strong) JPTransactionButtonViewModel *_Nonnull addCardButtonViewModel;

/**
 * The JPTransactionButtonViewModel for the back from billing details button
 */
@property (nonatomic, strong) JPTransactionButtonViewModel *_Nonnull backButtonViewModel;

@end
