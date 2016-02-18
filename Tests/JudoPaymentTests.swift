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
let globalConsumerReference = "consumer_00001"

class JudoPaymentTests: QuickSpec {
    
    override func spec() {
        describe("A simple payment") { () -> Void in
            
            var judoKitSession: JudoKit!
            
            beforeEach { judoKitSession = JudoKit(token: "", secret: "") }
            
            describe("initializing", { () -> Void in
                context("When its initialized using values", { () -> Void in
                    var runningPayment: JPPayment!
                    
                    beforeEach { runningPayment = judoKitSession.paymentWithJudoId(globalJudoId) }
                    
                    it("should contain the right values", closure: { () -> () in
                        expect(runningPayment.judoId).to(equal(globalJudoId))
                        expect(runningPayment.amount).to(beNil())
                        expect(runningPayment.reference).to(beNil())
                    })
                    
                    it("should fail when trying to validate", closure: { () -> () in
                        expect(runningPayment.validateTransaction()).notTo(beNil())
                    })
                })
                
                it("should have the auth header set", closure: { () -> () in
                    expect(judoKitSession.currentAPISession.authorizationHeader).notTo(beNil())
                })
                
            })
            
            describe("When creating a Payment object", { () -> Void in
                
                var payment: JPPayment!
                
                beforeEach {
                    payment = judoKitSession.paymentWithJudoId(globalJudoId)
                    payment.reference = JPReference.consumerReference(globalConsumerReference)
                    payment.amount = JPAmount("10.00", currency: "GBP")
                }
                
                describe("a payment", { 
                    it("should successfully transact with a visa card", closure: { () -> () in
                        payment.card = JPCard(cardNumber: "4976000000003436", expiryDate: "12/20", secureCode: "452")
                        
                        var result: JPResponse?
                        
                        expect(result).toNotEventually(beNil())
                        
                        payment.sendWithCompletion({ (response, error) -> Void in
                            result = response
                        })
                    })
                })
                
                
            })
            
        }
    }
    
}
