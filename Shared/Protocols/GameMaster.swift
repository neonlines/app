#if os(macOS)

import AppKit

#endif
#if os(iOS)

import UIKit

#endif

import GameKit

protocol GameMaster: AnyObject, GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate {
    func dismissGameCenter()
    func newGame(_ view: View)
    func show(_ controller: GKViewController)
    func gameCenterError()

#if os(macOS)
    
    func auth(_ controller: NSViewController)
    
#endif
#if os(iOS)
    
    func auth(_ controller: UIViewController)
    
#endif
}

extension GameMaster {
    func playerAuth() {
        GKLocalPlayer.local.authenticateHandler = { [weak self] controller, _ in
            guard let controller = controller else { return }
            self?.auth(controller)
        }
    }
    
    func matchmakerViewController(_: GKMatchmakerViewController, didFind: GKMatch) {
        dismissGameCenter()
        newGame(MultiplayerView(radius: 1_000, match: didFind))
    }
    
    func matchmakerViewControllerWasCancelled(_: GKMatchmakerViewController) {
        dismissGameCenter()
    }
    
    func matchmakerViewController(_: GKMatchmakerViewController, didFailWithError: Error) {
        dismissGameCenter()
    }
    
    func gameCenterViewControllerDidFinish(_: GKGameCenterViewController) {
        dismissGameCenter()
    }
    
    func leaderboards() {
        guard GKLocalPlayer.local.isAuthenticated else {
            gameCenterError()
            return
        }
        let controller = GKGameCenterViewController()
        controller.viewState = .leaderboards
        controller.gameCenterDelegate = self
        controller.leaderboardIdentifier = "neon.lines.top"
        show(controller)
    }
    
    func match() {
        guard GKLocalPlayer.local.isAuthenticated else {
            gameCenterError()
            return
        }
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        guard let controller = GKMatchmakerViewController(matchRequest: request) else { return }
        controller.matchmakerDelegate = self
        
        show(controller)
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
        board.loadScores { [weak self] scores, _ in
            scores?.first.map {
                self?.report($0.value + points, board: id)
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
