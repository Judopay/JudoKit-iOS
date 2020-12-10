//
//  AppCoordinator.swift
//  SwiftExampleApp
//
//  Created by Mihai Petrenco on 12/9/20.
//  Copyright © 2020 Judopay. All rights reserved.
//

import UIKit

enum AppScreen {
    case home
    case settings
}

protocol Coordinator: class {
    func start()
    func pushTo(_ screen: AppScreen)
    func pop()
}

class AppCoordinator: Coordinator {

    private let window: UIWindow
    private let homeModule = HomeModule.make()
    private let settingsModule = SettingsModule.make()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        homeModule.rootViewController.coordinator = self
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func pushTo(_ screen: AppScreen) {
        switch screen {
        case .home:
            navigationController.pushViewController(homeModule.rootViewController,
                                                    animated: true)
        case .settings:
            navigationController.pushViewController(settingsModule.rootViewController,
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
