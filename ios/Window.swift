import UIKit
import Balam
import Combine
import GameKit

let balam = Balam("lines")
var profile = Profile()

@UIApplicationMain final class Window: UIWindow, UIApplicationDelegate, GKGameCenterControllerDelegate {
    private var subs = Set<AnyCancellable>()
    private let board = "neon.lines.scores"
    
    func application(_: UIApplication, didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        backgroundColor = .systemBackground
        
        balam.nodes(Profile.self).sink {
            guard let stored = $0.first else {
                balam.add(profile)
                return
            }
            profile = stored
        }.store(in: &subs)
        
        GKLocalPlayer.local.authenticateHandler = { controller, _ in
            guard let controller = controller else { return }
            self.rootViewController!.present(controller, animated: true)
        }
        
        return true
    }
    
    func leaderboards() {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        let controller = GKGameCenterViewController()
        controller.viewState = .leaderboards
        controller.gameCenterDelegate = self
        controller.leaderboardIdentifier = board
        rootViewController!.present(controller, animated: true)
    }
    
    func gameCenterViewControllerDidFinish(_: GKGameCenterViewController) {
        rootViewController!.dismiss(animated: true)
    }
    
    func score(_ points: Int) {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        let report = GKScore(leaderboardIdentifier: board)
        report.value = .init(points)
        GKScore.report([report])
    }
}
