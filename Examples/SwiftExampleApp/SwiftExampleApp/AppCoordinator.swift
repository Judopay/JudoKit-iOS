import UIKit

enum AppScreen {
    case home
    case settings
    case results(Result)
    case tokenTransactions
    case noUICardPay
    case payByBankApp
    case applePay
}

protocol Coordinator: AnyObject {
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
    private let noUICardPayModule: NoUICardPayModule
    private let pbbaModule: PBBAModule
    private let applePayModule: ApplePayModule

    // MARK: - Initializers

    init(window: UIWindow) {
        self.window = window

        featureService = FeatureService()
        featureRepository = FeatureRepository()

        homeModule = HomeModule.make(with: featureRepository, service: featureService)
        settingsModule = SettingsModule.make()
        tokenModule = TokenModule.make(with: featureService)
        noUICardPayModule = NoUICardPayModule.make(with: featureService)
        pbbaModule = PBBAModule.make(with: featureService)
        applePayModule = ApplePayModule.make()
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
            navigationController.pushViewController(homeModule.rootViewController, animated: true)
        case .settings:
            navigationController.pushViewController(settingsModule.rootViewController, animated: true)
        case let .results(result):
            let resultsModule = ResultsModule.make(with: result)
            resultsModule.rootViewController.coordinator = self
            navigationController.pushViewController(resultsModule.rootViewController, animated: true)
        case .tokenTransactions:
            tokenModule.rootViewController.coordinator = self
            navigationController.pushViewController(tokenModule.rootViewController, animated: true)
        case .noUICardPay:
            noUICardPayModule.coordinator = self
            navigationController.pushViewController(noUICardPayModule.rootViewController, animated: true)
        case .payByBankApp:
            pbbaModule.rootViewController.coordinator = self
            navigationController.pushViewController(pbbaModule.rootViewController, animated: true)
        case .applePay:
            navigationController.pushViewController(applePayModule.rootViewController, animated: true)
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
