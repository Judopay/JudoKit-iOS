@card-entry
Feature: Judo Transactions
  As a user I want to be able to complete transactions via the Judo UI

  @test-judo-transactions
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Successful <paymentWidgetType>
    Given I am on the Main screen
    When I tap on the <optionLabel> option
    And I enter "4111 1111 1111 1111" in the Card Number text field
    And I enter "John Rambo" in the Cardholder Name text field
    And I enter "1229" in the Expiry Date text field
    And I enter "123" in the Secure Code text field
    And I tap on the <buttonLabel> button
    And I wait for "10" seconds
    Then the Results screen should be visible
    Examples:
      | paymentWidgetType | optionLabel          | buttonLabel     |
      | Card payment      | "Pay with card"      | "PAY NOW"       |
      | Pre-auth          | "Pre-auth with card" | "PAY NOW"       |
      | Register card     | "Register card"      | "REGISTER CARD" |
      | Create card token | "Check card"         | "CHECK CARD"    |
      | Check card        | "Save card"          | "SAVE CARD"     |

  @test-all-card-networks-payment
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Successful <cardNetwork> card payment
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I enter <cardNumber> in the Card Number text field
    And I enter "John Rambo" in the Cardholder Name text field
    And I enter "1229" in the Expiry Date text field
    And I enter <secureCode> in the Secure Code text field
    And I tap on the "PAY NOW" button
    And I wait for "10" seconds
    Then the Results screen should be visible
    Examples:
      | cardNetwork | cardNumber            | secureCode |
      | AmEx        | "3782 8224 6310 005"  | "1234"     |
      | Visa        | "4111 1111 1111 1111" | "123"      |
      | Discover    | "6011 1111 1111 1117" | "123"      |
      | JCB         | "3566 1111 1111 1113" | "123"      |
      | Mastercard  | "5555 5555 5555 4444" | "123"      |

  @test-all-card-networks-preauth
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Successful <cardNetwork> pre-auth
    Given I am on the Main screen
    When I tap on the "Pre-auth with card" option
    And I enter <cardNumber> in the Card Number text field
    And I enter "John Rambo" in the Cardholder Name text field
    And I enter "1229" in the Expiry Date text field
    And I enter <secureCode> in the Secure Code text field
    And I tap on the "PAY NOW" button
    And I wait for "10" seconds
    Then the Results screen should be visible
    Examples:
      | cardNetwork | cardNumber            | secureCode |
      | AmEx        | "3782 8224 6310 005"  | "1234"     |
      | Visa        | "4111 1111 1111 1111" | "123"      |
      | Discover    | "6011 1111 1111 1117" | "123"      |
      | JCB         | "3566 1111 1111 1113" | "123"      |
      | Mastercard  | "5555 5555 5555 4444" | "123"      |

  @test-all-card-networks-register-card
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Successful <cardNetwork> register card
    Given I am on the Main screen
    When I tap on the "Register card" option
    And I enter <cardNumber> in the Card Number text field
    And I enter "John Rambo" in the Cardholder Name text field
    And I enter "1229" in the Expiry Date text field
    And I enter <secureCode> in the Secure Code text field
    And I tap on the "REGISTER CARD" button
    And I wait for "10" seconds
    Then the Results screen should be visible
    And the "amount" list item should contain "1.01"
    Examples:
      | cardNetwork | cardNumber            | secureCode |
      | AmEx        | "3782 8224 6310 005"  | "1234"     |
      | Visa        | "4111 1111 1111 1111" | "123"      |
      | Discover    | "6011 1111 1111 1117" | "123"      |
      | JCB         | "3566 1111 1111 1113" | "123"      |
      | Mastercard  | "5555 5555 5555 4444" | "123"      |

  @test-all-card-networks-check-card
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Successful <cardNetwork> check card
    Given I am on the Main screen
    When I tap on the "Check card" option
    And I enter <cardNumber> in the Card Number text field
    And I enter "John Rambo" in the Cardholder Name text field
    And I enter "1229" in the Expiry Date text field
    And I enter <secureCode> in the Secure Code text field
    And I tap on the "CHECK CARD" button
    And I wait for "10" seconds
    Then the Results screen should be visible
    And the "amount" list item should contain "0.00"
    Examples:
      | cardNetwork | cardNumber            | secureCode |
      | AmEx        | "3782 8224 6310 005"  | "1234"     |
      | Visa        | "4111 1111 1111 1111" | "123"      |
      | Discover    | "6011 1111 1111 1117" | "123"      |
      | JCB         | "3566 1111 1111 1113" | "123"      |
      | Mastercard  | "5555 5555 5555 4444" | "123"      |

  @test-all-card-networks-save-card
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Successful <cardNetwork> save card
    Given I am on the Main screen
    When I tap on the "Save card" option
    And I enter <cardNumber> in the Card Number text field
    And I enter "John Rambo" in the Cardholder Name text field
    And I enter "1229" in the Expiry Date text field
    And I enter <secureCode> in the Secure Code text field
    And I tap on the "SAVE CARD" button
    And I wait for "10" seconds
    Then the Results screen should be visible
    And the "amount" list item should contain "0.00"
    Examples:
      | cardNetwork | cardNumber            | secureCode |
      | AmEx        | "3782 8224 6310 005"  | "1234"     |
      | Visa        | "4111 1111 1111 1111" | "123"      |
      | Discover    | "6011 1111 1111 1117" | "123"      |
      | JCB         | "3566 1111 1111 1113" | "123"      |
      | Mastercard  | "5555 5555 5555 4444" | "123"      |

  @test-card-number-validation
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Invalid <cardNetwork> card number
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I enter <cardNumber> in the Card Number text field
    Then an "Invalid card number" label should be visible
    Examples:
      | cardNetwork | cardNumber            |
      | AmEx        | "3782 8224 6310 000"  |
      | Visa        | "4111 1111 1111 1110" |
      | Discover    | "6011 1111 1111 1110" |
      | JCB         | "3566 1111 1111 1110" |
      | Mastercard  | "5555 5555 5555 4440" |

  @test-expiry-date-validation
    @require-non-3ds-config
  Scenario: Invalid expiry date
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I enter "1219" in the Expiry Date text field
    Then an "Invalid date value entered" label should be visible

  @test-secure-code-validation
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Invalid <cardNetwork> secure code
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I enter <cardNumber> in the Card Number text field
    And I enter <secureCode> in the Secure Code text field
    And I tap on the "Cardholder Name" text field
    Then the <errorMessage> label should be visible
    Examples:
      | cardNetwork | cardNumber            | secureCode | errorMessage      |
      | AmEx        | "3782 8224 6310 005"  | "111"      | "Check your CID"  |
      | Visa        | "4111 1111 1111 1111" | "11"       | "Check your CVV2" |
      | Discover    | "6011 1111 1111 1117" | "11"       | "Check your CVV"  |
      | JCB         | "3566 1111 1111 1113" | "11"       | "Check your CAV2" |
      | Mastercard  | "5555 5555 5555 4444" | "11"       | "Check your CVC2" |

  @test-submit-transaction-button-state
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Payment button disabled when <criteria> invalid
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I enter <cardNumber> in the Card Number text field
    And I enter <cardholderName> in the Cardholder Name text field
    And I enter <expiryDate> in the Expiry Date text field
    And I enter <secureCode> in the Secure Code text field
    Then the "PAY NOW" button should be disabled
    Examples:
      | criteria        | cardNumber            | cardholderName    | expiryDate | secureCode |
      | Card number     | "4111 1111 1111 1112" | "Cardholder name" | "1229"     | "452"      |
      | Cardholder Name | "4111 1111 1111 1111" | "Car"             | "1229"     | "452"      |
      | Expiry date     | "4111 1111 1111 1111" | "Cardholder name" | "1219"     | "452"      |
      | Secure code     | "4111 1111 1111 1111" | "CardholderName"  | "1229"     | "45"       |

  @test-cancel-payment
    @require-non-3ds-config
  Scenario: Cancel payment
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I tap on the "CANCEL" button
    Then the Main screen should be visible

  @test-avs-card-payment
    @require-non-3ds-config
    @require-all-card-networks
    @require-avs
  Scenario Outline: Successful AVS card payment with country <country>
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I enter "4111 1111 1111 1111" in the Card Number text field
    And I enter "John Rambo" in the Cardholder Name text field
    And I enter "1229" in the Expiry Date text field
    And I enter "123" in the Secure Code text field
    And I tap on the Country text field
    And I select <country> from the Country dropdown
    And I enter <postCode> in the Post Code text field
    And I tap on the "PAY NOW" button
    And I wait for "10" seconds
    Then the Results screen should be visible
    Examples:
      | country  | postCode   |
      | "UK"     | "SW15 5PU" |
      | "USA"    | "94102"    |
      | "Canada" | "K1A0B1"   |
      | "Other"  | "10115"    |

  @test-avs-card-preauth
    @require-non-3ds-config
    @require-all-card-networks
    @require-avs
  Scenario Outline: Successful AVS pre-auth card payment with country <country>
    Given I am on the Main screen
    When I tap on the "Pre-auth with card" option
    And I enter "4111 1111 1111 1111" in the Card Number text field
    And I enter "John Rambo" in the Cardholder Name text field
    And I enter "1229" in the Expiry Date text field
    And I enter "123" in the Secure Code text field
    And I tap on the Country text field
    And I select <country> from the Country dropdown
    And I enter <postCode> in the Post Code text field
    And I tap on the "PAY NOW" button
    And I wait for "10" seconds
    Then the Results screen should be visible
    Examples:
      | country  | postCode   |
      | "UK"     | "SW15 5PU" |
      | "USA"    | "94102"    |
      | "Canada" | "K1A0B1"   |
      | "Other"  | "10115"    |

  @test-avs-card-register-card
    @require-non-3ds-config
    @require-all-card-networks
    @require-avs
  Scenario Outline: Successful AVS register card with country <country>
    Given I am on the Main screen
    When I tap on the "Register card" option
    And I enter "4111 1111 1111 1111" in the Card Number text field
    And I enter "John Rambo" in the Cardholder Name text field
    And I enter "1229" in the Expiry Date text field
    And I enter "123" in the Secure Code text field
    And I tap on the Country text field
    And I select <country> from the Country dropdown
    And I enter <postCode> in the Post Code text field
    And I tap on the "REGISTER CARD" button
    And I wait for "10" seconds
    Then the Results screen should be visible
    Examples:
      | country  | postCode   |
      | "UK"     | "SW15 5PU" |
      | "USA"    | "94102"    |
      | "Canada" | "K1A0B1"   |
      | "Other"  | "10115"    |

  @test-avs-card-check-card
    @require-non-3ds-config
    @require-all-card-networks
    @require-avs
  Scenario Outline: Successful AVS check card with country <country>
    Given I am on the Main screen
    When I tap on the "Check card" option
    And I enter "4111 1111 1111 1111" in the Card Number text field
    And I enter "John Rambo" in the Cardholder Name text field
    And I enter "1229" in the Expiry Date text field
    And I enter "123" in the Secure Code text field
    And I tap on the Country text field
    And I select <country> from the Country dropdown
    And I enter <postCode> in the Post Code text field
    And I tap on the "CHECK CARD" button
    And I wait for "10" seconds
    Then the Results screen should be visible
    Examples:
      | country  | postCode   |
      | "UK"     | "SW15 5PU" |
      | "USA"    | "94102"    |
      | "Canada" | "K1A0B1"   |
      | "Other"  | "10115"    |

  @test-avs-card-save-card
    @require-non-3ds-config
    @require-all-card-networks
    @require-avs
  Scenario Outline: Successful AVS save card with country <country>
    Given I am on the Main screen
    When I tap on the "Save card" option
    And I enter "4111 1111 1111 1111" in the Card Number text field
    And I enter "John Rambo" in the Cardholder Name text field
    And I enter "1229" in the Expiry Date text field
    And I enter "123" in the Secure Code text field
    And I tap on the Country text field
    And I select <country> from the Country dropdown
    And I enter <postCode> in the Post Code text field
    And I tap on the "SAVE CARD" button
    And I wait for "10" seconds
    Then the Results screen should be visible
    Examples:
      | country  | postCode   |
      | "UK"     | "SW15 5PU" |
      | "USA"    | "94102"    |
      | "Canada" | "K1A0B1"   |
      | "Other"  | "10115"    |

  @test-avs-post-code-validation
    @require-non-3ds-config
    @require-avs
  Scenario Outline: Post code field validation for invalid <country> post code
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I tap on the Country text field
    And I select <country> from the Country dropdown
    And I enter <postCode> in the Post Code text field
    Then the "Invalid postcode entered" label should be visible
    Examples:
      | country  | postCode  |
      | "UK"     | "SW15 5P" |
      | "USA"    | "9410"    |
      | "Canada" | "K1A0B"   |

  @test-avs-post-code-length-validation
    @require-non-3ds-config
    @require-avs
  Scenario Outline: Post code field length validation for <country> post code
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I tap on the Country text field
    And I select <country> from the Country dropdown
    And I enter <postCode> in the Post Code text field
    Then the value in Post Code input field should be <expectedPostCode>
    Examples:
      | country  | postCode    | expectedPostCode |
      | "UK"     | "SW15 5PU0" | "SW15 5PU"       |
      | "USA"    | "941020"    | "94102"          |
      | "Canada" | "K1A0B1A"   | "K1A0B1"         |
      | "Other"  | "111111111" | "11111111"       |

  @test-validate-button-amount
    @require-non-3ds-config
    @require-currency-gbp
    @require-button-amount
  Scenario Outline: Validate the transaction button title for enabled display amount setting in <paymentWidgetType>.
    Given I am on the Main screen
    When I tap on the <optionLabel> option
    Then the Submit button title should be <buttonLabel>
    Examples:
      | paymentWidgetType | optionLabel          | buttonLabel     |
      | Card payment      | "Pay with card"      | "PAY £0.15"     |
      | Pre-auth          | "Pre-auth with card" | "PAY £0.15"     |
      | Register card     | "Register card"      | "REGISTER CARD" |
      | Create card token | "Check card"         | "CHECK CARD"    |
      | Check card        | "Save card"          | "SAVE CARD"     |
