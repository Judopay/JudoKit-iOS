import SwiftUI

enum FeatureType {
    case basic
    case customPresentation
    case basicAsyncAwait
    case customPresentationAsyncAwait
}
struct FeaturesView: View {
    
    let onFeatureTap: (_ type: FeatureType, _ isPreauth: Bool) -> Void
    
    @AppStorage("transactionMode")
    private var transactionMode = 0
    
    private var isPreauth: Bool {
        get {
            transactionMode == 1
        }
    }
    
    var body: some View {
        VStack {
            Picker("Transaction mode", selection: $transactionMode) {
                Text("Payment").tag(0)
                Text("Pre-Auth").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Text("completion handler")
                .padding(16)
            
            Button(action: {
                onFeatureTap(.basic, isPreauth)
            }) {
                Text("ApplePay basic")
                    .frame(maxWidth: .infinity)
                    .padding(14)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)

            Button(action: {
                onFeatureTap(.customPresentation, isPreauth)
            }) {
                Text("ApplePay custom presentation")
                    .frame(maxWidth: .infinity)
                    .padding(14)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)

            Text("async/await")
                .padding(16)
            
            Button(action: {
                onFeatureTap(.basicAsyncAwait, isPreauth)
            }) {
                Text("ApplePay basic")
                    .frame(maxWidth: .infinity)
                    .padding(14)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            
            Button(action: {
                onFeatureTap(.customPresentationAsyncAwait, isPreauth)
            }) {
                Text("ApplePay custom presentation")
                    .frame(maxWidth: .infinity)
                    .padding(14)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
        }
    }
}
