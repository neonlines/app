import GameKit

let game = GameMaster()

@UIApplicationMain final class Window: UIWindow, UIApplicationDelegate, GameDelegate {
    func application(_: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        game.delegate = self
        game.auth()
        backgroundColor = .systemBackground
        return true
    }
    
    func auth(_ controller: UIViewController) {
        rootViewController!.present(controller, animated: true)
    }
    
    func dismissGameCenter() {
        rootViewController!.dismiss(animated: true)
    }
    
    func newGame(_ view: View) {
        (rootViewController as! UINavigationController).show(Controller(view))
    }
    
    func show(_ controller: UINavigationController) {
        rootViewController!.present(controller, animated: true)
    }
    
    func gameCenterError() {
        let alert = UIAlertController(title: .key("Game.center.error"), message: .key("Check.you.are.logged"), preferredStyle: .alert)
        alert.addAction(.init(title: .key("Continue"), style: .cancel, handler: nil))
        alert.addAction(.init(title: .key("Go.to.settings"), style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        rootViewController!.present(alert, animated: true)
    }
}
