import UIKit
import Balam
import Combine
import GameKit

var profile = Profile()
let balam = Balam("lines")

@UIApplicationMain final class Window: UIWindow, UIApplicationDelegate, GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate {
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
        
        GKLocalPlayer.local.authenticateHandler = { controller, error in
            guard let controller = controller else { return }
            self.rootViewController!.present(controller, animated: true)
        }
        
        return true
    }
    
    func matchmakerViewController(_: GKMatchmakerViewController, didFind: GKMatch) {
        rootViewController!.dismiss(animated: true)
        newGame(didFind)
    }
    
    func matchmakerViewControllerWasCancelled(_: GKMatchmakerViewController) {
        rootViewController!.dismiss(animated: true)
    }
    
    func matchmakerViewController(_: GKMatchmakerViewController, didFailWithError: Error) {
        rootViewController!.dismiss(animated: true)
    }
    
    func gameCenterViewControllerDidFinish(_: GKGameCenterViewController) {
        rootViewController!.dismiss(animated: true)
    }
    
    func leaderboards() {
        guard GKLocalPlayer.local.isAuthenticated else {
            gameCenterError()
            return
        }
        let controller = GKGameCenterViewController()
        controller.viewState = .leaderboards
        controller.gameCenterDelegate = self
        controller.leaderboardIdentifier = board
        rootViewController!.present(controller, animated: true)
    }
    
    func score(_ points: Int) {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        let report = GKScore(leaderboardIdentifier: board)
        report.value = .init(points)
        GKScore.report([report])
    }
    
    func match() {
        guard GKLocalPlayer.local.isAuthenticated else {
            gameCenterError()
            return
        }
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 5
        request.defaultNumberOfPlayers = 2
        
        guard let controller = GKMatchmakerViewController(matchRequest: request) else { return }
        controller.matchmakerDelegate = self
        rootViewController!.present(controller, animated: true)
    }
    
    func newGame(_ match: GKMatch?) {
        (rootViewController as! UINavigationController).show(Controller(radius: 2_500, match: match))
    }
    
    private func gameCenterError() {
        let alert = UIAlertController(title: .key("Game.center.error"), message: .key("Check.you.are.logged"), preferredStyle: .alert)
        alert.addAction(.init(title: .key("Continue"), style: .cancel, handler: nil))
        alert.addAction(.init(title: .key("Go.to.settings"), style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        rootViewController!.present(alert, animated: true)
    }
}
