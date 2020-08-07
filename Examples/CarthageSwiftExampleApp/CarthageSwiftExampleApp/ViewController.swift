//
//  ViewController.swift
//  CarthageSwiftExampleApp
//
//  Copyright © 2020 Alternative Payments Ltd. All rights reserved.
//

import UIKit
import JudoKit_iOS

class ViewController: UIViewController {
    lazy var judoKit = JudoKit(authorization: JPBasicAuthorization(token: "your-token", andSecret: "your-secret"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func invokeJudoKit(_ sender: Any) {
        let amount = JPAmount(amount: "1.5", currency: "GBP")
        let reference = JPReference.init(consumerReference: "ref-here")
        let configuration = JPConfiguration(judoID: "121212", amount: amount, reference:reference)
        judoKit?.invokeTransaction(with: .payment,
                                   configuration: configuration,
                                   completion: { (response, error) in
                                    //todo: handle this callback
        })
    }
    
}
