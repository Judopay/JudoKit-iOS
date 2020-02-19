//
//  JPPaymentMethodsViewControllerMock.swift
//  JudoKitObjC
//
//  Created by Gheorghe Cojocaru on 2/20/20.
//  Copyright © 2020 Judo Payments. All rights reserved.
//

import Foundation

@objc class JPPaymentMethodsViewControllerMock: UIViewController, JPPaymentMethodsView {
    
    var cardsList:[JPPaymentMethodsCardModel] = []
    
    func configure(with viewModel: JPPaymentMethodsViewModel!) {
        for card in viewModel.items!{
            if (type(of: card) == JPPaymentMethodsCardListModel.self){
                let cardList = card as! JPPaymentMethodsCardListModel
                cardsList = cardList.cardModels as! [JPPaymentMethodsCardModel]
            }
        }
    }
    

    func displayAlert(withTitle title: String!, andError error: Error!) {
        
    }
    
    
}
