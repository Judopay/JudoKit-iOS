import UIKit
import SwiftUI
import JudoKit_iOS

class ResultViewController: UIViewController {
    
    private var hostingController: UIHostingController<ResultView>?
    
    var response: JPResponse?
    var error: JPError?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hostingController = hostSwiftUIView(view: ResultView(content: myContent))
        
        self.title = myTitle
    }
    
    private var myContent: String {
        get {
            if let response = self.response {
                return String(describing: response)
            } else if let error = self.error {
                return String(describing: error)
            } else {
                return "Noting to display"
            }
        }
    }
    
    private var myTitle: String {
        get {
            if self.response != nil {
                return "Response"
            } else if self.error != nil {
                return "Error"
            } else {
                return "Empty result"
            }
        }
    }
}
