import UIKit
import SwiftUI

class SettingsViewController: UIViewController {
    
    private var hostingController: UIHostingController<SettingsView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hostingController = hostSwiftUIView(view: SettingsView())
    }
}
