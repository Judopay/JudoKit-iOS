//
//  JPPaymentMethodsPresenter.h
//  JudoKit-iOS
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
#import "JPTransactionStatusView.h"

@protocol JPPaymentMethodsView, JPPaymentMethodsInteractor, JPPaymentMethodsRouter;
@class JPPaymentMethodsCardModel;

@protocol JPPaymentMethodsPresenter

/**
 * A method that updates the view model with the latest state and refreshes the view
 */
- (void)viewModelNeedsUpdate;

/**
 * A method called once a card was selected from the list. This method updates the view model for that specific card
 * and changes its isSelected state.
 *
 * @param index - the index of the card that has been selected
 * @param isEditing - a boolean property that specifies if the card should be edited
 */
- (void)didSelectCardAtIndex:(NSUInteger)index
               isEditingMode:(BOOL)isEditing;

/**
 * A method called once the user selects a iDEAL bank from the bank list. This method updates the view model with
 * the selected bank.
 *
 * @param index - the index of the selected iDEAL bank
 */
- (void)didSelectBankAtIndex:(NSUInteger)index;

/**
 * A method that is called when the Back button is tapped. It handles the view dismissal flow
 */
- (void)handleBackButtonTap;

/**
 * A method that is called when the Pay button is tapped. It handles the payment / pre-auth transaction.
 */
- (void)handlePayButtonTap;

/**
 * A method that is called when the Apple Pay button is tapped. It handles the Apple Pay payment / pre-auth transaction.
 */
- (void)handleApplePayButtonTap;

/**
 * A method for deleting a specific card details from the keychain by its index
 *
 * @param index - Card's index in cards list
 */
- (void)deleteCardWithIndex:(NSUInteger)index;

/**
 * A method for chaging card header button title acording to edit status of the card list
 *
 * @param isEditing - card list edit status
 */
- (void)changeHeaderButtonTitle:(BOOL)isEditing;

/**
 * A method that handles payment method change events
 *
 * @param index - the index of the newly selected payment method
 */
- (void)changePaymentMethodToIndex:(NSUInteger)index;

/**
 * A method that sets the latest added card as selected
 */
- (void)setLastAddedCardAsSelected;

/**
 * A method that reorders cards so that the default card is always on top
*/
- (void)orderCards;

@end

@interface JPPaymentMethodsPresenterImpl : NSObject <JPPaymentMethodsPresenter>

/**
 * A weak reference to the view that adops the  JPPaymentMethodsView protocol
 */
@property (nonatomic, weak) id<JPPaymentMethodsView> _Nullable view;

/**
 * A strong reference to the router that adops the  JPPaymentMethodsRouter protocol
 */
@property (nonatomic, strong) id<JPPaymentMethodsRouter> _Nullable router;

/**
 * A strong reference to the interactor that adops the  JPPaymentMethodsInteractor protocol
 */
@property (nonatomic, strong) id<JPPaymentMethodsInteractor> _Nullable interactor;

@end
