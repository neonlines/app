import UIKit

extension UIResponder {
    var controller: UIViewController? {
        return next as? UIViewController ?? next?.controller
    }
}
