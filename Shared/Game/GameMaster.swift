import GameKit
import Balam
import Combine

final class GameMaster: NSObject, GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate {
    var profile = Profile() {
        didSet {
            balam.update(profile)
        }
    }

    weak var delegate: GameDelegate!
    private var subs = Set<AnyCancellable>()
    private let balam = Balam("lines")
    
    func matchmakerViewController(_: GKMatchmakerViewController, didFind: GKMatch) {
        delegate.dismissGameCenter()
        delegate.newGame(MultiplayerView(radius: 1_000, match: didFind))
    }
    
    func matchmakerViewControllerWasCancelled(_: GKMatchmakerViewController) {
        delegate.dismissGameCenter()
    }
    
    func matchmakerViewController(_: GKMatchmakerViewController, didFailWithError: Error) {
        delegate.dismissGameCenter()
    }
    
    func gameCenterViewControllerDidFinish(_: GKGameCenterViewController) {
        delegate.dismissGameCenter()
    }
    
    func auth() {
        GKLocalPlayer.local.authenticateHandler = { controller, _ in
            guard let controller = controller else { return }
            self.delegate.auth(controller)
        }
        balam.nodes(Profile.self).sink {
            guard let stored = $0.first else {
                self.balam.add(self.profile)
                return
            }
            self.profile = stored
        }.store(in: &subs)
    }
    
    func leaderboards() {
        guard GKLocalPlayer.local.isAuthenticated else {
            delegate.gameCenterError()
            return
        }
        let controller = GKGameCenterViewController()
        controller.viewState = .leaderboards
        controller.gameCenterDelegate = self
        controller.leaderboardIdentifier = "neon.lines.top"
        delegate.show(controller)
    }
    
    func match() {
        guard GKLocalPlayer.local.isAuthenticated else {
            delegate.gameCenterError()
            return
        }
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        guard let controller = GKMatchmakerViewController(matchRequest: request) else { return }
        controller.matchmakerDelegate = self
        
        delegate.show(controller)
    }
    
    func report(seconds: Int) {
        report(.init(seconds), board: "neon.lines.seconds")
    }
    
    func report(ai: Int) {
        aggregate("neon.lines.ai", points: .init(ai))
    }
    
    func report(duels: Int) {
        aggregate("neon.lines.duels", points: .init(duels))
    }
    
    private func aggregate(_ id: String, points: Int64) {
        let board = GKLeaderboard(players: [GKLocalPlayer.local])
        board.identifier = id
        board.timeScope = .allTime
        board.loadScores { scores, _ in
            scores?.first.map {
                self.report($0.value + points, board: id)
            }
        }
    }
    
    private func report(_ points: Int64, board: String) {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        let report = GKScore(leaderboardIdentifier: board)
        report.value = points
        GKScore.report([report])
    }
}
