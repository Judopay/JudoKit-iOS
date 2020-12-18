@3DS
Feature: Judo 3DS Transactions
  As a user I want to be able to complete 3DS transactions via the Judo UI

  @test-judo-3ds-transactions
    @require-3ds-config
    @require-all-card-networks
  Scenario Outline: Successful 3DS <paymentWidgetType>
    Given I am on the Main screen
    When I tap on the <optionLabel> option
    And I enter "4000 0000 0000 0002" in the Card Number text field
    And I enter "John Rambo" in the Cardholder Name text field
    And I enter "1229" in the Expiry Date text field
    And I enter "123" in the Secure Code text field
    And I tap on the <buttonLabel> button
    And I wait for "5" seconds
    And I tap on the "Submit" button
    And I wait for "10" seconds
    Then the Results screen should be visible
    Examples:
      | paymentWidgetType | optionLabel          | buttonLabel     |
      | Card payment      | "Pay with card"      | "PAY NOW"       |
      | Pre-auth          | "Pre-auth with card" | "PAY NOW"       |

  @test-judo-3ds-transaction-cancel
    @require-3ds-config
    @require-all-card-networks
  Scenario Outline: Cancelled 3DS <paymentWidgetType>
    Given I am on the Main screen
    When I tap on the <optionLabel> option
    And I enter "4000 0000 0000 0002" in the Card Number text field
    And I enter "John Rambo" in the Cardholder Name text field
    And I enter "1229" in the Expiry Date text field
    And I enter "123" in the Secure Code text field
    And I tap on the <buttonLabel> button
    And I wait for "5" seconds
    And I tap on the "Dismiss" button
    And I wait for "10" seconds
    Then a "The transaction was cancelled by the user." alert should be visible
    Examples:
      | paymentWidgetType | optionLabel          | buttonLabel     |
      | Card payment      | "Pay with card"      | "PAY NOW"       |
      | Pre-auth          | "Pre-auth with card" | "PAY NOW"       |
