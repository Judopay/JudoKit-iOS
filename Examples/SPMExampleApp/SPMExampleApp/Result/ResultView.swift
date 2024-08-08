import SwiftUI

struct ResultView: View {
    var content: String = ""
    
    var body: some View {
        ScrollView {
            Text(content)
                .padding()
                .font(.system(.body, design: .monospaced))
        }
    }
}
