import UIKit

extension UIView {
    func initAutoLayout(UIViews: [UIView]) {
        UIViews.forEach({ UIView in
            UIView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(UIView)
        })
    }
    
}
