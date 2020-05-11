import UIKit

final class Scene: UIViewController, UIWindowSceneDelegate {
    override func loadView() {
        view = Launch()
    }
    
    func scene(_ scene: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions) {
        let window = UIApplication.shared.delegate as! Window
        window.windowScene = scene as? UIWindowScene
        window.rootViewController = self
        window.makeKeyAndVisible()
    }
}
