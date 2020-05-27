import UIKit

let game = GameMaster()

final class Scene: UINavigationController, UIWindowSceneDelegate, GameDelegate {
    func sceneDidBecomeActive(_ scene: UIScene) {
        game.delegate = self
        game.auth()
    }
    
    func scene(_ scene: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions) {
        setNavigationBarHidden(true, animated: false)
        setViewControllers([Options()], animated: false)
        let app = UIApplication.shared.delegate as! App
        app.windowScene = scene as? UIWindowScene
        app.overrideUserInterfaceStyle = .light
        app.backgroundColor = .white
        app.rootViewController = self
        app.makeKeyAndVisible()
    }
    
    func auth(_ controller: UIViewController) {
        present(controller, animated: true)
    }
    
    func dismissGameCenter() {
        dismiss(animated: true)
    }
    
    func show(_ controller: UINavigationController) {
        present(controller, animated: true)
    }
    
    func gameCenterError() {
        let alert = UIAlertController(title: .key("Game.center.error"), message: .key("Check.you.are.logged"), preferredStyle: .alert)
        alert.addAction(.init(title: .key("Continue"), style: .cancel, handler: nil))
        alert.addAction(.init(title: .key("Go.to.settings"), style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        present(alert, animated: true)
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
    
    func newGame(_ view: View) {
        show(Controller(view))
    }
}

@UIApplicationMain private final class App: UIWindow, UIApplicationDelegate { }
