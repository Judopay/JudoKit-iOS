import UIKit

class TokenViewController: UIViewController, TokenInteractorOutput {
    // MARK: - Constants

    private let kButtonHeight: CGFloat = 50.0

    // MARK: - Variables

    var interactor: TokenInteractorInput!
    var coordinator: Coordinator?

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        setupTargets()
        interactor.viewDidLoad()
    }

    // MARK: - Protocol methods

    func updateFields(withScheme scheme: String?, token: String?, csc: String?, cardholderName: String?) {
        schemeTextField.text = scheme
        tokenTextField.text = token
        cscTextField.text = csc
        chNameTextField.text = cardholderName
    }

    func areTokenTransactionButtonsEnabled(_ isEnabled: Bool) {
        tokenPaymentButton.backgroundColor = isEnabled ? .label : .systemGray
        tokenPreAuthButton.backgroundColor = isEnabled ? .label : .systemGray
        tokenPaymentButton.isEnabled = isEnabled
        tokenPreAuthButton.isEnabled = isEnabled
    }

    func navigateToResultsModule(with result: Result) {
        coordinator?.pushTo(.results(result))
    }

    // MARK: - User actions

    @objc private func onSchemeChange() {
        interactor.didChange(scheme: schemeTextField.text)
    }

    @objc private func onTokenChange() {
        interactor.didChange(token: tokenTextField.text)
    }

    @objc private func onCSCChange() {
        interactor.didChange(csc: cscTextField.text)
    }

    @objc private func onCHNameChange() {
        interactor.didChange(cardholderName: chNameTextField.text)
    }

    @objc private func didTapSaveCardButton() {
        interactor.didTapSaveCardButton()
    }

    @objc private func didTapTokenPaymentsButton() {
        interactor.didTapTokenPaymentButton()
    }

    @objc private func didTapTokenPreAuthButton() {
        interactor.didTapTokenPreAuthButton()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrameRect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardFrameHeight = view.convert(keyboardFrameRect, from: nil).size.height
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrameHeight, right: 0)
        }
    }

    @objc func keyboardWillHide() {
        scrollView.contentInset = .zero
    }

    // MARK: - Layout setup

    private func setupLayout() {
        navigationItem.title = "Token payments"
        view.backgroundColor = .systemBackground

        formStackView.addArrangedSubview(introLabel)
        formStackView.addArrangedSubview(fieldStackView(withChildren: [schemeLabel, schemeTextField]))
        formStackView.addArrangedSubview(fieldStackView(withChildren: [tokenLabel, tokenTextField]))
        formStackView.addArrangedSubview(fieldStackView(withChildren: [cscLabel, cscTextField]))
        formStackView.addArrangedSubview(fieldStackView(withChildren: [chNameLabel, chNameTextField]))

        contentStackView.addArrangedSubview(formStackView)
        contentStackView.addArrangedSubview(TokenViewController.label(text: "- or -", textAlignment: .center))
        contentStackView.addArrangedSubview(saveCardButton)
        contentStackView.addArrangedSubview(spacerView)
        contentStackView.addArrangedSubview(tokenPaymentButton)
        contentStackView.addArrangedSubview(tokenPreAuthButton)

        scrollView.addSubview(contentStackView)
        view.addSubview(scrollView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            saveCardButton.heightAnchor.constraint(equalToConstant: kButtonHeight),
            tokenPaymentButton.heightAnchor.constraint(equalToConstant: kButtonHeight),
            tokenPreAuthButton.heightAnchor.constraint(equalToConstant: kButtonHeight),
            spacerView.heightAnchor.constraint(equalToConstant: kButtonHeight),
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: contentStackView.topAnchor),
            scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    private func setupTargets() {
        schemeTextField.addTarget(self, action: #selector(onSchemeChange), for: .editingChanged)
        tokenTextField.addTarget(self, action: #selector(onTokenChange), for: .editingChanged)
        cscTextField.addTarget(self, action: #selector(onCSCChange), for: .editingChanged)
        chNameTextField.addTarget(self, action: #selector(onCHNameChange), for: .editingChanged)

        saveCardButton.addTarget(self, action: #selector(didTapSaveCardButton), for: .touchDown)
        tokenPaymentButton.addTarget(self, action: #selector(didTapTokenPaymentsButton), for: .touchDown)
        tokenPreAuthButton.addTarget(self, action: #selector(didTapTokenPreAuthButton), for: .touchDown)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let gestureRecogniser = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        gestureRecogniser.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecogniser)
    }

    // MARK: - Lazy instantiations

    private let scrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let formStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()

    private func fieldStackView(withChildren children: [UIView]) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        children.forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }

    private let contentStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let introLabel = label(text: "Please fill in the fields from below with tokenized card details", textAlignment: .center)

    private let schemeLabel = label(text: "Scheme")
    private let tokenLabel = label(text: "Token")
    private let cscLabel = label(text: "Security code")
    private let chNameLabel = label(text: "Cardholder name")

    private static func label(text: String?, textAlignment: NSTextAlignment = .natural) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textAlignment = textAlignment
        label.numberOfLines = 0
        return label
    }

    private let schemeTextField = textField(keyboardType: .numberPad)
    private let tokenTextField = textField(keyboardType: .default)
    private let cscTextField = textField(keyboardType: .numberPad)
    private let chNameTextField = textField(keyboardType: .default)

    private static func textField(text: String? = nil, keyboardType: UIKeyboardType) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = text
        textField.keyboardType = keyboardType
        textField.borderStyle = .line
        return textField
    }

    private let saveCardButton = button(titled: "Save Card")
    private let tokenPaymentButton = button(titled: "Token Payment")
    private let tokenPreAuthButton = button(titled: "Token PreAuth")

    private static func button(titled title: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.secondarySystemBackground, for: .normal)
        button.backgroundColor = UIColor.label
        return button
    }

    private let spacerView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
