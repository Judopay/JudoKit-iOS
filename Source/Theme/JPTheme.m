//
//  JPTheme.m
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

#import "JPTheme.h"

#import "CardNetwork.h"

@implementation JPTheme

- (NSArray *)acceptedCardNetworks {
    if (!_acceptedCardNetworks) {
        _acceptedCardNetworks = @[@(CardNetworkVisa), @(CardNetworkMasterCard)];
    }
    return _acceptedCardNetworks;
}

- (UIColor *)tintColor {
    if (!_tintColor) {
        _tintColor = [UIColor colorWithRed:30/255.0f green:120/255.0f blue:160/255.0f alpha:1.0f];
    }
    return _tintColor;
}

- (NSString *)paymentButtonTitle {
    if (_paymentButtonTitle) {
        _paymentButtonTitle = @"Pay";
    }
    return _paymentButtonTitle;
}

- (NSString *)registerCardButtonTitle {
	if (!_registerCardButtonTitle) {
		_registerCardButtonTitle = @"Add card";
	}
	return _registerCardButtonTitle;
}

- (NSString *)registerCardNavBarButtonTitle {
    if (!_registerCardNavBarButtonTitle) {
        _registerCardNavBarButtonTitle = @"Add";
    }
    return _registerCardNavBarButtonTitle;
}

- (NSString *)backButtonTitle {
	if (!_backButtonTitle) {
		_backButtonTitle = @"Back";
	}
	return _backButtonTitle;
}

- (NSString *)paymentTitle {
	if (!_paymentTitle) {
		_paymentTitle = @"Payment";
    }
	return _paymentTitle;
}

- (NSString *)registerCardTitle {
	if (!_registerCardTitle) {
		_registerCardTitle = @"Add card";
	}
	return _registerCardTitle;
}

- (NSString *)refundTitle {
	if (!_refundTitle) {
		_refundTitle = @"Refund";
	}
	return _refundTitle;
}

- (NSString *)authenticationTitle {
	if (!_authenticationTitle) {
		_authenticationTitle = @"Authentication";
	}
	return _authenticationTitle;
}

- (NSString *)loadingIndicatorRegisterCardTitle {
	if (!_loadingIndicatorRegisterCardTitle) {
		_loadingIndicatorRegisterCardTitle = @"Adding card...";
	}
	return _loadingIndicatorRegisterCardTitle;
}

- (NSString *)loadingIndicatorProcessingTitle {
	if (!_loadingIndicatorProcessingTitle) {
		_loadingIndicatorProcessingTitle = @"Processing payment...";
	}
	return _loadingIndicatorProcessingTitle;
}

- (NSString *)redirecting3DSTitle {
	if (!_redirecting3DSTitle) {
		_redirecting3DSTitle = @"Redirecting...";
	}
	return _redirecting3DSTitle;
}

- (NSString *)verifying3DSPaymentTitle {
	if (!_verifying3DSPaymentTitle) {
		_verifying3DSPaymentTitle = @"Verifying payment";
	}
	return _verifying3DSPaymentTitle;
}

- (NSString *)verifying3DSRegisterCardTitle {
	if (!_verifying3DSRegisterCardTitle) {
		_verifying3DSRegisterCardTitle = @"Verifying card";
	}
	return _verifying3DSRegisterCardTitle;
}

- (CGFloat)inputFieldHeight {
    if (_inputFieldHeight == 0) {
        _inputFieldHeight = 48;
    }
    return _inputFieldHeight;
}

- (NSString *)securityMessageString {
	if (!_securityMessageString) {
		_securityMessageString = @"Your card details are encrypted using SSL before transmission to our secure payment service provider. They will not be stored on this device or on our servers.";
	}
	return _securityMessageString;
}

- (CGFloat)securityMessageTextSize {
    if (_securityMessageTextSize == 0) {
        _securityMessageTextSize = 12;
    }
    return _securityMessageTextSize;
}

@end
