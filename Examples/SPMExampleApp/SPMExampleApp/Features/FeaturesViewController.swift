import Foundation
import UIKit
import SwiftUI

import JudoKit_iOS

class FeaturesViewController: UIViewController {
    
    @AppStorage("isSanboxed")
    private var isSandboxed = true

    @AppStorage("judoId")
    private var judoId = ""

    @AppStorage("token")
    private var token = ""

    @AppStorage("secret")
    private var secret = ""

    @AppStorage("amount")
    private var amount = "1.50"
    
    @AppStorage("currency")
    private var currency = "GBP"
    
    @AppStorage("merchantId")
    private var merchantId = "merchant.cybersourceshodanapplepay"

    @AppStorage("consumerReference")
    private var consumerReference = "my-consumer-reference"

    private var hostingController: UIHostingController<FeaturesView>?
    
    private var response: JPResponse?
    private var error: JPError?

    private lazy var judoKit: JudoKit? = {
        let kit = JudoKit(authorization: JPBasicAuthorization(token: token, andSecret: secret))
        return kit
    }()
        
    private var configuration: JPConfiguration {
        let item = JPPaymentSummaryItem(label: "My Item", amount: NSDecimalNumber(string: amount), type: .final)
        
        let configuration = JPConfiguration(judoID: judoId,
                                            amount: JPAmount(amount, currency: currency),
                                            reference: JPReference(consumerReference: consumerReference))
        
        configuration.applePayConfiguration = JPApplePayConfiguration(merchantId: merchantId,
                                                                      currency: currency,
                                                                      countryCode: "GB",
                                                                      paymentSummaryItems: [item])
        return configuration
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hostingController = hostSwiftUIView(view: FeaturesView(onFeatureTap: { [unowned self] type, isPreauth in
            self.invokeApplePay(type, isPreauth)
        }))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.judoKit?.isSandboxed = isSandboxed
        self.judoKit?.authorization = JPBasicAuthorization(token: token, andSecret: secret)
    }
    
    private func invokeApplePay(_ type: FeatureType, _ isPreauth: Bool) {
        switch type {
        case .basic:
            self.invokeBasicApplePay(isPreauth)
            
        case .customPresentation:
            self.invokeCustomApplePay(isPreauth)
            
        case .basicAsyncAwait:
            self.invokeBasicApplePayAsyncAwait(isPreauth)
            
        case .customPresentationAsyncAwait:
            self.invokeCustomApplePayAsyncAwait(isPreauth)
        }
    }
    
    // MARK: ApplePay - async/await wrappers
    @MainActor
    private func invokeBasicApplePayAsyncAwait(_ isPreauth: Bool) async -> (JPResponse?, JPError?) {
        await withCheckedContinuation { [unowned self] continuation in
            self.judoKit?.invokeApplePay(with: isPreauth ? .preAuth : .payment,
                                              configuration: configuration,
                                              completion: { response, error in
                continuation.resume(returning: (response, error))
            })
        }
    }
    
    @MainActor
    private func presentApplePayViewControllerAsyncAwait(_ isPreauth: Bool) async -> (JPResponse?, JPError?) {
        await withCheckedContinuation { [unowned self] continuation in
            let controller = self.judoKit?.applePayViewController(
                with: isPreauth ? .preAuth : .payment,
                configuration: configuration,
                completion: { response, error in
                    continuation.resume(returning: (response, error))
                }
            )
            
            guard let applePayViewController = controller else {
                let code = Int(JudoError.JudoParameterError.rawValue)
                let userInfo = [
                    NSLocalizedDescriptionKey: "Apple Pay transaction failed",
                    NSLocalizedFailureReasonErrorKey: "Failed to instanciate the Apple Pay view controller"
                ]
                
                let error = JPError(domain: JudoErrorDomain, code: code, userInfo: userInfo)
                
                continuation.resume(returning: (nil, error))
                
                return
            }
            
            self.present(applePayViewController, animated: true)
        }
    }
    
    private func invokeBasicApplePayAsyncAwait(_ isPreauth: Bool) {
        Task { [unowned self] in
            let (response, error) = await invokeBasicApplePayAsyncAwait(isPreauth)
            self.onComplete(withResponse: response, and: error)
        }
    }
    
    private func invokeCustomApplePayAsyncAwait(_ isPreauth: Bool) {
        Task { [unowned self] in
            let (response, error) = await presentApplePayViewControllerAsyncAwait(isPreauth)
            self.onComplete(withResponse: response, and: error)
        }
    }
    
    // MARK: ApplePay - completion handler-style API
    
    private func invokeBasicApplePay(_ isPreauth: Bool) {
        self.judoKit?.invokeApplePay(with: isPreauth ? .preAuth : .payment,
                                     configuration: configuration,
                                     completion: { [unowned self] response, error in
            self.onComplete(withResponse: response, and: error)
        })
    }
    
    private func invokeCustomApplePay(_ isPreauth: Bool) {
        let controller = self.judoKit?.applePayViewController(with: isPreauth ? .preAuth : .payment,
                                                              configuration: configuration,
                                                              completion: { [unowned self] response, error in
            self.onComplete(withResponse: response, and: error)
        })
        
        self.present(controller!, animated: true)
    }
    
    // MARK: Navigation & Helpers
    
    private func onComplete(withResponse response: JPResponse?, and error: JPError?) {
        self.error = error
        self.response = response
        
        self.performSegue(withIdentifier: "resultSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultSegue" {
            if let destinationVC = segue.destination as? ResultViewController {
                destinationVC.response = self.response
                destinationVC.error = self.error
            }
        }
    }
}
