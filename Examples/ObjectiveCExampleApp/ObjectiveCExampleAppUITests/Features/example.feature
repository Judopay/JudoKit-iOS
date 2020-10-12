@judo-transactions
Feature: Judo Transactions
As a user I want to be able to complete transactions via the Judo UI

@judo-transactions-payment
Scenario: Card Payment
  Given I am on the Main screen
  When I tap on the Payment option
  And I enter "4111 1111 1111 1111" in the Card Number field
  And I enter "John Rambo" in the Cardholder Name field
  And I enter "12/20" in the Expiry Date field
  And I enter "123" in the Secure Code field
  And I tap on the "Pay now" button
  And I wait for "10" seconds
  Then the Receipt screen should be visible
  When I tap on the "status" option
  Then a "Success" text should be visible
