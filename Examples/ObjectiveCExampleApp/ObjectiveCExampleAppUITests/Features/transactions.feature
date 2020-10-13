@judo-transactions
Feature: Judo Transactions
As a user I want to be able to complete transactions via the Judo UI

@judo-transactions-payment
Scenario: Card Payment
  Given I am on the Main screen
  When I tap on the "Pay with card" option
  And I enter "4111 1111 1111 1111" in the Card Number text field
  And I enter "John Rambo" in the Cardholder Name text field
  And I enter "1220" in the Expiry Date text field
  And I enter "123" in the Secure Code text field
  And I tap on the "PAY NOW" button
  And I wait for "10" seconds
  Then the Receipt screen should be visible
