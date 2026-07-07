import InAppSettingsKit
import UIKit

class SettingsViewController: IASKAppSettingsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = exportButton

        if let defaults = settingsReader?.gatherDefaultsLimited(toEditableFields: true) {
            UserDefaults.standard.register(defaults: defaults)
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangeSettings),
                                               name: .IASKSettingChanged,
                                               object: nil)
    }

    @objc func didChangeSettings(_ notification: Notification) {
        guard notification.name == .IASKSettingChanged, let key = notification.userInfo?.first?.key as? String else {
            return
        }

        if key == kIsPaymentSessionOnKey {
            setHiddenKeys(computeHiddenKeys(from: [key, kIsRecommendationOnKey, kIsAddressOnKey, kIsPrimaryAccountDetailsOnKey]), animated: true)
        } else if key == kIsTokenAndSecretOnKey {
            setHiddenKeys(computeHiddenKeys(from: [key, kIsRecommendationOnKey, kIsAddressOnKey, kIsPrimaryAccountDetailsOnKey]), animated: true)
        } else if key == kIsAddressOnKey || key == kIsPrimaryAccountDetailsOnKey || key == kIsRecommendationOnKey {
            setHiddenKeys(computeHiddenKeys(from: [
                kIsPaymentSessionOnKey,
                kIsTokenAndSecretOnKey,
                kIsRecommendationOnKey,
                kIsAddressOnKey,
                kIsPrimaryAccountDetailsOnKey
            ]),
            animated: true)
        }
    }

    private lazy var exportButton: UIBarButtonItem = {
        let exportIcon = UIImage(systemName: "square.and.arrow.up")
        let button = UIBarButtonItem(image: exportIcon,
                                     style: .done,
                                     target: self,
                                     action: #selector(didTapExportButton))
        button.accessibilityIdentifier = "Export settings button"
        return button
    }()

    @objc private func didTapExportButton() {
        UIPasteboard.general.string = SettingsImporter.export()
        let alert = UIAlertController(title: "Export Settings",
                                      message: "Settings JSON copied to clipboard.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
