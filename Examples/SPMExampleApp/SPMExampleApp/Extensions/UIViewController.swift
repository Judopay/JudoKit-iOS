import SwiftUI
import UIKit

extension UIViewController {
        
    @discardableResult
    func hostSwiftUIView<T: View>(view: T, insideView hostView: UIView? = nil) -> UIHostingController<T> {
        
        let hostingController = UIHostingController(rootView: view)
        
        addChild(hostingController)
        
        hostingController.didMove(toParent: self)
        
        let myHostView: UIView = hostView ?? self.view
        
        myHostView.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: myHostView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: myHostView.leadingAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: myHostView.widthAnchor),
            hostingController.view.heightAnchor.constraint(equalTo: myHostView.heightAnchor)
        ])

        return hostingController
    }
    
}
