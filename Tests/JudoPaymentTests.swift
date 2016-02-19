//
//  JudoPaymentTests.swift
//  JudoKitObjC
//
//  Created by Hamon Riazy on 17/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

import UIKit

import JudoKitObjC

import Quick
import Nimble

let globalToken = "3x2dQPx5HiyD1zir"
let globalSecret = "17aad220942556910e6c461bfb79b2c2d294a3de3c35c2f5484ba4d5dddadb93"

let globalJudoId = "100963875"
let globalAmount = JPAmount(amount: "1.00", currency: "GBP")
let globalConsumerReference = "consumer_00001"

class JudoPaymentTests: QuickSpec {
    
    override func spec() {
        var judoKitSession: JudoKit!
        
        beforeEach {
            judoKitSession = JudoKit(token: globalToken, secret: globalSecret)
            judoKitSession.currentAPISession.sandboxed = true
        }
        
        describe("when initializing a payment", { () -> Void in
            context("using values", { () -> Void in
                var runningPayment: JPPayment!
                
                beforeEach {
                    runningPayment = judoKitSession.paymentWithJudoId(globalJudoId, amount: globalAmount, consumerReference: globalConsumerReference)
                }
                
                it("should contain the correct values") { () -> () in
                    expect(runningPayment.judoId).to(equal(globalJudoId))
                    expect(runningPayment.amount).to(equal(globalAmount))
                    expect(runningPayment.reference.consumerReference).to(equal(globalConsumerReference))
                }
                
                it("should fail when trying to validate") { () -> () in
                    expect(runningPayment.validateTransaction()).notTo(beNil())
                }
            })
            
            it("should have the authentication headers set") { () -> () in
                expect(judoKitSession.currentAPISession.authorizationHeader).notTo(beNil())
            }
            
        })
        
        describe("When creating a Payment object", { () -> Void in
            
            var payment: JPPayment!
            
            beforeEach {
                payment = judoKitSession.paymentWithJudoId(globalJudoId, amount: JPAmount("10.00", currency: "GBP"), consumerReference:  globalConsumerReference)
            }
            
            describe("a payment", {
                it("should successfully transact with a visa card", closure: { () -> () in
                    payment.card = JPCard(cardNumber: "4976000000003436", expiryDate: "12/20", secureCode: "452")
                    
                })
            })
            
            
        })
        
    }
    
}
