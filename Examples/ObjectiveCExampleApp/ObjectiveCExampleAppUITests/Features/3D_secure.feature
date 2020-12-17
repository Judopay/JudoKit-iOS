@3DS
Feature: Judo 3DS Transactions
  As a user I want to be able to complete 3DS transactions via the Judo UI

  @test-judo-3ds-transactions
    @require-3ds-config
    @require-all-card-networks
  Scenario Outline: Successful 3DS transactions
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I enter <cardNetwork> "CARD NUMBER" in the Card Number text field
    And I enter <cardNetwork> "CARDHOLDER NAME" in the Cardholder Name text field
    And I enter <cardNetwork> "EXPIRY DATE" in the Expiry Date text field
    And I enter <cardNetwork> "SECURE CODE" in the Secure Code text field
    And I tap on the "PAY NOW" button
    And I wait for "5" seconds
    And I tap on the "Submit" button
    And I wait for "5" seconds
    Then the Results screen should be visible
    Examples:
      | cardNetwork |
      | VISA        |
      | MASTERCARD  |

  @test-judo-3ds-transaction-cancel
    @require-3ds-config
    @require-all-card-networks
  Scenario Outline: Cancelled 3DS <paymentWidgetType>
    Given I am on the Main screen
    When I tap on the "Pay with card" option
    And I enter <cardNetwork> "CARD NUMBER" in the Card Number text field
    And I enter <cardNetwork> "CARDHOLDER NAME" in the Cardholder Name text field
    And I enter <cardNetwork> "EXPIRY DATE" in the Expiry Date text field
    And I enter <cardNetwork> "SECURE CODE" in the Secure Code text field
    And I tap on the "PAY NOW" button
    And I wait for "5" seconds
    And I tap on the "Dismiss" button
    And I wait for "5" seconds
    Then a "The transaction was cancelled by the user." alert should be visible
    Examples:
      | cardNetwork |
      | VISA        |
      | MASTERCARD  |

