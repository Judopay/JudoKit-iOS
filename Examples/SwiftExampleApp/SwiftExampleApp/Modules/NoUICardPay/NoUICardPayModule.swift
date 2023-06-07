import SwiftUI

class NoUICardPayModule {
    // MARK: - Variables

    let rootViewController: UIHostingController<NoUICardPayView>
    var coordinator: Coordinator? {
        didSet {
            rootViewController.rootView.coordinator = coordinator
        }
    }

    // MARK: - Initializers

    private init(rootViewController: UIHostingController<NoUICardPayView>) {
        self.rootViewController = rootViewController
    }

    // MARK: - Public methods

    static func make(with featureService: FeatureService) -> NoUICardPayModule {
        let viewModel = NoUICardPayViewModel(featureService: featureService)
        let viewController = UIHostingController(rootView: NoUICardPayView(viewModel: viewModel))
        return NoUICardPayModule(rootViewController: viewController)
    }
}
