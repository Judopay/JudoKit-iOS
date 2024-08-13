import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
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
            
            CustomButton(title: "ApplePay basic") {
                onFeatureTap(.basic, isPreauth)
            }
            
            CustomButton(title: "ApplePay custom presentation") {
                onFeatureTap(.customPresentation, isPreauth)
            }
            
            Text("async/await")
                .padding(16)
            
            CustomButton(title: "ApplePay basic") {
                onFeatureTap(.basicAsyncAwait, isPreauth)
            }
            
            CustomButton(title: "ApplePay custom presentation") {
                onFeatureTap(.customPresentationAsyncAwait, isPreauth)
            }
        }
    }
}
