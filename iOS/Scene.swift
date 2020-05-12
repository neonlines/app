import UIKit

final class Scene: UINavigationController, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions) {
        setNavigationBarHidden(true, animated: false)
        setViewControllers([Launch()], animated: false)
        let window = UIApplication.shared.delegate as! Window
        window.windowScene = scene as? UIWindowScene
        window.rootViewController = self
        window.makeKeyAndVisible()
    }
}

extension UINavigationController {
    func show(_ controller: UIViewController) {
        UIView.animate(withDuration: 0.4, animations: {
            self.viewControllers.first?.view.alpha = 0
        }) { _ in
            controller.view.alpha = 0
            self.setViewControllers([controller], animated: false)
            UIView.animate(withDuration: 0.4) {
                controller.view.alpha = 1
            }
        }
    }
}
