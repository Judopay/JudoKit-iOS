//
//  AppDelegate.swift
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

// Launch argument holding a settings JSON, base64 encoded, to import at launch. Lets UI tests set up
// the app in one step, e.g. `xcrun simctl launch <device> com.judo.JudoPayDemoSwift -importSettings
// <base64 JSON>`.
private let kImportSettingsArgument = "importSettings"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Runs before the scene connects, so the screens SceneDelegate builds read the imported settings.
        importSettingsFromLaunchArguments()
        return true
    }

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    private func importSettingsFromLaunchArguments() {
        let defaults = UserDefaults.standard
        // "-importSettings <value>" on the launch command line lands in the argument domain, which
        // lasts for this launch only.
        guard let encoded = defaults.volatileDomain(forName: UserDefaults.argumentDomain)[kImportSettingsArgument] as? String,
              !encoded.isEmpty else {
            return
        }

        guard let data = Data(base64Encoded: encoded, options: .ignoreUnknownCharacters),
              let json = String(data: data, encoding: .utf8) else {
            NSLog("SettingsImport: Settings import failed: invalid base64")
            return
        }

        do {
            try SettingsImporter.importSettings(json, into: defaults)
            NSLog("SettingsImport: Settings imported")
        } catch {
            NSLog("SettingsImport: Settings import failed: %@", error.localizedDescription)
        }
    }
}
