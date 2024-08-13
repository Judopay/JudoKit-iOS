import SwiftUI

struct SettingsView: View {
    
    @AppStorage("isSanboxed")
    private var isSandboxed = true

    @AppStorage("judoId")
    private var judoId = ""

    @AppStorage("token")
    private var token = ""

    @AppStorage("secret")
    private var secret = ""

    @AppStorage("amount")
    private var amount = "1.50"
    
    @AppStorage("currency")
    private var currency = "GBP"
    
    @AppStorage("merchantId")
    private var merchantId = "merchant.cybersourceshodanapplepay"

    @AppStorage("consumerReference")
    private var consumerReference = "my-consumer-reference"
    
    var body: some View {
        Form {
            Section(header: Text("API CONFIGURATIONS")) {
                Toggle(isOn: $isSandboxed) {
                    Text("Sandboxed")
                }
                HStack(spacing: 16) {
                    Text("Judo ID")
                    TextField("Enter your judo id here", text: $judoId)
                        .textFieldStyle(PlainTextFieldStyle())
                }
            }
            Section(header: Text("AUTHORIZATION")) {
                HStack(spacing: 16) {
                    Text("Token")
                    TextField("Enter token", text: $token)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                HStack(spacing: 16) {
                    Text("Secret")
                    TextField("Enter secret", text: $secret)
                        .textFieldStyle(PlainTextFieldStyle())
                }
            }
            Section(header: Text("AMOUNT")) {
                HStack(spacing: 16) {
                    Text("Amount")
                    TextField("Enter amount", text: $amount)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                HStack(spacing: 16) {
                    Text("Currency")
                    TextField("Enter currency", text: $currency)
                        .textFieldStyle(PlainTextFieldStyle())
                }
            }
            Section() {
                HStack(spacing: 16) {
                    Text("Consumer reference")
                    TextField("Enter consumerReference", text: $consumerReference)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                HStack(spacing: 16) {
                    Text("MerchantId")
                    TextField("Enter merchantId", text: $merchantId)
                        .textFieldStyle(PlainTextFieldStyle())
                }
            }
        }
    }
    
}
