//
//  JPPaymentMethodsInteractorMock.swift
//  JudoKitObjC
//
//  Created by Gheorghe Cojocaru on 2/20/20.
//  Copyright © 2020 Judo Payments. All rights reserved.
//

import Foundation

class JPPaymentMethodsInteractorMock: JPPaymentMethodsInteractor {
    func getStoredCardDetails() -> [JPStoredCardDetails]! {
        
        let calendar = Calendar.current
        
        let todaysDate = Date()
        let dateInTwoMonths = calendar.date(byAdding: .month, value: 1, to: todaysDate)!
        let expiredDate = calendar.date(byAdding: .month, value: -1, to: todaysDate)!
        let notExpiredDate = calendar.date(byAdding: .month, value: 3, to: todaysDate)!

        let dateFormater = DateFormatter()
        dateFormater.dateFormat = ("MM/yy")
        
        let expiresSoonDateAsString = dateFormater.string(from: dateInTwoMonths)
        let expiredDateAsString = dateFormater.string(from: expiredDate)
        let notExpiredDateAsString = dateFormater.string(from: notExpiredDate)
        
        
        let validCard = JPStoredCardDetails(lastFour: "1111", expiryDate: notExpiredDateAsString, cardNetwork: .networkVisa, cardToken: "token")!
        let expiresSoonCard = JPStoredCardDetails(lastFour: "1111", expiryDate: expiresSoonDateAsString, cardNetwork: .networkVisa, cardToken: "token")!
        let expirdCard = JPStoredCardDetails(lastFour: "1111", expiryDate: expiredDateAsString, cardNetwork: .networkVisa, cardToken: "token")!
        
        return [validCard, expiresSoonCard, expirdCard]
    }
    
    
    func selectCard(at index: Int) {
        
    }
    
    func getAmount() -> JPAmount! {
        let amount = JPAmount("1.0", currency: "EUR");
        return amount
    }
    
    func getPaymentMethods() -> [JPPaymentMethod]! {
        return [JPPaymentMethod.card()]
    }
    
    func paymentTransaction(withToken token: String!, andCompletion completion: JudoCompletionBlock!) {
        
    }
    
    func startApplePay(completion: JudoCompletionBlock!) {
        let response = JPResponse()
        completion(response,nil)
    }
    
    func deleteCard(with index: Int) {
        
    }
    
    func setCardAsSelectedAtInded(_ index: Int) {
        
    }
    
    func isApplePaySetUp() -> Bool {
        return false
    }
    
    func handle3DSecureTransaction(fromError error: Error!, completion: JudoCompletionBlock!) {
        
    }
    
    
}
