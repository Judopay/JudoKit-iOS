@card-entry
Feature: Judo Transactions
  As a user I want to be able to complete transactions via the Judo UI

  @test-all-card-networks-payment
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Successful <cardNetwork> card payment
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I enter <cardNetwork> "CARD NUMBER" in the Card Number text field
    And I enter <cardNetwork> "CARDHOLDER NAME" in the Cardholder Name text field
    And I enter <cardNetwork> "EXPIRY DATE" in the Expiry Date text field
    And I enter <cardNetwork> "SECURE CODE" in the Secure Code text field
    And I tap on the "PAY NOW" button
    And I wait for "5" seconds
    Then the Results screen should be visible
    Examples:
      | cardNetwork |
      | VISA        |
      | MASTERCARD  |
      | AMEX        |
      | JCB         |
      | DISCOVER    |

  @test-all-card-networks-preauth
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Successful <cardNetwork> pre-auth
    Given I am on the Main screen
    When I tap on the "Pre-auth with card" option
    And I enter <cardNetwork> "CARD NUMBER" in the Card Number text field
    And I enter <cardNetwork> "CARDHOLDER NAME" in the Cardholder Name text field
    And I enter <cardNetwork> "EXPIRY DATE" in the Expiry Date text field
    And I enter <cardNetwork> "SECURE CODE" in the Secure Code text field
    And I tap on the "PAY NOW" button
    And I wait for "3" seconds
    Then the Results screen should be visible
    Examples:
      | cardNetwork |
      | VISA        |
      | MASTERCARD  |
      | AMEX        |
      | JCB         |
      | DISCOVER    |

  @test-all-card-networks-register-card
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Successful <cardNetwork> register card
    Given I am on the Main screen
    When I tap on the "Register card" option
    And I enter <cardNetwork> "CARD NUMBER" in the Card Number text field
    And I enter <cardNetwork> "CARDHOLDER NAME" in the Cardholder Name text field
    And I enter <cardNetwork> "EXPIRY DATE" in the Expiry Date text field
    And I enter <cardNetwork> "SECURE CODE" in the Secure Code text field
    And I tap on the "REGISTER CARD" button
    And I wait for "3" seconds
    Then the Results screen should be visible
    And the "amount" list item should contain "1.01"
    Examples:
      | cardNetwork |
      | VISA        |
      | MASTERCARD  |
      | AMEX        |
      | JCB         |
      | DISCOVER    |


  @test-all-card-networks-check-card
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Successful <cardNetwork> check card
    Given I am on the Main screen
    When I tap on the "Check card" option
    And I enter <cardNetwork> "CARD NUMBER" in the Card Number text field
    And I enter <cardNetwork> "CARDHOLDER NAME" in the Cardholder Name text field
    And I enter <cardNetwork> "EXPIRY DATE" in the Expiry Date text field
    And I enter <cardNetwork> "SECURE CODE" in the Secure Code text field
    And I tap on the "CHECK CARD" button
    And I wait for "3" seconds
    Then the Results screen should be visible
    And the "amount" list item should contain "0.00"
    Examples:
      | cardNetwork |
      | VISA        |
      | MASTERCARD  |
      | AMEX        |
      | JCB         |
      | DISCOVER    |

  @test-all-card-networks-save-card
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Successful <cardNetwork> save card
    Given I am on the Main screen
    When I tap on the "Save card" option
    And I enter <cardNetwork> "CARD NUMBER" in the Card Number text field
    And I enter <cardNetwork> "CARDHOLDER NAME" in the Cardholder Name text field
    And I enter <cardNetwork> "EXPIRY DATE" in the Expiry Date text field
    And I enter <cardNetwork> "SECURE CODE" in the Secure Code text field
    And I tap on the "SAVE CARD" button
    And I wait for "3" seconds
    Then the Results screen should be visible
    And the "amount" list item should contain "0.00"
    Examples:
      | cardNetwork |
      | VISA        |
      | MASTERCARD  |
      | AMEX        |
      | JCB         |
      | DISCOVER    |

  @test-card-number-validation
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Invalid <cardNetwork> card number
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I enter <cardNetwork> "CARD NUMBER" in the Card Number text field
    Then an "Invalid card number" label should be visible
    Examples:
      | cardNetwork |
      | VISA        |
      | MASTERCARD  |
      | AMEX        |
      | JCB         |
      | DISCOVER    |

  @test-expiry-date-validation
    @require-non-3ds-config
  Scenario: Invalid expiry date
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I enter VISA "EXPIRY DATE" in the Expiry Date text field
    Then an "Invalid date value entered" label should be visible

  @test-secure-code-validation
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Invalid <cardNetwork> secure code
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I enter <cardNetwork> "CARD NUMBER" in the Card Number text field
    And I enter <cardNetwork> "SECURE CODE" in the Secure Code text field
    And I tap on the "Cardholder Name" text field
    Then the <cardNetwork> "SECURE CODE ERROR MESSAGE" label should be visible
    Examples:
      | cardNetwork |
      | VISA        |
      | MASTERCARD  |
      | AMEX        |
      | JCB         |
      | DISCOVER    |

  @test-submit-transaction-button-state
    @require-non-3ds-config
    @require-all-card-networks
  Scenario Outline: Payment button disabled when <criteria> invalid
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I enter <cardNetwork> "CARD NUMBER" in the Card Number text field
    And I enter <cardNetwork> "CARDHOLDER NAME" in the Cardholder Name text field
    And I enter <cardNetwork> "EXPIRY DATE" in the Expiry Date text field
    And I enter <cardNetwork> "SECURE CODE" in the Secure Code text field
    Then the "PAY NOW" button should be disabled
    Examples:
      | criteria        | cardNetwork |
      | Card number     | VISA        |
      | Cardholder Name | AMEX        |
      | Expiry date     | JCB         |
      | Secure code     | MASTERCARD  |

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
    And I select "<country>" from the Country dropdown
    And I enter <country> "POST CODE" in the Post Code text field
    And I tap on the "PAY NOW" button
    And I wait for "5" seconds
    Then the Results screen should be visible
    Examples:
      | country |
      | UK      |
      | USA     |
      | Canada  |
      | Other   |

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
    And I select "<country>" from the Country dropdown
    And I enter <country> "POST CODE" in the Post Code text field
    And I tap on the "PAY NOW" button
    And I wait for "10" seconds
    Then the Results screen should be visible
    Examples:
      | country |
      | UK      |
      | USA     |
      | Canada  |
      | Other   |

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
    And I select "<country>" from the Country dropdown
    And I enter <country> "POST CODE" in the Post Code text field
    And I tap on the "REGISTER CARD" button
    And I wait for "10" seconds
    Then the Results screen should be visible
    Examples:
      | country |
      | UK      |
      | USA     |
      | Canada  |
      | Other   |

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
    And I select "<country>" from the Country dropdown
    And I enter <country> "POST CODE" in the Post Code text field
    And I tap on the "CHECK CARD" button
    And I wait for "10" seconds
    Then the Results screen should be visible
    Examples:
      | country |
      | UK      |
      | USA     |
      | Canada  |
      | Other   |

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
    And I select "<country>" from the Country dropdown
    And I enter <country> "POST CODE" in the Post Code text field
    And I tap on the "SAVE CARD" button
    And I wait for "10" seconds
    Then the Results screen should be visible
    Examples:
      | country |
      | UK      |
      | USA     |
      | Canada  |
      | Other   |

  @test-avs-post-code-validation
    @require-non-3ds-config
    @require-avs
  Scenario Outline: Post code field validation for invalid <country> post code
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I tap on the Country text field
    And I select "<country>" from the Country dropdown
    And I enter <country> "POST CODE" in the Post Code text field
    Then the "Invalid postcode entered" label should be visible
    Examples:
      | country |
      | UK      |
      | USA     |
      | Canada  |

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
