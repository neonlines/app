import UIKit

final class Scene: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions) {
        let window = UIWindow(windowScene: scene as! UIWindowScene)
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func sceneDidBecomeActive(_: UIScene) {
        
    }
}
