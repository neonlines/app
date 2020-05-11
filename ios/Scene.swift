import UIKit

final class Scene: NSObject, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions) {
        let window = UIApplication.shared.delegate as! Window
        window.windowScene = scene as? UIWindowScene
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
    }
    
    func sceneDidBecomeActive(_: UIScene) {
        
    }
}
