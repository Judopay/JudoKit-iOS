//
//  JPTransactionViewModel.m
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

#import "JPTransactionViewModel.h"
#import "JPInputType.h"
#import "UIImage+Additions.h"
#import "NSString+Additions.h"
#import "JPPresentationMode.h"

#pragma mark - JPTransactionInputFieldViewModel

@implementation JPTransactionInputFieldViewModel

+ (instancetype)viewModelWithType:(JPInputType)inputType {
    return [[JPTransactionInputFieldViewModel alloc] initWithType:inputType];
}

- (instancetype)initWithType:(JPInputType)inputType {
    if (self = [super init]) {
        self.type = inputType;
    }
    return self;
}

@end

#pragma mark - JPTransactionNumberInputViewModel

@implementation JPTransactionNumberInputViewModel

@end

#pragma mark - JPTransactionOptionSelectionInputViewModel

@implementation JPTransactionOptionSelectionInputViewModel

+ (instancetype)viewModelWithType:(JPInputType)inputType {
    return [[JPTransactionOptionSelectionInputViewModel alloc] initWithType:inputType];
}

@end

#pragma mark - JPTransactionButtonViewModel

@implementation JPTransactionButtonViewModel

@end

#pragma mark - JPTransactionScanCardButtonViewModel

@implementation JPTransactionScanCardButtonViewModel

- (instancetype)init {
    if (self = [super init]) {
        _iconLeft = [UIImage _jp_imageWithIconName:@"scan-card"];
        super.title = @"button_scan_card"._jp_localized.uppercaseString;
    }
    
    return self;
}

@end

#pragma mark - JPTransactionSecurityMessageViewModel

@implementation JPTransactionSecurityMessageViewModel

- (instancetype)init {
    if (self = [super init]) {
        _message = @"secure_server_transmission"._jp_localized;
        _iconLeft = [UIImage _jp_imageWithIconName:@"lock-icon"];
    }
    
    return self;
}

@end

#pragma mark - JPTransactionCardDetailsViewModel

@implementation JPTransactionCardDetailsViewModel

- (instancetype)init {
    if (self = [super init]) {
        _cancelButtonViewModel = [JPTransactionButtonViewModel new];
        _scanCardButtonViewModel = [JPTransactionScanCardButtonViewModel new];

        _cardNumberViewModel     = [JPTransactionNumberInputViewModel new];
        _cardholderNameViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardholderName];
        _expiryDateViewModel     = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardExpiryDate];
        _securityCodeViewModel   = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardSecureCode];
        _countryViewModel        = [JPTransactionOptionSelectionInputViewModel viewModelWithType:JPInputTypeCardAVSCountry];
        _postalCodeViewModel     = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeCardAVSPostalCode];

        _submitButtonViewModel    = [JPTransactionButtonViewModel new];
        _securityMessageViewModel = [JPTransactionSecurityMessageViewModel new];
    }
    
    return self;
}

- (void)setIsLoading:(BOOL)isLoading {
    _isLoading = isLoading;
    
    self.submitButtonViewModel.isLoading = isLoading;
    
    BOOL isEnabled = !isLoading;
    
    self.cancelButtonViewModel.isEnabled = isEnabled;
    self.scanCardButtonViewModel.isEnabled = isEnabled;
    
    self.cardNumberViewModel.isEnabled = isEnabled;
    self.cardholderNameViewModel.isEnabled = isEnabled;
    self.expiryDateViewModel.isEnabled = isEnabled;
    self.securityCodeViewModel.isEnabled = isEnabled;
    self.countryViewModel.isEnabled = isEnabled;
    self.postalCodeViewModel.isEnabled = isEnabled;
}

@end

#pragma mark - JPTransactionBillingInformationViewModel

@implementation JPTransactionBillingInformationViewModel
 
- (instancetype)init {
    if (self = [super init]) {
        _cancelButtonViewModel = [JPTransactionButtonViewModel new];

        _emailViewModel        = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeBillingEmail];
        _countryViewModel      = [JPTransactionOptionSelectionInputViewModel viewModelWithType:JPInputTypeBillingCountry];
        _stateViewModel        = [JPTransactionOptionSelectionInputViewModel viewModelWithType:JPInputTypeBillingState];
        _phoneCodeViewModel    = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeBillingPhoneCode];
        _phoneViewModel        = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeBillingPhone];
        _addressLine1ViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeBillingAddressLine1];
        _addressLine2ViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeBillingAddressLine2];
        _addressLine3ViewModel = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeBillingAddressLine3];
        _cityViewModel         = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeBillingCity];
        _postalCodeViewModel   = [JPTransactionInputFieldViewModel viewModelWithType:JPInputTypeBillingPostalCode];

        _backButtonViewModel   = [JPTransactionButtonViewModel new];
        _submitButtonViewModel = [JPTransactionButtonViewModel new];
    }
    
    return self;
}

- (void)setIsLoading:(BOOL)isLoading {
    _isLoading = isLoading;
    
    self.submitButtonViewModel.isLoading = isLoading;
    
    BOOL isEnabled = !isLoading;

    self.cancelButtonViewModel.isEnabled = isEnabled;
    self.backButtonViewModel.isEnabled = isEnabled;
    
    self.emailViewModel.isEnabled = isEnabled;
    self.countryViewModel.isEnabled = isEnabled;
    self.stateViewModel.isEnabled = isEnabled;
    self.phoneCodeViewModel.isEnabled = isEnabled;
    self.phoneViewModel.isEnabled = isEnabled;
    self.addressLine1ViewModel.isEnabled = isEnabled;
    self.addressLine2ViewModel.isEnabled = isEnabled;
    self.addressLine3ViewModel.isEnabled = isEnabled;
    self.cityViewModel.isEnabled = isEnabled;
    self.postalCodeViewModel.isEnabled = isEnabled;
}

@end

#pragma mark - JPTransactionViewModel

@implementation JPTransactionViewModel

- (instancetype)init {
    if (self = [super init]) {
        _cardDetailsViewModel = [JPTransactionCardDetailsViewModel new];
        _billingInformationViewModel = [JPTransactionBillingInformationViewModel new];
    }
    
    return self;
}

- (BOOL)shouldDisplayBillingInformationSection {
    return self.mode == JPPresentationModeBillingInfo
    || self.mode == JPPresentationModeCardAndBillingInfo
    || self.mode == JPPresentationModeSecurityCodeAndBillingInfo
    || self.mode == JPPresentationModeCardholderNameAndBillingInfo
    || self.mode == JPPresentationModeSecurityCodeAndCardholderNameAndBillingInfo;
}

- (void)setIsLoading:(BOOL)isLoading {
    _isLoading = isLoading;
    self.billingInformationViewModel.isLoading = isLoading;
    self.cardDetailsViewModel.isLoading = isLoading;
}

- (BOOL)isCardDetailsValid {
    JPTransactionCardDetailsViewModel *viewModel = self.cardDetailsViewModel;
    
    switch (self.mode) {
        case JPPresentationModeCardInfo:
        case JPPresentationModeCardInfoAndAVS:
        case JPPresentationModeCardAndBillingInfo: {
            BOOL isValid = viewModel.cardNumberViewModel.isValid
                         && viewModel.cardholderNameViewModel.isValid
                         && viewModel.expiryDateViewModel.isValid
                         && viewModel.securityCodeViewModel.isValid;
            
            if (self.mode == JPPresentationModeCardInfoAndAVS) {
                isValid &= viewModel.countryViewModel.isValid
                        && viewModel.postalCodeViewModel.isValid;
            }
            
            return isValid;
        }
        
        case JPPresentationModeSecurityCode:
        case JPPresentationModeSecurityCodeAndBillingInfo:
            return viewModel.securityCodeViewModel.isValid;
        
        case JPPresentationModeCardholderName:
        case JPPresentationModeCardholderNameAndBillingInfo:
            return viewModel.cardholderNameViewModel.isValid;
            
        case JPPresentationModeSecurityCodeAndCardholderName:
        case JPPresentationModeSecurityCodeAndCardholderNameAndBillingInfo:
            return viewModel.securityCodeViewModel.isValid && viewModel.cardholderNameViewModel.isValid;
            
        default:
            return NO;
    }
}

- (BOOL)isBillingInformationValid {
    JPTransactionBillingInformationViewModel *viewModel = self.billingInformationViewModel;

    return viewModel.emailViewModel.isValid
        && viewModel.countryViewModel.isValid
        && viewModel.stateViewModel.isValid
        && viewModel.addressLine1ViewModel.isValid
        && viewModel.addressLine2ViewModel.isValid
        && viewModel.addressLine3ViewModel.isValid
        && viewModel.phoneViewModel.isValid
        && viewModel.cityViewModel.isValid
        && viewModel.postalCodeViewModel.isValid;
}

@end
