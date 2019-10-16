import UIKit
import JudoKitObjC

extension MainViewController {

    @objc func pay() {
        judoKit?.invokePayment(judoId,
                               amount: testAmount,
                               consumerReference: MainViewController.consumerReference,
                               cardDetails: nil) { response, error in
            self.transactionData = self.handle(response, error: error)
        }
    }

    @objc func preAuth() {
        judoKit?.invokePreAuth(judoId,
                               amount: testAmount,
                               consumerReference: MainViewController.consumerReference,
                               cardDetails: nil) { response, error in
                                   self.transactionData = self.handle(response, error: error)
        }
    }

    @objc func createCardToken() {
        judoKit?.invokeRegisterCard(judoId,
                                consumerReference: MainViewController.consumerReference,
                                cardDetails: nil) { response, error in
                                 self.transactionData = self.handle(response, error: error)
        }
    }

    @objc func saveCard() {
        judoKit?.invokeSaveCard(judoId,
                                consumerReference: MainViewController.consumerReference,
                                cardDetails: nil) { response, error in
                                 self.transactionData = self.handle(response, error: error)
        }
    }

    @objc func repeatPayment() {
        guard let cardDetails = transactionData?.cardDetails, let paymentToken = transactionData?.paymentToken else {
            presentAllertWithTitle("Error", message: "you need to create a card token before you can do a pre auth")
            return
        }

        judoKit?.invokeTokenPayment(judoId,
                                    amount: testAmount,
                                    consumerReference: MainViewController.consumerReference,
                                    cardDetails: cardDetails,
                                    paymentToken: paymentToken) { response, error in
                                               self.transactionData = self.handle(response, error: error)
        }
    }

    @objc func tokenPreAuth() {
        guard let cardDetails = transactionData?.cardDetails, let paymentToken = transactionData?.paymentToken else {
            presentAllertWithTitle("Error", message: "you need to create a card token before you can do a pre auth")
            return
        }

        judoKit?.invokeTokenPreAuth(judoId,
                                    amount: testAmount,
                                    consumerReference: MainViewController.consumerReference,
                                    cardDetails: cardDetails,
                                    paymentToken: paymentToken) { response, error in
                                               self.transactionData = self.handle(response, error: error)
        }
    }

    @objc func applePayPayment() {
        judoKit?.invokeApplePay(with: testPaymentApplePayConfiguration) { response, error in
            self.transactionData = self.handle(response, error: error)
        }
    }

    @objc func applePayPreAuth() {
        judoKit?.invokeApplePay(with: testPreAuthApplePayConfiguration) { response, error in
            self.transactionData = self.handle(response, error: error)
        }
    }

    @objc func navigateToPaymentMethods() {
        judoKit?.invokePayment(judoId,
                               amount: testAmount,
                               consumerReference: MainViewController.consumerReference,
                               paymentMethods: .methodsAll,
                               applePayConfiguratation: testPaymentApplePayConfiguration,
                               cardDetails: nil) { response, error in
                                self.transactionData = self.handle(response, error: error)
                               }
    }

    @objc func navigateToStandaloneApplePayButton() {
        performSegue(withIdentifier: "toStandaloneApplePay", sender: self)
    }

}
