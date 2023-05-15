import SwiftUI

struct NoUICardPayView: View {
    @StateObject var viewModel: NoUICardPayViewModel
    var coordinator: Coordinator?

    var body: some View {
        VStack(spacing: 32) {
            Button("Pay with card") {
                viewModel.payWithCardToken()
            }
            Button("Pre-auth with card") {
                viewModel.preAuthWithCardToken()
            }
        }
        .navigationBarTitle("No UI payments")
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

struct NoUICardPayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NoUICardPayView(viewModel: NoUICardPayViewModel(featureService: FeatureService()))
        }
    }
}
