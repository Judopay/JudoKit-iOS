//
//  CardInputField.m
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

#import "CardInputField.h"

#import "NSString+Card.h"

#import "FloatingTextField.h"

#import "JPCard.h"
#import "JPTheme.h"
#import "CardLogoView.h"

@implementation CardInputField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *oldString = textField.text;
    NSString *newString = [oldString stringByReplacingCharactersInRange:range withString:string];
    
    if (!newString.length || !string.length) {
        return YES;
    }
    
    NSError *error = nil;
    
    NSString *cardPresentationString = [newString cardPresentationStringWithAcceptedNetworks:self.theme.acceptedCardNetworks error:&error];
    
    // TODO: need to add an error case here
    
    if (cardPresentationString) {
        [self dismissError];
    }
    
    return YES;
}

- (BOOL)isValid {
    return self.isTokenPayment || self.textField.text.isCardNumberValid;
}

- (NSAttributedString *)placeholder {
    return [[NSAttributedString alloc] initWithString:self.title attributes:@{NSForegroundColorAttributeName:self.theme.judoLightGrayColor}];
}

- (BOOL)containsLogo {
    return YES;
}

- (CardLogoView *)logoView {
    return [[CardLogoView alloc] initWithType:[CardInputField cardLogoTypeForNetworkType:self.cardNetwork]];
}

- (NSString *)title {
    return @"Card number";
}

- (NSString *)hintLabelText {
    return @"Long card number";
}

+ (CardLogoType)cardLogoTypeForNetworkType:(CardNetwork)network {
    switch (network) {
        case CardNetworkVisa:
        case CardNetworkVisaDebit:
        case CardNetworkVisaElectron:
        case CardNetworkVisaPurchasing:
            return CardLogoTypeVisa;
        case CardNetworkMasterCard:
        case CardNetworkMasterCardDebit:
            return CardLogoTypeMasterCard;
        case CardNetworkAMEX:
            return CardLogoTypeAMEX;
        case CardNetworkMaestro:
            return CardLogoTypeMaestro;
        default:
            return CardLogoTypeUnknown;
    }
}

@end
