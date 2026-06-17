//
//  SettingsImporter.swift
//  SwiftExampleApp
//
//  Copyright (c) 2026 Alternative Payments Ltd
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

enum SettingsImporter {
    enum ImportError: LocalizedError {
        case invalidEncoding
        case notAnObject

        var errorDescription: String? {
            switch self {
            case .invalidEncoding:
                return "The provided text is not valid UTF-8."
            case .notAnObject:
                return "Expected a JSON object at the root."
            }
        }
    }

    static func importSettings(_ json: String, into defaults: UserDefaults = .standard) throws {
        guard let data = json.data(using: .utf8) else {
            throw ImportError.invalidEncoding
        }

        let object = try JSONSerialization.jsonObject(with: data, options: [])

        guard let root = object as? [String: Any] else {
            throw ImportError.notAnObject
        }

        for (key, value) in root {
            if let section = value as? [String: Any] {
                section.forEach { applyLeaf($0.value, forKey: $0.key, into: defaults) }
            } else {
                applyLeaf(value, forKey: key, into: defaults)
            }
        }
    }

    private static let cardNetworkKeysByValue: [String: String] = [
        "VISA": kVisaEnabledKey,
        "MASTERCARD": kMasterCardEnabledKey,
        "MAESTRO": kMaestroEnabledKey,
        "AMEX": kAMEXEnabledKey,
        "CHINA_UNION_PAY": kChinaUnionPayEnabledKey,
        "JCB": kJCBEnabledKey,
        "DISCOVER": kDiscoverEnabledKey,
        "DINERS_CLUB": kDinersClubEnabledKey
    ]

    private static let challengeRequestIndicatorImportValues: [String: String] = [
        "DON_T_SET": "dontSet",
        "NO_PREFERENCE": "noPreference",
        "NO_CHALLENGE": "noChallenge",
        "CHALLENGE_PREFERRED": "challengePreferred",
        "CHALLENGE_AS_MANDATE": "challengeAsMandate"
    ]

    private static let scaExemptionImportValues: [String: String] = [
        "DON_T_SET": "dontSet",
        "LOW_VALUE": "lowValue",
        "SECURE_CORPORATE": "secureCorporate",
        "TRUSTED_BENEFICIARY": "trustedBeneficiary",
        "TRANSACTION_RISK_ANALYSIS": "transactionRiskAnalysis"
    ]

    private static func applyLeaf(_ value: Any, forKey rawKey: String, into defaults: UserDefaults) {
        switch rawKey {
        case "is_payment_session_enabled":
            if let number = value as? NSNumber, isBoolean(number) {
                defaults.set(number.boolValue, forKey: kIsPaymentSessionOnKey)
                defaults.set(!number.boolValue, forKey: kIsTokenAndSecretOnKey)
            }
            return
        case "supported_networks":
            if let array = value as? [Any] {
                applyCardNetworks(array.map { "\($0)" }, into: defaults)
            }
            return
        case "payment_methods":
            if let array = value as? [Any] {
                applyPaymentMethods(array.map { "\($0)" }, into: defaults)
            }
            return
        default:
            break
        }

        switch value {
        case let array as [Any]:
            defaults.set(array.map { "\($0)" }, forKey: rawKey)
        case let number as NSNumber where isBoolean(number):
            defaults.set(number.boolValue, forKey: rawKey)
        case let number as NSNumber:
            defaults.set(number.stringValue, forKey: rawKey)
        case let string as String:
            defaults.set(storedValue(for: rawKey, value: string), forKey: rawKey)
        default:
            break
        }
    }

    private static func storedValue(for key: String, value: String) -> String {
        switch key {
        case kChallengeRequestIndicatorKey:
            return challengeRequestIndicatorImportValues[value] ?? value
        case kScaExemptionKey:
            return scaExemptionImportValues[value] ?? value
        default:
            return value
        }
    }

    private static func applyCardNetworks(_ values: [String], into defaults: UserDefaults) {
        let selected = Set(values.map { $0.uppercased() })
        for (value, key) in cardNetworkKeysByValue {
            defaults.set(selected.contains(value), forKey: key)
        }
    }

    private static func applyPaymentMethods(_ values: [String], into defaults: UserDefaults) {
        let selected = Set(values.map { $0.uppercased() })
        defaults.set(selected.contains("CARD"), forKey: kCardPaymentMethodEnabledKey)
        defaults.set(selected.contains("APPLE_PAY") || selected.contains("GOOGLE_PAY"),
                     forKey: kApplePayPaymentMethodEnabledKey)
    }

    private static func isBoolean(_ number: NSNumber) -> Bool {
        CFGetTypeID(number) == CFBooleanGetTypeID()
    }
}

final class ImportSettingsViewController: UIViewController {
    var onImported: (() -> Void)?

    private let kTitle = "Import Settings from JSON"
    private let kPlaceholder = "Paste JSON here…"

    private var cardCenterYConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupCard()
        registerForKeyboardNotifications()

        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(didTapBackground(_:)))
        backgroundTap.cancelsTouchesInView = false
        view.addGestureRecognizer(backgroundTap)
    }

    @objc private func didTapBackground(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: view)
        if !cardView.frame.contains(location) {
            view.endEditing(true)
            dismiss(animated: true)
        }
    }

    @objc private func didTapCancel() {
        dismiss(animated: true)
    }

    @objc private func didTapImport() {
        let json = textView.text ?? ""
        guard !json.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(title: kTitle, message: "Please enter the settings JSON or choose a file.")
            return
        }
        apply(json: json)
    }

    @objc private func didTapChooseFile() {
        let picker: UIDocumentPickerViewController
        if #available(iOS 14.0, *) {
            picker = UIDocumentPickerViewController(forOpeningContentTypes: [.json, .text])
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["public.json", "public.text"], in: .import)
        }
        picker.delegate = self
        picker.allowsMultipleSelection = false
        present(picker, animated: true)
    }

    private func apply(json: String) {
        do {
            try SettingsImporter.importSettings(json)
            onImported?()
            let alert = UIAlertController(title: kTitle,
                                          message: "Settings imported successfully.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.dismiss(animated: true)
            })
            present(alert, animated: true)
        } catch {
            showAlert(title: kTitle, message: "Failed to import settings: \(error.localizedDescription)")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc private func keyboardWillChange(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let overlap = view.bounds.height - frame.origin.y
        cardCenterYConstraint?.constant = overlap > 0 ? -overlap / 2 : 0
        UIView.animate(withDuration: 0.25) { self.view.layoutIfNeeded() }
    }

    @objc private func keyboardWillHide() {
        cardCenterYConstraint?.constant = 0
        UIView.animate(withDuration: 0.25) { self.view.layoutIfNeeded() }
    }

    private func setupCard() {
        view.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(textView)
        textView.addSubview(placeholderLabel)
        cardView.addSubview(buttonStackView)

        let centerY = cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        cardCenterYConstraint = centerY

        let width = cardView.widthAnchor.constraint(equalToConstant: 320)
        width.priority = .defaultHigh

        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerY,
            width,
            cardView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),

            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 150),

            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -5),

            buttonStackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            buttonStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }

    private lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 14
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = kTitle
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.smartQuotesType = .no
        textView.smartDashesType = .no
        textView.delegate = self
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.accessibilityIdentifier = "Import settings text view"
        return textView
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = kPlaceholder
        label.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        label.textColor = .placeholderText
        label.numberOfLines = 0
        return label
    }()

    private lazy var buttonStackView: UIStackView = {
        let chooseFileButton = makeButton(title: "Choose File", action: #selector(didTapChooseFile))
        let cancelButton = makeButton(title: "Cancel", action: #selector(didTapCancel))
        let importButton = makeButton(title: "Import", action: #selector(didTapImport))
        importButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)

        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let stackView = UIStackView(arrangedSubviews: [chooseFileButton, spacer, cancelButton, importButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()

    private func makeButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }
}

extension ImportSettingsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

extension ImportSettingsViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }

        let shouldStopAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if shouldStopAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }

        do {
            let json = try String(contentsOf: url, encoding: .utf8)
            textView.text = json
            placeholderLabel.isHidden = !json.isEmpty
            apply(json: json)
        } catch {
            showAlert(title: "Import Settings", message: "Failed to read file: \(error.localizedDescription)")
        }
    }
}
