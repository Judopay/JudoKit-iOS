@payment-methods
Feature: Payment methods tests
  As a user I want to be able to complete transactions via the Judo payment methods screen

  @test-judo-payment-methods-card-selected
  @require-non-3ds-config
  @require-all-card-networks
  @require-card-payment-method
  Scenario Outline: Successful add card
    Given I am on the Main screen
    When I tap on the "Payment methods" option
    And I tap on the "ADD CARD" button
    And I enter <cardNetwork> "CARD NUMBER" in the Card Number text field
    And I enter <cardNetwork> "CARDHOLDER NAME" in the Cardholder Name text field
    And I enter <cardNetwork> "EXPIRY DATE" in the Expiry Date text field
    And I enter <cardNetwork> "SECURE CODE" in the Secure Code text field
    And I tap on the "SAVE CARD" button
    And I wait for "3" seconds
    Then a <cardNetwork> "PAYMENT METHODS SUBTITLE" item should be selected
    Examples:
      | cardNetwork |
      | VISA        |
      | MASTERCARD  |
      | AMEX        |
      | JCB         |
      | DISCOVER    |

  @test-judo-payment-methods-card-transaction
  @require-non-3ds-config
  @require-all-card-networks
  @require-card-payment-method
  Scenario Outline: Successful card transaction
    Given I am on the Main screen
    When I tap on the "Payment methods" option
    And I tap on the "ADD CARD" button
    And I enter <cardNetwork> "CARD NUMBER" in the Card Number text field
    And I enter <cardNetwork> "CARDHOLDER NAME" in the Cardholder Name text field
    And I enter <cardNetwork> "EXPIRY DATE" in the Expiry Date text field
    And I enter <cardNetwork> "SECURE CODE" in the Secure Code text field
    And I tap on the "SAVE CARD" button
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

  @test-judo-payment-methods-all-disabled
  Scenario: No payment methods displayed
    Given I am on the Main screen
    When I tap on the "Payment methods" option
    Then the payment method selector should not be visible

  @test-judo-payment-methods-pbba
  @require-pbba-payment-method
  @require-currency-gbp
  Scenario: PbBa should be visible when enabling PbBa and setting currency to GBP
    Given I am on the Main screen
    When I tap on the "Payment methods" option
    Then the PbBa Header view should be visible

  @test-judo-payment-methods-pbba-currency-eur
  @require-pbba-payment-method
  @require-currency-eur
  Scenario: PbBa should not be visible when enabling PbBa and setting currency to EUR
    Given I am on the Main screen
    When I tap on the "Payment methods" option
    Then an "PBBA transactions only support GBP as the currency." alert should be visible

  @test-judo-payment-methods-ideal
  @require-ideal-payment-method
  @require-currency-eur
  Scenario: iDEAL should be visible when enabling iDEAL and setting currency to EUR
    Given I am on the Main screen
    When I tap on the "Payment methods" option
    Then the iDEAL Header view should be visible

  @test-judo-payment-methods-ideal-currency-gbp
  @require-ideal-payment-method
  @require-currency-gbp
  Scenario: Payment methods screen should not be visible when enabling iDEAL and setting currency to GBP
    Given I am on the Main screen
    When I tap on the "Payment methods" option
    Then an "iDEAL transactions only support EUR as the currency." alert should be visible

  @test-judo-payment-methods-apple-pay
  @require-apple-pay-payment-method
  Scenario: Apple Pay should be visible when enabling Apple Pay
    Given I am on the Main screen
    When I tap on the "Payment methods" option
    Then the Apple Pay Header view should be visible

  @test-judo-all-payment-methods-enabled
  @require-all-payment-methods
  @require-currency-eur
  Scenario: Card, iDEAL and Apple pay payment methods should be visible
    Given I am on the Main screen
    When I tap on the "Payment methods" option
    Then the Card Selector option should be visible
    And the iDEAL Selector option should be visible
    And the Apple Pay Selector option should be visible
