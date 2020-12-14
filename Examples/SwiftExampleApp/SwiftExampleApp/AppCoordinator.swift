//
//  AppCoordinator.swift
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

enum AppScreen {
    case home
    case settings
    case results(Result)
    case tokenTransactions
    case payByBankApp
}

protocol Coordinator: class {
    func start()
    func start(with deeplinkURL: URL)
    func pushTo(_ screen: AppScreen)
    func pop()
}

class AppCoordinator: Coordinator {

    // MARK: - Variables

    private let window: UIWindow
    private let featureService: FeatureService
    private let featureRepository: FeatureRepository
    private let homeModule: HomeModule
    private let settingsModule: SettingsModule
    private let tokenModule: TokenModule
    private let pbbaModule: PBBAModule

    // MARK: - Initializers

    init(window: UIWindow) {
        self.window = window

        featureService = FeatureService()
        featureRepository = FeatureRepository()

        homeModule = HomeModule.make(with: featureRepository, service: featureService)
        settingsModule = SettingsModule.make()
        tokenModule = TokenModule.make(with: featureService)
        pbbaModule = PBBAModule.make(with: featureService)
    }

    // MARK: - Protocol methods

    func start() {
        homeModule.rootViewController.coordinator = self
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func start(with deeplinkURL: URL) {
        homeModule.rootViewController.coordinator = self
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        homeModule.rootViewController.handlePBBAStatus(with: deeplinkURL)
    }

    func pushTo(_ screen: AppScreen) {
        switch screen {
        case .home:
            navigationController.pushViewController(homeModule.rootViewController,
                                                    animated: true)
        case .settings:
            navigationController.pushViewController(settingsModule.rootViewController,
                                                    animated: true)
        case .results(let result):
            let resultsModule = ResultsModule.make(with: result)
            resultsModule.rootViewController.coordinator = self
            navigationController.pushViewController(resultsModule.rootViewController,
                                                    animated: true)
        case .tokenTransactions:
            tokenModule.rootViewController.coordinator = self
            navigationController.pushViewController(tokenModule.rootViewController,
                                                    animated: true)
        case .payByBankApp:
            pbbaModule.rootViewController.coordinator = self
            navigationController.pushViewController(pbbaModule.rootViewController,
                                                    animated: true)
        }
    }

    func pop() {
        navigationController.popViewController(animated: true)
    }

    private lazy var navigationController: UINavigationController = {
        let rootController = homeModule.rootViewController
        let navController = UINavigationController(rootViewController: rootController)
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }()
}
