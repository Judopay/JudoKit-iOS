//
//  SettingsViewController.swift
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

import InAppSettingsKit

class SettingsViewController: IASKAppSettingsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = nil

        if let defaults = settingsReader?.gatherDefaultsLimited(toEditableFields: true) {
            UserDefaults.standard.register(defaults: defaults)
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangeSettings),
                                               name: .IASKSettingChanged,
                                               object: nil)
    }

    @objc func didChangeSettings(_ notification: Notification) {

        guard notification.name == .IASKSettingChanged else {
            return
        }

        guard let setting =  notification.userInfo?.first else {
            return
        }

        if let key = setting.key as? String, key == kIsPaymentSessionOnKey {
            let hiddenKeys = computeHiddenKeys(from: [ key ])
            setHiddenKeys(hiddenKeys, animated: true)
        }

        if let key = setting.key as? String, key == kIsTokenAndSecretOnKey {
            let hiddenKeys = computeHiddenKeys(from: [ key ])
            setHiddenKeys(hiddenKeys, animated: true)
        }
    }
}
