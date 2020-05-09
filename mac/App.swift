import AppKit
import Balam
import Combine
import GameKit

let balam = Balam("lines")
var profile = Profile()

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate, GKGameCenterControllerDelegate {
    private var subs = Set<AnyCancellable>()
    private let board = "neon.lines.scores"
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func applicationWillFinishLaunching(_: Notification) {
//        mainMenu = Menu()
        Window().makeKeyAndOrderFront(nil)
        balam.nodes(Profile.self).sink {
            guard let stored = $0.first else {
                balam.add(profile)
                return
            }
            profile = stored
        }.store(in: &subs)
    }
    
    func applicationDidFinishLaunching(_: Notification) {
        GKLocalPlayer.local.authenticateHandler = { [weak self] controller, _ in
            guard let controller = controller else { return }
            self?.runModal(for: .init(contentViewController: controller))
        }
    }
    
    func leaderboards() {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        let controller = GKGameCenterViewController()
        controller.viewState = .leaderboards
        controller.gameCenterDelegate = self
        controller.leaderboardIdentifier = board
        runModal(for: .init(contentViewController: controller))
    }
    
    func gameCenterViewControllerDidFinish(_: GKGameCenterViewController) {
        stopModal()
        modalWindow?.close()
    }
    
    func score(_ points: Int) {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        let report = GKScore(leaderboardIdentifier: board)
        report.value = .init(points)
        GKScore.report([report])
    }
}
