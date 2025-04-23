import SwiftUI

struct NoUICardPayView: View {
    @StateObject var viewModel: NoUICardPayViewModel
    var coordinator: Coordinator?
    var body: some View {
        VStack(spacing: 10) {
            Button("Pay with card") {
                viewModel.payWithCard()
            }
            .buttonStyle(BasicButtonStyle())
            Button("PreAuth with card") {
                viewModel.preAuthWithCard()
            }
            .buttonStyle(BasicButtonStyle())
            Button("Check card") {
                viewModel.checkCard()
            }
            .buttonStyle(BasicButtonStyle())
        }
        .padding()
        .navigationBarTitle("No-UI transactions")
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK")) {
                    viewModel.showAlert = false
                })
        }
        .onChange(of: viewModel.result) { result in
            if let result {
                coordinator?.pushTo(.results(result))
            }
        }
    }
}

struct BasicButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(4)
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
    }
}

struct NoUICardPayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NoUICardPayView(viewModel: NoUICardPayViewModel(featureService: FeatureService()))
        }
    }
}
