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

let globalJudoId = "100000009"

class JudoPaymentTests: QuickSpec {
    
    override func spec() {
        describe("A simple payment") { () -> Void in
            
            var judoKitSession: JudoKit!
            
            beforeEach { judoKitSession = JudoKit(token: "", secret: "") }
            
            describe("initializing", { () -> Void in
                context("When its initialized using values", { () -> Void in
                    let runningPayment = judoKitSession.paymentWithJudoId(globalJudoId)
                    
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
            
        }
    }
    
}
