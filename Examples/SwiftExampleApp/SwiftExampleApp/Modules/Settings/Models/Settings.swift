import Judo3DS2_iOS
import JudoKit_iOS

// swiftlint:disable:next type_body_length
class Settings {
    // MARK: - Constants

    private let kDefaultConsumerReference = "my-unique-consumer-ref"
    private let kDontSet = "dontSet"

    // MARK: - Variables

    private let userDefaults: UserDefaults
    public static let standard = Settings()

    // MARK: - Initializers

    private init() {
        userDefaults = .standard
    }

    init(with userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    // MARK: - Getters

    public var isSandboxed: Bool {
        userDefaults.bool(forKey: kSandboxedKey)
    }

    public var judoId: String {
        userDefaults.string(forKey: kJudoIdKey) ?? ""
    }

    public var isBasicAuthorizationOn: Bool {
        userDefaults.bool(forKey: kIsTokenAndSecretOnKey)
    }

    public var isSessionAuthorizationOn: Bool {
        userDefaults.bool(forKey: kIsPaymentSessionOnKey)
    }

    public var authorization: JPAuthorization {
        if isBasicAuthorizationOn {
            let token = userDefaults.string(forKey: kTokenKey) ?? ""
            let secret = userDefaults.string(forKey: kSecretKey) ?? ""
            return JPBasicAuthorization(token: token, andSecret: secret)
        }

        let token = userDefaults.string(forKey: kSessionTokenKey) ?? ""
        let session = userDefaults.string(forKey: kPaymentSessionKey) ?? ""
        return JPSessionAuthorization(token: token, andPaymentSession: session)
    }

    public var reference: JPReference {
        var paymentReference = JPReference.generatePaymentReference()
        var consumerReference = kDefaultConsumerReference

        if let storedPaymentRef = userDefaults.string(forKey: kPaymentReferenceKey), !storedPaymentRef.isEmpty {
            paymentReference = storedPaymentRef
        }

        if let storedConsumerRef = userDefaults.string(forKey: kConsumerReferenceKey), !storedConsumerRef.isEmpty {
            consumerReference = storedConsumerRef
        }

        let reference = JPReference(consumerReference: consumerReference,
                                    paymentReference: paymentReference)
        reference.metaData = ["exampleMetaKey": "exampleMetaValue"]
        return reference
    }

    public var amount: JPAmount {
        let amount = userDefaults.string(forKey: kAmountKey) ?? ""
        let currency = userDefaults.string(forKey: kCurrencyKey) ?? ""
        return JPAmount(amount, currency: currency)
    }

    public var applePayMerchantID: String {
        userDefaults.string(forKey: kMerchantIdKey) ?? ""
    }

    var applePayReturnedContactInfo: JPReturnedInfo {
        var fields: JPReturnedInfo = []
        if userDefaults.bool(forKey: kIsApplePayBillingContactInfoRequired) {
            fields.insert(.billingContacts)
        }
        if userDefaults.bool(forKey: kIsApplePayShippingContactInfoRequired) {
            fields.insert(.shippingContacts)
        }
        return fields
    }

    var applePayBillingContactFields: JPContactField {
        var fields: JPContactField = []
        if userDefaults.bool(forKey: kIsBillingContactFieldPostalAddressRequiredKey) {
            fields.insert(.postalAddress)
        }
        if userDefaults.bool(forKey: kIsBillingContactFieldPhoneRequiredKey) {
            fields.insert(.phone)
        }
        if userDefaults.bool(forKey: kIsBillingContactFieldEmailRequiredKey) {
            fields.insert(.email)
        }
        if userDefaults.bool(forKey: kIsBillingContactFieldNameRequiredKey) {
            fields.insert(.name)
        }
        return fields
    }

    var applePayShippingContactFields: JPContactField {
        var fields: JPContactField = []
        if userDefaults.bool(forKey: kIsShippingContactFieldPostalAddressRequiredKey) {
            fields.insert(.postalAddress)
        }
        if userDefaults.bool(forKey: kIsShippingContactFieldPhoneRequiredKey) {
            fields.insert(.phone)
        }
        if userDefaults.bool(forKey: kIsShippingContactFieldEmailRequiredKey) {
            fields.insert(.email)
        }
        if userDefaults.bool(forKey: kIsShippingContactFieldNameRequiredKey) {
            fields.insert(.name)
        }
        return fields
    }

    public var supportedCardNetworks: JPCardNetworkType {
        var networks: JPCardNetworkType = []

        if userDefaults.bool(forKey: kVisaEnabledKey) {
            networks.insert(.visa)
        }

        if userDefaults.bool(forKey: kMasterCardEnabledKey) {
            networks.insert(.masterCard)
        }

        if userDefaults.bool(forKey: kMaestroEnabledKey) {
            networks.insert(.maestro)
        }

        if userDefaults.bool(forKey: kAMEXEnabledKey) {
            networks.insert(.AMEX)
        }

        if userDefaults.bool(forKey: kChinaUnionPayEnabledKey) {
            networks.insert(.chinaUnionPay)
        }

        if userDefaults.bool(forKey: kJCBEnabledKey) {
            networks.insert(.JCB)
        }

        if userDefaults.bool(forKey: kDiscoverEnabledKey) {
            networks.insert(.discover)
        }

        if userDefaults.bool(forKey: kDinersClubEnabledKey) {
            networks.insert(.dinersClub)
        }

        return networks
    }

    public var paymentMethods: [JPPaymentMethod] {
        var paymentMethods: [JPPaymentMethod] = []

        if userDefaults.bool(forKey: kCardPaymentMethodEnabledKey) {
            paymentMethods.append(JPPaymentMethod.card())
        }

        if userDefaults.bool(forKey: kApplePayPaymentMethodEnabledKey) {
            paymentMethods.append(JPPaymentMethod.applePay())
        }

        if userDefaults.bool(forKey: kiDEALPaymentMethodEnabledKey) {
            paymentMethods.append(JPPaymentMethod.iDeal())
        }

        if userDefaults.bool(forKey: kPbbaPaymentMethodEnabledKey) {
            paymentMethods.append(JPPaymentMethod.pbba())
        }

        return paymentMethods
    }

    public var isAVSEnabled: Bool {
        userDefaults.bool(forKey: kAVSEnabledKey)
    }

    public var shouldPaymentMethodsDisplayAmount: Bool {
        userDefaults.bool(forKey: kShouldPaymentMethodsDisplayAmount)
    }

    public var shouldPaymentButtonDisplayAmount: Bool {
        userDefaults.bool(forKey: kShouldPaymentButtonDisplayAmount)
    }

    public var shouldPaymentMethodsVerifySecurityCode: Bool {
        userDefaults.bool(forKey: kShouldPaymentMethodsVerifySecurityCode)
    }

    var isInitialRecurringPaymentEnabled: Bool {
        userDefaults.bool(forKey: kIsInitialRecurringPaymentKey)
    }

    var isRecommendationOn: Bool {
        userDefaults.bool(forKey: kIsRecommendationOnKey)
    }

    var isAddressOn: Bool {
        userDefaults.bool(forKey: kIsAddressOnKey)
    }

    var isPrimaryAccountDetailsOn: Bool {
        userDefaults.bool(forKey: kIsPrimaryAccountDetailsOnKey)
    }

    var isDelayedAuthorisationOn: Bool {
        userDefaults.bool(forKey: kIsDelayedAuthorisationOnKey)
    }

    var shouldAskForCSC: Bool {
        userDefaults.bool(forKey: kShouldAskForCSCKey)
    }

    var shouldAskForCardholderName: Bool {
        userDefaults.bool(forKey: kShouldAskForCardholderNameKey)
    }

    // MARK: - Recommendation Configuration

    var recommendationConfiguration: RecommendationConfiguration? {
        if isRecommendationOn {
            let rsaKey = userDefaults.string(forKey: kRsaKey)
            let recommendationURL = userDefaults.string(forKey: kRecommendationUrlKey)
//            let recommendationTimeout = userDefaults.string(forKey: kRecommendationTimeoutKey)
            return RecommendationConfiguration(rsaKey: rsaKey,
                                    recommendationURL: recommendationURL,
                                // Todo: timeout!
                                recommendationTimeout: nil
            )
        }
        return nil
    }

    // MARK: - Card Address

    var address: JPAddress? {
        if isAddressOn {
            let countryCode = userDefaults.integer(forKey: kAddressCountryCodeKey)
            let state = userDefaults.string(forKey: kAddressStateKey)
            return JPAddress(address1: userDefaults.string(forKey: kAddressLine1Key),
                             address2: userDefaults.string(forKey: kAddressLine2Key),
                             address3: userDefaults.string(forKey: kAddressLine3Key),
                             town: userDefaults.string(forKey: kAddressTownKey),
                             postCode: userDefaults.string(forKey: kAddressPostCodeKey),
                             countryCode: NSNumber(value: countryCode),
                             state: state?.isEmpty == true ? nil : state)
        }
        return nil
    }

    var primaryAccountDetails: JPPrimaryAccountDetails? {
        if isPrimaryAccountDetailsOn {
            let accountDetails = JPPrimaryAccountDetails()
            accountDetails.accountNumber = userDefaults.string(forKey: kPrimaryAccountAccountNumberKey)
            accountDetails.name = userDefaults.string(forKey: kPrimaryAccountNameKey)
            accountDetails.dateOfBirth = userDefaults.string(forKey: kPrimaryAccountDateOfBirthKey)
            accountDetails.postCode = userDefaults.string(forKey: kPrimaryAccountPostCodeKey)
            return accountDetails
        }
        return nil
    }

    var emailAddress: String? {
        isAddressOn ? userDefaults.string(forKey: kAddressEmailAddressKey) : nil
    }

    var phoneCountryCode: String? {
        isAddressOn ? userDefaults.string(forKey: kAddressPhoneCountryCodeKey) : nil
    }

    var mobileNumber: String? {
        isAddressOn ? userDefaults.string(forKey: kAddressMobileNumberKey) : nil
    }

    // MARK: - 3DS v2.0

    var shouldAskForBillingInformation: Bool {
        userDefaults.bool(forKey: kShouldAskForBillingInformationKey)
    }

    var challengeRequestIndicator: String? {
        let value = userDefaults.string(forKey: kChallengeRequestIndicatorKey)
        return value == kDontSet ? nil : value
    }

    var scaExemption: String? {
        let value = userDefaults.string(forKey: kScaExemptionKey)
        return value == kDontSet ? nil : value
    }

    var threeDsTwoMaxTimeout: Int {
        userDefaults.integer(forKey: kThreeDsTwoMaxTimeoutKey)
    }

    var threeDSTwoMessageVersion: String? {
        userDefaults.string(forKey: kThreeDSTwoMessageVersionKey) ?? ""
    }

    var recommendationUrl: String? {
        userDefaults.string(forKey: kRecommendationUrlKey) ?? ""
    }

    var connectTimeout: Int {
        timeoutFor(key: kConnectTimeoutKey)
    }

    var readTimeout: Int {
        timeoutFor(key: kReadTimeoutKey)
    }

    var writeTimeout: Int {
        timeoutFor(key: kWriteTimeoutKey)
    }

    private func timeoutFor(key: String) -> Int {
        let value = userDefaults.string(forKey: key) ?? "0"
        let intValue = Int(value) ?? 0
        return intValue == 0 ? 600 : intValue
    }

    var threeDSUICustomization: JP3DSUICustomization? {
        if userDefaults.bool(forKey: kIsThreeDSUICustomisationEnabledKey) {
            let customization = JP3DSUICustomization()

            let labelCustomization = JP3DSLabelCustomization()
            labelCustomization.setTextFontName(userDefaults.string(forKey: kThreeDSLabelTextFontNameKey) ?? "")
            labelCustomization.setTextColor(userDefaults.string(forKey: kThreeDSLabelTextColorKey) ?? "")
            labelCustomization.setTextFontSize(userDefaults.integer(forKey: kThreeDSLabelTextFontSizeKey))
            labelCustomization.setHeadingTextFontName(userDefaults.string(forKey: kThreeDSLabelHeadingTextFontNameKey) ?? "")
            labelCustomization.setHeadingTextColor(userDefaults.string(forKey: kThreeDSLabelHeadingTextColorKey) ?? "")
            labelCustomization.setHeadingTextFontSize(userDefaults.integer(forKey: kThreeDSLabelHeadingTextFontSizeKey))
            customization.setLabel(labelCustomization)

            let toolbarCustomization = JP3DSToolbarCustomization()
            toolbarCustomization.setTextFontName(userDefaults.string(forKey: kThreeDSToolbarTextFontNameKey) ?? "")
            toolbarCustomization.setTextColor(userDefaults.string(forKey: kThreeDSToolbarTextColorKey) ?? "")
            toolbarCustomization.setTextFontSize(userDefaults.integer(forKey: kThreeDSToolbarTextFontSizeKey))
            toolbarCustomization.setBackgroundColor(userDefaults.string(forKey: kThreeDSToolbarBackgroundColorKey) ?? "")
            toolbarCustomization.setHeaderText(userDefaults.string(forKey: kThreeDSToolbarHeaderTextKey) ?? "")
            toolbarCustomization.setButtonText(userDefaults.string(forKey: kThreeDSToolbarButtonTextKey) ?? "")
            customization.setToolbar(toolbarCustomization)

            let textBoxCustomization = JP3DSTextBoxCustomization()
            textBoxCustomization.setTextFontName(userDefaults.string(forKey: kThreeDSTextBoxTextFontNameKey) ?? "")
            textBoxCustomization.setTextColor(userDefaults.string(forKey: kThreeDSTextBoxTextColorKey) ?? "")
            textBoxCustomization.setTextFontSize(userDefaults.integer(forKey: kThreeDSTextBoxTextFontSizeKey))
            textBoxCustomization.setBorderWidth(userDefaults.integer(forKey: kThreeDSTextBoxBorderWidthKey))
            textBoxCustomization.setBorderColor(userDefaults.string(forKey: kThreeDSTextBoxBorderColorKey) ?? "")
            textBoxCustomization.setCornerRadius(userDefaults.integer(forKey: kThreeDSTextBoxCornerRadiusKey))
            customization.setTextBox(textBoxCustomization)

            let submitCustomization = JP3DSButtonCustomization()
            submitCustomization.setTextFontName(userDefaults.string(forKey: kThreeDSSubmitButtonTextFontNameKey) ?? "")
            submitCustomization.setTextColor(userDefaults.string(forKey: kThreeDSSubmitButtonTextColorKey) ?? "")
            submitCustomization.setTextFontSize(userDefaults.integer(forKey: kThreeDSSubmitButtonTextFontSizeKey))
            submitCustomization.setBackgroundColor(userDefaults.string(forKey: kThreeDSSubmitButtonBackgroundColorKey) ?? "")
            submitCustomization.setCornerRadius(userDefaults.integer(forKey: kThreeDSSubmitButtonCornerRadiusKey))
            customization.setButton(submitCustomization, of: .submit)

            let nextCustomization = JP3DSButtonCustomization()
            nextCustomization.setTextFontName(userDefaults.string(forKey: kThreeDSNextButtonTextFontNameKey) ?? "")
            nextCustomization.setTextColor(userDefaults.string(forKey: kThreeDSNextButtonTextColorKey) ?? "")
            nextCustomization.setTextFontSize(userDefaults.integer(forKey: kThreeDSNextButtonTextFontSizeKey))
            nextCustomization.setBackgroundColor(userDefaults.string(forKey: kThreeDSNextButtonBackgroundColorKey) ?? "")
            nextCustomization.setCornerRadius(userDefaults.integer(forKey: kThreeDSNextButtonCornerRadiusKey))
            customization.setButton(nextCustomization, of: .next)

            let cancelCustomization = JP3DSButtonCustomization()
            cancelCustomization.setTextFontName(userDefaults.string(forKey: kThreeDSCancelButtonTextFontNameKey) ?? "")
            cancelCustomization.setTextColor(userDefaults.string(forKey: kThreeDSCancelButtonTextColorKey) ?? "")
            cancelCustomization.setTextFontSize(userDefaults.integer(forKey: kThreeDSCancelButtonTextFontSizeKey))
            cancelCustomization.setBackgroundColor(userDefaults.string(forKey: kThreeDSCancelButtonBackgroundColorKey) ?? "")
            cancelCustomization.setCornerRadius(userDefaults.integer(forKey: kThreeDSCancelButtonCornerRadiusKey))
            customization.setButton(cancelCustomization, of: .cancel)

            let continueCustomization = JP3DSButtonCustomization()
            continueCustomization.setTextFontName(userDefaults.string(forKey: kThreeDSContinueButtonTextFontNameKey) ?? "")
            continueCustomization.setTextColor(userDefaults.string(forKey: kThreeDSContinueButtonTextColorKey) ?? "")
            continueCustomization.setTextFontSize(userDefaults.integer(forKey: kThreeDSContinueButtonTextFontSizeKey))
            continueCustomization.setBackgroundColor(userDefaults.string(forKey: kThreeDSContinueButtonBackgroundColorKey) ?? "")
            continueCustomization.setCornerRadius(userDefaults.integer(forKey: kThreeDSContinueButtonCornerRadiusKey))
            customization.setButton(continueCustomization, of: .continue)

            let resendCustomization = JP3DSButtonCustomization()
            resendCustomization.setTextFontName(userDefaults.string(forKey: kThreeDSResendButtonTextFontNameKey) ?? "")
            resendCustomization.setTextColor(userDefaults.string(forKey: kThreeDSResendButtonTextColorKey) ?? "")
            resendCustomization.setTextFontSize(userDefaults.integer(forKey: kThreeDSResendButtonTextFontSizeKey))
            resendCustomization.setBackgroundColor(userDefaults.string(forKey: kThreeDSResendButtonBackgroundColorKey) ?? "")
            resendCustomization.setCornerRadius(userDefaults.integer(forKey: kThreeDSResendButtonCornerRadiusKey))
            customization.setButton(resendCustomization, of: .resend)

            return customization
        }
        return nil
    }
}
