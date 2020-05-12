import AppKit
import Balam
import Combine
import GameKit

var profile = Profile()
let balam = Balam("lines")

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate, GKGameCenterControllerDelegate {
    private var subs = Set<AnyCancellable>()
    private let board = "neon.lines.scores"
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        mainMenu = Menu()
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
            NSWindow(contentViewController: controller).makeKeyAndOrderFront(self)
        }
    }
    
    func leaderboards() {
        guard GKLocalPlayer.local.isAuthenticated, !windows.contains(where: { $0.contentViewController is GKGameCenterViewController }) else {
            windows.first { $0.contentViewController is GKGameCenterViewController }?.makeKeyAndOrderFront(true)
            windows.first { $0.contentViewController is GKGameCenterViewController }?.center()
            return
        }
        let controller = GKGameCenterViewController()
        controller.viewState = .leaderboards
        controller.gameCenterDelegate = self
        controller.leaderboardIdentifier = board
        NSWindow(contentViewController: controller).makeKeyAndOrderFront(self)
    }
    
    func gameCenterViewControllerDidFinish(_: GKGameCenterViewController) {
        windows.first { $0.contentViewController is GKGameCenterViewController }?.close()
    }
    
    func score(_ points: Int) {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        let report = GKScore(leaderboardIdentifier: board)
        report.value = .init(points)
        GKScore.report([report])
    }
}
