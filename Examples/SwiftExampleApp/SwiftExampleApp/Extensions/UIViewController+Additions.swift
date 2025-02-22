//
//  UIViewController+Additions.swift
//  SwiftExampleApp
//
//  Copyright (c) 2020 Alternative Payments Ltd
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

import UIKit

extension UIViewController {

    typealias TextInputCompletion = (String) -> Void

    func displayErrorAlert(with error: NSError) {
        let alertController = UIAlertController(title: error.localizedDescription,
                                                message: error.localizedFailureReason,
                                                preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(confirmAction)

        present(alertController, animated: true, completion: nil)
    }

    func displayInputAlert(with title: String,
                           placeholder: String?,
                           completion: @escaping TextInputCompletion) {

        let alertController = UIAlertController(title: title,
                                                message: nil,
                                                preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = placeholder
        }

        let confirmAction = UIAlertAction(title: "Done", style: .default) { _ in
            if let textField = alertController.textFields?.first,
               let text = textField.text, !text.isEmpty {
               completion(text)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    @objc func presentNetworkRequestsInspector() {
        let name = NSNotification.Name(rawValue: "wormholy_fire")
        NotificationCenter.default.post(name: name, object: nil)
    }
}
