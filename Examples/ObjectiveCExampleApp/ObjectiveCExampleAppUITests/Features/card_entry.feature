@card-entry
Feature: Judo Transactions
  As a user I want to be able to complete transactions via the Judo UI

  @require-non-3ds-config
    @judo-transactions
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

  @require-non-3ds-config
    @card-network
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

  @require-non-3ds-config
    @card-network
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

  @require-non-3ds-config
    @card-network
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

  @require-non-3ds-config
    @card-network
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
    And the "amount" list item should contain "0"
    Examples:
      | cardNetwork | cardNumber            | secureCode |
      | AmEx        | "3782 8224 6310 005"  | "1234"     |
      | Visa        | "4111 1111 1111 1111" | "123"      |
      | Discover    | "6011 1111 1111 1117" | "123"      |
      | JCB         | "3566 1111 1111 1113" | "123"      |
      | Mastercard  | "5555 5555 5555 4444" | "123"      |

  @require-non-3ds-config
    @card-network
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
    And the "amount" list item should contain "0"
    Examples:
      | cardNetwork | cardNumber            | secureCode |
      | AmEx        | "3782 8224 6310 005"  | "1234"     |
      | Visa        | "4111 1111 1111 1111" | "123"      |
      | Discover    | "6011 1111 1111 1117" | "123"      |
      | JCB         | "3566 1111 1111 1113" | "123"      |
      | Mastercard  | "5555 5555 5555 4444" | "123"      |

  @card-entry-validation
  Scenario Outline: Invalid <cardNetwork> card number
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I enter <cardNumber> in the Card Number text field
    Then the "Invalid card number" label should be visible
    Examples:
      | cardNetwork | cardNumber            |
      | AmEx        | "3782 8224 6310 000"  |
      | Visa        | "4111 1111 1111 1110" |
      | Discover    | "6011 1111 1111 1110" |
      | JCB         | "3566 1111 1111 1110" |
      | Mastercard  | "5555 5555 5555 4440" |

  @card-entry-validation
  Scenario: Invalid expiry date
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I enter "1219" in the Expiry Date text field
    Then the "Check expiry date" label should be visible

  @card-entry-validation
  Scenario Outline: Invalid <cardNetwork> secure code
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I enter <cardNumber> in the Card Number text field
    And I enter <secureCode> in the Secure Code text field
    And I tap on the "Cardholder Name" text field
    Then the "Check CVV" label should be visible
    Examples:
      | cardNetwork | cardNumber            | secureCode |
      | AmEx        | "3782 8224 6310 005"  | "111"      |
      | Visa        | "4111 1111 1111 1111" | "11"       |
      | Discover    | "6011 1111 1111 1117" | "11"       |
      | JCB         | "3566 1111 1111 1113" | "11"       |
      | Mastercard  | "5555 5555 5555 4444" | "11"       |

  @card-entry-validation
  Scenario Outline: Pay button disabled when <criteria> invalid
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

  @cancel-payment
  Scenario: Cancel payment
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I tap on the "CANCEL" button
    Then the "Main" screen should be visible
