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
        guard notification.name == .IASKSettingChanged, let key = notification.userInfo?.first?.key as? String else {
            return
        }

        if key == kIsPaymentSessionOnKey {
            setHiddenKeys(computeHiddenKeys(from: [key, kIsAddressOnKey, kIsPrimaryAccountDetailsOnKey]), animated: true)
        } else if key == kIsTokenAndSecretOnKey {
            setHiddenKeys(computeHiddenKeys(from: [key, kIsAddressOnKey, kIsPrimaryAccountDetailsOnKey]), animated: true)
        } else if key == kIsAddressOnKey || key == kIsPrimaryAccountDetailsOnKey {
            setHiddenKeys(computeHiddenKeys(from: [
                kIsPaymentSessionOnKey,
                kIsTokenAndSecretOnKey,
                kIsAddressOnKey,
                kIsPrimaryAccountDetailsOnKey
            ]),
            animated: true)
        }
    }
}
